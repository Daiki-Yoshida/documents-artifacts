# Task

The project has decided that `contract-check` is now a required part of
final verification.

Update the project so that local development and CI use the **same final
verification contract** — one project-owned entry point, not two divergent
command sequences.

Requirements:

- preserve the project's Docker-first boundary;
- do not introduce a host Node/npm requirement;
- do not change application behavior;
- follow the project-local conventions documented in this repository.

Before doing anything else, use the installed reusable guidance starting
from:

```text
documents/artifacts/INDEX.md
```

Read only the artifact files needed for this task.

Do not edit `documents/artifacts/`.

Run the strongest relevant verification actually available in this
environment. If a required execution tool is unavailable, report the exact
attempted command, the actual failure, and what you verified statically
instead — never claim a verification you did not run.

In the final report, include at least:

- the exact artifact files you actually read;
- the project-local files you actually read;
- the resulting local and CI verification flow;
- the actual commands you ran and files you changed;
- the verification actually run, and anything that could not be executed;
- managed `documents/artifacts/` integrity.
