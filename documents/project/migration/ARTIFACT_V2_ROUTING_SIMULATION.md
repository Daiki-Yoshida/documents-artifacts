# Artifact v2 — Routing Simulation

```yaml
document_type: "repository_local_artifact_routing_simulation"
date: "2026-09-24"
candidate_head: "d58ea9e8b4986da8378ff322dd971d71d4222994"
measurement: "Git blob byte size / 4 as coarse token approximation; not a tokenizer guarantee"
candidate_files: 41
candidate_pack_approx_tokens: 18692
root_index_approx_tokens: 554
```

## Goal

The whole artifact pack may be installed in every target project, but a normal AI task should load only a small relevant path.

The simulation checks whether common tasks can route from the root without reading the full pack.

## Scenarios

| Scenario | Intended read path | Approx tokens | Result |
|---|---|---:|---|
| Private refactor | root → change lifecycle → implementation router → code structure | ~1,911 | PASS |
| Dependency / DI change | root → change lifecycle → implementation router → dependencies | ~1,750 | PASS |
| New public API | root → design router → contracts → compatibility → change lifecycle | ~2,402 | PASS |
| New architectural boundary | root → design router → horizon → responsibility → contracts → lifecycle | ~3,716 | PASS |
| Expected failure / async behavior | root → failure/async → contracts | ~1,984 | PASS |
| Performance-driven API redesign | root → performance → contracts → compatibility | ~2,201 | PASS |
| Documentation structure change | root → documentation router → principles/routing → workflow/maintenance | ~2,451 | PASS |
| Establish/complete Work Identity | root → project router → Work Identity → Work lifecycle | ~1,933 | PASS |
| Routine worktree create/status | root → worktree contract | ~1,630 | PASS |
| Dirty/forced worktree removal question | root → worktree contract → destructive operations | ~2,046 | PASS |
| Docker / CI command work | root → execution router → host/container → commands/CI | ~1,691 | PASS |
| DB reset / destructive recovery | root → safety router → destructive operations → diagnostics/recovery | ~1,358 | PASS |
| Multi-repository integration | root → workspace → Work lifecycle → integration safety | ~2,065 | PASS |

The broadest representative route above remains far below reading the whole ~18.7k-token pack.

## Routing quality observations

### Good

- Most specialized tasks need only 2–4 files including root.
- Worktree detail is isolated from normal code changes.
- Testing, DI, mapping, failure, performance, and compatibility are independently routable.
- Design boundary questions can load strong contract rules without loading all implementation guidance.
- Safety can be added only when the requested effect is destructive/structural.
- Project/work identity does not force development-execution detail into every task.

### Guard added during simulation

The root router now states that installed artifacts are managed derived snapshots. This prevents a target-project AI from treating the distributed copy as the place to persist generic or local rule changes.

Documentation routing also points to engineering change lifecycle when a documentation update is part of an engineering change.

## Router integrity

Expected invariant:

- root router is small;
- directory INDEX files contain routing, not duplicated leaf bodies;
- leaf files may cross-route only when the adjacent concern is conditionally necessary;
- a normal task must not require "read all artifacts first".

A future regression should be flagged if:

- a common task regularly exceeds ~6k–8k tokens of artifact context;
- a router grows into a second copy of leaf content;
- one leaf is routinely read while most of it is irrelevant;
- the same normative rule must be independently maintained in multiple leaves;
- task routing requires long chains of INDEX → INDEX → INDEX.

## Promotion result

The reviewed candidate was promoted byte-for-byte to formal `artifacts/` after:

1. cross-file semantic review;
2. link/routing integrity review;
3. explicit runtime language decision;
4. legacy semantic regression review;
5. whole-pack distribution redesign.

Distribution behavior validation and the remaining full-checkout limitation are recorded in `ARTIFACT_V2_PROMOTION_VALIDATION.md`.
