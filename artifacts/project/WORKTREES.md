# Worktree Contract

Read this only when a project has adopted Work-specific Git worktrees and you are creating, diagnosing, or removing them. Work Identity itself does not require every project or every Work to use a worktree.

## Public directory target and semantic identity

When a project adopts Work-specific Git worktrees, it exposes safe create/status/remove operations; Work Identity alone does not require materializing a worktree.

For a Make-based public interface with variable directory targets, **prefer generic `DIR=<directory-path>`**. Here the public operation treats `DIR` as the candidate location of one repository-specific worktree:

~~~bash
make DIR=.worktrees/feat/pathfinding/project/ worktree-create
make DIR=.worktrees/feat/pathfinding/project/ worktree-status
make DIR=.worktrees/feat/pathfinding/project/ worktree-remove
~~~

The public path is not permission to place a worktree arbitrarily. Resolve it against the Project Root's canonical mapping to obtain **internal** semantic inputs:

~~~yaml
WORK: "<work-type>/<work-name>"
REPO: "<stable project repository selector>"
BASE: "required if a missing branch has no documented default starting ref"
~~~

Keep `REPO` explicit **internally** even in a single-repository project; it is not the Git branch name. Caller-facing `WORK + REPO` remains a valid project-local/compatibility interface, not the generic required command syntax. Callers should not decide sparse-checkout or branch naming.

## Canonical path

~~~text
<project-root>/.worktrees/<work-type>/<work-name>/<repo-selector>/
~~~

For `DIR`-based worktree operations, validate the candidate's path shape, repository mapping, existing ancestor/symlink/ownership boundaries and the confirmed Work Identity. Do not infer authorization merely from a directory value.

- Create may accept a **missing final target path**, but only the deterministic canonical destination, with conflict/ownership checks.
- Status is non-mutating and can report an unregistered/missing canonical target. If registered, inspect actual Git path, branch, owner and cleanliness.
- Remove requires an existing registered worktree and must check that the selected path and branch match the resolved Work/REPO; dirty state is refused.
- A Work Root path without repository-specific selection does not uniquely identify one worktree in a multi-repository Work. Fail on ambiguity unless a separate explicit operation intentionally targets the entire Work.

Generic `DIR` path-input semantics are owned by `../execution/COMMANDS_AND_CI.md`. The branch, worktree materialization, registration, and cleanup safety rules remain here.

## Branch semantics

A branch start ref and an upstream are different decisions.

For a missing Work branch:

- use explicit `BASE` or documented project default;
- never use accidental current HEAD as the base;
- creating from a base must not automatically imply tracking that base branch.

A same-name remote Work branch may track its corresponding remote branch according to project policy.

## Management Root Repository materialization invariant

When the selected repository's stable role owns (or can later receive) tracked project-level `.worktrees/**` coordination state, a nested linked worktree must **not recursively materialize the project-level `.worktrees/` tree**.

Do not decide applicability only from whether the currently selected branch already contains `.worktrees/**`; a first Work or an older base branch can receive that coordination state later.

Validated creation sequence:

```bash
git worktree add --no-checkout <path> <branch>

git -C <path>   sparse-checkout set --no-cone '/*' '!/.worktrees/'

git -C <path>   reset --hard HEAD
```

This low-level sequence should be wrapped in a project-owned create operation. Reapply the policy on recreation because worktree-local sparse state is removed with the worktree.

Do not blindly apply this sparse policy to independent Component Repositories whose role does not own the project-level coordination namespace. Current branch-tree inspection can be diagnostic, but stable repository role is the primary applicability signal.

## Create contract

Preflight at least:

- Project Root/repository resolves;
- Work syntax is valid;
- branch resolves deterministically;
- missing branch has explicit/documented base;
- target path is absent or the exact requested registered worktree;
- no unrelated content occupies the path;
- branch is not owned by another incompatible writable worktree;
- Management Root Repository ignore boundary covers the sibling worktree path where required;
- required materialization capability is supported.

Create should be idempotent:

- exact existing valid worktree → no-op success;
- conflicting/invalid existing state → diagnose and fail;
- do not steal a branch or destructively repair by default.

Verify before returning success:

- the registered Git worktree path equals the resolved path;
- the checked-out branch equals the resolved Work branch;
- the single-writable-checkout ownership invariant holds;
- for a Management Root Repository checkout, Work Documents remain materialized/tracked and the sibling worktree path does not appear as ordinary untracked project content — never blanket-ignore Work Documents;
- where the materialization contract applies, ordinary repository content is materialized, nested `.worktrees/` is absent, and worktree-local sparse state is active.

Creation that fails these checks is not successful even if its commands exited 0.

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

Preflight at least:

- the resolved path is a registered worktree of the expected repository;
- resolved identity/branch matches the requested WORK/REPO expectation;
- the worktree has no uncommitted changes;
- commits are preserved according to project policy.

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

Reference validation demonstrated the contract for the test repository below. Here, `REPO: main` is that repository's selector and must not be read as a universal selector or branch-name requirement:

```yaml
topology: "single repository"
REPO: "main"
case: "Management Root Repository itself as linked worktree"
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
