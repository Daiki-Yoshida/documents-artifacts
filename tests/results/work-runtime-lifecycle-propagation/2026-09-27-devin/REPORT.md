# Raw execution report — work-runtime-lifecycle-propagation

- scenario: `work-runtime-lifecycle-propagation`
- run-id: `2026-09-27-devin`
- agent: Devin CLI / SWE-2 Max
- source main baseline: `130280b` (merge of PR #78 — lifecycle-propagation
  guidance + this scenario's definition)
- generated repo: `/tmp/documents-artifacts-agent-tests-1000/work-runtime-lifecycle-propagation/repo`
- confirmed Work Identity: `feat/schema-preview` (not re-confirmed, no new
  identity minted)

## Project-local files actually read

- `PROMPT.md`, `RUN_METADATA.txt` (run dir)
- `README.md`, `Makefile`, `compose.yml`, `package.json`
- `scripts/resource-identity.js`, `scripts/lifecycle-check.sh`

## Artifact files actually read (routed from `documents/artifacts/INDEX.md`)

- `documents/artifacts/INDEX.md` → route: Work identity/lifecycle, Docker env
- `documents/artifacts/execution/INDEX.md`
- `documents/artifacts/project/WORK_LIFECYCLE.md`
- `documents/artifacts/execution/HOST_AND_CONTAINER.md`
- `documents/artifacts/execution/COMMANDS_AND_CI.md`

## Baseline lifecycle-check result (before fix)

`make lifecycle-check` FAILED with exactly the seeded defect:

- work-up/status/config/verify: PASS (resolve `wrr-feat-schema-preview` set)
- work-down: FAIL — does not resolve the Work-scoped configuration
- work-cleanup: FAIL — does not resolve the Work-scoped configuration;
  FAIL — blanket volume purge (`-v`); FAIL — does not remove
  `wrr-feat-schema-preview-db-data`
- default runtime commands do not target Work-scoped resources: PASS

## Lifecycle mismatch diagnosis

`work-up` materializes the Work runtime under `$(WORK_ENV)` =
`DB_VOLUME_NAME=wrr-…-db-data RUNTIME_NETWORK_NAME=wrr-…-net APP_HOST_PORT=8637`
with `-p wrr-feat-schema-preview`. `work-down`/`work-cleanup` dropped
`$(WORK_ENV)`, so the same Compose project name would render
`db-data`/`default` networks to the **default** names
(`work-runtime-lifecycle-db-data`, `work-runtime-lifecycle-net`) — teardown
targets a different resource set than creation. Worse, `work-cleanup` used
`down -v`, which under the unscoped env would have deleted the **shared**
project cache `work-runtime-lifecycle-pkg-cache` plus the default runtime's
DB volume, while leaving the actual Work volume orphaned.

## Files changed

- `Makefile` only (+6/-4):
  - `work-down`: prepend `$(WORK_ENV)` — same resolved scope/identity as
    every other lifecycle op (per WORK_LIFECYCLE: identity is not a
    creation-time-only name; per HOST_AND_CONTAINER: propagate the resolved
    configuration to counterpart operations).
  - `work-cleanup`: `$(WORK_ENV) docker compose -p $(WORK_PROJECT) down` +
    `docker volume rm -f $(WORK_PROJECT)-db-data` — scoped cleanup removes
    only the Work-scoped mutable volume; no blanket `-v` (which would also
    remove the Project-scoped shared cache). Stop vs destructive-purge
    semantics remain separate per COMMANDS_AND_CI.

## Scope/identity resolver design

Unchanged — single derivation already exists: `WORK_SLUG`/`WORK_PROJECT`/
`WORK_PORT`/`WORK_ENV` in the Makefile mirroring
`scripts/resource-identity.js` (`project + confirmed Work identity + role`;
port `8100 + cksum(work) % 900`). The defect was propagation, not
derivation; fix propagates the same `WORK_ENV` to all ops — no second
resolver added.

## Per-operation resolution (after fix)

| op | recipe resolves |
|---|---|
| work-up | `$(WORK_ENV) docker compose -p wrr-feat-schema-preview up -d app` |
| work-status | same env, `ps` |
| work-config | same env, `config` |
| work-verify | same env, `run --rm app npm run verify` |
| work-down | **same env**, `down` (was missing env) |
| work-cleanup | **same env**, `down` + `docker volume rm -f wrr-feat-schema-preview-db-data` (was missing env + `down -v`) |

- Shared image/cache: `work-runtime-dev:node20` and
  `work-runtime-lifecycle-pkg-cache` untouched — verified in rendered
  config; cleanup no longer threatens them.
- Work DB/network/port: `wrr-feat-schema-preview-db-data` /
  `-net` / `8637` for all six operations.
- Normal stop (`work-down`) removes container+network only; volume removal
  happens only in `work-cleanup`.

## Commands actually executed

- `make lifecycle-check` (baseline → FAIL×4 as above; after fix → 8/8 PASS)
- `docker compose build app` (image present)
- `make verify` — first attempt exited `Error 1` at the
  `docker compose run` step immediately after the build (exact line
  filtered by my output grep; not reproduced), re-run **PASS**: npm test ok,
  resource-check 11/11 PASS, lifecycle-check 8/8 PASS
- `make work-up/status/config/verify/down/cleanup WORK=feat/schema-preview`
  — full live lifecycle, all succeeded; `curl http://localhost:8637/` →
  `{"status":"ok"}` while up

## Rendered / live Docker checks

`make work-config` rendered: `name: wrr-feat-schema-preview`, image
`work-runtime-dev:node20` (shared), `published: "8637"`,
`wrr-feat-schema-preview-net`, `wrr-feat-schema-preview-db-data`,
`work-runtime-lifecycle-pkg-cache` (shared, retained).

Live resources:

- **Created + removed (Work-scoped)**: container
  `wrr-feat-schema-preview-app-1`, network `wrr-feat-schema-preview-net`,
  volume `wrr-feat-schema-preview-db-data` — all gone from daemon after
  `work-down` + `work-cleanup` (verified via `docker ps/network/volume ls`).
- **Intentionally retained (Project-scoped/shared)**:
  `work-runtime-dev:node20` image, `work-runtime-lifecycle-pkg-cache`
  (shared cache — compose emitted only a project-label warning when the
  Work runtime attached it; volume itself never targeted),
  `work-runtime-lifecycle-net`/`work-runtime-lifecycle-db-data`
  (default-runtime resources not created by this run's lifecycle and not
  eligible for Work cleanup), `work-runtime-resources-*` leftovers from the
  earlier scenario's default runtime (same retention rationale).

## Final generated repo status

`M Makefile` only — the single intended fix. `documents/artifacts/`:
untouched (managed-artifacts.patch empty). No checks weakened or deleted.

## Evidence capture result

Captured to `evidence/`: `metadata.txt`, `status.txt`,
`changed-files.txt` (1 file), `diff-stat.txt`, `changes.patch`,
`managed-artifacts.patch` (empty), `filesystem.txt`, `inspection.txt`,
`worktrees.txt` — all present.

## Evidence limitations

Machine evidence records the repo diff (Makefile only); Docker daemon
state (images/containers/networks/volumes listings, curl response, live
command transcripts) is testimony in this report, not archived evidence.
The one transient `make verify` failure could not be fully attributed —
output was filtered; the subsequent identical re-run passed completely.

## Self-assessment

Minimal propagation fix matching the reported symptom and the routed
guidance: one shared `WORK_ENV` now covers all six lifecycle operations;
cleanup is scoped (no blanket purge), shared cache/image preserved,
default runtime unaffected, no new Work identity minted, Docker-first
maintained, no checks weakened.
