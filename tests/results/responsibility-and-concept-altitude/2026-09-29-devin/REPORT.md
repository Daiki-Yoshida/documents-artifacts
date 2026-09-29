# Agent Test Report — responsibility-and-concept-altitude

- **Scenario**: `responsibility-and-concept-altitude`
- **Run ID**: `2026-09-29-devin`
- **Agent/model**: Devin (SWE-2 Max)
- **Source main baseline**: `main` @ `cb4bd57` (PR #126 merged; includes
  the hardened concept-neutrality checker)
- **Generated baseline**: `artifact-test-baseline` tag

## Files actually read

### Artifact files (routed from `documents/artifacts/INDEX.md`)

- `documents/artifacts/INDEX.md` — router
- `documents/artifacts/design/INDEX.md` — design router; "consumer-neutral
  concept meaning / sharing" → `CONCEPT_ALTITUDE.md`
- `documents/artifacts/design/CONCEPT_ALTITUDE.md` — model a concept by
  what it is, not its first consumer; three independent decisions
  (semantic altitude / physical placement / hardening-sharing); neutral
  but local until real reuse appears; YAGNI blocks speculative shared
  extraction, not neutral naming
- `documents/artifacts/design/RESPONSIBILITY.md` — responsibility is
  caller-coherent meaning; hardening is separate from identifying a
  responsibility

### Project-local files

- `README.md` — project facts: stable `quoteCart`; money responsibility
  = amount/invariant/arithmetic/rendering; pricing policy separate;
  checkout is the only consumer; no shared domain package; `make verify`
  is the final gate
- `src/checkout/index.js` — public surface (`quoteCart` only)
- `src/checkout/application/quote-cart.js` — pricing composition
- `src/checkout/domain/checkout-money.js` — the polluted concept
- `tests/quote-cart.test.js` — public behavior contract
- `Makefile`, `package.json` — verification surface

## Analysis before mutation

### Semantic altitude

`CheckoutMoney`'s contract is a currency amount, its invariant,
arithmetic, and rendering — nothing in it needs the word "checkout".
A responsibility sentence that doesn't need the feature name signals a
consumer-neutral concept: the `Checkout*` meaning is semantic pollution.
→ semantic meaning: **monetary**, not checkout-specific.

### Physical placement

Checkout is the only consumer today, so the concept stays inside
`src/checkout/` — neutral but local.
→ physical placement: **checkout-local**.

### Sharing / hardening

No second consumer exists and no shared domain package exists; promoting
to a project-wide shared abstraction has no current evidence.
→ sharing/hardening: **none**.

## Responsibility split understood

- money concept: currency amount + amount invariant + arithmetic +
  rendering;
- checkout application: subtotal/discount/tax/quote composition —
  kept in the application file, not absorbed into the concept.

## Files changed

- `src/checkout/domain/checkout-money.js` → renamed to
  `src/checkout/domain/money.js`; class `CheckoutMoney` → `Money`;
  comment de-scoped to consumer-neutral wording. Responsibility,
  invariants, and API unchanged.
- `src/checkout/application/quote-cart.js` — import/require path and
  constructor references updated only; pricing composition untouched.

## Public contract / pricing impact

- `quoteCart({subtotalCents, discountCents, taxCents})` →
  `{totalCents, display}` unchanged; `src/checkout/index.js` still
  exports `quoteCart` only; the money concept is not publicly exported.
- Pricing policy ownership unchanged (application file).

## Verification (actual)

```text
npm test              → PASS (2/2)
npm run concept-check → PASS (8/8)
make verify           → PASS
```

## Final Git status

```text
RM src/checkout/domain/checkout-money.js -> src/checkout/domain/money.js
 M src/checkout/application/quote-cart.js
```

No `shared/common/core/global` extraction; no
factory/registry/plugin/interface machinery; no other file touched.
`documents/artifacts/` untouched — `managed-artifacts.patch` empty
(0 bytes).

## Evidence capture result

`tests/scripts/capture-agent-test.sh --scenario
responsibility-and-concept-altitude --run-id 2026-09-29-devin` →
evidence under
`tests/results/responsibility-and-concept-altitude/2026-09-29-devin/evidence/`
(9 files). `changed-files.txt` shows only the focused rename + import
update.

## Evidence limitations

- Semantic-altitude reasoning is recorded in this report; the patch
  shows the rename, not the rejected alternatives (shared extraction,
  consumer-scoped rename).
- The checker's semantic signals are visible; the negative-space
  guarantees (no shared dir, no machinery) are evidenced by absence in
  `filesystem.txt`/`changes.patch`.

## Self-assessment

Separated the three judgments before editing: corrected the semantic
altitude (consumer-neutral `Money`), kept physical placement
checkout-local (sole consumer), and created no shared/hardened
abstraction (no reuse evidence). Responsibilities stayed split —
composition in the application, amount/invariant/arithmetic/rendering in
the concept — with the public `quoteCart` contract and project gate
verified unchanged and green.
