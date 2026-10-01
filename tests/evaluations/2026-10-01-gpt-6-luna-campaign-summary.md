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

## Follow-up — 2026-10-01 (independent reviews; observed entry-hook pair)

Appended after the original summary; all earlier sections are
unchanged. The "Pending" item above is superseded as noted below.
This section remains an evaluator summary — not an agent transcript
and not independent read telemetry.

### Source pins

- `19fc5e78c6c128dc7431558b56eafa91222b5f48` — Issue #141 projection
  fixes under independent review
- `48ae5e9682310fb4ce01738955c61c8b9e98af44` — Issue #142 observer
  boundary/identity fixes
- `52e6a3d4713f4a2d6a842b4d5573a6db66a4a5c7` — prepare/capture source
  pin for the observed pair below
- `eea6a9c1ef831b4f4e3c9bfcf82c3f0d4e122236` — later test-only
  regression fix; the observed pair is not retroactively relabeled
  with it (observer blob identical at both commits:
  `a4f1e91967194f8572e9c0ec1a5548d694525a31`)

### Issue #141 — independent review result

Independent cloud review at `19fc5e7` accepts both minimal
canonical-grounded projection fixes; all three suites and
protected-original checks pass. Two fresh `gpt-6-luna`/medium
`separate-runtime-boundary` runs preserve the published API boundary
and the same-runtime CLI, map/render the requested wire field, and
pass the boundary guard plus evaluator behavioral probes. One run
documents date-only semantics but passes through the internal value;
upstream format is unspecified, so broader format coverage is
conditional — not a proven original-task failure. The guard alone is
green at baseline and is not sufficient outcome evidence. One fresh
VCS task correctly creates its authorized local review commit,
leaves main/remotes unchanged, and reports external verification
NOT RUN. Reported reads (self-reported): the VCS run now includes
`operation/INDEX.md` plus authority/reporting leaves; one runtime run
reports `CODE_STRUCTURE.md`, the other does not. Actual read
telemetry remains absent for these runs; no causal improvement claim.

### Issue #142 — observer review and observed pair

The optional observer was independently reviewed and fixed
(`48ae5e9` boundary/identity defects; `52e6a3d` test-header restore;
`eea6a9c` diagnostic-path regressions). At `eea6a9c` all three
suites pass, including `test-knowledge-integrity.sh` with the pinned
historical snapshot present — no comparison skip.

One paired observation ran at pin `52e6a3d`: fresh native
`gpt-6-luna`/medium, one run each on `project-entry-discovery`
(conditional hook) and `project-entry-required` (required hook),
identical blind task and artifact pack, no observer instructions and
no runtime-guidance change. Identical 44-file watch scope: 41
installed artifact documents plus `AGENTS.md`, `README.md`,
`documents/INDEX.md`; owner documents and the run-level `PROMPT.md`
were outside the scope. The observer was READY before each subject
started and stopped after each finished, before inspection/capture;
both sessions exited 0 with footers `drained: true`,
`incomplete: false`, `reasons: []`.

Outcome (assessed separately from observation): **both runs pass** —
only `documents/project/HTTP_CLIENT.md` changed; GET retries ≤ 2 for
502/503 with exponential backoff; POST never retried; 8-second
timeout preserved; managed artifacts byte-identical; post-stop
`git diff --check` clean. Reporting differs: the conditional run's
final message includes its consulted-file list; **the required run's
final omits the requested list — an earlier supplemental response
contains it**; both records are preserved separately, the gap is not
silently filled.

Observed OPEN labels (first-observed registration-label order; OPEN
is not reading, exposure to the model, or understanding):

- Conditional — 6 labels, 3 of 41 artifact documents:
  `AGENTS.md`, `README.md`, `documents/INDEX.md`,
  `documentation/INDEX.md`, `documentation/WORKFLOW_AND_MAINTENANCE.md`,
  `documentation/FORMAT_AND_GIT.md`.
  **No `artifacts/INDEX.md` OPEN was observed** in the conditional
  run's completed window.
- Required — 8 labels, 5 of 41 artifact documents: the same six plus
  `documentation/PRINCIPLES_AND_ROUTING.md` and
  `artifacts/INDEX.md`. The artifact-root OPEN is **eventual, not
  root-first** — two documentation-guidance files precede it. Whether
  that root event preceded the owner-document edit is not known:
  the OPEN-only scope cannot establish timing-relative ordering
  against the edit.

Testimony comparison: the watched portion of each self-reported path
list exactly matches its observed OPEN-label set (two abbreviated
filenames normalized for set comparison; raw finals unchanged).
Owner-document and `PROMPT.md` consultation lie outside the watch
scope and are not corroborated. Keep separate: policy-output pass;
self-reported consultation; independently observed OPEN
labels/order.

### Limits for the follow-up

OPEN does not prove bytes were read, exposed to the model, or
understood. inotify has no PID attribution; harness or other-process
opens are indistinguishable. Events coalesce — counts are not
unique-open counts. Preloaded/cached content and already-open
descriptors may produce no event. End-only identity checks cannot
detect a move-out-and-back transient. An absent event means only no
OPEN observed for that label within the completed window. One pair
is descriptive evidence, not a causal or reliability claim.

### Deferred scenarios (unchanged)

brownfield-execution-adoption, docker-ci-parity,
work-runtime-lifecycle-propagation,
work-runtime-resource-scoping — still Docker-deferred; no host
substitution, no coverage claim.

### Follow-up evidence links

- Issue #141 independent review:
  [comment](https://github.com/Daiki-Yoshida/documents-artifacts/issues/141#issuecomment-5925723081)
- Issue #142 observed pair + regression validation:
  [comment](https://github.com/Daiki-Yoshida/documents-artifacts/issues/142#issuecomment-5926251512)
- Issue #142 earlier reviews:
  [boundary defects](https://github.com/Daiki-Yoshida/documents-artifacts/issues/142#issuecomment-5925942864),
  [header-restore fix](https://github.com/Daiki-Yoshida/documents-artifacts/issues/142#issuecomment-5925956209),
  [diagnostic-path fix](https://github.com/Daiki-Yoshida/documents-artifacts/issues/142#issuecomment-5926131579)
