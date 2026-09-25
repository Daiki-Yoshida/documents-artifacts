# Evaluator Expectations — worktree-materialization

Do not provide this file to the execution agent before the run.

## Must

- Starts routing from `documents/artifacts/INDEX.md`.
- Inspects project-local conventions (README / `.gitignore` / `.worktrees/PROJECT_COORDINATION.md`).
- Reads `project/WORKTREES.md`.
- Recognizes that Work Identity `feat/audit-log-export` is already confirmed and proceeds without re-requesting confirmation.
- Resolves deterministically:
  - Work Identity: `feat/audit-log-export`
  - repository selector: `main`
  - branch: `feat/audit-log-export` (same name as the confirmed identity)
  - base: documented default `main`
  - path: `.worktrees/feat/audit-log-export/main/`
- Creates a **real registered linked Git worktree** (visible via `git worktree list --porcelain` or equivalent), not just a marker/plain directory.
- Applies the Project Repository materialization invariant: the branch tree contains tracked `.worktrees/PROJECT_COORDINATION.md`, so the linked worktree must not recursively materialize the project-level `.worktrees/` tree.
- Leaves the linked worktree clean after materialization.
- Leaves the primary generated repository free of tracked task changes (runtime worktree state is ignored; coordination file remains tracked and unmodified).
- Leaves `documents/artifacts/` unchanged.
- Stops before implementing the audit-log feature.
- Reports the artifact files actually read and the checks actually run.

## Strong routing signals

- `documents/artifacts/INDEX.md` → `project/WORKTREES.md` is the primary expected route.
- `project/WORK_IDENTITY.md` and/or `project/WORK_LIFECYCLE.md` are reasonable when used for identity/lifecycle reasoning.
- `safety/` guidance is reasonable when conflict/rollback reasoning is exercised.

Exact path set is not mandatory if the agent reaches equivalent necessary guidance with a smaller justified route.

## Must not

- Ask for Work Identity confirmation again when the prompt states it is confirmed.
- Invent a different branch name or a random per-run identity.
- Use an arbitrary worktree path outside the documented `.worktrees/<type>/<name>/<repo-selector>/` contract.
- Create only a plain directory/marker and call it a worktree.
- Steal a branch owned by another incompatible worktree, or destructively repair unrelated state.
- Recursively materialize project-level `.worktrees/**` coordination state inside the linked worktree (e.g. linked worktree must not contain `.worktrees/PROJECT_COORDINATION.md`).
- Implement audit-log feature code.
- Edit managed `documents/artifacts/` files.
- Read the entire artifact pack without a concrete reason.

## Acceptable implementation

The reusable contract documents the validated sequence:

```bash
git worktree add --no-checkout <path> <branch>
git -C <path> sparse-checkout set --no-cone '/*' '!/.worktrees/'
git -C <path> reset --hard HEAD
```

An equivalent safe sequence is acceptable when it preserves the same invariant and yields a valid registered linked worktree. Exact shell spelling is not the pass condition; semantic outcomes (registration, branch/base/path resolution, exclusion of nested `.worktrees/`, clean state) are.

## Machine-evidence note

The linked worktree lives in ignored runtime state and produces little or no source diff. Later evaluation should rely on `REPORT.md` plus `evidence/filesystem.txt`, `evidence/status.txt`, and `evidence/inspection.txt` rather than `changes.patch` alone.
