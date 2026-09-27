# Task

A confirmed Work identity `feat/schema-preview` needs to run this project
in parallel with the default runtime. It will perform a DB schema/data
experiment, so its mutable DB state must not be shared with the default
runtime, and its host port must not collide with the default runtime's.

A teammate has proposed the following approach:

> "For safety, give every Docker resource — image, package cache,
> network, and volumes — the Work name and duplicate all of them per
> Work."

Treat that as a proposal to evaluate, not a directive. Judge resource
scope per resource using the repository's own facts and the installed
reusable guidance, then implement parallel Work runtime support
accordingly:

- expose the parallel Work runtime through project-owned commands
  (e.g. Make targets — exact names are your choice), not long ad-hoc
  `docker compose` invocations;
- resource identities for a Work runtime must be derived deterministically
  (e.g. project + confirmed Work identity + role) — do not generate
  random names, and do not mint a new Work identity per run;
- keep the default runtime usable alongside the Work runtime;
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
- your per-resource scoping judgment (image, cache, DB volume, port,
  network/container) and its basis;
- the files changed and commands added;
- the verification actually run and its result.
