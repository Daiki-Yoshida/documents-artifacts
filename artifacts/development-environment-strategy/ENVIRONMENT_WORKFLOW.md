# Environment Workflow

```yaml
document_type: "environment_workflow"
target_audience: "ai_agents"
language: "english"
strategy_version: "1.3.0"
scope: "setup, Work Identity lifecycle, checkout selection, validation, integration, cleanup, and recovery"
```

## 1. New Project Setup

### Step 1: Choose Repository Topology

Decide whether the project needs:

```yaml
single_repository: "product code and environment tooling share one repository"
workspace_and_components: "a Workspace Repository coordinates one or more independent Component Repositories"
```

Choose the second form only when separate histories, stable component roots, shared tooling, or parallel-agent coordination justify it.

### Step 2: Define the Host Boundary

- List the host control-plane tools.
- Place project runtimes, package managers, build tools, test tools, and project-specific CLIs in the container by default.
- Record any host exception and its version-control strategy.
- Ensure routine commands do not require elevated privileges.

### Step 3: Create the Public Command Interface

- Add a discoverable command router, normally a Makefile.
- Add an optional shared wrapper when checkout selection or environment setup requires it.
- Put complex logic in `scripts/` or an equivalent owned location.
- Define help, status/diagnosis, partial validation, canonical final validation, and scoped cleanup operations.
- Separate normal and destructive operations.

### Step 4: Define Work Identity and Resource Identity

Define how the project names and confirms Work Identities before implementation.

- Semantic form should normally follow `<work-type>/<work-name>`.
- The user explicitly confirms the Work Identity once the development goal is concrete enough to implement.
- If Git is available, define how work branches map deterministically to the Work Identity.
- Define project-, Work-, and run-scoped resource naming.
- Do not create isolated resources merely because a Work Identity exists.

### Step 5: Define Work Root and Repository Paths

- Establish the Project Root and owning Project Repository.
- Reserve `.worktrees/<work-type>/<work-name>/` as the Work Root shape.
- Reserve `<Work Root>/documents/` for Project-Repository-tracked Work Documents.
- Place participating Git worktrees at `<Work Root>/<repository>/` only when a separate checkout is actually required.
- Use the same Work Root shape for single- and multi-repository projects.
- Ensure the Project Repository tracks Work Documents without tracking sibling repository worktrees.
- If the Project Repository itself participates through a nested worktree, verify that Project-level `.worktrees/` is not recursively materialized inside it.
- Ensure commands can target the current/Primary Checkout or an explicit repository worktree without editing command internals.

### Step 6: Verify Bootstrap

From a clean clone or equivalent clean state:

- create the environment;
- show versions and selected paths;
- run a minimal check;
- run the canonical validation;
- remove only resources created by the verification.

Report any undocumented host prerequisite.

## 2. Brownfield Adoption

Do not turn environment adoption into an unrelated repository or code rewrite.

### Audit

Classify existing behavior:

```yaml
host_dependencies: "installed runtimes, package managers, SDKs, and CLIs"
entry_commands: "documented and undocumented build/test/deploy commands"
container_state: "images, Compose files, names, ports, volumes, permissions"
git_topology: "repository roots, embedded repositories, branches, and optional worktrees"
ci_behavior: "logic duplicated or diverging from local scripts"
destructive_paths: "cleanup, reset, force removal, and data deletion"
```

### Migration Order

1. Establish a stable public command interface over current behavior.
2. Move project-specific execution into controlled containers.
3. Introduce Work Identity and normalize resource ownership around it.
4. Establish the uniform Work Root and Work Documents ownership boundary.
5. Add diagnosis and canonical validation.
6. Add/normalize Git worktree support only when parallel development or explicit isolation requires it.
7. Align CI with project-owned commands.

Preserve working behavior while changing one environment boundary at a time.

### Brownfield Guard

- Explicit project conventions outrank this generic strategy when they conflict; report the conflict.
- Do not silently move repositories or delete environment state.
- Do not introduce separate Workspace and Component repositories unless the requested project change actually requires that topology.
- Do not introduce Git worktrees when the current checkout already satisfies a single active Work.
- Existing violations outside the requested scope are reported, not opportunistically rewritten.

## 3. Work Identity Lifecycle

### Establish the Work

Before implementation begins:

