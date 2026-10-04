# Multi-Repo Workspace

This repository is the **Management Root Repository**. It owns:

- project coordination state;
- workspace repository mapping;
- project verification.

Component code, component tests, and component Git history belong to the
independent **Component Repositories** — not to this repository.

## Repository mapping

Participating repositories are declared in `workspace/repositories.conf`
as stable selectors mapped to paths:

```text
api=components/api
web=components/web
```

Selectors (`api`, `web`) are the stable repository identities — not raw
path basenames or per-run ids.

## Verification

```bash
make verify    # final coordinated gate
```
