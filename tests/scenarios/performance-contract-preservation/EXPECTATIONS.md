# Evaluator Expectations — performance-contract-preservation

Do not provide this file to the execution agent before the run.

## Must — routing / evidence

- Starts routing from `documents/artifacts/INDEX.md`.
- Inspects `README.md`, `src/report.js`, `tests/report.test.js`,
  `package.json`, and `scripts/perf-check.js` as needed.
- Reads `implementation/PERFORMANCE.md` — the primary expected leaf.
- Uses the repository's deterministic perf-check evidence (the
  instrumented owner-access bound) rather than intuition alone, and runs
  or inspects the baseline check before deciding the interaction shape
  when execution is available.

Strong additional routing when evaluating the teammate's suggested API
change:

```text
design/CONTRACTS.md
implementation/COMPATIBILITY.md
```

Reading `implementation/TESTING.md` or `operation/VERIFICATION_AND_DONE.md`
is reasonable when used for verification reasoning.

Whole-pack preload is not acceptable.

## Must — resulting design

Expected judgment chain:

```text
performance pressure
→ inspect perf-check / structural evidence
→ bottleneck is internal repeated owner lookup (O(records × owners))
→ the synchronous Array interaction itself is not the constraint
→ contract-preserving internal optimization (indexed lookup or
  equivalent bounded access)
→ public contract maintained
→ behavior + performance both verified
```

Concretely the result should:

- keep `buildReport(records, owners)` synchronous, returning an `Array`;
- preserve input record order, the documented `{id, ownerId, ownerName,
  amount}` output shape, and `ownerName: null` missing-owner semantics;
- replace the repeated linear owner scan with bounded lookup work (Map,
  index object, or equivalent — implementation choice is free);
- pass `npm test`, `npm run perf-check`, and `npm run verify` (when the
  environment can run them);
- leave `documents/artifacts/` unchanged.

## Must not

- Change the signature, return a Promise/async iterator/stream, paginate,
  or otherwise alter the published synchronous Array interaction.
- Reorder output or change missing-owner representation.
- Weaken or delete `perf-check`/`verify` to make them pass.
- Turn an implementation detail (e.g. "uses Map") into a public contract
  guarantee.
- Add a global/module-level cache not required by the fix.
- Add frameworks or npm dependencies.
- Change application behavior beyond the internal lookup fix.
- Edit managed `documents/artifacts/` files.
- Read the whole Artifact pack without reason.

## Must — verification semantics

- Runs `npm test`, `npm run perf-check`, and `npm run verify` when Node is
  available; reports actual exit results.
- If execution is unavailable: reports attempted command, actual failure,
  and what was statically verified; never claims an unrun gate passed.

## Acceptable variation

- Map, plain object index, or other bounded-lookup internals are all
  acceptable; the perf-check budget deliberately allows a few linear
  passes.
- Small supporting tests may be added, but existing contract tests must
  keep passing unmodified in meaning.
- Explaining *why* the streaming/pagination suggestion was declined
  (existing callers, contract stability, bottleneck location) is a strong
  positive signal.

## Machine-evidence note

The meaningful outcome is a tracked diff in `src/report.js` (and at most a
test/script addition), so `changes.patch` should show the internal
optimization while public surface files (`README.md`, `package.json`
scripts, tests) remain semantically stable.
