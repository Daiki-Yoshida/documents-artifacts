# Project and Repository Workspace

Read this when resolving Project Root, repository ownership, multi-repository structure, or stable repository identity.

## Static model

**Project Repository** owns project-level coordination state.

**Project Root** is the baseline working-tree root of the Project Repository and the reference point for project-level paths such as `documents/` and `.worktrees/`.

In a multi-repository Project, the **Project Repository** owns Project-level coordination while independent **Component Repositories** own product/component source and Git history.

Do not introduce a separate Workspace Repository as a required third peer role. Older/project-local uses of that term may describe a Project Repository focused on workspace coordination, but the current reusable role model is Project Repository + Component Repository.

Do not create a Project Repository merely because unrelated repositories share a folder; it must have real Project-level coordination responsibility.

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

Do not describe this relationship as parent/child repository hierarchy. Filesystem containment does not define Git ownership, dependency direction, or Project context.

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

## Development entry root

For development work that belongs to a Project, initialize the AI development session from the **Project Root**.

The Project Root is not only a path-resolution anchor. It is the entry surface for project-owned documentation, agent instructions, routing, policy, public commands, repository ownership, and Work guidance.

Do not treat these as the Project-level AI session root merely because implementation happens there:

- a Work Root;
- a Component Repository checkout;
- a repository-specific Work worktree;
- a linked worktree of the Project Repository itself.

Resolve project context first, then route operations to the selected repository/worktree.

```text
Project Root
  -> project context / policy / routing
  -> Work / repository selection
  -> implementation target
```

This does not require every subprocess to run with Project Root as its working directory. Execution-target routing belongs to `../execution/COMMANDS_AND_CI.md`.

A repository that normally acts as a Component Repository may itself be the Project Repository when it is intentionally developed as a standalone Project. Repository role is therefore contextual: use the Project context that owns the Work, not a permanent parent/child label or filesystem position.

## Documentation ownership in multi-repository Projects

Project Repository owns Project-level documentation/routing. Component Repository may own component-specific documentation where that ownership is appropriate, but Component Repository status alone does not imply a separate Project Documentation tree or a separate Project context.

Project Documentation should route to component-specific knowledge when Project work needs it; do not duplicate component authority into Project Repository merely for convenience.

## Primary checkout

A Primary Checkout is a stable reference checkout for repository/root resolution and project-level helper operations.

It does not decide which branch/worktree a Work must use.
