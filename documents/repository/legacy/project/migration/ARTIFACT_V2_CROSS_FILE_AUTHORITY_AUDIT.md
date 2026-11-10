# Artifact v2 — Cross-File Authority Audit

```yaml
document_type: "repository_local_artifact_authority_audit"
date: "2026-09-24"
candidate_head: "e3c4922ce4693446b6b1f4f071d940b49bd08eb6"
candidate_files: 41
```

## Goal

Artifact files are intentionally denormalized for AI consumption, but they must not create new competing authorities.

A leaf may restate enough context to be usable by itself. It must still route the deeper decision to one primary owner.

## Authority boundaries

| Concern | Primary artifact owner | Related artifact behavior | Verdict |
|---|---|---|---|
| where/how far to harden | `design/BOUNDARY_HORIZON.md` | responsibility and contracts consume the chosen boundary | PASS |
| selected contract completeness / contract risk level | `design/CONTRACTS.md` | failure/performance/compatibility route here when caller-visible | PASS |
| compatibility mechanics | `implementation/COMPATIBILITY.md` | CONTRACTS owns confirmation level; compatibility owns evidence/dimensions | PASS |
| concept neutrality / sharing | `design/CONCEPT_ALTITUDE.md` | CODE_STRUCTURE only carries shared-placement guard | PASS |
| mutable state / cross-boundary outcome | `design/STATE_AND_CONSISTENCY.md` | DOMAIN_AND_DATA routes to it | PASS |
| code realization / layering | `implementation/CODE_STRUCTURE.md` | design leaves do not own layer implementation | PASS |
| dependency / DI / external containment | `implementation/DEPENDENCIES.md` | CODE_STRUCTURE references dependency direction only at high level | PASS |
| engineering lifecycle | `operation/CHANGE_LIFECYCLE.md` | it routes domain/risk questions instead of redefining them | PASS |
| commit/push authority | `operation/VERSION_CONTROL_AND_REPORTING.md` | documentation FORMAT_AND_GIT owns only documentation presentation convention | PASS |
| documentation routing/model | `documentation/*` | project/work artifacts own static/dynamic placement, not documentation semantics | PASS |
| static repository/project structure | `project/WORKSPACE.md` | Work Identity consumes stable repository identity | PASS |
| dynamic Work identity/lifecycle/resources | `project/WORK_IDENTITY.md` + `WORK_LIFECYCLE.md` | execution materializes resources; safety governs destructive effects | PASS |
| normal worktree create/status/remove | `project/WORKTREES.md` | force/delete/purge routes to safety | PASS |
| runtime materialization/reuse | `execution/HOST_AND_CONTAINER.md` | Work lifecycle owns scope/identity, not Docker implementation | PASS |
| public development command surface | `execution/COMMANDS_AND_CI.md` | Worktree semantics remain owned by project/WORKTREES | PASS |
| destructive-operation authorization | `safety/DESTRUCTIVE_OPERATIONS.md` | other leaves may identify destructive cases but do not lower the safety level | PASS |
| diagnosis/recovery | `safety/DIAGNOSTICS_AND_RECOVERY.md` | execution/work files provide state vocabulary, not recovery authority | PASS |
| integration-operation safety | `safety/INTEGRATION_AND_CONFIRMATION.md` | Work lifecycle decides when the whole Work is complete | PASS |
| managed installed artifact ownership | root `INDEX.md` + documentation workflow | root gives always-visible guard; documentation owns detailed update/override semantics | PASS |

## Accepted local restatement

The following duplication is intentional because omitting it would make a leaf unsafe when read alone:

- CONTRACTS repeats that YAGNI must not weaken selected contract completeness.
- FAILURE_AND_ASYNC reminds the reader that caller-visible failure/async semantics are contractual.
- WORKTREES identifies force removal as destructive, then routes authorization to safety.
- HOST_AND_CONTAINER uses Work identity terms for resource names, while WORK_LIFECYCLE remains the scope/lifecycle owner.
- Root INDEX states the managed-snapshot rule, while documentation workflow contains the detailed maintenance rule.

These are **contextual restatements**, not independent definitions.

## Misownership avoided

Candidate review intentionally avoids:

- putting branch/worktree lifecycle into workspace static structure;
- putting destructive cleanup authorization into Work lifecycle;
- putting code-contract severity into engineering workflow;
- putting commit/push authority into documentation format rules;
- putting general brownfield scope discipline into execution migration;
- treating artifact routing directories as new semantic subjects.

## Verdict

No unresolved cross-file authority conflict was found in the current candidate.

Future edits should fail review if the same normative decision becomes independently editable in multiple leaves.
