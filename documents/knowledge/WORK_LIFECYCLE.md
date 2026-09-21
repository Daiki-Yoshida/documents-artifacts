# Work Lifecycle

```yaml
document_type: "canonical_knowledge"
authority: "canonical_source"
audience: ["ai_agents", "human_maintainers"]
scope: "identity, active-work knowledge, repository participation, isolation, and completion"
artifact_projection: "derived"
```

This document owns the complete semantic model of one concrete development Work. It deliberately combines identity, active Work knowledge, Git representation, optional worktrees, Work-scoped resources, and completion so those concepts do not become fragmented across code/documentation/environment guidance.

## 1. Work Identity

A **Work Identity** is the semantic identity and ownership/lifecycle boundary for one concrete development goal once that goal is specific enough to implement.

Typical form:

```text
<work-type>/<work-name>
```

Examples:

```text
feat/pathfinding
fix/login-timeout
refactor/payment-boundary
```

The exact vocabulary is project-owned.

### Establishment

Do not create a Work Identity for every discussion, command, test run, or exploratory thought.

Establish it when:

1. the development goal is concrete;
2. implementation is about to begin;
3. the project needs a stable ownership/lifecycle identity.

An agent may propose the name. The user/project confirms it before implementation when explicit confirmation is part of the workflow.

## 2. Work Identity Is Above Its Representations

```text
Goal
  ↓
Work Identity
  ├─ repository-specific branch(es)
  ├─ optional Git worktree(s)
  ├─ Work Documents
  ├─ mutable runtime/test state when isolation is required
  ├─ logs and generated outputs
  └─ cleanup / retention obligations
```

A Work Identity is not:

- a Git branch;
- a worktree;
- a conversation/task counter;
- one command invocation;
- one test run;
- a reason to duplicate every environment resource.

Git normally represents a Work Identity when available, but Git does not define it.

## 3. Project Root and Work Root

The Project Repository owns the Work workspace namespace.

```text
<project-root>/
├─ documents/                        # accepted/current Project knowledge
└─ .worktrees/
   └─ <work-type>/
      └─ <work-name>/                # Work Root
         ├─ documents/               # active Work Documents
         └─ <repository>/            # optional repository worktree(s)
```

The Work Root is:

```text
<project-root>/.worktrees/<work-type>/<work-name>/
```

The same shape applies to single- and multi-repository projects.

### Single repository

```text
.worktrees/feat/pathfinding/
├─ documents/
└─ main/
```

### Multiple repositories

```text
.worktrees/feat/user-auth/
├─ documents/
├─ front/
└─ back/
```

Do not invent a second lifecycle model just because more repositories participate.

## 4. Repository Roles

Useful roles:

```yaml
project_repository:
  meaning: "the repository whose project root owns the Work Root and Work Documents"

workspace_repository:
  meaning: "optional repository owning workspace tooling and coordination when separate from product repositories"

component_repository:
  meaning: "independent repository owning a product/component history"

primary_checkout:
  meaning: "stable default checkout of a repository; it may host one ordinary Work when isolation is unnecessary"

participating_repository:
  meaning: "a repository contributing to one Work Identity"
```

A project may have only one repository. Do not create repository types that the project does not need.

## 5. Repository Selector and Branch Mapping

When public tooling addresses a repository within a Work, use a stable project-owned selector such as:

```text
REPO=main
REPO=front
REPO=back
```

The selector should deterministically resolve:

- repository root;
- directory name under the Work Root;
- repository-specific Work branch;
- whether the repository carries Project-level tracked Work coordination state.

Routine callers should not need to supply arbitrary filesystem paths or low-level Git configuration.

### Branch relationship

One base Work Identity may map to repository-specific branches.

Examples:

```text
base Work: feat/user-auth

front branch: feat/user-auth/front
back branch:  feat/user-auth/back
```

or another documented deterministic convention.

### Branch start point vs upstream

These are separate decisions.

```text
base/start ref = commit from which a new Work branch begins
upstream       = remote branch used for later tracking/pull/push semantics
```

Creating a Work branch from `main` does not imply that `main` should become that Work branch's upstream.

If a same-name remote Work branch exists, project policy may intentionally track it.

## 6. Checkout Selection

A Work Identity does not require a Git worktree.

