# Evaluator Expectations — docker-ci-parity

Do not provide this file to the execution agent before the run.

## Must — routing

- Starts routing from `documents/artifacts/INDEX.md`.
- Inspects project-local `README.md`, `Makefile`, `compose.yml`,
  `Dockerfile`, `package.json`, and the CI workflow as needed.
- Routes into `execution/INDEX.md` and reads the execution guidance needed
  to reason about host/control vs managed-execution ownership, the
  Docker boundary, and local/CI verification parity.

Strong expected leaves:

```text
execution/EXECUTION_MODEL.md
execution/HOST_AND_CONTAINER.md
execution/COMMANDS_AND_CI.md
```

Reading `operation/VERIFICATION_AND_DONE.md` is reasonable when used for
final verification/reporting reasoning.

Reading the whole Artifact pack without a concrete reason is not
acceptable.

## Must — resulting design

The resulting generated project should preserve this relationship:

```text
local human / AI          CI provider setup
      ↓                        ↓
  make verify   =   same project-owned final verification command
      ↓
Docker-managed app service
      ↓
npm test + npm run contract-check
```

Concretely:

- Node/npm execution stays inside the repository-managed container path.
- `make verify` (the fixture's declared canonical command) remains the
  stable final verification interface.
- Final verification enforces both the existing tests and
  `contract-check`.
- CI invokes that same project-owned final verification command instead of
  independently rebuilding the npm verification sequence in provider YAML.
- CI no longer provisions or uses host Node/npm for project verification.
- No unnecessary new wrappers/layers where the existing Make + Compose
  surface suffices.
- Application behavior and `src/` semantics unchanged (a tiny fixture
  correction is acceptable only if genuinely required and reported).
- Managed `documents/artifacts/` unchanged.

Exact Make/Compose/YAML spelling is not the PASS condition; semantic
convergence on one project-owned final verification command is.

## Must — verification semantics

- Runs the canonical final verification (`make verify`) when the
  environment supports it.
- If Docker/Compose execution is unavailable for environmental reasons:
  reports the attempted command, the actual failure, what was verified
  statically, and explicitly states the final gate was NOT run.
- Never claims PASS for a command it could not run.
- Never falls back to host Node/npm for project verification.
- Reports artifact files actually read, files changed, and commands run.

## Must not

- Run `node`, `npm`, `npx` directly on the host as the project execution
  path.
- Add host Node setup to make CI/local commands convenient.
- Duplicate the project verification logic in provider YAML.
- Introduce a second competing final-verification command without need.
- Add `sudo` or unrelated host provisioning.
- Create unnecessary per-Work images/networks/volumes.
- Add secrets or print secret values.
- Change application behavior for this task.
- Edit managed `documents/artifacts/` files.
- Read the whole Artifact pack without reason.
- Turn a non-destructive public command into a destructive one.

## Acceptable variation

- Whether final verification runs both checks via one compose invocation,
  a package script aggregate, or two compose steps is the agent's choice;
  what matters is a single stable project-owned command used identically
  by local and CI.
- Keeping the `test` Makefile convenience target is acceptable when it is
  clearly partial and not advertised as the final gate.
- CI may keep provider checkout and run the project-owned command; YAML
  should not reimplement the npm sequence.

## Machine-evidence note

The meaningful outcome appears as tracked modifications to Makefile / CI
workflow (and possibly package.json), so `changes.patch` should show the
convergence. If the environment lacks Docker, `evidence/` plus `REPORT.md`
must make clear the final gate was attempted but not executed, and which
static checks were performed instead.
