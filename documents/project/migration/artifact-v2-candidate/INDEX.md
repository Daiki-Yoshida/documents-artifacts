# AI Engineering Guidance

This directory contains reusable engineering guidance derived from the repository's canonical knowledge.

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
| Work identity / lifecycle | `project/WORK_IDENTITY.md`; add `project/WORK_LIFECYCLE.md` when needed |
| Worktree operation | `project/WORKTREES.md`; add safety guidance for destructive actions |
| Docker / build / test / CI environment | `execution/INDEX.md` |
| Delete / cleanup / reset / recovery | `safety/INDEX.md` |

## Global guard

Keep public boundaries precise and contained internals flexible. Use YAGNI to avoid speculative surface and internal machinery, not to weaken a selected contract merely because completing it is expensive.
