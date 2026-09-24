# Source record: 2026-07-19-optional-worktree-policy-commit

```yaml
record_type: "verbatim_external_source_snapshot"
source_kind: "Git commit message + GitHub API patch"
source_repository: "Daiki-Yoshida/development-environment-strategy"
source_commit: "56ff05569927737b31e68d4e4126ed8caadba0eb"
source_url: "https://github.com/Daiki-Yoshida/development-environment-strategy/commit/56ff05569927737b31e68d4e4126ed8caadba0eb"
source_author_date: "2026-07-19T17:14:39Z"
retrieved_date: "2026-09-24"
source_text_status: "GitHub APIで取得したcommit messageとpatchのsnapshot"
record_body_policy: "commit messageとpatchは無加工。commit stateで導入・変更された内容の証拠であり、元チャットの提案・承認原文とは区別する"
```

## Commit message原文

~~~~text
fix: make worktrees conditional for parallel isolation
~~~~

## GitHub API patch snapshot

### `artifacts/DEVELOPMENT_ENVIRONMENT_PHILOSOPHY.md`

~~~~diff
@@ -4,7 +4,7 @@
 document_type: "development_environment_philosophy"
 target_audience: "ai_agents"
 language: "english"
-strategy_version: "1.0.0"
+strategy_version: "1.1.0"
 ```
 
 ## Development Environment Contract
@@ -58,37 +58,58 @@ This separation reduces host mutation, version conflicts, accidental privilege e
 
 ```yaml
 workspace_repository:
-  meaning: "the repository that owns development tooling, workspace coordination, environment documents, and worktree management"
+  meaning: "the repository that owns development tooling, workspace coordination, environment documents, and optional worktree management"
 component_repository:
   meaning: "an independent repository that owns product code and its product history"
 primary_checkout:
-  meaning: "the stable checkout of a component repository used for synchronization, worktree creation, integration, and final inspection"
+  meaning: "the stable default checkout of a component repository; it may be used for one active writing task when project policy permits"
 task_worktree:
-  meaning: "a temporary checkout assigned to one task, one branch, and one writing agent"
+  meaning: "an additional temporary checkout created only when parallel writing or explicit isolation is needed"
 ```
 
 A Workspace Repository and Component Repository may have completely separate Git histories. This is a workspace relationship, not necessarily a Git submodule relationship.
 
 A single-repository project may use the same principles without creating a separate Workspace Repository. Do not add repository layers without a real coordination or isolation need.
 
+## Checkout Selection Rule
+
+Worktree support is a capability, not a mandatory step for every task.
+
+```yaml
+default:
+  checkout: "use the currently assigned checkout on an appropriate task branch"
+  condition: "one writing task is active and no separate checkout or runtime isolation is needed"
+create_task_worktree_when:
+  - "two or more writing tasks or agents must operate on the same Component Repository concurrently"
+  - "another branch must remain checked out at a stable path"
+  - "the user or project workflow explicitly requests a worktree"
+  - "the task needs an independently disposable checkout and mutable runtime state"
+do_not_create_task_worktree_when:
+  - "only one writing task is active"
+  - "the current checkout can safely switch to or already uses the task branch"
+  - "the only reason is that .worktrees/ exists or worktree commands are available"
+```
+
+Agents must choose the least complex checkout mode that satisfies safety and isolation requirements. Creating unnecessary worktrees adds state, cleanup cost, and opportunities for selecting the wrong checkout.
+
 ## Parallel-Agent Isolation
 
-Parallel development requires more than separate branches.
+When parallel writing or explicit task isolation is active, separate branches alone are insufficient.
 
 ```yaml
-isolate_per_task:
+isolate_per_parallel_task:
   - "branch"
   - "working directory"
   - "container namespace"
   - "network and host-port allocation"
   - "mutable volumes when state must not be shared"
   - "logs and generated outputs"
