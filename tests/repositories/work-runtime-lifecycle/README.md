# Work Runtime Lifecycle

Small Docker-first Node project. A minimal service plus a project-owned
runtime resource policy and a parallel Work-runtime command surface.

## Environment boundary

Host prerequisites (control plane only):

- Git
- Docker / Compose
- Make

Managed runtime — Node, npm, and project commands run **inside** the app
container. Host Node/npm is not part of this project's execution model.

## Runtime resources

Facts about this project's runtime resources:

- **Toolchain/runtime image** is a project resource. It carries the
  managed runtime (Node, npm); it does **not** carry source — `src/` is
  bind-mounted into the container, so the image is not a
  per-run/per-task source snapshot.
- **Package/download cache** is shared project infrastructure
  (`pkg-cache` volume): dependency downloads are identical regardless of
  which runtime consumes them.
- **DB/data volume** holds mutable state. Two runtimes must not share
  mutable state when either of them mutates it.
- **Host port** (`APP_HOST_PORT`, default `8080`) is per-runtime: two
  concurrently running runtimes cannot bind the same host port.

`scripts/resource-identity.js` is the project-owned description of this
runtime resource policy; project tooling derives resource names/ports
from it rather than hardcoding them per command.

## Command surface

Default runtime:

```bash
make up                 # start default runtime
make down               # stop default runtime
make verify             # final verification gate
```

Parallel Work runtime for one confirmed Work identity:

```bash
make work-up       WORK=<type>/<name>   # start the Work runtime
make work-status   WORK=<type>/<name>   # inspect it
make work-config   WORK=<type>/<name>   # render its Compose config
make work-verify   WORK=<type>/<name>   # run verification inside it
make work-down     WORK=<type>/<name>   # stop it (non-destructive)
make work-cleanup  WORK=<type>/<name>   # teardown incl. Work-scoped volume
```

Work-scoped identities derive deterministically from the confirmed Work
identity (`wrr-<work-slug>-<role>`, port `8100 + cksum(work) % 900`); the
toolchain image and package cache are shared with the default runtime,
while the DB volume, host port, network, and container namespace are
per-runtime.

## Verification

- `make verify` — final verification gate: container-managed checks
  (`npm run verify` = `npm test` + `npm run resource-check`) plus the
  host-side `scripts/lifecycle-check.sh`.
- `npm test` — behavior checks for the app module (inside container).
- `npm run resource-check` — validates the runtime resource policy
  (inside container). Deterministic.
- `make lifecycle-check` — validates that every lifecycle command
  resolves the same Work-scoped resource configuration, by inspecting
  the printed recipes (`make -n`) of the `work-*` targets.
  Deterministic: no Docker daemon access, no wall-clock, no randomness.