Default:

```yaml
checkout: "current or Primary Checkout on the Work branch"
condition: "one writing Work owns the repository and no separate checkout/runtime isolation is required"
```

Create a Git worktree when:

- multiple writable Works or agents need the same repository concurrently;
- another branch must remain checked out at a stable path;
- the user/project explicitly requests a worktree;
- the Work needs an independently disposable checkout plus mutable runtime isolation.

Do not create a worktree merely because:

- `.worktrees/` exists;
- helper commands exist;
- a Work Identity exists.

Choose the least complex checkout mode that satisfies safety and isolation.

## 7. Work Documents

Work Documents are active-work knowledge owned by a Work Identity.

Location:

```text
<Work Root>/documents/
```

They may contain:

- design decisions;
- investigation results;
- hypotheses and rejected approaches;
- migration context;
- verification plans/results;
- multi-repository coordination state;
- information needed for handoff while the Work is active.

They are:

- project-owned;
- AI-facing;
- Git-recorded;
- authoritative for the active Work's intent/context;
- not canonical accepted Project knowledge.

They are not disposable scratch merely because their lifecycle is temporary.

### Git ownership

The Project Repository tracks:

```text
.worktrees/<work-type>/<work-name>/documents/**
```

Repository worktree directories beneath the same Work Root are separate Git checkouts and are not tracked as ordinary Project Repository content.

This allows active Work Documents to remain visible from the Project Repository baseline while repository worktrees remain independent.

## 8. Project Documents vs Work Documents

```yaml
project_documents:
  location: "documents/"
  meaning: "accepted/current project knowledge"

work_documents:
  location: ".worktrees/<work-type>/<work-name>/documents/"
  meaning: "active Work knowledge not yet reconciled into accepted/current project knowledge"
```

At Work completion, review active knowledge:

```text
Work Documents
  ↓ reconciliation
  ├─ durable accepted knowledge → Project Documents
  └─ transient/history-only material → remove from active state
```

Do not blindly copy every Work Document into canonical Project Documents.

Git history preserves removed Work Documents; do not create a second archive solely for history.

## 9. Resource Scope

Classify mutable state by lifecycle.

```yaml
project_scoped:
  meaning: "safe to share across Works; lifecycle exceeds one Work"
  examples:
    - "shared images"
    - "immutable dependency/tool caches"
    - "safely reusable read-only state"

work_scoped:
  meaning: "owned by one Work Identity"
  examples:
    - "Work branch"
    - "optional worktree"
    - "isolated mutable runtime"
    - "test database/state"
    - "logs"
    - "Work Documents"
    - "generated Work outputs"

run_scoped:
  meaning: "owned by one execution inside a Work"
  examples:
    - "one test process"
    - "temporary files"
    - "single command output"
```

Run-scoped state remains subordinate to the Work Identity. An execution counter does not create another Work.

## 10. Isolation and Reuse

Do not equate Work identity with resource duplication.

Create separate mutable resources only when required by:

- concurrent execution;
- mutable-state isolation;
- differing configuration;
- independent disposal;
- explicit project policy.

Reuse project-scoped images and safe caches when correct.

When isolated surfaces are created, they must remain traceable to the same Work Identity.

One writable checkout should have one writing agent/owner at a time.

## 11. Worktree Public Semantics

A project exposing Work Root worktrees should provide semantic operations equivalent to:

```text
worktree-create
worktree-status
worktree-remove
```

Exact command syntax is project-owned.

Routine identity input should be stable across single- and multi-repository projects:

```text
WORK=<work-type>/<work-name>
REPO=<repository-selector>
```

For missing branch creation, an explicit or documented base may be required.

### Create

Create must:

- validate Work and repository resolution;
- resolve branch/path deterministically;
- reuse the exact valid existing worktree idempotently;
- refuse unrelated target-path content;
- refuse incompatible branch ownership;
- choose the correct materialization mode;
- verify postconditions;
- roll back only state created by the failed invocation when safe.

Create is not a force-repair operation.

### Status

Status is non-mutating and should make visible:

- Work Identity;
- repository selector/root;
- branch and worktree path;
- registration/ownership;
- clean/dirty state;
- applicable materialization state;
- Work Documents visibility when relevant.

Use Git/filesystem as the live source of truth rather than a duplicate worktree registry.