1. Confirm that the user's development goal is concrete enough to implement.
2. Propose a meaningful Work Identity when one is not already specified.
3. Obtain explicit user confirmation of that Work Identity.
4. Establish the Work Root at `.worktrees/<work-type>/<work-name>/`.
5. Create/update Work Documents under `<Work Root>/documents/` when the Work needs durable active-work context.
6. When Git is available, create or select branch identities that map deterministically to the Work Identity.

Do not manufacture a Work Identity for every investigation command, test run, or conversational iteration.

### Select the Checkout Mode

Choose the least complex safe mode per participating repository.

```yaml
current_or_primary_checkout:
  use_when:
    - "one writing Work is active for the repository"
    - "the checkout can safely use the Work branch"
    - "no stable secondary branch checkout is required"
    - "separate mutable runtime state is unnecessary"
  action: "use the assigned checkout; do not create a Git worktree"
git_worktree:
  use_when:
    - "multiple writing Works or agents need concurrent writable checkouts"
    - "another branch must remain checked out at a stable path"
    - "the user/project explicitly requests a worktree"
    - "the Work needs an independently disposable checkout and runtime state"
  action: "create the repository worktree under the Work Root"
```

The existence of `.worktrees/`, helper commands, or the Work Identity itself is not sufficient reason to create a Git worktree.

### Prepare the Selected Repository

For each participating repository:

- verify it belongs to the intended project;
- verify its repository-specific identity maps to the confirmed base Work Identity;
- verify the selected checkout/branch;
- synchronize refs according to project policy;
- ensure only one writing agent owns each writable checkout.

When a Git worktree is required, its path is:

```text
.worktrees/<work-type>/<work-name>/<repository>/
```

Create it through one project-owned **Work Identity Git worktree creation operation**. That operation must preserve the Worktree Materialization Contract from `WORKSPACE_STRUCTURE.md`.

The normative low-level sequence is:

```bash
git worktree add --no-checkout <worktree-path> <work-branch>

git -C <worktree-path> \
  sparse-checkout set --no-cone '/*' '!/.worktrees/'

git -C <worktree-path> \
  reset --hard HEAD
```

Do not make humans or agents manually reproduce these steps during routine work. Encode them in a project-owned wrapper/script or equivalent stable command.

Do not use raw `git worktree add` as the normal Work Root creation path when tracked Project-level `.worktrees/` content exists; it can recursively materialize that tree before exclusion is applied.

After creation, verify:

```yaml
primary_checkout:
  - "Work Documents remain materialized and tracked by the Project Repository"
  - "the sibling repository worktree path is ignored as ordinary Project Repository content"
nested_worktree:
  - "the intended Work branch is selected"
  - "ordinary repository content is materialized"
  - "Project-level .worktrees/ is absent from the filesystem"
  - "worktree-local sparse configuration is active"
```

Report the repository, branch, path, and any Work-scoped runtime identity.

### Implement and Validate

During implementation:

1. Keep Work Documents current when design/verification knowledge materially changes.
2. Run the narrowest relevant validation first.
3. Use project-owned commands, not ad hoc host tool invocations.
4. Diagnose failures through the selected Work Identity, repository checkout, logs, and runtime state.
5. Avoid mutating another Work's writable checkout or mutable state.
6. Run the canonical final validation on the final implementation state before reporting completion.

### Preserve

Before integration, checkout switching, or worktree removal:

- review the working tree;
- preserve intended changes in commits according to project policy;
- identify untracked/generated files;
- verify remote or other preservation requirements when applicable;
- ensure material decisions needed after completion have been captured in Work Documents or canonical Project Documents.

## 4. Integration

Integration policy is project-specific, but the environment flow must preserve repository boundaries.

- Perform merge/rebase/PR operations in the repository that owns the branch.
- Do not commit Component Repository changes into the Workspace Repository.
- Re-run required integration validation after the final integrated HEAD changes.
- If Workspace tooling changed, verify affected Component Repositories against the intended workspace ref.
- Return the Primary Checkout to the project-defined stable state after integration when required.

This strategy does not decide pull-request approval or release policy.

## 5. Work Completion and Cleanup

A repository branch merge is a **component completion signal**, not necessarily completion of the whole Work.

For multi-repository Work, the base Work Identity remains active while any participating repository, required validation, or Work Document reconciliation remains incomplete.

### Reconcile Work Documents

Before declaring the Work complete:

1. Review `<Work Root>/documents/`.
2. Promote durable project knowledge into canonical Project Documents under `documents/`.
3. Do not blindly copy transient notes, rejected hypotheses, raw logs, or one-off benchmark output.
4. Apply canonical Project Document versioning/routing rules to promoted knowledge.
5. Remove Work Documents that no longer need to remain active after reconciliation.

