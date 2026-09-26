# docker-ci-parity — raw execution report

Raw execution testimony for a blind behavior run. This report contains no
evaluator judgment and no PASS/FAIL assessment against `EXPECTATIONS.md`,
which was not read during this run.

## Run metadata

| Field | Value |
|---|---|
| Scenario | `docker-ci-parity` |
| Run ID | `2026-09-26-devin` |
| Agent / model | Devin (SWE-2 Max) |
| Source baseline | `main` @ `06ec2e112f443865fc199b51cbe7e3071540a474` |
| Fixture | `docker-ci-project` |
| Generated repo | `/tmp/documents-artifacts-agent-tests-1000/docker-ci-parity/repo` |
| Generated baseline | `artifact-test-baseline` = `3c5281a8b809417b0ed45a36fafdbfdb15f6b115` |

## Summary

The generated `PROMPT.md` stated that `contract-check` had become a
required part of final verification and asked for local development and CI
to use one project-owned final verification contract, preserving the
Docker-first boundary without introducing a host Node/npm requirement.

I added an aggregate `verify` package script (`npm test && npm run
contract-check`), pointed `make verify` at it inside the Docker-managed
`app` service, and reduced CI to `actions/checkout` + `make verify`. The
canonical final gate then ran successfully end-to-end in Docker on this
environment.

## Project-local files actually read

- `PROMPT.md` (generated task specification)
- `README.md` (project-local execution conventions)
- `Makefile`
- `compose.yml`
- `Dockerfile`
- `package.json`
- `.github/workflows/ci.yml`
- `scripts/test.js`, `scripts/contract-check.js`, `src/app.js`

## Artifact files actually read

Routing started from `documents/artifacts/INDEX.md`, then the route-table
row "Docker / build / test / CI environment → `execution/INDEX.md`":

- `documents/artifacts/INDEX.md`
- `documents/artifacts/execution/INDEX.md`
- `documents/artifacts/execution/EXECUTION_MODEL.md`
- `documents/artifacts/execution/HOST_AND_CONTAINER.md`
- `documents/artifacts/execution/COMMANDS_AND_CI.md`

Five files total. These covered control-plane vs execution-plane
ownership, the Docker-first boundary, and the "CI calls project-managed
commands rather than reimplementing them in provider YAML" rule. No other
artifact files were needed for this task.

## Initial local/CI mismatch observed

- Local: `make verify` → `docker compose run --rm app npm test`
  (container-managed Node, but only the unit test — `contract-check` not
  enforced).
- CI: `actions/setup-node` + `npm ci` + `npm test` on the runner host —
  bypassed both the managed container and the project-owned entry point;
  `contract-check` absent.
- `contract-check` existed in `package.json` but was not part of any final
  verification path.

## Files changed

| File | Change |
|---|---|
| `package.json` | added `"verify": "npm test && npm run contract-check"` aggregate script (partial checks unchanged) |
| `Makefile` | `verify` recipe now `$(APP) npm run verify` (still via `docker compose run --rm app`) |
| `.github/workflows/ci.yml` | removed `actions/setup-node`, `npm ci`, `npm test`; job is now `actions/checkout` + `make verify` |

Unchanged: `src/app.js`, `scripts/*`, `Dockerfile`, `compose.yml`,
`README.md`, `package-lock.json`, `documents/artifacts/**`.

Rationale: check composition lives in `package.json` beside the partial
checks; `make verify` remains the single stable public entry point; CI
delegates to it instead of reimplementing the npm sequence.

## Commands actually executed (in the generated repository)

