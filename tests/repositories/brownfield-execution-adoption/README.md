# Brownfield Execution Adoption

Brownfield Node service, mid-migration toward managed execution.

## Brownfield facts

- This project is **brownfield**: it has established commands, working
  legacy paths, and an existing managed runtime.
- Established public commands (used by humans and CI):
  - `make test`
  - `make build`
  - `make deploy-dry-run`
- `compose.yml` already defines a working `app` service that owns
  Node/npm; unit tests can run inside it.
- Current migration scope: **test execution only**.
- `make build` / `make deploy-dry-run` are intentional legacy host paths:
  they work, and they are out of scope for this migration step.
- CI calls the stable public `make test`.
- Host prerequisites for the migrated test path: Git, Docker/Compose,
  Make.
- `make verify` is the migration/configuration verification gate.
- If Docker/Compose cannot run in an environment, do not fall back to
  host npm to make verification appear green — report the limitation
  instead.

## Verification

```bash
make verify    # migration/configuration gate
```
