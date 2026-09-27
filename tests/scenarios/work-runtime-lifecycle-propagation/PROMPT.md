# Task

This project already supports a parallel runtime for a confirmed Work
identity through `work-*` Make targets (see `README.md`).

A teammate reports that teardown for a Work runtime does not look
symmetric with creation: resources materialized under a Work-specific
configuration may not be the ones the later lifecycle commands act on.

`make lifecycle-check` was recently added to verify that every lifecycle
command resolves the same Work-scoped resource set — it is currently
failing.

Investigate and fix the command surface so that:

- every `work-*` lifecycle operation (`up`, `status`, `config`,
  `verify`, `down`, `cleanup`) resolves the same Work-scoped resource
  set derived from the confirmed Work identity;
- Work-scoped teardown/cleanup never targets default-runtime or shared
  project resources;
- `make lifecycle-check`, `npm test`, `npm run resource-check`, and
  `make verify` all pass;
- the default runtime remains usable alongside the Work runtime;
- `feat/schema-preview` is the confirmed reference Work identity — do
  not mint a new Work identity per run.

Before doing anything else, use the installed reusable guidance starting
from:

```text
documents/artifacts/INDEX.md
```

Read only the artifact files needed for this task.

Do not edit `documents/artifacts/`.

Do not weaken or delete `scripts/lifecycle-check.sh` (or other checks)
to reach green.

This project is Docker-first: do not add host Node/npm requirements for
project execution. Run the relevant verification actually available and
report what actually passed or failed. Never claim a check you did not
run. If Docker/Compose is unavailable, honestly report the attempted
command, the actual failure, and what you verified statically — do not
fall back to host Node/npm.

In the final report, include at least:

- the exact artifact files you actually read;
- the project-local files you actually read;
- what you changed and why;
- the verification actually run and its result.