-rule: "one task worktree is owned by one writing agent at a time"
+rule: "one writable checkout is owned by one writing agent at a time"
 ```
 
 Shared read-only caches may be reused when safe. Mutable project state must not be shared merely for convenience.
 
-Task, branch, worktree, container namespace, and logs should be traceable through a common stable identity.
+When a Task Worktree is used, task, branch, worktree, container namespace, and logs should be traceable through a common stable identity.
 
 ## Explicit Operations
 
@@ -140,7 +161,7 @@ Do not solve safety by forcing repeated manual steps that agents will bypass. En
 governs:
   - "host and container responsibility"
   - "development tool execution"
-  - "repository and worktree topology"
+  - "repository and optional worktree topology"
   - "top-level environment directories"
   - "command interfaces and environment scripts"
   - "local/CI execution paths"
@@ -161,9 +182,10 @@ Code quality inside scripts is evaluated by `design-principles`. Placement and i
 misreadings:
   - "Docker-first != every operation must run in Docker; host control-plane operations may stay on the host"
   - "minimal host != a universal fixed allowlist; classify tools by responsibility"
-  - "one task worktree != one process; several read-only processes may inspect it, but only one agent owns writes"
+  - "worktree support != create a worktree for every task; use it only for parallelism or explicit isolation"
+  - "one writable checkout per agent != every agent needs a separate checkout when only one writing task exists"
   - "Workspace Repository != Git parent repository or mandatory submodule"
-  - "Primary Checkout != ordinary feature workspace; keep it stable for integration and management"
+  - "Primary Checkout != default branch only; it may host ordinary single-agent task-branch work when project policy permits"
   - "resource isolation != duplicate every cache; immutable or safely shareable caches may be shared"
   - "explicit names != mechanically prefix every command; add scope when meaning or side effects would otherwise be unclear"
   - "reproducibility != never update; updates must be intentional and reviewable"
~~~~

### `artifacts/ENVIRONMENT_STANDARDS.md`

~~~~diff
@@ -4,7 +4,7 @@
 document_type: "environment_standards"
 target_audience: "ai_agents"
 language: "english"
-strategy_version: "1.0.0"
+strategy_version: "1.1.0"
 scope: "host boundary, Docker, command interface, Git safety, validation, and CI parity"
 ```
 
@@ -50,7 +50,7 @@ Rules:
 
 ### Resource Identity
 
-Every resource must be attributable to a project and, when relevant, a task/worktree.
+Every resource must be attributable to a project and, when relevant, a task or worktree.
 
 ```yaml
 identity_components:
@@ -65,7 +65,7 @@ properties:
 
 - Avoid generic names that reveal only a role, such as an unscoped `web`, `api`, or `database`.
 - Avoid random names when a stable project/task identity is available.
-- Use a task-specific Compose project name when parallel worktrees may run simultaneously.
+- Use a task-specific Compose project name only when parallel or explicitly isolated checkouts may run simultaneously.
 - Apply the same identity to containers, networks, mutable volumes, logs, and temporary output locations where practical.
 
 ### Files, Ownership, and Mounts
@@ -79,15 +79,15 @@ properties:
 ### Caches and Volumes
 
 - Share immutable or safely reusable dependency caches when this improves speed without cross-task corruption.
-- Isolate mutable state that can alter test or runtime results.
+- Isolate mutable state that can alter test or runtime results when multiple checkouts run concurrently.
 - Name volumes so ownership and deletion scope are clear.
 - Removing a task worktree must not silently remove shared caches used by other tasks.
 
 ### Ports and Networks
 
-- Parallel worktrees must not claim the same fixed host ports without an allocation rule.
+- Parallel checkouts must not claim the same fixed host ports without an allocation rule.
 - Prefer internal container networking when host exposure is unnecessary.
-- When host ports are required, derive or configure them explicitly per task.
+- When host ports are required, derive or configure them explicitly per isolated task.
 - A cleanup command must affect only the selected project's or task's network resources.
 
 ### Secrets
@@ -143,9 +143,12 @@ prohibited_pattern: "an ambiguous short name whose target or destructive effect
 
 ## 4. Git Operation Safety
 
-- Keep the default branch or primary checkout stable; ordinary feature implementation should occur on task branches/worktrees.
-- One task worktree maps to one branch and one writing agent.
-- Verify the selected repository and worktree before mutation.
+- Keep the default branch stable. Ordinary feature implementation should occur on a task branch.
+- A task branch does not require a Task Worktree. Use the currently assigned checkout when only one writing task is active and no separate isolation is needed.
+- Create a Task Worktree only for concurrent writing, an explicitly requested stable secondary checkout, or another documented isolation need.
+- Do not create a worktree merely because `.worktrees/` exists or worktree commands are available.
+- One writable checkout maps to one writing agent at a time.
+- Verify the selected repository and checkout before mutation; verify the worktree as well when one is used.
 - Do not operate on repositories outside the declared workspace scope.
 - Normal worktree removal must refuse dirty worktrees.
 - Check for unpushed or otherwise unpreserved commits before removal when the workflow can determine this reliably.
@@ -179,13 +182,13 @@ A project environment should expose operations equivalent to:
 
 ```yaml
 discovery: "list available operations and required parameters"
