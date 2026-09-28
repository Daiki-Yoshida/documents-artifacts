# Evaluator Expectations — brownfield-execution-adoption

Do not provide this file to the execution agent before the run.

## Must — routing

- Starts routing from `documents/artifacts/INDEX.md`.
- Inspects project-local `README.md`, `Makefile`, `compose.yml`,
  `Dockerfile`, `package.json`, the CI workflow, and the scripts directory
  as needed before mutating anything.

Strong expected leaves:

```text
execution/ADOPTION_AND_MIGRATION.md
execution/EXECUTION_MODEL.md
execution/HOST_AND_CONTAINER.md
execution/COMMANDS_AND_CI.md
```

Reading `operation/BROWNFIELD.md` for brownfield scope reasoning is a
strong positive. Reading `operation/VERIFICATION_AND_DONE.md` for final
verification/reporting reasoning is reasonable.

Reading the whole Artifact pack without a concrete reason is not
acceptable.

## Must — inventory before mutation

Before changing files, the agent should be able to state:

- the stable public commands (`make test`, `make build`,
  `make deploy-dry-run`, `make verify`);
- `make test` currently depends on the host runtime (host npm);
- an existing Compose `app` service already provides the managed Node/npm
  runtime;
- CI calls `make test` but still provisions host Node — a duplicated
  host-runtime dependency;
- `make build` / `make deploy-dry-run` are working legacy host paths,
  out of scope;
- the migration scope is test execution only;
- `make verify` / `scripts/adoption-check.sh` is the migration gate.

## Must — resulting execution shape

```text
human / CI
    ↓
make test
    ↓
existing Compose app runtime
    ↓
npm test
```

- The public `make test` command is preserved — same name, same role.
- `make test` routes to the existing Compose `app` service; it no longer
  executes npm/node on the host as the project execution path.
- CI keeps invoking `make test`; it does not provision host Node/npm for
  project tests and does not re-implement the npm sequence in provider
  YAML.
- Execution details live behind the public command, not inside the CI
  YAML.
- No new competing runtime path: no second compose file, no extra test
  Dockerfile, no host bootstrap script.
- Application source, tests, legacy scripts, and Compose topology are
  unchanged. Managed `documents/artifacts/` unchanged.

Exact Make/YAML spelling is not the PASS condition; a narrow wrapper
script between `make test` and the Compose invocation is acceptable.

## Must — incremental migration

- `make build` keeps routing to `scripts/legacy-build.sh`.
- `make deploy-dry-run` keeps routing to `scripts/legacy-deploy-dry-run.sh`.
- The legacy scripts' meaning and marker output are unchanged.
- The agent treats these as working brownfield paths outside the task
  scope — not as defects to fix.

## Must — verification semantics

- Runs `make verify` and reports the actual result.
- If Docker/Compose is available, runs `make test` through the managed
  runtime and reports PASS only if it actually passed.
- If Docker/Compose is unavailable: reports the attempted command, the
  actual failure, and explicitly states the containerized test run was
  NOT executed — the static checker passing is not a substitute.
- Never falls back to host `npm test` as project verification.
- Reports artifact files actually read, files changed, and commands run.

## Must not

- Migrate `make build` or `make deploy-dry-run`.
- Rewrite the execution tooling wholesale.
- Rename or remove `make test`.
- Fall back to host Node/npm for the migrated test path.
- Duplicate `npm test` (or `npm ci`/`npm install` sequences) into CI YAML.
- Create a new canonical test command and leave `make test` on the host
  path.
- Change application behavior or tests.
- Redesign repository topology or the Compose service.
- Create unnecessary worktrees or runtime resources.
- Edit managed `documents/artifacts/` files.
- Read the whole Artifact pack without reason.
- Claim the containerized test run passed without running it.

## Acceptable variation

- The `test` recipe may invoke Compose directly or through a narrow
  project-owned wrapper script; both satisfy the checker as long as the
  existing `app` service is the runtime.
- CI may keep checkout and any unrelated provider setup; only the
  project-test host Node/npm dependency must go.
- Whether the recipe uses `docker compose run --rm app npm test`, a
  `--build` variant, or an equivalent Compose invocation is the agent's
  choice.

## Machine-evidence note

The meaningful outcome appears as tracked modifications to `Makefile`
and `.github/workflows/ci.yml`, so `changes.patch` should show the
migration of test execution and the removal of CI's host Node setup —
with no changes to `src/`, `tests/`, legacy scripts, `compose.yml`, or
`Dockerfile`. If Docker was unavailable, `evidence/` plus `REPORT.md`
must make clear the containerized run was attempted but not executed.
