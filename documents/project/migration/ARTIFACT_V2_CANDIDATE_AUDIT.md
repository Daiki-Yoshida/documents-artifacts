# Artifact v2 Candidate Audit

```yaml
document_type: "repository_local_artifact_candidate_audit"
candidate_root: "documents/project/migration/artifact-v2-candidate/"
checked_head: "c5fd5c3ed4cb13b4e1fa219421440b3112000cb7"
date: "2026-09-24"
```

## Current candidate

The current candidate is a **whole-pack distribution / selective-reading** structure.

```yaml
files: 41
approx_total_pack_tokens: 18692
largest_leaf_approx_tokens: 1076
root_INDEX_approx_tokens: 554
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

Completed in this design PR:

- section-level semantic review focused on normative strength / condition / exception preservation;
- all 50 current non-history subject files accounted for in projection mapping;
- legacy 14-artifact / 129-H2 regression chain reviewed through current owner/history classification;
- representative task routing simulation completed;
- all 41 candidate files checked for internal artifact references; **0 broken internal references**;
- cross-file authority audit completed with no unresolved double-owner conflict;
- runtime language policy established: concise English artifacts, Japanese canonical knowledge, no bilingual duplication.

See:

- `ARTIFACT_V2_LEGACY_REGRESSION_AUDIT.md`
- `ARTIFACT_V2_ROUTING_SIMULATION.md`
- `ARTIFACT_V2_CROSS_FILE_AUTHORITY_AUDIT.md`

Still intentionally not performed in this PR:

1. replacement of real `artifacts/`;
2. replacement of legacy `artifacts.sh --modules` behavior;
3. distribution/test/README migration for the real pack.

The candidate is now considered **ready for promotion as a separate implementation step**, after this architecture/candidate PR is accepted.


## First semantic-review corrections

First-pass review found two cases where compression weakened current normative meaning. Both were corrected:

1. `project/WORK_IDENTITY.md`
   - restored the current rule that AI may propose a Work Identity but the **user explicitly confirms it before implementation begins**.
2. `documentation/WORKFLOW_AND_MAINTENANCE.md`
   - restored managed-artifact ownership/update semantics;
   - restored documentation strategy re-read triggers.

These are examples of the projection rule `compression != semantic weakening`: omission was shorter, but materially changed runtime guidance.