-diagnosis: "report tool versions, selected repository/worktree, containers, ports, mounts, and common configuration failures"
+diagnosis: "report tool versions, selected repository/checkout, containers, ports, mounts, and common configuration failures"
 status: "show current project/task resources without mutation"
 validation: "run the canonical completion gate"
 ```
 
 - Diagnostics must not print secrets.
-- Diagnostic output should identify the selected task/worktree and container namespace.
+- Diagnostic output should identify the selected checkout and, when applicable, the task worktree and container namespace.
 - Validation should start with the narrowest useful checks during implementation and finish with the canonical gate before completion is reported.
 - Do not claim completion when the canonical gate fails or was not runnable; report the limitation and evidence.
 
~~~~

### `artifacts/ENVIRONMENT_WORKFLOW.md`

~~~~diff
@@ -4,8 +4,8 @@
 document_type: "environment_workflow"
 target_audience: "ai_agents"
 language: "english"
-strategy_version: "1.0.0"
-scope: "setup, task worktree lifecycle, validation, integration, cleanup, and recovery"
+strategy_version: "1.1.0"
+scope: "setup, checkout selection, optional task worktrees, validation, integration, cleanup, and recovery"
 ```
 
 ## 1. New Project Setup
@@ -31,7 +31,7 @@ Choose the second form only when separate histories, stable component roots, sha
 ### Step 3: Create the Public Command Interface
 
 - Add a discoverable command router, normally a Makefile.
-- Add an optional shared wrapper when target/worktree selection or environment setup requires it.
+- Add an optional shared wrapper when checkout selection or environment setup requires it.
 - Put complex logic in `scripts/` or an equivalent owned location.
 - Define help, status/diagnosis, partial validation, canonical final validation, and scoped cleanup operations.
 - Separate normal and destructive operations.
@@ -42,18 +42,19 @@ Define deterministic names for:
 
 - workspace/project;
 - component;
-- task/worktree;
-- resource role.
+- resource role;
+- task/worktree only when separate task isolation is used.
 
 Ensure parallel tasks receive isolated mutable resources and non-conflicting host ports.
 
-### Step 5: Define Repository and Worktree Paths
+### Step 5: Define Repository and Optional Worktree Paths
 
 - Establish each Component Repository's Primary Checkout.
 - Ignore independent Component Repository paths from the Workspace Repository.
-- Create and ignore `.worktrees/`.
-- Select the task worktree naming rule.
-- Ensure commands can target a worktree without editing command internals.
+- Define and ignore `.worktrees/` only when worktree support is part of the workspace.
+- Select a worktree naming rule for the cases that require one.
+- Ensure commands can target either the current checkout or an explicitly selected worktree without editing command internals.
+- Do not create a Task Worktree during setup merely to prove that worktree support exists.
 
 ### Step 6: Verify Bootstrap
 
@@ -79,7 +80,7 @@ Classify existing behavior:
 host_dependencies: "installed runtimes, package managers, SDKs, and CLIs"
 entry_commands: "documented and undocumented build/test/deploy commands"
 container_state: "images, Compose files, names, ports, volumes, permissions"
