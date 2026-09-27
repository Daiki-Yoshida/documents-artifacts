# Diagnostics Recovery

Small dependency-free project modelling a local runtime with layered
state ownership.

## Runtime state

Runtime state lives under `.runtime/` (git-ignored):

- `.runtime/shared/` — Project-scoped shared state (e.g. the package
  cache). Safe to share across every runtime and Work.
- `.runtime/persistent/` — persistent developer state (e.g. the local
  dev DB). Survives routine Work churn.
- `.runtime/work/<work-slug>/` — Work-scoped disposable runtime state for
  one Work. Marker files name the bound port: `port-<port>.ready` when
  healthy, `port-<port>.stale` when stale.

The expected port for a Work is configured in `config/work-ports.conf`.

## Commands

Project-owned commands go through Make:

```bash
make help
make status       WORK=<type>/<name>   # observe, never mutates
make verify       WORK=<type>/<name>   # final Work runtime check
make recover-work WORK=<type>/<name>   # Work-scoped recovery
make reset-all                         # broad destructive operation
```

`make verify WORK=...` is the final verification gate for a Work
runtime.
