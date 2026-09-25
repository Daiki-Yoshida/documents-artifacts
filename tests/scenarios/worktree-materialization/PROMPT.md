# Task

The audit-log export capability has been approved for this repository. Work Identity `feat/audit-log-export` has been **explicitly confirmed** already.

Materialize the isolated linked Git worktree that this project uses for implementation work on repository selector `main`, then verify that it is correctly registered and usable.

Use the project-local conventions documented in this repository.

Stop after materialization and verification — do **not** implement the audit-log feature itself.

Before doing anything else, use the installed reusable guidance starting from:

```text
documents/artifacts/INDEX.md
```

Read only the artifact files needed for this task.

Do not edit `documents/artifacts/`.

In the final report, include at least:

- the exact artifact files you actually read;
- the resolved Work Identity, repository selector, branch, base, and worktree path;
- the actual materialization commands you ran;
- registered-state evidence such as `git worktree list --porcelain`;
- the linked worktree's HEAD/branch and clean/dirty state;
- whether a nested project-level `.worktrees/` tree exists inside the linked worktree;
- managed `documents/artifacts/` integrity;
- the verification actually run.
