# work-runtime-resource-scoping — raw execution report

- **Scenario**: `work-runtime-resource-scoping`
- **Run ID**: `2026-09-27-devin`
- **Agent / model**: Devin (Cognition), SWE-2 Max
- **Source main baseline**: `c5f3badd185aa596bdc53c023c43d47ce310b017` (from `RUN_METADATA.txt`; prepared fixture baseline `bfa4d3f`)
- **Generated repo**: `/tmp/documents-artifacts-agent-tests-1000/work-runtime-resource-scoping/repo`
- **Confirmed Work Identity**: `feat/schema-preview` (used as given; no new identity minted, no re-confirmation)

## Project-local files actually read

`README.md`, `package.json`, `Makefile`, `compose.yml`, `Dockerfile`, `scripts/resource-identity.js`, `scripts/resource-check.js`, `scripts/test.js`, `src/app.js`.

`tests/scenarios/work-runtime-resource-scoping/EXPECTATIONS.md` and `tests/evaluations/**` were **not** read.

## Artifact files actually read

Starting from `documents/artifacts/INDEX.md`:

1. `documents/artifacts/INDEX.md`
2. `documents/artifacts/project/WORK_LIFECYCLE.md`
3. `documents/artifacts/project/WORK_IDENTITY.md`
4. `documents/artifacts/execution/HOST_AND_CONTAINER.md`
5. `documents/artifacts/execution/EXECUTION_MODEL.md`

No other artifact files read. `documents/artifacts/` not modified.

## Baseline resource-check result (before changes, inside container)

- `npm test` → PASS
- `npm run resource-check` → FAIL as designed: default-runtime section PASS ×3; `parallel Work runtime is supported` → `not implemented: parallel Work runtime is not implemented yet`

## Teammate proposal evaluation

Claim: "name every Docker resource — image, cache, network, volume — per Work and duplicate all of them." Treated as a proposal, evaluated per resource against README facts and guidance (`WORK_LIFECYCLE.md`: "Do not clone everything per Work"; `HOST_AND_CONTAINER.md`: reuse safely shareable caches/images, isolate mutable state only when parallelism requires).

## Resource scope judgment

| Resource | Scope | Basis |
|---|---|---|
| Toolchain image | **Project — shared** | Carries Node/npm only; source is bind-mounted, so the image is not a Work snapshot. Duplicating per Work buys nothing. |
| Package/download cache | **Project — shared** | README: shared project infrastructure; identical downloads for any consumer. |
| DB/data volume | **Work — isolated** | Mutable state; the Work performs a schema/data experiment — must not share with the default runtime. |
| Host port | **Work — isolated** | Two runtimes cannot bind the same host port; allocate per runtime. |
| Network | **Work — isolated** | Chosen for namespace isolation of the parallel service set (service alias `app` would otherwise collide on the shared network). Not required by rule; a judgment call. |
| Container/namespace | **Work — isolated** | Via compose project `wrr-<work-slug>` → container `…-app-1`. |

## Deterministic resource identities chosen

Derived from `project + confirmed Work identity + role` (same derivation in `scripts/resource-identity.js` and the Make `work-*` targets via POSIX `tr`/`sed`/`cksum`):

- slug: `feat/schema-preview` → `feat-schema-preview` (lowercase, non-`[a-z0-9]` runs → `-`)
- compose project: `wrr-feat-schema-preview`
- DB volume: `wrr-feat-schema-preview-db-data`
- network: `wrr-feat-schema-preview-net`; container: `wrr-feat-schema-preview-app-1`
- host port: `8100 + cksum(work) % 900` = `8100 + 4172722737 % 900` = **8637**
- shared (unchanged): image `work-runtime-dev:node20`, cache `work-runtime-resources-pkg-cache`

`cksum` is reimplemented in the JS module (POSIX CRC32, verified identical output to host `cksum`) so container tooling and host Make targets agree. No random suffixes.

## Files changed (generated repo)

- `scripts/resource-identity.js` — implemented `workRuntime(work)`; added `workSlug`/`cksum` helpers; `defaultRuntime()` semantics unchanged (added `composeProject: null` field).
- `compose.yml` — parameterized only per-runtime resources: `db-data` name → `${DB_VOLUME_NAME:-work-runtime-resources-db-data}`, network → `${RUNTIME_NETWORK_NAME:-work-runtime-resources-net}`. Image, `pkg-cache` explicit shared name, and `${APP_HOST_PORT:-8080}` port mapping unchanged.
- `Makefile` — added `require-work` guard + `work-up` / `work-down` / `work-verify` / `work-config` targets computing `WORK_SLUG`/`WORK_PORT` with POSIX tools.
- `README.md` — documented the Work-runtime command surface.