### Remove

Routine remove:

- resolves target from Work + repository selector;
- refuses dirty worktrees;
- uses non-force removal;
- does not delete the Work branch;
- does not delete Work Documents;
- does not remove the whole Work Root;
- does not remove sibling repository worktrees.

Worktree removal is not Work completion.

## 12. Project Root Resolution

Project-level lifecycle tooling must resolve the Project Root from a stable anchor.

Do not accidentally treat a linked worktree as a new Project Root merely because a command is invoked there.

A project may:

- restrict project-level Work management commands to the Primary Checkout; or
- support linked-worktree invocation through another explicit, validated Project Root resolution mechanism.

Ambiguity should fail closed.

## 13. Worktree Materialization Contract

A special case occurs when a participating repository's branch contains tracked Project-level `.worktrees/**` coordination state, notably when the Project Repository itself participates as a linked worktree.

The nested repository worktree must not recursively materialize the Project-level `.worktrees/` tree inside itself.

Desired semantics:

```text
ordinary tracked repository content → materialize
Project-level .worktrees/           → remain represented in Git state as applicable, but absent from nested filesystem
```

Validated Git-native sequence:

```bash
git worktree add --no-checkout <worktree-path> <work-branch>

git -C <worktree-path>   sparse-checkout set --no-cone '/*' '!/.worktrees/'

git -C <worktree-path>   reset --hard HEAD
```

The non-cone pattern means "materialize everything except root `.worktrees/`", including future top-level directories.

This low-level sequence should be encapsulated by project-owned tooling, not manually reproduced by routine callers.

Do not apply this exclusion blindly to an independent Component Repository that does not carry Project-level `.worktrees/**` state.

### Recreation

Worktree-local sparse state is removed with the linked worktree's Git administrative state.

Recreation must reapply the materialization policy.

### Compatibility

Projects relying on this contract must verify it on their supported Git versions. The reusable model does not require one universal Git version.

## 14. Work Lifecycle

### Establish

1. make the goal concrete;
2. establish/confirm Work Identity;
3. identify participating repositories and required knowledge;
4. create the Work Root and initial Work Documents when useful;
5. choose checkout mode for each repository;
6. create only the Work-scoped resources required for safe execution.

### Implement

During work:

- keep material decisions and verification knowledge current in Work Documents;
- use the selected repository/checkouts consistently;
- isolate mutable state where required;
- run the narrowest relevant validation first;
- avoid mutating another Work's writable state.

### Preserve

Before integration, checkout switching, or worktree removal:

- inspect the working tree;
- preserve intended changes according to project policy;
- identify untracked/generated state;
- capture material decisions needed after completion.

### Integrate

Integration belongs to each participating repository's Git history.

One repository merge is only a component completion signal. A multi-repository Work remains active while any participating repository, validation, documentation reconciliation, or Work-scoped resource remains incomplete.

### Complete

Before declaring the Work complete:

1. verify all required repository changes and final validation;
2. reconcile Work Documents into Project Documents;
3. reconcile every Work-scoped resource to either removed or intentionally retained;
4. remove repository worktrees no longer needed;
5. remove the Work Root when it is empty;
6. report intentionally retained external state.

## 15. Cleanup

Every Work-scoped resource must end in one of two states:

```yaml
removed:
  meaning: "no longer needed and safely removed"

intentionally_retained:
  meaning: "kept for a concrete follow-up with owner/reason recorded"
```

Unowned residue is not a valid completion state.

Project-scoped shared resources are not cleanup targets merely because a Work used them.

Run-scoped state should disappear with its execution unless retained for diagnosis.

## 16. Destructive Purge

Destructive purge is separate from routine cleanup.

Do not combine branch deletion, force worktree removal, persistent database deletion, shared-cache deletion, and unrelated cleanup under one vague command.

Each destructive effect must have a narrow target and confirmation semantics.

## 17. Common Misreadings

- Work Identity does not mean "one branch + one worktree + one Docker stack" must always exist.
- Work Root is not merely a Git worktree bucket.
- Work Documents are active authoritative context but not accepted Project knowledge.
- Removing one component worktree is not completing the Work.
- A branch start ref is not automatically its upstream.
- A cross-repository Work still has one base semantic identity.
