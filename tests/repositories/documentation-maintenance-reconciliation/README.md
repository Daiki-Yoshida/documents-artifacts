# Documentation Maintenance Reconciliation

Project repository for the CSV export feature line.

## Project Documentation

`documents/INDEX.md` routes topics to their owning documents. CSV export
behavior is owned by `documents/project/EXPORT.md`.

## Work Documents

`.worktrees/<type>/<work>/documents/` holds Work-scoped documents for the
Work Identity `feat/csv-export`. That Work's implementation and
integration are already complete — only its Work Documents remain.

## Verification

```bash
make verify    # final documentation reconciliation gate
```
