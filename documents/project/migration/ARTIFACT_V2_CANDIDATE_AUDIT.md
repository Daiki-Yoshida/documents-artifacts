# Artifact v2 Candidate Audit

```yaml
document_type: "repository_local_artifact_candidate_audit"
candidate_root: "documents/project/migration/artifact-v2-candidate/"
checked_head: "f24ffd052e52d3d5d736516bf221554fab1e6eb1"
date: "2026-09-24"
```

## Current candidate

The current candidate is a **whole-pack distribution / selective-reading** structure.

```yaml
files: 41
approx_total_pack_tokens: 17340
largest_leaf_approx_tokens: 1076
root_INDEX_approx_tokens: 460
router_broken_links: 0
```

The full pack size is not the normal context cost. The expected context cost is the task-selected route.

## Representative read paths

Approximation uses UTF-8 file byte size / 4 only as a coarse comparison metric, not a tokenizer guarantee.

| Task | Files | Approx tokens |
|---|---:|---:|
| normal dependency / DI change | root + lifecycle + implementation router + dependency leaf | ~1,656 |
| public contract change | root + contract + compatibility + lifecycle | ~2,192 |
| architecture / new boundary | root + design router + horizon + responsibility + contract + lifecycle | ~3,518 |
| worktree operation | root + worktree + destructive safety | ~1,952 |
| Docker / CI change | root + execution router + commands/CI + host/container | ~1,509 |
| documentation workflow change | root + documentation router + workflow/maintenance | ~1,138 |

Even the broader representative architecture path remains below the initial 6k–8k preferred normal-task budget.

## Granularity result

The refined split is materially better than the earlier 8-leaf + root design.

Reasons:

- DI changes do not load domain/testing/performance guidance.
- testing changes do not load dependency or mapping guidance.
- Work Identity core does not automatically load the detailed worktree experiment/contract.
- documentation, execution, and destructive safety can be routed independently.
- design decisions can load boundary/contract/state guidance without all code implementation rules.

The relevant metric is **small relevant context**, not repository file count.

## Projection coverage

Current map accounts for all active non-history subject documents.

Special case:

- `encapsulation-horizon/S007_GLOSSARY.md` is not a standalone runtime artifact.
- Terms needed by an artifact are defined locally in the leaf that uses them.
- This avoids requiring a glossary hop for ordinary decisions while preserving necessary semantics.

All `*_HISTORY.md` files are excluded from normal artifact projection by default.

## Candidate status

Completed:

- root router
- 7 directory routers
- 33 task-oriented leaf files
- initial subject → artifact projection map
- all major current subjects represented
- router link check: no broken candidate links
- representative context-size check

Not yet completed:

1. section-level semantic review of every leaf against its current subject source;
2. legacy 14-artifact semantic regression check;
3. representative prompt/task simulations for routing behavior;
4. replacement of real `artifacts/`;
5. replacement of legacy `artifacts.sh --modules` behavior and tests.

Do not promote this candidate to `artifacts/` until semantic review is complete.


## First semantic-review corrections

First-pass review found two cases where compression weakened current normative meaning. Both were corrected:

1. `project/WORK_IDENTITY.md`
   - restored the current rule that AI may propose a Work Identity but the **user explicitly confirms it before implementation begins**.
2. `documentation/WORKFLOW_AND_MAINTENANCE.md`
   - restored managed-artifact ownership/update semantics;
   - restored documentation strategy re-read triggers.

These are examples of the projection rule `compression != semantic weakening`: omission was shorter, but materially changed runtime guidance.
