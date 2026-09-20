# Workspace Structure

```yaml
document_type: "workspace_structure"
target_audience: "ai_agents"
language: "english"
strategy_version: "1.3.0"
scope: "repository topology, Work Roots, checkouts, Work Documents placement, and top-level environment layout"
```

## 1. Repository Topology

### Workspace Repository

The Workspace Repository owns the development control plane.

```yaml
owns:
  - "Docker and Compose definitions"
  - "Makefile and public command wrappers"
  - "environment scripts"
  - "AI-agent environment context"
  - "optional worktree creation and cleanup operations"
  - "multi-component coordination"
does_not_own_by_default:
  - "component product history"
  - "component source code"
```

### Component Repository

A Component Repository owns a product or independently versioned component.

```yaml
owns:
  - "product source code"
  - "product tests"
  - "component-specific CI and release files"
  - "component Git history"
relationship: "may be placed inside a Workspace Repository without being tracked by it"
```

Workspace and Component repositories may be separate Git repositories with separate histories. Do not describe this relationship as a Git submodule unless it actually is one.

### Single-Repository Alternative

A separate Workspace Repository is optional.

Use one repository when environment tooling and product code share one lifecycle and parallel coordination does not justify a second history. Apply the same host, command, branch, and optional worktree rules at the single repository root.

## 2. Project Root and Primary Checkouts

The **Project Root** is the top-level path whose owning Project Repository controls project coordination and contains `.worktrees/`.

A separate Workspace Repository is optional. In a single-repository project, the same repository may simultaneously be the Project Repository and the product repository.

Each participating repository may also have a stable Primary Checkout.

```yaml
project_root:
  owns:
    - ".worktrees/ Work Identity workspace"
    - "Work Documents through the Project Repository"
    - "project-level coordination"
primary_checkout:
  purpose:
    - "ordinary single-writer work when no separate checkout is needed"
    - "fetch and synchronization"
    - "Git worktree creation"
    - "integration and final inspection"
```

When Git is available, implementation should normally occur on a branch representing the confirmed Work Identity rather than directly on the protected/default branch.

## 3. Work Root

Each active Work Identity has one filesystem root:

```text
.worktrees/<work-type>/<work-name>/
```

Example:

```text
.worktrees/feat/pathfinding/
```

The Work Root groups the filesystem-facing state of one development goal.

```yaml
work_root:
  identity: "<work-type>/<work-name>"
  contains:
    - "documents/ — Work Documents tracked by the Project Repository"
    - "<repository>/ — zero or more participating Git worktrees"
  lifecycle: "created for active Work; removed after completion/abandonment reconciliation"
```

Do not introduce a separate `.work/<identity>/` hierarchy for the same purpose.

## 4. Uniform Single- and Multi-Repository Shape

Use the same Work Root shape regardless of repository count.

### Single repository

```text
.worktrees/
└─ feat/
   └─ pathfinding/
      ├─ documents/
      └─ main/
```

`main/` is the participating repository's Git worktree.

### Multiple repositories

```text
.worktrees/
└─ feat/
   └─ hogehoge/
      ├─ documents/
      ├─ front/
      └─ back/
```

`front/` and `back/` are Git worktrees of their respective repositories.

This uniform shape is intentional: project topology may evolve, and agents should not need separate single-repository and multi-repository management flows.

## 5. Work Documents Placement and Ownership

```text
.worktrees/<work-type>/<work-name>/documents/
```

contains **Work Documents**: Git-managed documentation for the active Work Identity.

Ownership rules:

- The Project Repository at the Project Root owns and tracks Work Documents.
- Work Documents are intended to be visible from the Project Repository's main/default coordination state so that active Work can be discovered from that baseline.
- Work Documents are not the same as canonical Project Documents under `documents/`; their content semantics and reconciliation rules are owned by `documentation-strategy`.
- Sibling repository directories under the Work Root are Git worktrees and MUST NOT be tracked as ordinary files by the Project Repository.
- Do not create a dedicated Git repository only for Work Documents.

The Project Repository's ignore/materialization rules must express this ownership boundary rather than ignoring the entire `.worktrees/` tree.

## 6. Repository Worktrees and Identity

A Git worktree, when required, lives at:

```text
.worktrees/<work-type>/<work-name>/<repository>/
```

A Work Identity is normally expressed semantically as:

```text
<work-type>/<work-name>
```

For multiple participating repositories, derive repository-specific identities deterministically from the base Work Identity.

Examples:

```text
base:  feat/hogehoge
front: feat-hogehoge-front
back:  feat-hogehoge-back
```

or, when the project prefers hierarchical branch names:

```text
feat/hogehoge/front
feat/hogehoge/back
```

The exact branch syntax is project-owned. The invariant is deterministic traceability back to the same base Work Identity.

### Checkout Selection

Use the simplest safe checkout arrangement.

```yaml
use_current_or_primary_checkout_when:
  - "one writing Work is active for the repository"
  - "the checkout can safely use the Work branch"
  - "no other branch must remain available at a stable path"
  - "separate mutable runtime state is unnecessary"
create_git_worktree_when:
  - "multiple writing Works or agents need concurrent writable checkouts"
  - "another branch must remain checked out at a stable path"
  - "the user/project explicitly requires a worktree"
  - "an independently disposable checkout and runtime state are needed"
insufficient_reason:
  - ".worktrees/ exists"
  - "worktree helper commands exist"
  - "a Work Identity exists"
```