-git_topology: "repository roots, embedded repositories, branches, and worktrees"
+git_topology: "repository roots, embedded repositories, branches, and optional worktrees"
 ci_behavior: "logic duplicated or diverging from local scripts"
 destructive_paths: "cleanup, reset, force removal, and data deletion"
 ```
@@ -90,7 +91,7 @@ destructive_paths: "cleanup, reset, force removal, and data deletion"
 2. Move project-specific execution into controlled containers.
 3. Normalize resource identity and ownership.
 4. Add diagnosis and canonical validation.
-5. Add or normalize worktree support when parallel development requires it.
+5. Add or normalize worktree support only when parallel development or explicit isolation requires it.
 6. Align CI with project-owned commands.
 
 Preserve working behavior while changing one environment boundary at a time.
@@ -100,47 +101,77 @@ Preserve working behavior while changing one environment boundary at a time.
 - Explicit project conventions outrank this generic strategy when they conflict; report the conflict.
 - Do not silently move repositories or delete environment state.
 - Do not introduce separate Workspace and Component repositories unless the task explicitly requires the structural change.
+- Do not introduce Task Worktrees when the current checkout already satisfies a single writing task.
 - Existing violations outside the requested scope are reported, not opportunistically rewritten.
 
-## 3. Task Worktree Lifecycle
+## 3. Checkout Selection and Optional Task Worktree Lifecycle
 
-### Create
+### Select the Checkout Mode
 
-Before creation:
+Before editing, choose the least complex safe mode.
+
+```yaml
+current_or_primary_checkout:
+  use_when:
+    - "only one writing task is active for the Component Repository"
+    - "the checkout can safely use the task branch"
+    - "no stable secondary branch checkout is required"
+    - "separate mutable runtime state is unnecessary"
+  action: "use the assigned checkout; do not create a worktree"
+task_worktree:
+  use_when:
+    - "multiple writing tasks or agents must run concurrently"
+    - "another branch must remain checked out at a stable path"
+    - "the user or project workflow explicitly requests a worktree"
+    - "the task needs an independently disposable checkout and runtime state"
+  action: "create and explicitly select a Task Worktree"
+```
+
+The existence of `.worktrees/`, worktree helper commands, or a TASK_ID is not sufficient reason to create a worktree.
+
+### Prepare the Selected Checkout
+
+For either mode:
 
 - identify the Component Repository;
-- identify the task and branch;
+- identify the task and task branch;
+- verify the selected checkout belongs to the intended repository;
+- synchronize refs according to project policy;
+- ensure only one writing agent owns that writable checkout.
+
+When using the Primary Checkout, switch to or create the task branch according to project policy. Do not implement directly on the protected/default branch.
+
+### Create a Task Worktree When Required
+
+Before creation:
+
+- verify the isolation trigger is actually present;
 - verify the Primary Checkout is the intended repository;
-- verify the branch/path identity does not collide;
-- synchronize refs according to project policy.
+- verify branch/path identity does not collide.
 
 Creation must produce a Task Worktree under the declared `.worktrees/` namespace and report its branch, absolute or workspace-relative path, and runtime identity.
 
-### Assign
-
 ```yaml
-assignment:
+worktree_assignment:
   worktree: "one writing agent"
   branch: "the branch checked out by that worktree"
   mutable_runtime: "isolated by task identity"
   command_target: "explicitly selected for every operation"
 ```
 
-The agent must verify its current repository and worktree before editing.
-
 ### Implement and Validate
 
 During implementation:
 
 1. Run the narrowest relevant validation first.
 2. Use project-owned commands, not ad hoc host tool invocations.
-3. Diagnose failures through the selected worktree's logs and status.
-4. Avoid touching the Primary Checkout or another Task Worktree.
+3. Diagnose failures through the selected checkout's logs and status.
+4. Avoid touching another writable checkout.
 5. Run the canonical final validation on the final HEAD before completion is reported.
 
 ### Preserve
 
-Before integration or removal:
+Before integration, checkout switching, or worktree removal:
 
 - review the working tree;
 - preserve intended changes in commits according to project policy;
@@ -155,15 +186,24 @@ Integration policy is project-specific, but the environment flow must preserve r
 - Do not commit Component Repository changes into the Workspace Repository.
 - Re-run required integration validation after the final integrated HEAD changes.
 - If Workspace tooling changed, verify affected Component Repositories against the intended workspace ref.
-- Keep the Primary Checkout clean after integration.
+- Return the Primary Checkout to the project-defined stable state after integration when required.
 
 This strategy does not decide pull-request approval or release policy.
 
 ## 5. Cleanup
 
+### No Worktree Was Created
+
+When the task used the current or Primary Checkout:
+
+- do not run worktree cleanup;
+- preserve the task branch according to project policy;
+- stop or remove only task-specific runtime resources that were actually created;
+- return the checkout to the expected branch only when the project workflow requires it.
+
 ### Normal Worktree Removal
 
-Normal removal must:
+When a Task Worktree was created, normal removal must:
 
 1. resolve the selected worktree deterministically;
 2. verify it belongs to the intended Component Repository;
@@ -185,12 +225,12 @@ Never combine branch deletion, worktree force removal, database deletion, and sh
 When an environment operation fails, inspect in this order:
 
 ```yaml
