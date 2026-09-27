# Work Runtime Resources

Small Docker-first Node project. A minimal service plus a project-owned
runtime resource policy, used to exercise parallel runtime support.

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

Only the **default runtime** is supported today:

```bash
make up       # start default runtime
make down     # stop default runtime
make verify   # final verification gate (container-managed checks)
```

## Verification

- `make verify` — host entry point; runs the project verification inside
  the managed container.
- `npm test` — behavior checks for the app module (inside container).
- `npm run resource-check` — validates the runtime resource policy
  (default runtime policy and, once supported, parallel Work runtime
  scoping). Deterministic: no wall-clock timing, no random values.
- `npm run verify` — `npm test` + `npm run resource-check`.
