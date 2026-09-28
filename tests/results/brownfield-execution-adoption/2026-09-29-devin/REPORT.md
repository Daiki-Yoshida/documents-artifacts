# Agent Test Report — brownfield-execution-adoption

- **Scenario**: `brownfield-execution-adoption`
- **Run ID**: `2026-09-29-devin`
- **Agent/model**: Devin (SWE-2 Max)
- **Source baseline**: `main` @ `5eecaf4` (PR #116 merged; scenario
  definition includes the hardened routing checker)
- **Generated baseline**: `artifact-test-baseline` tag in the prepared run

## Files actually read

### Artifact files (routed from `documents/artifacts/INDEX.md`)

- `documents/artifacts/INDEX.md` — router; "Docker / build / test / CI
  environment" → `execution/INDEX.md`
- `documents/artifacts/execution/INDEX.md` — execution router
- `documents/artifacts/execution/ADOPTION_AND_MIGRATION.md` — brownfield
  inventory-then-incremental-migration, one execution boundary at a time,
  align CI to project-managed commands
- `documents/artifacts/execution/EXECUTION_MODEL.md` — host control plane
  vs project execution plane; test runtime belongs to the managed plane
- `documents/artifacts/execution/HOST_AND_CONTAINER.md` — host owns
  Docker/Compose/Git/routing; do not install host runtimes for
  convenience
- `documents/artifacts/execution/COMMANDS_AND_CI.md` — stable public
  commands; CI calls project-managed commands instead of reimplementing
  them in provider YAML
- `documents/artifacts/operation/BROWNFIELD.md` — local convention first;
  do not turn the task into a violation hunt / scope expansion

### Project-local files

- `README.md` — brownfield facts (public commands, existing `app`
  service, scope = test execution only, `make verify` gate, no host
  fallback policy)
- `Makefile` — `test`/`build`/`deploy-dry-run`/`verify` targets
- `compose.yml` — existing `app` service (`build: .`)
- `Dockerfile` — `node:20.11.0-alpine`, `CMD ["npm", "test"]`
- `package.json` — `test` script = `node --test`
- `.github/workflows/ci.yml` — checkout → setup-node → `make test`
- `scripts/legacy-build.sh`, `scripts/legacy-deploy-dry-run.sh` — marker
  output; working legacy paths
- `scripts/adoption-check.sh` — migration-shape gate
- `src/check.js`, `tests/check.test.js` — application + unit test

## Execution-path inventory (before mutation)

| Command | Current path | Scope |
|---|---|---|
| `make test` | host `npm test` | **this task** |
| `make build` | `scripts/legacy-build.sh` (host) | out of scope — working |
| `make deploy-dry-run` | `scripts/legacy-deploy-dry-run.sh` (host) | out of scope — working |
| `make verify` | `scripts/adoption-check.sh` | migration gate |
| CI `verify` job | checkout → `setup-node` → `make test` | host Node needed only because `make test` ran on host |
| Compose `app` | `build: .`, can run `npm test` inside | existing managed runtime, already healthy |

Baseline `make verify`: FAIL ×3 — host npm exec in `make test`, no
Compose routing, CI host Node setup. All other checks pass; legacy
paths verified working (`LEGACY-BUILD-OK`, `DEPLOY-DRY-RUN-OK`).

## Migration scope and chosen approach

Scope is test execution only. The existing `app` service is already a
valid managed runtime — no topology redesign, no competing path.

- `Makefile` `test:` recipe → `docker compose run --rm app npm test`
  (same public name/role; execution moves to the managed plane while the
  host keeps the control plane).
- `ci.yml` → drop `actions/setup-node`; CI keeps calling the same public
  `make test`. npm details stay behind the public command, not in YAML.

`make build` / `make deploy-dry-run` and the legacy scripts are left
unchanged deliberately — they are working brownfield paths outside this
task's scope, not defects.

## Files changed

- `Makefile` — 1 line: `test` recipe re-routed to the Compose `app`
  runtime.
- `.github/workflows/ci.yml` — 3 lines removed: host `setup-node` step.

No changes to `src/`, `tests/`, `compose.yml`, `Dockerfile`,
`scripts/legacy-*.sh`, or `package.json`. No new files.

## Resulting flows

```text
human / local:   make test → docker compose run --rm app → npm test
CI:              checkout → make test → same Compose path
```

## Verification (actually run)

```text
make verify  → PASS (15/15 adoption-check items, "all checks passed")
make test    → PASS — executed inside the Compose-managed runtime
               (node:test TAP: pass 1 / fail 0)
make build / make deploy-dry-run → unchanged legacy markers verified
```

Docker/Compose was available in this environment; the containerized run
was actually executed. No host `npm test` fallback was used.

## Final Git status (generated repo)

```text
 M .github/workflows/ci.yml
 M Makefile
```

## Managed Artifact integrity

`documents/artifacts/` untouched; `managed-artifacts.patch` is empty
(0 bytes).

## Evidence capture result

`tests/scripts/capture-agent-test.sh --scenario
brownfield-execution-adoption --run-id 2026-09-29-devin` → captured to
`tests/results/brownfield-execution-adoption/2026-09-29-devin/evidence/`
(9 files). `changed-files.txt` shows only the two focused modifications.

## Evidence limitations

- Evidence is a static snapshot of the generated repo diff; the
  containerized `make test` PASS is reported from the agent run log, not
  re-captured inside evidence files.
- CI YAML change was verified statically (checker); no actual GitHub
  Actions run exists in this environment.

## Self-assessment

The migration moved one execution boundary (test execution) onto the
existing managed runtime while preserving the public command surface and
leaving working legacy paths untouched, matching the inventory-first,
incremental approach in the routed guidance. Public contract, Compose
topology, and application behavior are unchanged.
