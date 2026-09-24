# Source record: 2026-07-18-environment-workflow-origin-commit

```yaml
record_type: "verbatim_external_source_snapshot"
source_kind: "Git commit message + GitHub API patch"
source_repository: "Daiki-Yoshida/development-environment-strategy"
source_commit: "ab217f1f2dae1adad48cedcdaee046384d9de7f3"
source_url: "https://github.com/Daiki-Yoshida/development-environment-strategy/commit/ab217f1f2dae1adad48cedcdaee046384d9de7f3"
source_author_date: "2026-07-18T20:18:05Z"
retrieved_date: "2026-09-24"
source_text_status: "GitHub APIで取得したcommit messageとpatchのsnapshot"
record_body_policy: "commit messageとpatchは無加工。commit stateで導入・変更された内容の証拠であり、元チャットの提案・承認原文とは区別する"
```

## Commit message原文

~~~~text
docs: 開発環境の導入・worktree・復旧フローを追加
~~~~

## GitHub API patch snapshot

### `artifacts/ENVIRONMENT_WORKFLOW.md`

~~~~diff
@@ -0,0 +1,249 @@
+# Environment Workflow
+
+```yaml
+document_type: "environment_workflow"
+target_audience: "ai_agents"
+language: "english"
+strategy_version: "1.0.0"
+scope: "setup, task worktree lifecycle, validation, integration, cleanup, and recovery"
+```
+
+## 1. New Project Setup
+
+### Step 1: Choose Repository Topology
+
+Decide whether the project needs:
+
+```yaml
+single_repository: "product code and environment tooling share one repository"
+workspace_and_components: "a Workspace Repository coordinates one or more independent Component Repositories"
+```
+
+Choose the second form only when separate histories, stable component roots, shared tooling, or parallel-agent coordination justify it.
+
+### Step 2: Define the Host Boundary
+
+- List the host control-plane tools.
+- Place project runtimes, package managers, build tools, test tools, and project-specific CLIs in the container by default.
+- Record any host exception and its version-control strategy.
+- Ensure routine commands do not require elevated privileges.
+
+### Step 3: Create the Public Command Interface
+
+- Add a discoverable command router, normally a Makefile.
+- Add an optional shared wrapper when target/worktree selection or environment setup requires it.
+- Put complex logic in `scripts/` or an equivalent owned location.
+- Define help, status/diagnosis, partial validation, canonical final validation, and scoped cleanup operations.
+- Separate normal and destructive operations.
+
+### Step 4: Define Resource Identity
+
+Define deterministic names for:
+
+- workspace/project;
+- component;
+- task/worktree;
+- resource role.
+
+Ensure parallel tasks receive isolated mutable resources and non-conflicting host ports.
+
+### Step 5: Define Repository and Worktree Paths
+
+- Establish each Component Repository's Primary Checkout.
+- Ignore independent Component Repository paths from the Workspace Repository.
+- Create and ignore `.worktrees/`.
+- Select the task worktree naming rule.
+- Ensure commands can target a worktree without editing command internals.
+
+### Step 6: Verify Bootstrap
+
+From a clean clone or equivalent clean state:
+
+- create the environment;
+- show versions and selected paths;
+- run a minimal check;
+- run the canonical validation;
+- remove only resources created by the verification.
+
+Report any undocumented host prerequisite.
+
+## 2. Brownfield Adoption
+
+Do not turn environment adoption into an unrelated repository or code rewrite.
+
+### Audit
+
+Classify existing behavior:
+
+```yaml
+host_dependencies: "installed runtimes, package managers, SDKs, and CLIs"
+entry_commands: "documented and undocumented build/test/deploy commands"
+container_state: "images, Compose files, names, ports, volumes, permissions"
+git_topology: "repository roots, embedded repositories, branches, and worktrees"
+ci_behavior: "logic duplicated or diverging from local scripts"
+destructive_paths: "cleanup, reset, force removal, and data deletion"
+```
+
+### Migration Order
+
+1. Establish a stable public command interface over current behavior.
+2. Move project-specific execution into controlled containers.
+3. Normalize resource identity and ownership.
+4. Add diagnosis and canonical validation.
+5. Add or normalize worktree support when parallel development requires it.
+6. Align CI with project-owned commands.
+
+Preserve working behavior while changing one environment boundary at a time.
+
+### Brownfield Guard
+
+- Explicit project conventions outrank this generic strategy when they conflict; report the conflict.
+- Do not silently move repositories or delete environment state.
+- Do not introduce separate Workspace and Component repositories unless the task explicitly requires the structural change.
+- Existing violations outside the requested scope are reported, not opportunistically rewritten.
+
+## 3. Task Worktree Lifecycle
+
+### Create
+
+Before creation:
+
+- identify the Component Repository;
+- identify the task and branch;
+- verify the Primary Checkout is the intended repository;
+- verify the branch/path identity does not collide;
+- synchronize refs according to project policy.
+
+Creation must produce a Task Worktree under the declared `.worktrees/` namespace and report its branch, absolute or workspace-relative path, and runtime identity.
+
+### Assign
+
+```yaml
+assignment:
+  worktree: "one writing agent"
+  branch: "the branch checked out by that worktree"
+  mutable_runtime: "isolated by task identity"
+  command_target: "explicitly selected for every operation"
+```
+
+The agent must verify its current repository and worktree before editing.
+
+### Implement and Validate
+
+During implementation:
+
+1. Run the narrowest relevant validation first.
+2. Use project-owned commands, not ad hoc host tool invocations.
+3. Diagnose failures through the selected worktree's logs and status.
+4. Avoid touching the Primary Checkout or another Task Worktree.
+5. Run the canonical final validation on the final HEAD before completion is reported.
+
+### Preserve
+
+Before integration or removal:
+
+- review the working tree;
+- preserve intended changes in commits according to project policy;
+- identify untracked generated files;
+- verify remote or other preservation requirements when applicable.
+
+## 4. Integration
+
+Integration policy is project-specific, but the environment flow must preserve repository boundaries.
+
+- Perform merge/rebase/PR operations in the repository that owns the branch.
+- Do not commit Component Repository changes into the Workspace Repository.
+- Re-run required integration validation after the final integrated HEAD changes.
+- If Workspace tooling changed, verify affected Component Repositories against the intended workspace ref.
+- Keep the Primary Checkout clean after integration.
+
+This strategy does not decide pull-request approval or release policy.
+
+## 5. Cleanup
+
+### Normal Worktree Removal
+
+Normal removal must:
+
+1. resolve the selected worktree deterministically;
+2. verify it belongs to the intended Component Repository;
+3. refuse uncommitted changes;
+4. warn or refuse when commits are not preserved according to project policy;
+5. stop and remove task-scoped runtime resources;
+6. remove the Git worktree without force;
+7. prune stale metadata only when appropriate;
+8. report what remains, including the branch.
+
+### Destructive Purge
+
+A purge may discard work or persistent state. It must be a separate explicit operation and must report its scope before or immediately after execution according to the project's confirmation policy.
+
+Never combine branch deletion, worktree force removal, database deletion, and shared-cache deletion into one vague cleanup operation.
+
+## 6. Diagnosis and Recovery
+
+When an environment operation fails, inspect in this order:
+
+```yaml
+1_selection: "selected workspace, component, branch, and worktree"
+2_host_boundary: "required control-plane tools and permissions"
+3_versions: "container/runtime/tool versions and lock files"
+4_runtime: "containers, networks, ports, mounts, user ownership, volumes"
+5_commands: "public command parameters and exit status"
+6_git_state: "dirty state, branch ownership, worktree metadata, remote refs"
+7_ci_difference: "provider setup or workspace-ref mismatch"
+```
+
+Recovery rules:
+
+- Prefer scoped recreation of task resources over global host cleanup.
+- Preserve source changes before rebuilding or deleting state.
+- Do not use force removal until the ordinary failure is understood.
+- Do not run global Docker prune or broad filesystem deletion as an initial diagnostic step.
+- Report the failing layer and evidence; do not claim the environment is repaired without rerunning the failed operation.
+
+## 7. Environment Confirmation Gate
+
+Classify environment changes before execution.
+
+```yaml
+L0_observational:
+  examples: ["help text", "status", "diagnostics", "non-mutating version checks"]
+  action: "proceed"
+
+L1_local_additive:
+  examples: ["new non-destructive target", "new diagnostic script", "task-scoped container config"]
+  action: "proceed and report"
+
+L2_structural:
+  examples: ["new Workspace/Component split", "moving repository roots", "changing worktree paths", "changing canonical command names", "changing CI workspace ref policy"]
+  action: "proceed only when clearly implied by the task; report explicitly"
+
+L3_destructive_or_host_mutating:
+  examples: ["discarding dirty worktree", "deleting branches or persistent volumes", "database destruction", "global host cleanup", "installing/removing host runtimes", "history rewriting"]
+  action: "must confirm before execution unless the user explicitly requested that exact destructive effect"
+```
+
+A command implementation must not downgrade the effective level by hiding a destructive operation behind a harmless name.
+
+## 8. Re-read Triggers
+
+```yaml
+must_re_read:
+  - "first contact with a project using this strategy"
+  - "creating or changing Workspace/Component repository topology"
+  - "adding or redesigning worktree support"
+  - "changing the host/container boundary"
+  - "adding destructive environment operations"
+
+should_re_read:
+  - "changing Docker resource naming or isolation"
+  - "changing Makefile/public command structure"
+  - "aligning local and CI execution"
+  - "changing workspace-tool version selection"
+
+no_re_read_needed:
+  - "routine use of established commands"
+  - "ordinary task worktree creation under established rules"
+  - "small internal script fix behind an unchanged command contract"
+```
~~~~
