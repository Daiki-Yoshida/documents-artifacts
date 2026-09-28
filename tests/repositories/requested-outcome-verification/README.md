# Requested Outcome Verification

Report CLI. `src/report/render.js` owns rendering behavior — its callable
contract `renderReport(report, { includeOwner })` is stable. `src/cli.js`
is the user-facing composition path: it loads report data and runtime
config, then produces the output.

## Runtime config

`include_owner` controls whether the owner line appears in the report.

- `config/report.conf` — default runtime config
- `REPORT_CONFIG=<path>` overrides the config file
- `config/report-disabled.conf` — config with owner display disabled

## Verification

```bash
npm test               # narrow unit/contract verification (renderer)
npm run outcome-check  # actual CLI observable behavior
make verify            # final project gate — unit + CLI outcome
```