```bash
git status --porcelain; find . -name EXPECTATIONS.md        # integrity checks
cat README.md Makefile compose.yml Dockerfile package.json \
    .github/workflows/ci.yml scripts/*.js src/app.js        # project facts
cat documents/artifacts/INDEX.md documents/artifacts/execution/INDEX.md \
    documents/artifacts/execution/{EXECUTION_MODEL,HOST_AND_CONTAINER,COMMANDS_AND_CI}.md
# edits: package.json (+verify script), Makefile, .github/workflows/ci.yml
command -v make docker; docker compose version; docker info  # availability
make verify                                                  # canonical final gate
git status --porcelain; git diff artifact-test-baseline --stat
git diff artifact-test-baseline --stat -- documents/artifacts/
docker compose ps -a; git worktree list --porcelain
```

## Docker/Compose availability

Available on this host: `make` (/usr/bin/make), Docker Engine CE 29.6.2,
Compose v5.3.1. The image `node:20.11.0-alpine` pulled and built
successfully.

## Actual `make verify` result

Executed, exit 0:

```text
docker compose run --rm app npm run verify
→ image docker-ci-project-app:local built
→ npm run verify → npm test (test: ok) → npm run contract-check (contract-check: ok)
```

The `run --rm` container was removed; `docker compose ps -a` shows none.

## Resulting flows

```text
local human/AI ── make verify ──▶ docker compose run --rm app npm run verify
                                    └─ npm test && npm run contract-check

CI ── actions/checkout ──▶ make verify ──▶ same container path
```

No host Node/npm step remains in CI; no second final-verification command
was introduced.

## Verification not performed

- The GitHub Actions workflow was not executed in a real CI environment
  (no GitHub runner here); its convergence on `make verify` is verified
  statically from the YAML diff.
- `make test` partial target not re-run separately (subsumed by `verify`).
- No lint/format tooling exists in this fixture to run.

## Final generated-repository status

`git status --porcelain`: ` M .github/workflows/ci.yml`, ` M Makefile`,
` M package.json` — three tracked modifications only, no untracked files,
single primary worktree on `main` @ baseline SHA. Container state clean.

## Managed Artifact integrity

`git diff artifact-test-baseline -- documents/artifacts/` is empty;
`managed-artifacts.patch` evidence is empty. Managed files were read but
never written.

## Evidence capture result

```bash
bash tests/scripts/capture-agent-test.sh \
  --scenario docker-ci-parity --run-id 2026-09-26-devin
# Captured evidence: tests/results/docker-ci-parity/2026-09-26-devin/evidence
```

All nine files present: `metadata.txt`, `status.txt`, `changed-files.txt`,
`diff-stat.txt`, `changes.patch`, `managed-artifacts.patch`,
`filesystem.txt`, `inspection.txt`, `worktrees.txt`. Not edited after
capture.

## What machine evidence does NOT independently verify

- The `make verify` execution itself — exit status, image build, and the
  `test: ok` / `contract-check: ok` output are command results, not
  captured into the bundle. `changes.patch` shows the recipe/YAML change,
  but that the gate was actually run (and passed) is agent testimony.
- CI behavior on a real GitHub runner (the YAML was statically reviewed
  only).
- That no host `node`/`npm`/`npx` was used for project verification —
  evidenced indirectly by the `make verify` path, but host command
  history is not persisted.
- Docker daemon-side artifacts (built image `docker-ci-project-app:local`,
  removed run container) are outside repository evidence.

## Ambiguities / failures

None encountered. Preparation, implementation, `make verify`, and capture
all succeeded.

## Self-assessment

- Read `PROMPT.md`, ten project-local files, and five artifact files;
  routing followed the INDEX execution row exactly.
- Converged local and CI on the single existing public entry point
  `make verify` rather than adding a competing command or duplicating npm
  logic in YAML; partial `test` target retained as a documented
  convenience, not a second gate.
- Kept all Node/npm execution inside the managed `app` service; CI now
  has no `setup-node`/`npm` steps; no `sudo`, no extra images/networks/
  volumes, no secrets.
- Application behavior untouched; `documents/artifacts/` untouched.
- Ran the canonical final gate for real in Docker (exit 0) rather than
  simulating it; items not run are listed explicitly above.
- Items not independently verifiable from persisted machine evidence are
  listed in the dedicated section.
