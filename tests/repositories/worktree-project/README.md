# Worktree Project Sample

Single-**Project Repository** fixture for isolated feature work.

## Work environment conventions

- This project is a single Project Repository; the stable repository
  selector is `main`.
- A confirmed Work Identity maps to a branch of the same name
  (e.g. `feat/audit-log-export` → branch `feat/audit-log-export`).
- A missing Work branch is created from the documented default base:
  the `main` branch.
- Linked Work worktrees live under `.worktrees/` per the reusable
  Worktree contract: `.worktrees/<work-type>/<work-name>/<repo-selector>/`.
- `.worktrees/PROJECT_COORDINATION.md` is tracked project-level
  coordination state. It belongs to the primary repository, not inside a
  linked Work worktree.
- Runtime worktree state under `.worktrees/` is gitignored, except the
  tracked coordination file above.
- There is no project-owned worktree wrapper command in this repository;
  low-level Git materialization may be used when required by the reusable
  guidance.
