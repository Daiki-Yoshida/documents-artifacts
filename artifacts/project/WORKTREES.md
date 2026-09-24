# Worktree Contract

Read this only when creating, diagnosing, or removing Work-specific Git worktrees.

## Identity inputs

Routine operations use:

```yaml
WORK: "<work-type>/<work-name>"
REPO: "<stable project repository selector>"
BASE: "required only when a missing Work branch needs a start ref and no documented default exists"
```

Keep `REPO` explicit even for a single-repository project so the public contract does not change if the project later grows.

Callers should not manually supply:

- arbitrary worktree path;
- sparse-checkout decision;
- branch name by default.

Resolve them deterministically from Work + repository identity.

## Path

```text
<project-root>/.worktrees/<work-type>/<work-name>/<repo-selector>/
```

Fail closed if unrelated filesystem content occupies the target.

## Branch semantics

A branch start ref and an upstream are different decisions.

For a missing Work branch:

- use explicit `BASE` or documented project default;
- never use accidental current HEAD as the base;
- creating from a base must not automatically imply tracking that base branch.

A same-name remote Work branch may track its corresponding remote branch according to project policy.

## Project Repository materialization invariant

When the selected repository's branch tree contains tracked project-level `.worktrees/**` coordination state, a nested linked worktree must **not recursively materialize the project-level `.worktrees/` tree**.

Validated creation sequence:

```bash
git worktree add --no-checkout <path> <branch>

git -C <path>   sparse-checkout set --no-cone '/*' '!/.worktrees/'

git -C <path>   reset --hard HEAD
```

This low-level sequence should be wrapped in a project-owned create operation. Reapply the policy on recreation because worktree-local sparse state is removed with the worktree.

Do not blindly apply this sparse policy to independent Component Repositories that do not contain the project-level tracked coordination tree.

## Create contract

Preflight at least:

- Project Root/repository resolves;
- Work syntax is valid;
- branch resolves deterministically;
- missing branch has explicit/documented base;
- target path is absent or the exact requested registered worktree;
- no unrelated content occupies the path;
- branch is not owned by another incompatible writable worktree;
- required materialization capability is supported.

Create should be idempotent:

- exact existing valid worktree → no-op success;
- conflicting/invalid existing state → diagnose and fail;
- do not steal a branch or destructively repair by default.

If creation partially fails, roll back only state created by that invocation when safe. Do not delete pre-existing worktrees or branches.

## Status contract

Status is non-mutating and should expose enough to diagnose identity and materialization:

- Work Identity;
- repository selector/root;
- resolved branch/path;
- registered state;
- current HEAD/branch;
- clean/dirty state;
- materialization/sparse state when applicable;
- whether nested project-level `.worktrees/` is absent;
- Work Documents visibility where relevant.

Use Git/filesystem as source of truth; do not create a duplicate registry.

## Remove contract

Normal remove:

- targets only the selected registered worktree;
- refuses dirty state;
- uses normal `git worktree remove`, not force;
- does not delete the branch;
- does not delete Work Documents;
- does not delete the Work Root;
- does not delete sibling repositories.

Force removal, branch deletion, Work Root purge, unpreserved commit loss, or shared-resource deletion are destructive operations and require safety guidance.

## Validation boundary

Reference validation demonstrated the contract for:

```yaml
topology: "single repository"
REPO: "main"
case: "Project Repository itself as linked worktree"
Git: "2.43.0"
OS: "WSL2/Linux"
```

Validated: materialization, create/status/remove, idempotent create, conflict guards, dirty-remove refusal, remove/recreate, base-ref/upstream separation.

Not fully validated by that reference implementation:

- real multi-repository mapping;
- independent Component Repository normal materialization path;
- macOS / native Windows Git;
- all older/newer Git versions.

Do not present those unvalidated areas as experimentally proven.
