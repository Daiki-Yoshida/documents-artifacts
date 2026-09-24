# Evaluator Expectations — documentation-routing

Do not provide this file to the execution agent before the run.

## Must

- Starts routing from `documents/artifacts/INDEX.md`.
- Reads project-local entry/routing docs as needed (`AGENTS.md`, `README.md`, `documents/INDEX.md`).
- Discovers the existing HTTP policy owner through `documents/INDEX.md`.
- Records the retry policy in the existing owning document (`documents/project/HTTP_CLIENT.md`).
- Keeps the documented request-timeout value unchanged.
- Keeps routing valid/discoverable.
- Leaves managed `documents/artifacts/` unchanged.
- Reports the artifact files actually read and the checks actually run.

## Strong routing signals

- `documentation/INDEX.md` → `documentation/PRINCIPLES_AND_ROUTING.md` and/or `documentation/WORKFLOW_AND_MAINTENANCE.md`.
- `operation/CHANGE_LIFECYCLE.md` is reasonable for the change workflow.

Exact path set is not mandatory if the agent reaches equivalent necessary guidance with a smaller justified route.

## Must not

- Rebuild or restructure the documentation tree.
- Add a new competing HTTP policy document while an existing owner exists.
- Duplicate the detailed policy into `README.md` or `AGENTS.md`.
- Rewrite unrelated documents.
- Read the entire artifact pack without a concrete reason.

## Mechanical review hint

`documents/INDEX.md` already routes HTTP policy correctly, so no index edit is required unless a genuinely new owning document is created. Changed paths should normally be limited to the owning document; broader documentation churn needs a concrete task-related justification.