-1_selection: "selected workspace, component, branch, and worktree"
+1_selection: "selected workspace, component, branch, checkout, and optional worktree"
 2_host_boundary: "required control-plane tools and permissions"
 3_versions: "container/runtime/tool versions and lock files"
 4_runtime: "containers, networks, ports, mounts, user ownership, volumes"
 5_commands: "public command parameters and exit status"
-6_git_state: "dirty state, branch ownership, worktree metadata, remote refs"
+6_git_state: "dirty state, branch ownership, worktree metadata when applicable, remote refs"
 7_ci_difference: "provider setup or workspace-ref mismatch"
 ```
 
@@ -244,6 +284,7 @@ should_re_read:
 
 no_re_read_needed:
   - "routine use of established commands"
-  - "ordinary task worktree creation under established rules"
+  - "choosing the current checkout for an ordinary single-writer task"
+  - "ordinary Task Worktree creation after an actual isolation trigger is established"
   - "small internal script fix behind an unchanged command contract"
 ```
~~~~

### `artifacts/INDEX.md`

~~~~diff
@@ -6,18 +6,18 @@ target_audience: "ai_agents"
 optimization: "token_efficiency"
 language: "english"
 role: "entry point for the exported development-environment guidance"
-strategy_version: "1.0.0"
+strategy_version: "1.1.0"
 ```
 
 Read this file first. Load only the documents required by the current task.
 
 ## Read Order
 
 ```yaml
-1_philosophy: "DEVELOPMENT_ENVIRONMENT_PHILOSOPHY.md" # WHY: safety, reproducibility, isolation, parallel operation
+1_philosophy: "DEVELOPMENT_ENVIRONMENT_PHILOSOPHY.md" # WHY: safety, reproducibility, isolation, checkout selection
 2_standards:  "ENVIRONMENT_STANDARDS.md"             # HOW: host, Docker, commands, Git safety, CI parity
-3_structure:  "WORKSPACE_STRUCTURE.md"               # WHERE: repositories, checkouts, worktrees, top-level layout
-4_workflow:   "ENVIRONMENT_WORKFLOW.md"               # FLOW: setup, task lifecycle, validation, cleanup, recovery
+3_structure:  "WORKSPACE_STRUCTURE.md"               # WHERE: repositories, checkouts, optional worktrees, layout
+4_workflow:   "ENVIRONMENT_WORKFLOW.md"               # FLOW: setup, checkout choice, validation, cleanup, recovery
 ```
 
 On first contact, read 1 -> 2 -> 3 -> 4. For a focused task, use Quick Task Routing.
@@ -28,9 +28,28 @@ On first contact, read 1 -> 2 -> 3 -> 4. For a focused task, use Quick Task Rout
 core_idea: "A development environment is a contract: topology, toolchain, command interface, state lifecycle, isolation, and safety."
 priority: "host/data safety > reproducibility > isolation > parallel operability > explicit operations > diagnosability > local/CI parity > efficiency"
 primary_pattern: "host as control plane; containers as project execution plane"
+checkout_default: "use the currently assigned checkout for one writing task; create a Task Worktree only for parallelism or explicit isolation"
 scope: "development workspace, repository topology, execution tooling, and environment lifecycle"
 ```
 
