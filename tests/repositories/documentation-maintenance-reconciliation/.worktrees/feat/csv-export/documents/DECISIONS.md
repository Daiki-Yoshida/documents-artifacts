# feat/csv-export — Decisions

Work-scoped decisions for the CSV export implementation.

## Confirmed

- CSV output is UTF-8 without BOM.
- Header order: `id,name,email`.
- Fields containing a comma, double quote, or newline are quoted.
- An embedded double quote is escaped by doubling it (`""`).

## Rejected

- Switching the export format to TSV — rejected; CSV remains the format.
