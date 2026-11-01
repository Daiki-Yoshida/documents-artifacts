# AI Engineering Guidance

This directory contains reusable engineering guidance derived from the repository's canonical knowledge.

## RuleClass (RC)

RuleClass describes the force of **each applicable rule**, not a file-wide rank or an operation-risk level:

- **RC3 — Required:** follow the contract when its conditions apply. Do not silently opt out.
- **RC2 — Recommended:** prefer the stated approach; use an alternative for a concrete task/project reason.
- **RC1 — Project Defined:** the project chooses the concrete method, name, or policy; its choice can still be binding locally.

Resolve applicability separately from RC. Project-local instructions specialize the reusable rules; an actual exception to an applicable RC3 contract needs an explicit Owner decision. RC does not change commit, merge, or destructive-operation authority.

For concrete implementation in a project adopting this pack, **Work Identity is RC3**: reuse the confirmed Work or establish a new one before implementation (see `project/WORK_IDENTITY.md`). Branches, worktrees, containers, and other materialized resources are separate need-based choices.

## Read minimally

Do **not** read every file by default. Start here, identify the task, then open only the relevant router or leaf files.

Project-local instructions, architecture, commands, and constraints take precedence where they intentionally specialize this reusable guidance. Do not invent project-local facts from these artifacts.

This directory is a **managed derived snapshot**. Do not edit the installed artifact copy to create project-specific rules or permanent corrections. Put local overrides in project-owned instructions/documentation; fix reusable guidance at its canonical source and redistribute it.

## Route by task

| Task | Read |
|---|---|
| Normal code change / refactor | `operation/CHANGE_LIFECYCLE.md` → `implementation/INDEX.md` |
| New API / boundary / architecture | `design/INDEX.md` + `operation/CHANGE_LIFECYCLE.md` + relevant implementation leaf |
| Dependency / DI | `implementation/DEPENDENCIES.md` |
| Domain model / DTO / mapping | `implementation/DOMAIN_AND_DATA.md` |
| Failure / async / concurrency | `implementation/FAILURE_AND_ASYNC.md` |
| Tests | `implementation/TESTING.md` |
| Public contract change | `design/CONTRACTS.md` + `implementation/COMPATIBILITY.md` |
| Performance-driven redesign | `implementation/PERFORMANCE.md`; add `design/CONTRACTS.md` if interaction shape changes |
| Documentation | `documentation/INDEX.md`; also use `operation/CHANGE_LIFECYCLE.md` when documentation is part of an engineering change |
| Project / repository structure | `project/WORKSPACE.md` |
| Project-owned scratch / isolated checkout / Project-Root-external write | `project/WORKSPACE.md` + `operation/SCOPE_AND_AUTHORITY.md`; add `safety/INDEX.md` for structural/destructive/host risk |
| Multi-repository workspace setup (primary checkouts + Work checkouts) | `project/WORKSPACE.md` → `project/WORKTREES.md` |
| Project-root session / command target routing | `project/WORKSPACE.md` + `execution/COMMANDS_AND_CI.md` |
| Work identity / lifecycle | `project/WORK_IDENTITY.md`; add `project/WORK_LIFECYCLE.md` when needed |
| Work Records checkpoint / completed Work archive | `project/WORK_IDENTITY.md` + `project/WORK_LIFECYCLE.md`; add `documentation/WORKFLOW_AND_MAINTENANCE.md` for reconciliation |
| Worktree operation | `project/WORKTREES.md`; add safety guidance for destructive actions |
| Repository integration / merge / rebase | `safety/INTEGRATION_AND_CONFIRMATION.md` → `operation/VERIFICATION_AND_DONE.md` |
| Scope / authority / clarification, approach-only / brownfield entry, commit / push / reporting decisions | `operation/INDEX.md` |
| Instruction / task-spec / review / handoff / explanation context | `operation/CONTEXT_SHAPING.md` |
| Docker / build / test / CI environment | `execution/INDEX.md` |
| Delete / cleanup / reset / recovery | `safety/INDEX.md` |

## Global guard

Keep public boundaries precise and contained internals flexible. Use YAGNI to avoid speculative surface and internal machinery, not to weaken a selected contract merely because completing it is expensive.

Shape guidance around the model needed for the current purpose. Do not expand rejected or undesired alternatives solely to negate them; preserve alternatives when they carry necessary decision, correction, migration, safety, or explanatory value.
