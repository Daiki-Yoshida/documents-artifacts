# Development Environment Philosophy

```yaml
document_type: "development_environment_philosophy"
target_audience: "ai_agents"
language: "english"
strategy_version: "1.1.1"
```

## Development Environment Contract

A development environment is not an informal collection of local tools. It is a contract that defines how development work is entered, executed, isolated, verified, and removed.

```yaml
contract:
  topology: "where repositories, primary checkouts, worktrees, tools, caches, and outputs live"
  toolchain: "which tools belong on the host and which belong in the project execution environment"
  command_interface: "the stable operations available to humans, AI agents, and CI"
  state_lifecycle: "how environment state is created, inspected, reused, cleaned, and recovered"
  isolation: "how projects, tasks, branches, and parallel agents avoid interfering with each other"
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

## Workspace Topology Concepts

```yaml
workspace_repository:
  meaning: "the repository that owns development tooling, workspace coordination, environment documents, and optional worktree management"
component_repository:
  meaning: "an independent repository that owns product code and its product history"
primary_checkout:
  meaning: "the stable default checkout of a component repository; it may be used for one active writing task when project policy permits"
task_worktree:
  meaning: "an additional temporary checkout created only when parallel writing or explicit isolation is needed"
```

A Workspace Repository and Component Repository may have completely separate Git histories. This is a workspace relationship, not necessarily a Git submodule relationship.

A single-repository project may use the same principles without creating a separate Workspace Repository. Do not add repository layers without a real coordination or isolation need.

## Checkout Selection Rule

Worktree support is a capability, not a mandatory step for every task.

```yaml
default:
  checkout: "use the currently assigned checkout on an appropriate task branch"
  condition: "one writing task is active and no separate checkout or runtime isolation is needed"
create_task_worktree_when:
  - "two or more writing tasks or agents must operate on the same Component Repository concurrently"
  - "another branch must remain checked out at a stable path"
  - "the user or project workflow explicitly requests a worktree"
  - "the task needs an independently disposable checkout and mutable runtime state"
do_not_create_task_worktree_when:
  - "only one writing task is active"
  - "the current checkout can safely switch to or already uses the task branch"
  - "the only reason is that .worktrees/ exists or worktree commands are available"
```

Agents must choose the least complex checkout mode that satisfies safety and isolation requirements. Creating unnecessary worktrees adds state, cleanup cost, and opportunities for selecting the wrong checkout.

## Parallel-Agent Isolation

When parallel writing or explicit task isolation is active, separate branches alone are insufficient.

```yaml
isolate_per_parallel_task:
  - "branch"
  - "working directory"
  - "container namespace"
  - "network and host-port allocation"
  - "mutable volumes when state must not be shared"
  - "logs and generated outputs"
rule: "one writable checkout is owned by one writing agent at a time"
```

Shared read-only caches may be reused when safe. Mutable project state must not be shared merely for convenience.

When a Task Worktree is used, task, branch, worktree, container namespace, and logs should be traceable through a common stable identity.

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
  - "cleanup affects only resources owned by the selected project or task"
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
  - "documents/ routing and versioning"
  - "issue triage and pull-request approval policy"
  - "release governance and team permissions"
```

Code quality inside scripts is evaluated by `design-principles`. Placement and invocation of those scripts are evaluated by this strategy. Documentation under `documents/` is evaluated by `documentation-strategy`.

## Common Misreadings

```yaml
misreadings:
  - "Docker-first != every operation must run in Docker; host control-plane operations may stay on the host"
  - "minimal host != a universal fixed allowlist; classify tools by responsibility"
  - "worktree support != create a worktree for every task; use it only for parallelism or explicit isolation"
  - "one writable checkout per agent != every agent needs a separate checkout when only one writing task exists"
  - "Workspace Repository != Git parent repository or mandatory submodule"
  - "Primary Checkout != default branch only; it may host ordinary single-agent task-branch work when project policy permits"
  - "resource isolation != duplicate every cache; immutable or safely shareable caches may be shared"
  - "explicit names != mechanically prefix every command; add scope when meaning or side effects would otherwise be unclear"
  - "reproducibility != never update; updates must be intentional and reviewable"
  - "safety != slow workflow; safe paths should be the shortest paths"
```
