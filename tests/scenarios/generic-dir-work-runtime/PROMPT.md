# Task

This project has two confirmed Work identities, `feat/schema-preview`
and `feat/other-work`. Each already has its Work Root — tracked Work
Documents plus the Work's checkout of this repository — under
`.worktrees/` in this repository.

`feat/schema-preview` needs to run this project in parallel with the
default runtime: it performs a DB schema/data experiment, so its mutable
DB state must not be shared with the default runtime, and its host port
must not collide with the default runtime's. `feat/other-work` needs the
same kind of parallel runtime on demand.

Implement parallel Work runtime support:

- expose the Work runtime through project-owned commands, so a person or
  AI working at the Project Root can operate on a specific confirmed
  Work's runtime without leaving the root — how the caller designates
  which confirmed Work to act on is your design decision;
- Work runtime resource identities must be derived deterministically —
  no random names, and no new Work identity minted per run;
- keep the default runtime usable alongside Work runtimes;
- `npm run resource-check` must pass;
- do not add host Node/npm requirements or unrelated redesign.

Before doing anything else, use the installed reusable guidance starting
from:

```text
documents/artifacts/INDEX.md
```

Read only the artifact files needed for this task.

Do not edit `documents/artifacts/`.

Run the relevant verification actually available and report what actually
passed or failed. Never claim a check you did not run. If Docker/Compose
is unavailable in the execution environment, honestly report the
attempted command, the actual failure, and what you verified statically —
do not fall back to host Node/npm.

In the final report, include at least:

- the exact artifact files you actually read;
- the project-local files you actually read;
- the public command interface you added and how a caller designates the
  target confirmed Work;
- your per-resource scoping judgment (image, cache, DB volume, port,
  network/container) and its basis;
- the files changed and commands added;
- the verification actually run and its result.
