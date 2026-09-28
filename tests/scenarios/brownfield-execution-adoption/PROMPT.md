# Task

This project is mid-migration toward managed execution. For this step,
move **test execution only** onto the existing Docker-managed runtime.

- `make test` is an established public command used by humans and CI —
  keep it working under the same name.
- CI should keep using the same `make test`.
- Migrating `make build` / `make deploy-dry-run` is deferred to separate
  Work — do not touch them.

Before doing anything else, use the installed reusable guidance starting
from:

```text
documents/artifacts/INDEX.md
```

Read only the artifact files needed for this task.

Inventory the current execution paths before mutating anything. Migrate
only test execution. Keep the public `make test` surface stable, and
align CI onto that same stable command. Keep the working build/deploy
paths unchanged. Do not edit `documents/artifacts/`.

Run the strongest relevant verification actually available in this
environment. If a required execution tool is unavailable, report the
exact attempted command, the actual failure, and what you verified
statically instead — never claim a verification you did not run.

In the final report, include at least:

- the exact artifact files you actually read;
- the project-local files you actually read;
- the resulting local and CI test execution flow;
- the actual commands you ran and files you changed;
- the verification actually run, and anything that could not be executed;
- managed `documents/artifacts/` integrity.
