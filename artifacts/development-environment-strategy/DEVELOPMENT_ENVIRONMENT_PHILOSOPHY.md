# Development Environment Philosophy

```yaml
document_type: "development_environment_philosophy"
target_audience: "ai_agents"
language: "english"
strategy_version: "1.4.1"
```

## Development Environment Contract

A development environment is not an informal collection of local tools. It is a contract that defines how development work is entered, executed, isolated, verified, and removed.

```yaml
contract:
  topology: "where repositories, primary checkouts, worktrees, tools, caches, and outputs live"
  toolchain: "which tools belong on the host and which belong in the project execution environment"
  command_interface: "the stable operations available to humans, AI agents, and CI"
  state_lifecycle: "how environment state is created, inspected, reused, cleaned, and recovered"
  isolation: "how projects, Work Identities, branches, and parallel agents avoid interfering with each other"
  safety: "which operations are non-destructive, destructive, or require confirmation"
```

The environment contract is the development-facing equivalent of a public software contract. Internal tooling may change, but routine callers should keep a clear and stable way to build, test, diagnose, and clean the project.

## Priority Order

```yaml
priority:
  1: "Host and data safety"
  2: "Reproducibility"
  3: "Repository and resource isolation"
  4: "Parallel-agent operability"
  5: "Explicit operation semantics"
  6: "Diagnosability and recoverability"
  7: "Local and CI execution parity"
  8: "Developer efficiency"
```

Efficiency remains important. Safety should be achieved by providing short, safe paths, not by making routine development cumbersome.

## Control Plane and Execution Plane

```yaml
host_control_plane:
  purpose: "coordinate source control, containers, command routing, authentication, and remote access"
  rule: "keep project-specific runtimes and package ecosystems off the host unless an explicit exception is documented"
container_execution_plane:
  purpose: "own project runtimes, package managers, build tools, test tools, and project-specific CLIs"
  rule: "project execution should be reproducible from repository-controlled definitions"
```

The host is not the project runtime by default. It controls the runtime.

This separation reduces host mutation, version conflicts, accidental privilege expansion, and differences between developers or AI agents.

## Work Identity

A **Work Identity** is the semantic identity of one concrete development goal once that goal is specific enough to implement.

```yaml
work_identity:
  meaning: "what development outcome this work exists to achieve"
  owns:
    - "work-scoped ownership"
    - "resource identity"
    - "lifecycle"
establishment:
  timing: "after the goal is concrete and before implementation begins"
  confirmation: "the user explicitly confirms the Work Identity; an agent may propose the name"
```

Do not create a Work Identity for every discussion, command, test run, or exploratory thought. Establish it when work crosses from design/discussion into implementation.

A Work Identity is intentionally above its tool representations:

```text
Goal
  ↓
Work Identity
  ├─ Git branch / optional worktree
  ├─ mutable runtime and test state
  ├─ logs and generated work outputs
  └─ Work Documents
```

Git is strongly preferred for normal software development, but it does not define the Work Identity. When Git is available, a work branch should deterministically represent the Work Identity according to project naming conventions. A Git-less environment may still use the same Work Identity and lifecycle model.

Typical semantic form:

```text
<work-type>/<work-name>
```

Examples include `feat/pathfinding`, `fix/login-timeout`, and `refactor/payment-boundary`. The exact branch syntax remains project-owned.

## Workspace Topology Concepts

```yaml
workspace_repository:
  meaning: "the repository that owns development tooling, workspace coordination, environment documents, and multi-component coordination when such a separate repository is useful"
component_repository:
  meaning: "an independent repository that owns product code and its product history"
project_repository:
  meaning: "the top-level repository whose project root owns .worktrees/ and the Work Documents stored there; it may also be the only product repository"
primary_checkout:
  meaning: "the stable default checkout of a repository; it may host one active Work when project policy permits"
work_root:
  meaning: ".worktrees/<work-type>/<work-name>/; the filesystem workspace owned by one Work Identity"
git_worktree:
  meaning: "an optional repository checkout under a Work Root, used when a separate writable checkout is justified"
```

A Workspace Repository and Component Repository may have separate Git histories. A single-repository project uses the same Work Root shape without inventing a different workflow.

## Checkout Selection Rule

A Work Identity does **not** imply that a Git worktree must exist.

