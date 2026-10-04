# Task

This Management Root Repository coordinates two independent Component
Repositories. Their source checkouts are provided outside this repository,
at `../sources/` relative to the repository root.

Work Identity `feat/bootstrap-check` has been **explicitly confirmed**
already. It covers every participating repository.

Set up this workspace for that Work:

- create each Component Repository's primary checkout according to this
  project's conventions;
- materialize the repository-specific Work worktrees for every
  participating repository, including this Management Root Repository;
- establish the Work Root's tracked coordination documents;
- verify the result with the project's verification gate.

Use the project-local conventions documented in this repository.

Stop after the workspace is set up and verified — do not implement any
feature work inside the components.

Before doing anything else, use the installed reusable guidance starting
from:

```text
documents/artifacts/INDEX.md
```

Read only the artifact files needed for this task.

Do not edit `documents/artifacts/`.

In the final report, include at least:

- the exact artifact files you actually read;
- the project-local files you actually read;
- each repository's resolved selector, checkout/worktree path, and branch;
- the actual commands you ran;
- `git worktree list --porcelain` evidence for every participating
  repository;
- the verification actually run and its result.