Git history is the historical record; do not create a parallel archive merely to preserve deleted Work Documents.

### Reconcile Work-Scoped Resources

Creating Work-scoped resources creates an obligation to reconcile them when the Work ends.

```yaml
completion_state:
  removed: "resource is no longer needed and was removed through normal scoped cleanup"
  intentionally_retained: "resource remains for a concrete follow-up and its owner/reason is reported"
rule: "unowned or unexplained residual Work-scoped resources are not an acceptable completion state"
```

Project-scoped shared resources are not cleanup targets merely because a Work used them. Run-scoped state should disappear with its execution unless retained for diagnosis.

### Git Worktree Removal

For each Git worktree being removed:

1. resolve it from the Work Identity and repository deterministically;
2. verify it belongs to the intended repository;
3. refuse uncommitted changes;
4. warn/refuse when commits are not preserved according to project policy;
5. stop/remove Work-scoped runtime resources owned by that repository surface;
6. remove the Git worktree without force;
7. prune stale metadata only when appropriate;
8. keep branch deletion as a separate decision.

Worktree-local sparse configuration is removed with the linked worktree's Git administrative state. If the worktree is later recreated, run the full Work Identity Git worktree creation operation again; do not assume prior sparse configuration survives.

### Work Root Completion

After all participating repository work, validation, Work Document reconciliation, and Work-scoped cleanup are complete:

- remove the now-empty Work Root;
- keep canonical promoted knowledge in `documents/`;
- rely on Git history for the former Work Documents;
- report any intentionally retained external Work-scoped resources.

### Destructive Purge

A purge may discard work or persistent state. It must be a separate explicit operation with a narrow declared scope.

Never combine branch deletion, worktree force removal, database deletion, and shared-cache deletion into one vague cleanup operation.

## 6. Diagnosis and Recovery

When an environment operation fails, inspect in this order:

```yaml
1_selection: "selected workspace, component, branch, checkout, and optional worktree"
2_host_boundary: "required control-plane tools and permissions"
3_versions: "container/runtime/tool versions and lock files"
4_runtime: "containers, networks, ports, mounts, user ownership, volumes"
5_commands: "public command parameters and exit status"
6_git_state: "dirty state, branch ownership, worktree metadata when applicable, remote refs"
7_ci_difference: "provider setup or workspace-ref mismatch"
```

Recovery rules:

- Prefer scoped recreation of Work resources over global host cleanup.
- Preserve source changes before rebuilding or deleting state.
- Do not use force removal until the ordinary failure is understood.
- Do not run global Docker prune or broad filesystem deletion as an initial diagnostic step.
- Report the failing layer and evidence; do not claim the environment is repaired without rerunning the failed operation.

## 7. Environment Confirmation Gate

Classify environment changes before execution.

```yaml
L0_observational:
  examples: ["help text", "status", "diagnostics", "non-mutating version checks"]
  action: "proceed"

L1_local_additive:
  examples: ["new non-destructive target", "new diagnostic script", "Work-scoped container config"]
  action: "proceed and report"

L2_structural:
  examples: ["new Workspace/Component split", "moving repository roots", "changing worktree paths", "changing canonical command names", "changing CI workspace ref policy"]
  action: "proceed only when clearly implied by the requested work; report explicitly"

L3_destructive_or_host_mutating:
  examples: ["discarding dirty worktree", "deleting branches or persistent volumes", "database destruction", "global host cleanup", "installing/removing host runtimes", "history rewriting"]
  action: "must confirm before execution unless the user explicitly requested that exact destructive effect"
```

A command implementation must not downgrade the effective level by hiding a destructive operation behind a harmless name.

## 8. Re-read Triggers

```yaml
must_re_read:
  - "first contact with a project using this strategy"
  - "creating or changing Workspace/Component repository topology"
  - "adding or redesigning worktree support"
  - "changing the host/container boundary"
  - "adding destructive environment operations"

should_re_read:
  - "changing Docker resource naming or isolation"
  - "changing Makefile/public command structure"
  - "aligning local and CI execution"
  - "changing workspace-tool version selection"

no_re_read_needed:
  - "routine use of established commands"
  - "choosing the current checkout for an ordinary single-writer Work"
  - "ordinary Git worktree creation after an actual isolation trigger is established"
  - "small internal script fix behind an unchanged command contract"
```