+## Absolute Worktree Selection Rule
+
+```yaml
+rule: "Worktree support is optional capability, not a mandatory per-task step."
+default: "one writing task -> current or Primary Checkout on a task branch"
+worktree_triggers:
+  - "concurrent writing tasks or agents on the same Component Repository"
+  - "another branch must remain checked out at a stable path"
+  - "explicit user or project requirement"
+  - "independently disposable checkout and mutable runtime state are required"
+never_sufficient_alone:
+  - ".worktrees/ exists"
+  - "worktree helper commands exist"
+  - "the task has a TASK_ID"
+```
+
+This rule overrides wording that could otherwise be read as requiring a Task Worktree for ordinary single-agent work.
+
 ## Ownership Map
 
 Each concept has one authoritative document. Link instead of duplicating.
@@ -41,7 +60,7 @@ DEVELOPMENT_ENVIRONMENT_PHILOSOPHY.md:
     - "Development Environment Contract"
     - "Priority order"
     - "Host control plane and container execution plane"
-    - "Safety without unnecessary friction"
+    - "Checkout selection rationale"
     - "Workspace Repository, Component Repository, Primary Checkout, and Task Worktree concepts"
     - "Parallel-agent isolation rationale"
     - "Scope boundary and common misreadings"
@@ -60,21 +79,23 @@ ENVIRONMENT_STANDARDS.md:
 WORKSPACE_STRUCTURE.md:
   owns:
     - "Workspace Repository and Component Repository placement"
-    - "Primary Checkout and Task Worktree placement"
+    - "Primary Checkout and optional Task Worktree placement"
+    - "Checkout selection conditions"
     - ".worktrees/ structure and naming"
     - "Top-level development-environment directories"
     - "Git tracking and ignore boundaries"
     - "Multi-component workspaces"
     - "Workspace-to-component tool-version dependency"
-    - "Identity propagation across Git, Docker, logs, and outputs"
+    - "Identity propagation across isolated Git, Docker, logs, and outputs"
 
 ENVIRONMENT_WORKFLOW.md:
   owns:
     - "New-project setup"
     - "Brownfield adoption"
-    - "Task worktree creation and assignment"
+    - "Checkout mode selection"
+    - "Optional Task Worktree creation and assignment"
     - "Implementation-time and final validation flow"
-    - "Integration and cleanup flow"
+    - "Integration and conditional cleanup flow"
     - "Diagnosis and recovery"
     - "Environment Confirmation Gate"
     - "Re-read triggers"
@@ -87,7 +108,8 @@ ENVIRONMENT_WORKFLOW.md:
 "adding Docker or Compose":                      "ENVIRONMENT_STANDARDS.md (Docker Standards)"
 "naming containers, networks, or volumes":       "ENVIRONMENT_STANDARDS.md (Resource Identity)"
 "designing Make targets or scripts":             "ENVIRONMENT_STANDARDS.md (Command Interface)"
-"adding or changing Git worktrees":              "WORKSPACE_STRUCTURE.md (Task Worktrees) + ENVIRONMENT_WORKFLOW.md (Task Lifecycle)"
+"deciding whether to create a worktree":         "DEVELOPMENT_ENVIRONMENT_PHILOSOPHY.md (Checkout Selection Rule) + ENVIRONMENT_WORKFLOW.md"
+"adding or changing Git worktree support":       "WORKSPACE_STRUCTURE.md (Task Worktrees) + ENVIRONMENT_WORKFLOW.md"
 "organizing parent and child repositories":      "WORKSPACE_STRUCTURE.md (Repository Topology)"
 "supporting several component repositories":     "WORKSPACE_STRUCTURE.md (Multi-Component Workspace)"
 "running several AI agents in parallel":         "DEVELOPMENT_ENVIRONMENT_PHILOSOPHY.md (Parallel Isolation) + WORKSPACE_STRUCTURE.md"
@@ -107,7 +129,7 @@ design_principles:
 documentation_strategy:
   owns: "documents/ structure, routing, versioning, and maintenance"
 development_environment_strategy:
