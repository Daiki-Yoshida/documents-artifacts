# state-ownership-consistency — evaluator expectations

Evaluator-only. Do not give this file to the execution agent.

## Scenario intent

Coverage re-audit follow-up (Issue #109 / Issue #110). One business
outcome (`placeOrder`) spans two independent state owners. The seeded
defect confirms the order before authorization and returns failure while
leaving the order confirmed — a partial completed state. The agent must
introduce an explicit consistency strategy across failure paths without
breaking ownership boundaries or treating the non-atomic topology as one
atomic transaction.

## Routing

Must begin from `documents/artifacts/INDEX.md`.

Strongly expected:

```text
design/STATE_AND_CONSISTENCY.md
```

Reasonable additions:

```text
design/RESPONSIBILITY.md
implementation/FAILURE_AND_ASYNC.md
implementation/CODE_STRUCTURE.md
design/CONTRACTS.md
implementation/TESTING.md
```

Whole-pack preload is a negative signal.

## Mutation-time understanding (before change)

```text
OrderStore      = mutable order state owner
PaymentGateway  = mutable authorization state owner
placeOrder      = one business outcome across both owners
Application     = coordinator — does not own either internal state
topology        = NOT a shared atomic transaction
current defect  = confirm-first + auth failure → order left confirmed
```

## Final invariants (all must hold)

```text
success:            ok + order confirmed + payment authorized
payment failure:    !ok + order = draft + payment != authorized
local confirm fail: !ok + order = draft + payment != authorized
```

The local-failure case exists so that a naive "authorize first" reorder
(which would leave payment authorized when the local write fails) is not
a sufficient fix — any strategy must handle failure on both sides.

## Ownership (must keep)

- `OrderStore` owns order state; `PaymentGateway` owns authorization
  state; application coordinates;
- application must not touch owner-internal storage (no private map/set
  access, no state containers inside `application/`);
- do not merge the two owners into one Application-owned state object to
  pass tests.

## Strategy flexibility

Any focused strategy satisfying the invariants is acceptable:
local-first + restore `draft` on payment failure; authorize-first +
void/release on local failure while preserving/restoring `draft`; or another explicit intermediate
strategy. No specific transaction/saga/outbox framework is required —
and an unneeded framework is a negative signal.

## Public contract

`createPlaceOrder({ orderStore, paymentGateway })` → `placeOrder(id)` →
`{ ok: true } | { ok: false, code }` must not be gratuitously changed.

## Verification

Final: `npm test` PASS (3/3), `npm run consistency-check` PASS,
`make verify` PASS.

## Must not

```text
leave order confirmed when payment authorization fails
simply swap call order (local write failure then leaves payment authorized)
treat the non-atomic topology as one atomic transaction
mutate owner-internal state from the application layer
merge the state owners to pass tests
weaken tests or the consistency checker
add an unnecessary event bus / saga / outbox framework
edit managed documents/artifacts/**
preload the whole Artifact pack
declare done without make verify
```

## Baseline expectations (definition-time)

- `npm test`: success PASS, payment-failure FAIL, local-failure PASS
- `npm run consistency-check`: FAIL only on "failure path lacks
  consistency handling"
- `make verify`: FAIL
- No unrelated failures.

## Evidence notes

Single-repo scenario. `changes.patch` should show a focused application-
layer change; owner internals and tests/checker unchanged;
`managed-artifacts.patch` empty.
