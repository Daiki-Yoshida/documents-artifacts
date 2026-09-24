# Operations

## Deploy

- Deploys run from the `main` branch via CI.
- Rollback: redeploy the previous release tag.

## Runtime

- Logs go to stdout; no log files inside the repository.
- Restart is safe at any time; no in-process persistent state.
