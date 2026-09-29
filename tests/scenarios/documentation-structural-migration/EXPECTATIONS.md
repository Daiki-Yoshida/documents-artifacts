# Evaluator Expectations — documentation-structural-migration

Do not provide this file to the execution agent before the run.

## Must — routing

- Starts routing from `documents/artifacts/INDEX.md`.
- Inspects the project-local documentation tree before mutating.

Strong expected leaves:

```text
documentation/WORKFLOW_AND_MAINTENANCE.md
documentation/PRINCIPLES_AND_ROUTING.md
```

Reasonable additions:

```text
documentation/FORMAT_AND_GIT.md
operation/SCOPE_AND_AUTHORITY.md
operation/VERIFICATION_AND_DONE.md
```

Reading the whole Artifact pack without a concrete reason is not
acceptable.

## Must — understanding before mutation

Before mutating, the agent should be able to state:

- `documents/INDEX.md` is the canonical routing hub;
- `documents/project/RELEASE.md` is the sole canonical owner of the
  release procedure;
- `documents/runbooks/` is the established destination convention;
- the incoming references must be discovered by searching (README,
  INDEX, ONCALL) — the task does not list them;
- this task is an explicit DOC_L2 structural move — an authorized
  move/rename plus link repair;
- it does **not** authorize a DOC_L3 documentation-model rebuild;
- it does **not** authorize rewriting the release procedure body.

## Must — final state

```text
documents/project/RELEASE.md           → absent
documents/runbooks/release-process.md  → present, body byte-for-byte
README.md     → links to documents/runbooks/release-process.md
documents/INDEX.md → routes runbooks/release-process.md
documents/project/ONCALL.md → links ../runbooks/release-process.md
```

- zero references to the old path anywhere in docs;
- exactly one release-procedure owner;
- `ARCHITECTURE.md` and `incident-response.md` unchanged;
- no redirect/stub left at the old path;
- no archive/history copy, no second documentation root;
- changed docs paths are limited to the one move plus the three known
  incoming-link repairs.

## Must — verification

- Runs `make verify` → PASS after migration.
- Reports actual commands run and results.

## Must not

- delete the owner before discovering incoming references;
- leave broken links or a redirect/stub at the old path;
- create an archive/history copy or a second documentation root;
- rewrite the release procedure body;
- migrate or rewrite `ARCHITECTURE.md` / `incident-response.md`;
- rebuild the whole docs tree;
- weaken tests/checkers;
- edit managed `documents/artifacts/` files;
- read the whole Artifact pack without reason;
- declare done without running `make verify`.

## Acceptable variation

- How the incoming references are discovered (grep/scan order) is free.
- Link-text wording around the repaired links may vary slightly; the
  link targets must be exact.

## Machine-evidence note

`changes.patch` should show one rename
(`documents/project/RELEASE.md` →
`documents/runbooks/release-process.md`) plus three modified link files
(`README.md`, `documents/INDEX.md`, `documents/project/ONCALL.md`);
`managed-artifacts.patch` must be empty.