-  owns: "workspace topology, development tools, execution paths, Git worktrees, and environment lifecycle"
+  owns: "workspace topology, development tools, execution paths, optional Git worktrees, and environment lifecycle"
 ```
 
 For mixed tasks, apply each artifact set to its own domain. Do not use development-environment rules to redesign application modules, and do not use code-layout rules to decide repository/worktree topology.
~~~~

### `artifacts/WORKSPACE_STRUCTURE.md`

~~~~diff
@@ -4,8 +4,8 @@
 document_type: "workspace_structure"
 target_audience: "ai_agents"
 language: "english"
-strategy_version: "1.0.0"
-scope: "repository topology, primary checkouts, task worktrees, and top-level environment layout"
+strategy_version: "1.1.0"
+scope: "repository topology, checkouts, optional task worktrees, and top-level environment layout"
 ```
 
 ## 1. Repository Topology
@@ -20,7 +20,7 @@ owns:
   - "Makefile and public command wrappers"
   - "environment scripts"
   - "AI-agent environment context"
-  - "worktree creation and cleanup operations"
+  - "optional worktree creation and cleanup operations"
   - "multi-component coordination"
 does_not_own_by_default:
   - "component product history"
@@ -46,36 +46,64 @@ Workspace and Component repositories may be separate Git repositories with separ
 
 A separate Workspace Repository is optional.
 
-Use one repository when environment tooling and product code share one lifecycle and parallel coordination does not justify a second history. Apply the same host, command, and worktree rules at the single repository root.
+Use one repository when environment tooling and product code share one lifecycle and parallel coordination does not justify a second history. Apply the same host, command, branch, and optional worktree rules at the single repository root.
 
 ## 2. Primary Checkout
 
-Each Component Repository has one stable Primary Checkout within the workspace.
+Each Component Repository has one Primary Checkout within the workspace.
 
 ```yaml
 purpose:
+  - "ordinary single-agent work on a task branch when project policy permits"
   - "fetch and synchronization"
-  - "worktree creation"
+  - "optional worktree creation"
   - "integration and final inspection"
   - "stable component path for interactive tools when required"
-ordinary_feature_work: "discouraged; use a Task Worktree"
+default_branch_rule: "keep the default branch stable; switch to a task branch before implementation"
 ```
 
-Keep the Primary Checkout free from unrelated local edits. Its stable path is part of the workspace contract.
+A Primary Checkout does not have to remain permanently on the default branch. It may be the active feature checkout when only one writing task is running and no stable secondary checkout is needed.
 
-## 3. Task Worktrees
+Keep it free from unrelated local edits. Its stable path remains part of the workspace contract.
 
-Task Worktrees live under the Workspace Repository's `.worktrees/` directory.
+## 3. Checkout Selection
+
+Select the simplest checkout mode that satisfies the task.
+
+```yaml
+use_current_or_primary_checkout_when:
+  - "one writing task is active for the Component Repository"
+  - "the checkout can safely use the task branch"
+  - "no other branch must remain available at a stable path"
+  - "separate mutable runtime state is unnecessary"
+create_task_worktree_when:
+  - "multiple writing tasks or agents must run concurrently on the same Component Repository"
+  - "another branch must remain checked out at a stable path"
+  - "the user or project workflow explicitly requires a worktree"
+  - "an independently disposable checkout and runtime state are needed"
+prohibited_reason:
+  - "the .worktrees/ directory exists"
+  - "worktree commands are available"
+  - "the task has an identifier"
+```
+
+Creating a Task Worktree is an isolation decision, not a routine ceremony. A task branch alone is sufficient when there is only one active writer and no additional isolation requirement.
+
+## 4. Task Worktrees
+
+When selected by the Checkout Selection rule, Task Worktrees live under the Workspace Repository's `.worktrees/` directory.
 
 ```yaml
 canonical_shape: ".worktrees/<component>/<task-identity>/"
 ownership: "one task, one branch, one writing agent"
-lifecycle: "temporary; create for work, remove after integration or abandonment"
+lifecycle: "temporary; create for isolated work, remove after integration or abandonment"
 git_tracking: "ignored by the Workspace Repository"
 ```
 
 A flat `.worktrees/<component>-<task>/` layout is acceptable for a workspace with exactly one component, but the nested form is preferred when multiple components exist or are expected.
 
+The `.worktrees/` directory may remain empty. Its presence does not require agents to create a worktree.
+
 ### Worktree Identity
 
 A Task Worktree name should identify:
