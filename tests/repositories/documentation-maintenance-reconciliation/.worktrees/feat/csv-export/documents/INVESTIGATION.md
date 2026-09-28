# feat/csv-export — Investigation (scratch)

Exploratory notes — none of these are final decisions.

- Hypothesis: a `;` delimiter might simplify quoting — explored, not
  adopted.
- Benchmark scratch: local write loop throughput ~40k rows/s on this
  machine (informal).
- Temporary output filename during experiments: `export.tmp.csv`.
- Local observation: LibreOffice opened the sample fine either way.