### Worktree Invariants

- A branch must not be assigned to two writable worktrees.
- One writable checkout is owned by one writing agent at a time.
- The selected repository/worktree path must propagate to build, test, format, logs, and generated-output operations.
- Parallel Works must receive distinct mutable state where sharing would alter results.
- A Work Root repository worktree must satisfy the Worktree Materialization Contract in §8.
- Removing a worktree must not implicitly delete its branch.

## 7. Recommended Top-Level Layout

```text
<project-root>/
├─ Makefile
├─ <public-wrapper>
├─ compose.yml
├─ docker/
├─ scripts/
├─ documents/                         # canonical Project Documents
├─ <primary-repository-checkouts>/    # project-specific
└─ .worktrees/
   └─ <work-type>/
      └─ <work-name>/
         ├─ documents/                # Work Documents; Project Repository tracked
         ├─ <repository-a>/           # optional Git worktree
         └─ <repository-b>/           # optional Git worktree
```

The exact filenames are ecosystem-specific. The ownership and lifecycle boundaries are normative.

## 8. Git Tracking and Materialization Boundaries

### Project Repository

The Project Repository:

- tracks Work Documents under `.worktrees/<type>/<name>/documents/`;
- does not track nested participating repository worktrees as ordinary files;
- keeps environment-local secrets, caches, and generated build output out of Git;
- uses Git history as the historical record for completed/deleted Work Documents rather than inventing a parallel archive.

### Participating Repository

Each repository owns its own source, tests, history, caches, build outputs, and tool-specific ignores.

### Tracking ownership and materialization are separate

The Project Repository may track:

```text
.worktrees/<work-type>/<work-name>/documents/**
```

while sibling repository worktree directories remain ignored as ordinary Project Repository files.

A compatible ignore boundary is:

```gitignore
.worktrees/*/*/*
!.worktrees/*/*/documents/
!.worktrees/*/*/documents/**
```

This controls **tracking ownership only**. It does not stop Git from checking out tracked Work Documents inside another worktree.

### Worktree Materialization Contract

A repository worktree created under a Work Root MUST NOT materialize the Project-level `.worktrees/` tree inside itself.

For Work Root worktrees, the standard materialization semantics are:

```text
ordinary tracked repository content
    → materialize

Project-level .worktrees/
    → keep tracked in Git history/index as applicable, but exclude from this worktree filesystem
```

Use worktree-local non-cone sparse checkout with:

```text
/*
!/.worktrees/
```

Non-cone exclusion is intentional: it means "materialize everything except Project-level `.worktrees/`" and does not require maintaining an allow-list of future top-level repository directories.

### Creation and recreation invariant

Create a Work Root repository worktree without first materializing the full tracked tree:

```bash
git worktree add --no-checkout <worktree-path> <work-branch>

git -C <worktree-path> \
  sparse-checkout set --no-cone '/*' '!/.worktrees/'

git -C <worktree-path> \
  reset --hard HEAD
```

The worktree-local sparse state is owned by the linked worktree's Git administrative directory and is removed with that worktree. Therefore every recreation MUST repeat the sparse configuration before materialization.

Do not use plain `git worktree add` as the standard Work Root creation path when the branch contains tracked Project-level `.worktrees/` content; it transiently materializes the forbidden recursive tree before sparse exclusion can be applied.

A project using this contract MUST support a Git version where worktree-local sparse checkout is verified to behave correctly. The generic strategy does not mandate one universal Git version; project bootstrap/doctor logic should verify compatibility for supported versions.

## 9. Multi-Repository Coordination and Resource Identity

A single Work Identity may coordinate several repositories.

```yaml
requirements:
  - "one base Work Identity describes the shared development goal"
  - "repository-specific identities map deterministically to that base"
  - "commands identify the selected repository when the operation is not project-wide"
  - "cross-repository validation is an explicit operation"
  - "one repository merge does not by itself imply that the whole Work is complete"
```

For isolated runtime surfaces, propagate the same semantic Work Identity:

```yaml
propagate_to_when_work_scoped:
  - "branch metadata"
  - "worktree path"
  - "Compose/container namespace"
  - "mutable volumes / databases / host ports"
  - "logs"
  - "generated work outputs"
```

Formatting may vary by subsystem, but the mapping must remain deterministic and diagnosable.

## 10. Workspace-to-Component Tool Dependency

A Component Repository may rely on tools stored in a separate Workspace Repository.

The dependency selection must be explicit.

```yaml
selection_modes:
  moving_ref:
    meaning: "use a documented branch or current workspace checkout"
    tradeoff: "easy updates, weaker historical reproducibility"
  fixed_ref:
    meaning: "use a tag or commit"
    tradeoff: "strong reproducibility, requires deliberate updates"
rule: "CI and release validation must not accidentally consume an unspecified workspace version"
```

Record the selected mode in project documentation or CI configuration. Local convenience may use the current workspace checkout, while formal validation may require a fixed ref.

## 11. Cross-Artifact Boundaries

```yaml
development_environment_strategy:
  owns: "Work Identity, Work Root, repository/checkout/worktree placement, and environment-facing lifecycle boundaries"
design_principles:
  owns: "application modules, public code surfaces, dependency direction, and test architecture"
documentation_strategy:
  owns: "Project Document and Work Document content semantics, routing, maintenance, and reconciliation"
```

When a folder has mixed significance, apply each strategy only to the concern it owns.