@@ -96,7 +124,7 @@ Names must be filesystem-safe and collision-resistant. Branch-to-path normalizat
 - Parallel worktrees must receive distinct mutable runtime state.
 - Removing a worktree must not delete the branch automatically unless the command explicitly owns that separate action.
 
-## 4. Recommended Top-Level Layout
+## 5. Recommended Top-Level Layout
 
 ```text
 <workspace>/
@@ -108,7 +136,7 @@ Names must be filesystem-safe and collision-resistant. Branch-to-path normalizat
 ├─ documents/
 ├─ <component-a>/
 ├─ <component-b>/
-└─ .worktrees/
+└─ .worktrees/              # optional task checkouts; may be empty
    ├─ <component-a>/
    │  └─ <task-identity>/
    └─ <component-b>/
@@ -125,19 +153,19 @@ docker: "Dockerfiles and container-specific support"
 scripts: "owned implementation of environment operations"
 documents: "AI-facing project documentation; governed by documentation-strategy"
 component_paths: "Primary Checkouts of independent Component Repositories"
-worktrees: "temporary Task Worktrees"
+worktrees: "optional temporary Task Worktrees"
 ```
 
 Do not use this structure to prescribe application-internal modules. Source-code module placement belongs to `design-principles`.
 
-## 5. Git Tracking Boundaries
+## 6. Git Tracking Boundaries
 
 ### Workspace Repository
 
 The Workspace Repository should ignore:
 
 - embedded Component Repository checkouts that have independent Git histories;
-- `.worktrees/`;
+- `.worktrees/` when worktree support is present;
 - environment-local secrets;
 - generated build/export output;
 - runtime caches;
@@ -151,31 +179,31 @@ Each Component Repository owns its own ignore rules for product caches, build ou
 
 The Workspace Repository must not become the accidental owner of files generated inside a Component Repository.
 
-## 6. Multi-Component Workspace
+## 7. Multi-Component Workspace
 
 A Workspace Repository may coordinate multiple Component Repositories.
 
 ```yaml
 requirements:
   - "each component has a stable Primary Checkout path"
   - "commands identify the selected component when the operation is not workspace-wide"
-  - "worktrees are namespaced by component"
+  - "worktrees are namespaced by component when they are used"
   - "resource names include the component when collision is possible"
   - "cross-component validation is a separate explicit operation"
 ```
 
 Do not create a Workspace Repository solely to place unrelated repositories in one folder. The workspace must own real shared tooling, coordination, or environment behavior.
 
-## 7. Resource Identity Propagation
+## 8. Resource Identity Propagation
 
-Use one logical task identity across environment surfaces.
+Use one logical task identity across isolated environment surfaces when a Task Worktree or separate task runtime is used.
 
 ```yaml
-propagate_to:
+propagate_to_when_isolated:
   - "branch or task metadata"
   - "worktree path"
   - "Compose project/container namespace"
-  - "mutable volumes and host ports when isolated"
+  - "mutable volumes and host ports"
   - "logs"
   - "temporary and generated output paths"
 ```
@@ -187,11 +215,13 @@ Resource names should distinguish:
 ```yaml
 workspace: "which development workspace owns the resource"
 component: "which Component Repository it belongs to"
-task: "which worktree or task owns mutable state"
+task: "which isolated task or worktree owns mutable state"
 role: "what the resource does"
 ```
 
-## 8. Workspace-to-Component Tool Dependency
+Do not manufacture task-specific namespaces when a single shared checkout and runtime are intentionally being used.
+
+## 9. Workspace-to-Component Tool Dependency
 
 A Component Repository may rely on tools stored in a separate Workspace Repository.
 
@@ -210,11 +240,11 @@ rule: "CI and release validation must not accidentally consume an unspecified wo
 
 Record the selected mode in project documentation or CI configuration. Local convenience may use the current workspace checkout, while formal validation may require a fixed ref.
 
-## 9. Cross-Artifact Boundaries
+## 10. Cross-Artifact Boundaries
 
 ```yaml
 development_environment_strategy:
-  owns: "repository/worktree placement and environment-facing top-level directories"
+  owns: "repository/checkout/worktree placement and environment-facing top-level directories"
 design_principles:
   owns: "application modules, public code surfaces, dependency direction, and test architecture"
 documentation_strategy:
~~~~
