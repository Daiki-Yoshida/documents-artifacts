# Task

This workspace adopted protocol version 2 (see
`config/protocol-version.txt`), but the participating components and the
project coordination state have not been updated to match.

Component repositories participating in this workspace are independent
Git repositories — that is a project fact. The workspace mapping lives in
`workspace/repositories.conf`.

Please:

- update every participating repository to the workspace target
  protocol;
- update the Project-Repository-owned coordination state accordingly;
- keep each repository's ownership intact;
- make `make verify` pass.

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
- what you changed and why;
- the verification actually run and its result.
