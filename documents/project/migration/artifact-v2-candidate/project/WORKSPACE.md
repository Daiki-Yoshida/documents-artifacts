# Project and Repository Workspace

Read this when resolving Project Root, repository ownership, multi-repository structure, or stable repository identity.

## Static model

**Project Repository** owns project-level coordination state.

**Project Root** is the baseline working-tree root of the Project Repository and the reference point for project-level paths such as `documents/` and `.worktrees/`.

In a multi-repository project, a **Workspace Repository** may serve as the Project Repository while independent **Component Repositories** own product/component source and Git history.

Do not force a Workspace Repository merely because unrelated repositories share a folder; it should have real coordination responsibility.

## Ownership

Project Repository may statically own/project:

- Project Documentation;
- project-level Docker/Compose definitions;
- public command wrappers/scripts;
- cross-component coordination;
- the project-level `.worktrees/` coordination namespace.

Component Repository owns its own:

- source/test;
- component-specific CI/release files;
- Git history.

Do not accidentally commit Component Repository source/history as ordinary Project Repository files.

## `.worktrees/` ownership boundary

Do not ignore the whole `.worktrees/` tree blindly.

Current model distinguishes:

```text
.worktrees/<work-type>/<work-name>/documents/
  → tracked by the Project Repository

.worktrees/<work-type>/<work-name>/<repository>/
  → Git worktree of the participating repository
  → not an ordinary Project Repository file
```

Detailed materialization belongs to `WORKTREES.md`.

## Stable repository identity

Each participating repository should be deterministically resolvable by a stable project-local selector/role.

The live Git/filesystem state remains source of truth; do not create a duplicate registry merely to mirror worktree state.

Work-level branch/path mapping uses that stable repository identity and is covered by Work guidance.

## Primary checkout

A Primary Checkout is a stable reference checkout for repository/root resolution and project-level helper operations.

It does not decide which branch/worktree a Work must use.