```yaml
default:
  checkout: "use the currently assigned or Primary Checkout on the Work's branch when Git is available"
  condition: "one active writing Work exists for that repository and no separate checkout or mutable-runtime isolation is needed"
create_git_worktree_when:
  - "multiple writing Works or agents must operate on the same repository concurrently"
  - "another branch must remain checked out at a stable path"
  - "the user or project workflow explicitly requests a worktree"
  - "the Work needs an independently disposable checkout and mutable runtime state"
do_not_create_git_worktree_when:
  - "only one writing Work is active"
  - "the current checkout can safely use the Work's branch"
  - "the only reason is that .worktrees/ exists or worktree commands are available"
```

Choose the least complex checkout mode that satisfies safety and isolation. Work Identity is the ownership boundary; a Git worktree is only one possible execution surface.

## Parallel-Agent Isolation

When parallel writing or explicit Work isolation is active, a branch alone may be insufficient.

```yaml
isolate_per_parallel_work_when_needed:
  - "writable checkout"
  - "container namespace"
  - "network and host-port allocation"
  - "mutable volumes or databases"
  - "logs and generated outputs"
rule: "one writable checkout is owned by one writing agent at a time"
```

Shared read-only caches may be reused when safe. Mutable project state must not be shared merely for convenience.

When separate surfaces are created, branch, worktree, runtime resources, logs, outputs, and Work Documents must remain deterministically traceable to the same Work Identity.

## Explicit Operations

A command name is part of the environment contract.

```yaml
principle: "The operator must be able to identify the target and expected effect before execution."
implications:
  - "ambiguous lifecycle names require a scope"
  - "normal cleanup and destructive purge are separate operations"
  - "commands expose stable intent rather than raw tool syntax"
  - "failure must be visible and actionable"
```

Short names are allowed when their meaning is unambiguous within the project. Brevity is not a substitute for semantics.

## Reproducibility

A repository state should describe enough of the development environment to recreate its behavior.

```yaml
required_characteristics:
  - "tool versions or version ranges are controlled"
  - "dependency lock files are respected"
  - "environment creation does not depend on undocumented host state"
  - "local and CI invoke the same project-owned operations where practical"
  - "external workspace-tool dependencies declare how their version is selected"
```

Reproducibility does not mean freezing everything forever. It means changes to the environment are intentional, reviewable, and attributable.

## Safety Without Friction

```yaml
principle: "Make the safe operation the easiest operation."
examples_of_policy:
  - "routine commands are non-destructive by default"
  - "destructive commands are explicit and narrowly scoped"
  - "diagnostic commands are easy to discover"
  - "the final validation path is canonical and documented"
  - "cleanup affects only resources owned by the selected project or Work Identity"
```

Do not solve safety by forcing repeated manual steps that agents will bypass. Encode safety into the command interface and resource identity.

## Scope Boundary

```yaml
governs:
  - "host and container responsibility"
  - "development tool execution"
  - "repository and optional worktree topology"
  - "top-level environment directories"
  - "command interfaces and environment scripts"
  - "local/CI execution paths"
  - "environment state, diagnostics, cleanup, and recovery"
does_not_govern:
  - "application code architecture"
  - "domain module boundaries"
  - "project-document content and routing semantics; those belong to documentation-strategy"
  - "issue triage and pull-request approval policy"
  - "release governance and team permissions"
```

Code quality inside scripts is evaluated by `design-principles`. Placement and invocation of those scripts are evaluated by this strategy. Documentation content is evaluated by `documentation-strategy`; this strategy owns the Work Identity, Work Root placement, and environment lifecycle around Work Documents.

## Common Misreadings

```yaml
misreadings:
  - "Work Identity != conversation index, command run, or arbitrary tool identifier; it represents a concrete development goal"
  - "Work Identity != Git branch; Git branches normally represent Work Identities when Git is available"
  - "Work Identity != create every resource again; isolate only mutable state that actually requires separation"
  - "worktree support != create a Git worktree for every Work; use it only for parallelism or explicit isolation"
  - ".worktrees/ != only a Git worktree bucket; it is the Project Repository's Work Identity workspace"
  - "one writable checkout per agent != every agent always needs a separate checkout"
  - "Workspace Repository != mandatory extra repository or Git submodule"
  - "Primary Checkout != default branch only; it may host ordinary single-writer Work when policy permits"
  - "resource isolation != duplicate every cache; immutable or safely shareable caches may be shared"
  - "Docker-first != every operation must run in Docker; host control-plane operations may stay on the host"
  - "reproducibility != never update; updates must be intentional and reviewable"
  - "safety != slow workflow; safe paths should be the shortest paths"
```
