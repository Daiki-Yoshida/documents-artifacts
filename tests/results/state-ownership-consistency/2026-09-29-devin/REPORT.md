# state-ownership-consistency — run report

- Scenario: `state-ownership-consistency`
- Run id: `2026-09-29-devin`
- Agent: Devin (SWE-2 Max)
- Source repository baseline: `main` @ `b87726a` (merge of PR #111)

## Generated baseline

`artifact-test-baseline` = fixture baseline + Artifact install commit;
see `evidence/metadata.txt`.

## Artifact files actually read

1. `documents/artifacts/INDEX.md` — routed code change →
   `operation/CHANGE_LIFECYCLE.md`.
2. `documents/artifacts/operation/CHANGE_LIFECYCLE.md` — understand
   required outcome; verify contract + requested outcome.
3. `documents/artifacts/design/INDEX.md` — routed cross-boundary
   consistency → `STATE_AND_CONSISTENCY.md`.
4. `documents/artifacts/design/STATE_AND_CONSISTENCY.md` — one mutable
   state, one owner; coordinator owns coordination/consistency/failure
   policy; choose an explicit consistency strategy (compensation etc.);
   do not treat non-atomic topology as atomic.

## Project-local files actually read

`README.md`, `package.json`, `Makefile`, `src/order/index.js`,
`src/order/application/place-order.js`,
`src/order/infrastructure/order-store.js`,
`src/order/infrastructure/payment-gateway.js`,
`tests/place-order.test.js`, `scripts/consistency-check.js`.

## Ownership / coordinator model (discovered from project facts)

- `OrderStore` — owns order status; `draft` is the pre-placement state;
  private `Map`, inspected only via `getStatus`/`setStatus`.
- `PaymentGateway` — owns authorization; `authorize`/`void`/
  `isAuthorized`; private `Set`.
- `placeOrder` (application) — coordinator for one business outcome;
  owners share **no** atomic transaction.
- Contract: failed `placeOrder` must leave `order = draft`,
  `payment = unauthorized`.

## Baseline defect observed

`npm test`: payment-authorization-failure case FAIL — the flow confirms
the order, then returns `{ok:false}` on auth failure while the order
stays `confirmed` (partial completed state). `consistency-check` FAIL:
failure path lacks consistency handling. Success and local-failure cases
PASS at baseline.

## Chosen consistency strategy

**Local-first + restore `draft` on authorization failure** (explicit
compensation through the owner's public surface):

```js
const saved = orderStore.setStatus(orderId, 'confirmed');
if (!saved.ok) return { ok: false, code: 'order_save_failed' };
const auth = await paymentGateway.authorize(orderId);
if (!auth.ok) {
  orderStore.setStatus(orderId, 'draft');      // compensation
  return { ok: false, code: 'payment_declined' };
}
return { ok: true };
```

Why this covers both failure directions without partial completion:

- **local confirmation failure** → early return *before* authorize; order
  never left `draft`, payment never touched;
- **payment authorization failure** → compensating write restores the
  order owner's state to `draft`; authorization never recorded.

Alternative authorize-first + `void` was also viable; confirm-first was
kept because it avoids hitting the external payment boundary when the
local write already fails — the smaller behavioral change.

## Files changed

`src/order/application/place-order.js` only (+4 lines: comment +
`setStatus(orderId, 'draft')`).

## Public contract / ownership impact

- `createPlaceOrder` / `placeOrder` / `{ok}|{ok:false,code}` — unchanged.
- Owners remain separate; no owner-private access; no state merged into
  the application; no transaction/saga/event-bus/outbox framework added.

## Final behavior

```text
success             → ok + order confirmed + payment authorized
payment failure     → !ok + order draft + payment unauthorized
local confirm fail  → !ok + order draft + payment unauthorized
```

## Verification (actual)

```text
npm test                 PASS (3/3)
npm run consistency-check PASS
make verify             PASS
```

## Final Git status

`M src/order/application/place-order.js` only. `documents/artifacts/**`
untouched — `managed-artifacts.patch` empty (0 bytes). Tests and
consistency checker unmodified.

## Evidence

9-file bundle captured by `capture-agent-test.sh`; `changes.patch` shows
only the focused coordinator change.

## Evidence limitations

- Runtime failure-injection behavior is evidenced by test/checker
  results; the patch shows the code change, not the injected runs.
- The compensation write cannot itself be observed as an intermediate
  state in the diff — only the final `draft` outcome is asserted by
  tests.

## Self-assessment

Identified ownership/coordinator model from project facts before
mutating; chose an explicit consistency strategy (compensation through
the owner's public surface) rather than call-order tricks or fake
atomicity; kept the fix focused and the public contract intact; verified
all three invariants plus the final project gate before reporting done.
