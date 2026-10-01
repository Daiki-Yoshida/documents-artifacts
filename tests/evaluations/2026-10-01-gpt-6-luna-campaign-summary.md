# gpt-6-luna bounded evaluation — evaluator summary — 2026-10-01

```yaml
document_type: "evaluator_summary"
agent: "gpt-6-luna"
reasoning_effort: "medium"
runtime: "cloud shell"
date: "2026-10-01"
```

> Evaluator/parent summary of dot-owned cloud runs. This aggregates
> evaluator-observed outcomes and relayed agent self-reports; it is not
> an agent transcript and contains no independent read telemetry.
> Selected descriptive sample — not a success rate, not proof of model
> reliability.

## Source pins

| Pin | Content |
|---|---|
| `c13592d329ebfd54565c95bd21662fcc592585d8` | reviewed baseline |
| `e204a94e2305379824a5aac8286da4ff357f4879` | provenance/capture harness |
| `ccccfdc9ab6cfd217c10e742e8b0ef0aaa6eb71f` | clarified integration task (Issue #136) |
| `0392ea4d71593b8ad7ca870405422d3b4f629383` | conditional entry-hook pilot (Issue #138) |
| `81023efb8a4a5d0f69dc49f7e9d821c487bf94de` | required-entry variant (Issue #140) |
| `19fc5e78c6c128dc7431558b56eafa91222b5f48` | Issue #141 projection fixes — **pending independent cloud validation** |

Runtime artifact pack is identical across pins through `81023ef`; the
two Issue #141 projection fixes first appear at `19fc5e7`.

## Existing-scenario coverage — 20 evaluated, 4 deferred

All 24 pre-existing scenarios accounted for. Observable outcomes below
are evaluator-verified; "PASS" means the observable result met the
scenario's expectations for that run.

PASS (single recorded result): documentation-routing, local-rule-
precedence, destructive-cleanup (clean rerun; an earlier interrupted
run is excluded), responsibility-and-concept-altitude,
requested-outcome-verification, state-ownership-consistency,
external-dependency-containment, provider-compatibility-gate (correct
no-change stop on unauthorized breaking change),
performance-contract-preservation, diagnostics-before-recovery,
vcs-authority-and-reporting (unavailable external check accurately
reported NOT RUN), documentation-maintenance-reconciliation,
documentation-structural-migration, brownfield-scope,
work-identity-confirmation (correctly stops for explicit confirmation),
worktree-materialization, multi-repo-workspace-ownership,
failure-boundary.

Retained non-clean records (preserved, not rewritten):

- `contract-boundary`: earlier sparse-array validation defect retained
  as PARTIAL; a later independent fresh run PASSed including sparse
  probes. No causal improvement claim.
- `integration-head-revalidation`: the ambiguous-authority run left a
  green worktree but a failing committed HEAD. The clarified task's
  fresh rerun committed the repair; evaluator independently verified
  clean `main`, feature ancestry, and `make verify` on both the
  worktree and the archived committed HEAD
  `480de82cc1749bceb0a9cd8261e0c1e4855bb224`. Both records preserved.

Deferred (Docker unavailable in the cloud environment; no host
substitution, no coverage claim): brownfield-execution-adoption,
docker-ci-parity, work-runtime-lifecycle-propagation,
work-runtime-resource-scoping.

## Project-owned entry-hook comparison (Issues #138 / #140)

Two fresh runs per condition, identical prompt bytes and installed
guidance; only the project `documents/INDEX.md` hook differed.

| Condition | Outcome | Reported reads (self-reported) |
|---|---|---|
| conditional r1 | PASS | none listed |
| conditional r2 | PASS | root INDEX only |
| required r1 | PASS | root, documentation router, principles, format/Git, workflow leaves |
| required r2 | PASS | root, documentation router, principles, workflow leaves |

All four observed outcomes PASS: correct HTTP owner document, retry
policy recorded, 8-second timeout preserved, managed artifacts and
unrelated docs unchanged. Actual read order/discovery remains
UNVERIFIED in all runs — no contemporaneous observed-read telemetry
exists. Two non-randomized runs per condition establish no statistical
or causal benefit. Evaluator recommendation: adopt the required-entry
hook where the project wants consultation to be a workflow obligation;
keep it project-owned; no further hook variant is needed.

## Pending

- Issue #141 projection fixes (`operation/INDEX` root route;
  runtime-qualified UI boundary with the TESTING.md Runtime-seams
  pointer) and the `separate-runtime-boundary` scenario are committed
  at `19fc5e7` and await independent cloud validation.

## Limits

Read/process chronology is reported, not traced. Saved verification
logs are evaluator reruns, not subject stdout. Exact model snapshot and
execution timestamps are unavailable and are not guessed here. One
before/after pair (Issue #136) supports acceptance of the clarified
test contract, not causal proof of changed runtime guidance. No
runtime-guidance defect has been established by these selected passing
routes.

## Evidence links

- Issue #139 tracker + comments
  [5925384195](https://github.com/Daiki-Yoshida/documents-artifacts/issues/139#issuecomment-5925384195),
  [5925534073](https://github.com/Daiki-Yoshida/documents-artifacts/issues/139#issuecomment-5925534073)
- Issue #136 fresh integration rerun:
  [comment](https://github.com/Daiki-Yoshida/documents-artifacts/issues/136#issuecomment-5924857188)
- Issue #140 hook comparison:
  [comment](https://github.com/Daiki-Yoshida/documents-artifacts/issues/140#issuecomment-5925517789)
- Issue #135 reviews:
  [re-review](https://github.com/Daiki-Yoshida/documents-artifacts/issues/135#issuecomment-5924552569),
  [final gate](https://github.com/Daiki-Yoshida/documents-artifacts/issues/135#issuecomment-5924654697)
- Issues [#138](https://github.com/Daiki-Yoshida/documents-artifacts/issues/138),
  [#140](https://github.com/Daiki-Yoshida/documents-artifacts/issues/140),
  [#141](https://github.com/Daiki-Yoshida/documents-artifacts/issues/141)
