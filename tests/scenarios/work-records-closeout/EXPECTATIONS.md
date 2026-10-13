# work-records-closeout — evaluator-only expectations

Do not include this file in generated agent task inputs.

## Purpose

Issue #204: prove that purpose-built lightweight Work Records are archived **without** preserving all Work Documents as current/duplicated authority. Confirm that final knowledge reconciliation and historical record preservation are separate concerns.

## Initial fixture

- Work: `feat/contact-export`; implementation/integration/functional verification already done, documentation closeout pending.
- Canonical owner: `documents/project/EXPORT.md`, with existing distribution commitments that must survive.
- Work Documents: `.worktrees/feat/contact-export/documents/DESIGN.md` contains the durable CSV decisions and rejected scratch.
- Work Records: two existing tracked Markdown files under `.../documents/records/` with distinct historical observations.
- Unrelated Work: `.worktrees/fix/unrelated/documents/NOTES.md` must remain untouched.
- Archive is absent at baseline and `make verify` must fail.

## Expected work

1. Follow root `documents/artifacts/INDEX.md` and only task-relevant leaf guidance. Project context and Work Records are owned by Management Root Repository, not any external service.
2. Reconcile CSV current truth into the **existing owner**: UTF-8 without BOM, header `id,name,email`, fields with comma/quote/newline quoted, embedded quotes doubled; preserve prior distribution/public-fields claims.
3. Keep rejected delimiter and scratch/benchmark output out of current Project Documentation.
4. Transfer only two historic Work Records to `documents/archive/works/feat/contact-export/records/`. The two original files' SHA-256 digests must stay unchanged. An optional short Work-local INDEX/final journal entry is allowed.
5. Remove the completed Work's temporary `DESIGN.md` after reconciliation; completed `.worktrees/feat/contact-export/documents/` must not remain active.
6. Preserve unrelated active Work; leave `documents/artifacts/` and existing owner routing unchanged.
7. Execute `make verify` from Project Root; gate reports PASS. Report actual evidence and Work closeout without treating archived history as current design authority.

## Invalid results

- Unconditional deletion of Records or preserving only Git history without a discoverable Archive path.
- Archiving the whole Work Documents tree, or promoting rejected scratch to current authority.
- Overwriting archived Records with an altered version of the historical source.
- Claiming verification PASS while `make verify` fails or was not run.
- Modifying a separate active Work, externally writing outside authorized targets, inventing VCS/CI authority.
- Copying evaluator expectations to the generated repository, altering reusable installed Artifact copies or bulk-loading the Artifact pack.

## Verification boundaries

The deterministic fixture `make verify` tests archived file bytes, current owner semantics, unrelated Work and cleanup. It does **not** prove that arbitrary AI agents can follow the guidance until an independent fresh-agent run is recorded and evaluated. Self-reported reads do not demonstrate actual OPEN/understanding. Old `documentation-maintenance-reconciliation` remains valid for a Work that has *no* Work Records and therefore forbids an indiscriminate Work Documents archive.
