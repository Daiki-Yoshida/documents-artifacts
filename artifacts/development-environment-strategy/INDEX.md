# Development Environment Strategy - Index

```yaml
document_type: "index"
target_audience: "ai_agents"
optimization: "token_efficiency"
language: "english"
role: "entry point for the exported development-environment guidance"
strategy_version: "1.1.1"
```

Read this file first. Load only the documents required by the current task.

## Read Order

```yaml
1_philosophy: "DEVELOPMENT_ENVIRONMENT_PHILOSOPHY.md" # WHY: safety, reproducibility, isolation, checkout selection
2_standards:  "ENVIRONMENT_STANDARDS.md"             # HOW: host, Docker, commands, Git safety, CI parity
3_structure:  "WORKSPACE_STRUCTURE.md"               # WHERE: repositories, checkouts, optional worktrees, layout
4_workflow:   "ENVIRONMENT_WORKFLOW.md"               # FLOW: setup, checkout choice, validation, cleanup, recovery
```

On first contact, read 1 -> 2 -> 3 -> 4. For a focused task, use Quick Task Routing.

## Foundational Lens

```yaml
core_idea: "A development environment is a contract: topology, toolchain, command interface, state lifecycle, isolation, and safety."
priority: "host/data safety > reproducibility > isolation > parallel operability > explicit operations > diagnosability > local/CI parity > efficiency"
primary_pattern: "host as control plane; containers as project execution plane"
checkout_default: "use the currently assigned checkout for one writing task; create a Task Worktree only for parallelism or explicit isolation"
scope: "development workspace, repository topology, execution tooling, and environment lifecycle"
```

## Absolute Worktree Selection Rule

```yaml
rule: "Worktree support is optional capability, not a mandatory per-task step."
default: "one writing task -> current or Primary Checkout on a task branch"
worktree_triggers:
  - "concurrent writing tasks or agents on the same Component Repository"
  - "another branch must remain checked out at a stable path"
  - "explicit user or project requirement"
  - "independently disposable checkout and mutable runtime state are required"
never_sufficient_alone:
  - ".worktrees/ exists"
  - "worktree helper commands exist"
  - "the task has a TASK_ID"
```

This rule overrides wording that could otherwise be read as requiring a Task Worktree for ordinary single-agent work.

## Ownership Map

Each concept has one authoritative document. Link instead of duplicating.

```yaml
DEVELOPMENT_ENVIRONMENT_PHILOSOPHY.md:
  owns:
    - "Development Environment Contract"
    - "Priority order"
    - "Host control plane and container execution plane"
    - "Checkout selection rationale"
    - "Workspace Repository, Component Repository, Primary Checkout, and Task Worktree concepts"
    - "Parallel-agent isolation rationale"
    - "Scope boundary and common misreadings"

ENVIRONMENT_STANDARDS.md:
  owns:
    - "Host dependency policy"
    - "Docker resource naming and isolation"
    - "UID/GID, caches, ports, secrets, and generated files"
    - "Makefile, public command interface, and scripts responsibility"
    - "Command naming and destructive-operation rules"
    - "Git operation safety"
    - "Local and CI execution parity"
    - "Diagnostics and canonical validation requirements"

WORKSPACE_STRUCTURE.md:
  owns:
    - "Workspace Repository and Component Repository placement"
    - "Primary Checkout and optional Task Worktree placement"
    - "Checkout selection conditions"
    - ".worktrees/ structure and naming"
    - "Top-level development-environment directories"
    - "Git tracking and ignore boundaries"
    - "Multi-component workspaces"
    - "Workspace-to-component tool-version dependency"
    - "Identity propagation across isolated Git, Docker, logs, and outputs"

ENVIRONMENT_WORKFLOW.md:
  owns:
    - "New-project setup"
    - "Brownfield adoption"
    - "Checkout mode selection"
    - "Optional Task Worktree creation and assignment"
    - "Implementation-time and final validation flow"
    - "Integration and conditional cleanup flow"
    - "Diagnosis and recovery"
    - "Environment Confirmation Gate"
    - "Re-read triggers"
```

## Quick Task Routing

```yaml
"choosing host-installed tools":                 "ENVIRONMENT_STANDARDS.md (Host Dependency Boundary)"
"adding Docker or Compose":                      "ENVIRONMENT_STANDARDS.md (Docker Standards)"
"naming containers, networks, or volumes":       "ENVIRONMENT_STANDARDS.md (Resource Identity)"
"designing Make targets or scripts":             "ENVIRONMENT_STANDARDS.md (Command Interface)"
"deciding whether to create a worktree":         "DEVELOPMENT_ENVIRONMENT_PHILOSOPHY.md (Checkout Selection Rule) + ENVIRONMENT_WORKFLOW.md"
"adding or changing Git worktree support":       "WORKSPACE_STRUCTURE.md (Task Worktrees) + ENVIRONMENT_WORKFLOW.md"
"organizing parent and child repositories":      "WORKSPACE_STRUCTURE.md (Repository Topology)"
"supporting several component repositories":     "WORKSPACE_STRUCTURE.md (Multi-Component Workspace)"
"running several AI agents in parallel":         "DEVELOPMENT_ENVIRONMENT_PHILOSOPHY.md (Parallel Isolation) + WORKSPACE_STRUCTURE.md"
"making local and CI behavior match":            "ENVIRONMENT_STANDARDS.md (Local/CI Parity)"
"adding a destructive cleanup command":          "ENVIRONMENT_STANDARDS.md (Destructive Operations) + ENVIRONMENT_WORKFLOW.md (Confirmation Gate)"
"setting up a new project":                      "ENVIRONMENT_WORKFLOW.md (New Project Setup)"
"adopting this in an existing project":          "ENVIRONMENT_WORKFLOW.md (Brownfield Adoption)"
"diagnosing a broken environment":               "ENVIRONMENT_WORKFLOW.md (Diagnosis and Recovery)"
"deciding whether a change needs confirmation":  "ENVIRONMENT_WORKFLOW.md (Environment Confirmation Gate)"
```

## Relationship to Sibling Artifact Sets

```yaml
design_principles:
  owns: "code architecture, module contracts, implementation, and testing strategy"
documentation_strategy:
  owns: "documents/ structure, routing, versioning, and maintenance"
development_environment_strategy:
  owns: "workspace topology, development tools, execution paths, optional Git worktrees, and environment lifecycle"
```

For mixed tasks, apply each artifact set to its own domain. Do not use development-environment rules to redesign application modules, and do not use code-layout rules to decide repository/worktree topology.
