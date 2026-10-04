# Multi-Repo Bootstrap Workspace

This repository is the **Management Root Repository**. It owns:

- project coordination state;
- the stable repository mapping;
- the project-level `.worktrees/` coordination namespace;
- project verification.

Component code, component tests, and component Git history belong to the
independent **Component Repositories** — not to this repository.

## Repository mapping

Stable repository selectors:

- `main` — this Management Root Repository itself (its checkout is the
  Project Root);
- `api`, `web` — the Component Repositories participating in this project.

`workspace/repositories.conf` maps each Component Repository selector to its
primary checkout path under the Project Root:

```text
api=components/api
web=components/web
```

A Component Repository primary checkout lives under the Project Root at its
mapped path and stays an independent Git repository. Its source and history
are never tracked by this repository. Selectors are stable repository
identities — not Git branch names.

## Work worktrees

Work-specific repository checkouts live under the project Work Root:

```text
.worktrees/<work-type>/<work-name>/<repo-selector>/
```

- Every participating repository uses a Work branch named after the
  confirmed Work Identity.
- A missing Work branch is created from the repository's documented
  default base: its `main` branch.
- `.worktrees/<work-type>/<work-name>/documents/` holds Work Documents
  tracked by this repository; repository worktree directories are ignored
  runtime state.
- `.worktrees/PROJECT_COORDINATION.md` is tracked project-level
  coordination state. Linked worktrees of the Management Root Repository
  itself must apply the reusable materialization invariant so this tree is
  never materialized recursively inside them. Component Repository
  worktrees do not carry that exclusion.
- There is no project-owned worktree wrapper command in this repository;
  low-level Git materialization may be used when required by the reusable
  guidance.

## Verification

```bash
make verify WORK=<work-type>/<work-name>
```

The gate checks mapped component checkouts, registered Work worktrees,
Work Documents tracking, and repository ownership boundaries.
