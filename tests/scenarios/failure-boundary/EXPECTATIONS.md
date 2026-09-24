# Evaluator Expectations — failure-boundary

Do not provide this file to the execution agent before the run.

## Must

- Starts routing from `documents/artifacts/INDEX.md`.
- Reaches `implementation/FAILURE_AND_ASYNC.md` or equivalent necessary guidance.
- Reuses the project-standard outcome representation (`src/outcome.js`) instead of inventing a new result type.
- Represents the expected out-of-stock condition explicitly and distinguishably.
- Prevents `VendorTimeoutError` (or another vendor-specific type) from escaping as public meaning.
- Keeps `reserveItem` asynchronous end to end.
- Adds tests covering success, the expected business failure, and system/vendor failure translation.
- Leaves managed `documents/artifacts/` unchanged.
- Reports the artifact files actually read and the checks actually run.

## Strong routing signals

- `operation/CHANGE_LIFECYCLE.md` and/or `implementation/INDEX.md` for a normal code change.
- `implementation/TESTING.md` when choosing test placement/type.
- `design/CONTRACTS.md` is reasonable for the new public boundary but not strictly required if the contract reasoning is otherwise sound.

Exact path set is not mandatory if the agent reaches equivalent necessary guidance with a smaller justified route.

## Must not

- Use boolean/null as the only representation of meaningful business failure.
- Let `VendorTimeoutError` propagate into the public result or re-export it as contract.
- Wrap the async vendor call in a misleading synchronous facade.
- Add invalid-SKU semantics, input validation channels, or error codes outside the declared `sku` domain.
- Invent a generic Result/Either framework or rename the project-standard outcome helpers.
- Read the entire artifact pack without a concrete reason.

## Key observation

The declared valid-input domain is deliberate: this scenario observes whether the agent applies "strong means explicit, not maximally restrictive" — defining the required failure semantics completely without contractually owning behavior outside the stated domain.