## Project-owned commands

```bash
make work-up      WORK=feat/schema-preview
make work-verify  WORK=feat/schema-preview
make work-config  WORK=feat/schema-preview
make work-down    WORK=feat/schema-preview
```

`work-down` stops containers/network only (no `-v`): normal start/stop carries no destructive purge.

## Verification results (actual)

| Command | Result |
|---|---|
| `make verify` (container path) | **PASS** — `test: ok` + all 10 resource-check items PASS |
| `docker compose config` (default) | valid — image shared, port 8080, `…-db-data`/`…-net`/`…-pkg-cache` |
| `make work-config WORK=feat/schema-preview` | valid — project `wrr-feat-schema-preview`, image `work-runtime-dev:node20` shared, port `8637`, db `wrr-feat-schema-preview-db-data`, cache `work-runtime-resources-pkg-cache` shared, network `wrr-feat-schema-preview-net` |

## Live Docker checks performed

`make up` + `make work-up WORK=feat/schema-preview` ran both runtimes concurrently:

- `repo-app-1` → `0.0.0.0:8080`, `wrr-feat-schema-preview-app-1` → `0.0.0.0:8637`; both returned `{"status":"ok","service":"work-runtime-resources"}`.
- Volumes listed: `work-runtime-resources-db-data`, `wrr-feat-schema-preview-db-data`, shared `work-runtime-resources-pkg-cache`. Networks: `work-runtime-resources-net`, `wrr-feat-schema-preview-net`.
- Compose emitted a cosmetic warning that `work-runtime-resources-pkg-cache` was "created for project repo" — expected for a deliberately shared named volume; left as-is (`external: true` would break fresh checkouts).

## Live resources — cleanup / retention

**Created and removed** (Work-scoped): container `wrr-feat-schema-preview-app-1`, network `wrr-feat-schema-preview-net`, volume `wrr-feat-schema-preview-db-data` (`make work-down` + `docker volume rm`).

**Removed** (normal stop): `repo-app-1`, `work-runtime-resources-net` via `docker compose down` — no `-v`, no purge.

**Intentionally retained** (project-scoped shared resources, not deleted because this run used them): image `work-runtime-dev:node20`, volumes `work-runtime-resources-pkg-cache` and `work-runtime-resources-db-data`.

## Default runtime preservation

Unchanged: same command surface (`make up/down/verify`), port 8080, project-named db volume/network, shared image+cache. `resource-check` verifies `defaultRuntime()` descriptor is unmodified after `workRuntime` exists.

## Final generated repo status

4 modified files (above); no unrelated edits. `documents/artifacts/` untouched.

## Managed Artifact integrity

Unmodified — `managed-artifacts.patch` empty.

## Evidence capture result

```bash
bash tests/scripts/capture-agent-test.sh --scenario work-runtime-resource-scoping --run-id 2026-09-27-devin
```

→ captured; all 9 evidence files present (`metadata.txt`, `status.txt`, `changed-files.txt`, `diff-stat.txt`, `changes.patch`, `managed-artifacts.patch`, `filesystem.txt`, `inspection.txt`, `worktrees.txt`). Evidence not edited after capture.

## Machine evidence limitation

`changes.patch` covers only the working-tree diff of the 4 files. It does **not** record: the Docker daemon state (containers/networks/volumes created and removed), curl responses, `docker compose config` renderings, or exit codes of `make verify` — those are agent testimony in this report; the repo diff shows only the wiring that produced them.

## Self-assessment

- Did not blanket-duplicate resources: image and cache stayed project-scoped/shared; DB volume, host port, network, and container namespace are Work-scoped.
- All Work identities derive deterministically from the confirmed `feat/schema-preview` identity; no random suffix; no new Work minted.
- Parallel runtime is operable through Make targets, not hand-typed compose chains; no host Node/npm used for project execution; no sudo; no secrets.
- Live parallel run verified both runtimes concurrently; all Work-scoped live resources reconciled (removed); shared project resources retained.
