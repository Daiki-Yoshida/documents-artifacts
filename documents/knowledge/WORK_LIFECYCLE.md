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

An agent may propose the name, but the **user explicitly confirms the Work Identity before implementation begins**.

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

Do not introduce a second `.work/<identity>/` hierarchy for the same lifecycle.

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
  normally_owns: ["Docker/Compose definitions", "Makefile/public command wrappers", "environment scripts", "AI-agent environment context", "optional worktree lifecycle tooling", "multi-component coordination"]
  does_not_own_by_default: ["component product history", "component source code"]

component_repository:
  meaning: "independent repository owning a product/component history"
  normally_owns: ["product source", "product tests", "component CI/release files", "component Git history"]

primary_checkout:
  meaning: "stable default checkout of a repository; it may host one ordinary Work when isolation is unnecessary"
  purposes: ["ordinary single-writer Work", "fetch/synchronization", "Git worktree creation", "integration/final inspection"]

participating_repository:
  meaning: "a repository contributing to one Work Identity"
```

Workspace and Component repositories may be separate Git repositories with separate histories. Do not call that relationship a Git submodule unless it actually is one.

A project may have only one repository. A separate Workspace Repository is optional; use one repository when environment tooling and product code share one lifecycle and separate history/coordination is not justified.

When Git is available, implementation normally occurs on a branch representing the confirmed Work Identity rather than directly on a protected/default branch.

Do not create repository types that the project does not need.

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

Maintain Work Documents when active-work knowledge materially changes, especially when:

- a design decision changes;
- an investigation resolves uncertainty that affects implementation;
- cross-repository coordination changes;
- verification evidence changes the completion judgment;
- a rejected alternative must be remembered to avoid repeating the same analysis.

Do not turn every command result into a document. Prefer curated context that prevents information loss or repeated reasoning.

### Git ownership

The Project Repository tracks:

```text
.worktrees/<work-type>/<work-name>/documents/**
```

Do not create a dedicated Git repository solely for Work Documents; they belong to the Project Repository's Work lifecycle and history.

Repository worktree directories beneath the same Work Root are separate Git checkouts and are not tracked as ordinary Project Repository content.

A compatible Project Repository ignore boundary is:

```gitignore
.worktrees/*/*/*
!.worktrees/*/*/documents/
!.worktrees/*/*/documents/**
```

This ignore boundary controls **tracking ownership**. The Project Repository must not ignore the entire `.worktrees/` tree, because Work Documents inside it are intentionally tracked while sibling repository worktrees are not.

It does not prevent Git from materializing already-tracked Project-level Work Documents in another linked worktree; that is a separate materialization concern handled by the Worktree Materialization Contract.

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

The selected repository/worktree path must propagate consistently to build, test, format, logs, and generated-output operations. Parallel Works receive distinct mutable state wherever sharing would alter results. A branch must not be assigned to two writable worktrees. Removing a worktree must not implicitly delete its branch.

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

Before mutation, the project-owned worktree operation must:

1. resolve the Project Root from a stable project-owned anchor; never infer a linked worktree itself as a new Project Root;
2. verify the `REPO` mapping and Work Identity syntax;
3. resolve the repository-specific Work branch deterministically;
4. if the branch does not exist, resolve its start/base from explicit `BASE` or a documented project default — never accidental current HEAD;
5. resolve upstream policy separately from branch start/base;
6. verify the target path is absent or already the exact registered worktree being requested;
7. refuse unrelated filesystem content at the target path;
8. verify the branch is not assigned to another incompatible writable worktree;
9. verify the Project Repository ignore boundary for the sibling worktree path when applicable;
10. verify supported Git/materialization capability when the Worktree Materialization Contract applies.

If the exact requested worktree already exists and satisfies the contract, return success without recreating it.

The create operation then:

- chooses the correct materialization mode;
- verifies postconditions;
- reports repository, branch, path, and relevant Work-scoped runtime identity.

If creation fails after this invocation created a linked worktree but before postconditions pass:

- roll back only worktree state created by this invocation;
- use normal non-force removal only when safe;
- do not delete a pre-existing worktree;
- do not delete the Work branch as part of rollback;
- if safe rollback cannot complete, stop and report the exact residual filesystem/Git administrative state.

Create is not a force-repair operation and must not silently escalate into destructive repair.

### Create postconditions

Before reporting success, verify:

```yaml
common:
  - "registered worktree path equals the resolved path"
  - "selected branch equals the resolved Work branch"
  - "branch start/base and upstream tracking semantics match project policy"
  - "one writable checkout ownership invariant holds"

project_checkout:
  - "Work Documents remain materialized and tracked by the Project Repository"
  - "the sibling repository worktree path is not ordinary untracked Project Repository content"

materialization_contract_case:
  - "ordinary repository content is materialized"
  - "nested Project-level .worktrees/ is absent"
  - "worktree-local sparse configuration is active"
```

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

Routine removal is addressed by Work Identity + repository selector, not an arbitrary path.

For the selected repository worktree:

1. resolve `WORK + REPO` to the expected repository, branch, and path;
2. verify that path is a registered worktree of the expected repository;
3. verify Work/branch ownership;
4. refuse uncommitted changes;
5. warn/refuse when commits are not preserved according to project policy;
6. stop/remove Work-scoped runtime resources owned by that repository surface when the public operation owns them;
7. remove the worktree without force;
8. prune stale metadata only when appropriate; pruning stale Git metadata is not permission to delete live directories;
9. keep branch deletion as a separate decision.

Force removal belongs only to an explicitly destructive path after the ordinary failure is understood; never hide `--force` behind routine remove.

Routine remove does not delete the Work branch, Work Documents, whole Work Root, or sibling repository worktrees.

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

Do not use plain `git worktree add` for this case: when tracked Project-level `.worktrees/**` content exists, it can transiently materialize the forbidden recursive tree before sparse exclusion is applied.

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

- review the working tree;
- preserve intended changes in commits according to project policy;
- identify untracked/generated files;
- verify remote or other preservation requirements when applicable;
- ensure material decisions needed after completion are captured in Work Documents or canonical Project Documents.

### Integrate

Integration belongs to each participating repository's Git history.

Rules:

- perform merge/rebase/PR operations in the repository that owns the branch;
- do not commit Component Repository changes into the Workspace/Project Repository by accident;
- rerun required integration validation after the final integrated HEAD changes;
- when Workspace tooling changes, verify affected Component Repositories against the intended Workspace ref;
- return the Primary Checkout to the project-defined stable state after integration when project policy requires it;
- cross-repository validation must be an explicit operation when several repositories jointly satisfy one Work outcome.

One repository merge is only a component completion signal. A multi-repository Work remains active while any participating repository, cross-repository validation, documentation reconciliation, or Work-scoped resource remains incomplete.

Pull-request approval and release governance remain project-specific.

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
