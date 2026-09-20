# Development Environment Strategy - Index

```yaml
document_type: "index"
target_audience: "ai_agents"
optimization: "token_efficiency"
language: "english"
role: "entry point for the exported development-environment guidance"
strategy_version: "1.3.0"
```

Read this file first. Load only the documents required by the current request.

## Read Order

```yaml
1_philosophy: "DEVELOPMENT_ENVIRONMENT_PHILOSOPHY.md" # WHY: environment contract, Work Identity, safety, isolation
2_standards:  "ENVIRONMENT_STANDARDS.md"             # HOW: host, Docker, resource scope, commands, Git safety, CI
3_structure:  "WORKSPACE_STRUCTURE.md"               # WHERE: Project Root, Work Root, repositories, Work Documents, worktrees
4_workflow:   "ENVIRONMENT_WORKFLOW.md"               # FLOW: establish Work, implement, validate, reconcile, clean, recover
```

On first contact, read 1 -> 2 -> 3 -> 4. For a focused request, use Quick Routing.

## Foundational Lens

```yaml
core_idea: "A development environment is a contract whose active development unit is a Work Identity: one concrete goal, one ownership/lifecycle boundary."
priority: "host/data safety > reproducibility > isolation > parallel operability > explicit operations > diagnosability > local/CI parity > efficiency"
primary_pattern: "host as control plane; containers as project execution plane"
work_identity: "confirm <work-type>/<work-name> after the goal is concrete and before implementation"
git_relation: "Git is preferred; branches/worktrees represent a Work Identity but do not define it"
work_root: ".worktrees/<work-type>/<work-name>/"
scope: "development workspace, repository topology, Work Identity, execution tooling, and environment lifecycle"
```

## Worktree Selection Rule

```yaml
rule: "A Work Identity does not require a Git worktree."
default: "one writing Work -> current or Primary Checkout on the Work branch when Git is available"
worktree_triggers:
  - "concurrent writable Works/agents on the same repository"
  - "another branch must remain checked out at a stable path"
  - "explicit user/project requirement"
  - "independently disposable checkout and mutable runtime are required"
never_sufficient_alone:
  - ".worktrees/ exists"
  - "worktree helper commands exist"
  - "a Work Identity exists"
```

`.worktrees/` is the Project Repository's Work Identity workspace, not merely a bucket of Git worktrees.

## Ownership Map

Each concept has one authoritative document. Link instead of duplicating.

```yaml
DEVELOPMENT_ENVIRONMENT_PHILOSOPHY.md:
  owns:
    - "Development Environment Contract and priority order"
    - "Host control plane / container execution plane"
    - "Work Identity WHY, definition, confirmation timing, and Git relationship"
    - "Checkout/worktree selection rationale"
    - "Parallel-agent isolation rationale"
    - "Scope boundary and common misreadings"

ENVIRONMENT_STANDARDS.md:
  owns:
    - "Host dependency policy"
    - "Project / Work / Run resource scope"
    - "Work-scoped Docker/runtime identity and resource reuse"
    - "UID/GID, caches, ports, secrets, generated files"
    - "Makefile, public command interface, and scripts responsibility"
    - "Git operation safety"
    - "Work Root worktree materialization compatibility and helper requirements"
    - "Destructive-operation rules"
    - "Local/CI parity, diagnostics, canonical validation"

WORKSPACE_STRUCTURE.md:
  owns:
    - "Project Root and Project/Workspace/Component Repository placement"
    - "Work Root: .worktrees/<type>/<name>/"
    - "Uniform single-/multi-repository shape"
    - "Work Documents placement and Git ownership boundary"
    - "Repository-specific Work Identity derivation"
    - "Git worktree placement and Worktree Materialization Contract"
    - "Multi-repository coordination and identity propagation"

ENVIRONMENT_WORKFLOW.md:
  owns:
    - "New-project and brownfield adoption"
    - "Work Identity establishment and explicit confirmation"
    - "Work Root / Work Documents creation"
    - "Checkout and optional Git worktree lifecycle, including atomic Work Root creation/recreation"
    - "Implementation-time/final validation"
    - "Multi-repository integration semantics"
    - "Work Documents reconciliation and Work completion"
    - "Scoped cleanup, diagnosis, recovery, and confirmation gate"
```

## Quick Routing

```yaml
"understanding Work Identity":                   "DEVELOPMENT_ENVIRONMENT_PHILOSOPHY.md (Work Identity)"
"starting implementation work":                  "ENVIRONMENT_WORKFLOW.md (Work Identity Lifecycle)"
"naming or locating a Work Root":                "WORKSPACE_STRUCTURE.md (Work Root)"
"working with Work Documents":                   "WORKSPACE_STRUCTURE.md (Work Documents Placement and Ownership) + ENVIRONMENT_WORKFLOW.md (Work Completion and Cleanup)"
"choosing host-installed tools":                 "ENVIRONMENT_STANDARDS.md (Host Dependency Boundary)"
"adding Docker or Compose":                      "ENVIRONMENT_STANDARDS.md (Docker Standards)"
"naming containers, networks, or volumes":       "ENVIRONMENT_STANDARDS.md (Resource Identity / Resource Scope)"
"designing Make targets or scripts":             "ENVIRONMENT_STANDARDS.md (Command Interface)"
"deciding whether to create a worktree":         "DEVELOPMENT_ENVIRONMENT_PHILOSOPHY.md (Checkout Selection Rule) + ENVIRONMENT_WORKFLOW.md"
"adding or changing Git worktree support":       "WORKSPACE_STRUCTURE.md (Repository Worktrees and Identity + Git Tracking and Materialization Boundaries) + ENVIRONMENT_WORKFLOW.md"
"creating a Work Root Git worktree":             "ENVIRONMENT_WORKFLOW.md (Prepare the Selected Repository) + WORKSPACE_STRUCTURE.md (Worktree Materialization Contract)"
"organizing parent and child repositories":      "WORKSPACE_STRUCTURE.md (Repository Topology)"
"supporting several component repositories":     "WORKSPACE_STRUCTURE.md (Multi-Repository Coordination and Resource Identity)"
"running several AI agents in parallel":         "DEVELOPMENT_ENVIRONMENT_PHILOSOPHY.md (Parallel-Agent Isolation) + WORKSPACE_STRUCTURE.md"
"making local and CI behavior match":            "ENVIRONMENT_STANDARDS.md (Local and CI Parity)"
"adding a destructive cleanup command":          "ENVIRONMENT_STANDARDS.md (Destructive Operations) + ENVIRONMENT_WORKFLOW.md"
"setting up a new project":                      "ENVIRONMENT_WORKFLOW.md (New Project Setup)"
"adopting this in an existing project":          "ENVIRONMENT_WORKFLOW.md (Brownfield Adoption)"
"diagnosing a broken environment":               "ENVIRONMENT_WORKFLOW.md (Diagnosis and Recovery)"
```

## Relationship to Sibling Artifact Sets

```yaml
design_principles:
  owns: "code architecture, module contracts, implementation, and testing strategy"
documentation_strategy:
  owns: "canonical Project Document and active Work Document content semantics, routing, versioning, and reconciliation"
development_environment_strategy:
  owns: "Work Identity, Work Root/worktree topology, development tools, resource lifecycle, and execution paths"
```

For mixed requests, apply each artifact set only to the domain it owns. In particular, Work Document **placement and lifecycle boundary** come from this strategy; Work Document **content/reconciliation semantics** come from documentation-strategy.
