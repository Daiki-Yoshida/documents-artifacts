# Public Commands and CI

Read this when designing Make targets, wrappers/scripts, command semantics, or local/CI execution paths.

## Expose intent, not raw tool syntax

A public command should make its target and effects understandable before execution.

Use stable purpose-oriented operations rather than requiring humans/AI to reconstruct long provider-specific commands.

A common structure is:

- Makefile or similar router: public operation names/help/parameters;
- wrapper CLI: optional shared checkout/environment selection;
- scripts: complex branching, validation, orchestration, cleanup.

Keep complex shell logic out of a Makefile recipe when a script is clearer/testable.

Provide a discoverable help/status path that explains available operations, required parameters, and destructive effects. Prefer named/structured parameters over one ambiguous catch-all argument.

## Naming

Short names are fine when project scope is unambiguous.

Use `<scope>-<action>` when names such as `up`, `down`, `reset`, `clean`, `deploy`, or `logs` would otherwise hide target/effect.

Do not silently change a formerly non-destructive command into a destructive one.

Separate stop/container removal/volume deletion/full purge semantics.

A scoped command family (`<scope>-up`, `-status`, `-config`, `-verify`, `-down`, `-cleanup`) must share one consistent scope/identity resolution — the same scope name is not a sufficient contract if each command resolves the scope differently. For non-trivial identity derivation, prefer one project-owned resolver/script/config shared by all lifecycle commands over reimplementing the derivation separately per recipe or language; do not over-abstract trivial fixed values.

## Public commands are the execution interface

Project-owned Make targets, wrappers, and scripts are not merely command shortcuts. They are the stable execution interface through which humans, AI, and CI inherit project scope, environment selection, safety checks, and verification paths.

When a project-owned public operation already represents the requested routine operation, prefer that interface instead of reconstructing an underlying raw tool command.

Direct raw-tool execution is reasonable when:

- implementing or repairing the public interface itself;
- diagnosing/failure-isolating the underlying tool;
- no suitable public operation exists;
- project documentation explicitly makes the raw operation the supported path.

Do not bypass the public interface in a way that silently loses its scope, environment, safety, or verification semantics.

## Generic directory target (`DIR`)

Keep the AI session rooted at Project Root. For project-owned public operations with a variable directory target, prefer a consistent named `DIR=<directory-path>` input in Make-based projects.

`DIR` is **only a path locator**. The selected public operation defines what that path means: an existing checkout to test, a Work Root for Docker operations, or a location/basis for creation. `DIR` itself is not a Work, repository, branch, runtime identity, or authorization.

~~~bash
make DIR=.worktrees/feat/pathfinding/ docker-up
make DIR=.worktrees/feat/pathfinding/ docker-down
make DIR=.worktrees/feat/pathfinding/game/ test
make DIR=components/api/ generate
make DIR=.worktrees/feat/pathfinding/game/ worktree-create
~~~

These are command-contract examples, not universally supplied targets. A command need not accept `DIR` when its target is fixed. A project-specific resolver may derive Work identity, a repository selector, Compose namespace, or a subdirectory from the **validated path** as required by that operation. Do not add an implicit repository suffix as a meaning of generic `DIR`. Reusing a path argument helps discoverability and may support shell path completion when configured.

Recommended path handling:

- Resolve relative paths from Project Root, independent of incidental process CWD; quote the value as one path, never evaluate it as a shell fragment.
- Normalize harmless trailing slashes. Resolve realpath/symlink and ownership boundaries when relevant; allow absolute/outside-root targets only with explicit project support and authority.
- Operations for existing targets must verify existence. **Creation operations may accept a not-yet-existing final target** after checking canonical placement, existing ancestors, collisions and authorization.
- Define command-specific target kinds and fail on ambiguous selection; a Work Root does not uniquely choose one of multiple component repositories.
- Omitted `DIR` uses that command's documented default; never accidentally select another Work/default runtime because scope information was dropped.
- A directory selector does not grant destructive authority; see `../safety/DESTRUCTIVE_OPERATIONS.md` and `../operation/SCOPE_AND_AUTHORITY.md`.

### Operation-owned identity and Worktree lifecycle

`docker-up/status/config/verify/down/cleanup` must resolve the **same resource identity** from the same target path and project state, using one project-owned resolver/config source for non-trivial derivation. Docker Work isolation and shared resource rules remain in `HOST_AND_CONTAINER.md` and `../project/WORK_LIFECYCLE.md`.

Worktree create/status/remove can accept a canonical candidate path through `DIR` while resolving **Work Identity + stable repository selector (+ BASE)** internally. Its safety and Git materialization contract is owned by `../project/WORKTREES.md`. Existing project-specific `WORK + REPO` CLI input may remain for compatibility, but it is not a generic requirement for callers.

## Verification commands

Define a standard final verification path.

Partial checks are useful during development/diagnosis but do not automatically replace the final gate.

Commands should return non-zero on failure and leave diagnostic output.

## Local and CI

CI should call project-managed build/test/validation commands instead of reimplementing them in provider YAML.

Provider-specific provisioning may differ, but converge on the same repository-managed verification scripts/targets.

External repository/tool dependencies must use an explicit ref/policy rather than accidentally consuming whatever latest checkout happens to exist.

Work-specific worktree command semantics live in `../project/WORKTREES.md`.
