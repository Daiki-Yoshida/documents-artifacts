# Source record: 2026-07-18-workspace-structure-origin-commit

```yaml
record_type: "verbatim_external_source_snapshot"
source_kind: "Git commit message + GitHub API patch"
source_repository: "Daiki-Yoshida/development-environment-strategy"
source_commit: "5ca1d2211cf5f8a62c16c1327be7cc52523673a3"
source_url: "https://github.com/Daiki-Yoshida/development-environment-strategy/commit/5ca1d2211cf5f8a62c16c1327be7cc52523673a3"
source_author_date: "2026-07-18T20:17:11Z"
retrieved_date: "2026-09-24"
source_text_status: "GitHub APIで取得したcommit messageとpatchのsnapshot"
record_body_policy: "commit messageとpatchは無加工。commit stateで導入・変更された内容の証拠であり、元チャットの提案・承認原文とは区別する"
```

## Commit message原文

~~~~text
docs: Workspace・Component・worktree構造を追加
~~~~

## GitHub API patch snapshot

### `artifacts/WORKSPACE_STRUCTURE.md`

~~~~diff
@@ -0,0 +1,224 @@
+# Workspace Structure
+
+```yaml
+document_type: "workspace_structure"
+target_audience: "ai_agents"
+language: "english"
+strategy_version: "1.0.0"
+scope: "repository topology, primary checkouts, task worktrees, and top-level environment layout"
+```
+
+## 1. Repository Topology
+
+### Workspace Repository
+
+The Workspace Repository owns the development control plane.
+
+```yaml
+owns:
+  - "Docker and Compose definitions"
+  - "Makefile and public command wrappers"
+  - "environment scripts"
+  - "AI-agent environment context"
+  - "worktree creation and cleanup operations"
+  - "multi-component coordination"
+does_not_own_by_default:
+  - "component product history"
+  - "component source code"
+```
+
+### Component Repository
+
+A Component Repository owns a product or independently versioned component.
+
+```yaml
+owns:
+  - "product source code"
+  - "product tests"
+  - "component-specific CI and release files"
+  - "component Git history"
+relationship: "may be placed inside a Workspace Repository without being tracked by it"
+```
+
+Workspace and Component repositories may be separate Git repositories with separate histories. Do not describe this relationship as a Git submodule unless it actually is one.
+
+### Single-Repository Alternative
+
+A separate Workspace Repository is optional.
+
+Use one repository when environment tooling and product code share one lifecycle and parallel coordination does not justify a second history. Apply the same host, command, and worktree rules at the single repository root.
+
+## 2. Primary Checkout
+
+Each Component Repository has one stable Primary Checkout within the workspace.
+
+```yaml
+purpose:
+  - "fetch and synchronization"
+  - "worktree creation"
+  - "integration and final inspection"
+  - "stable component path for interactive tools when required"
+ordinary_feature_work: "discouraged; use a Task Worktree"
+```
+
+Keep the Primary Checkout free from unrelated local edits. Its stable path is part of the workspace contract.
+
+## 3. Task Worktrees
+
+Task Worktrees live under the Workspace Repository's `.worktrees/` directory.
+
+```yaml
+canonical_shape: ".worktrees/<component>/<task-identity>/"
+ownership: "one task, one branch, one writing agent"
+lifecycle: "temporary; create for work, remove after integration or abandonment"
+git_tracking: "ignored by the Workspace Repository"
+```
+
+A flat `.worktrees/<component>-<task>/` layout is acceptable for a workspace with exactly one component, but the nested form is preferred when multiple components exist or are expected.
+
+### Worktree Identity
+
+A Task Worktree name should identify:
+
+- the Component Repository;
+- the task or tracked work item when one exists;
+- optionally a concise branch slug when it adds useful meaning.
+
+Use a stable task identifier in workflows that already have one. Avoid identity based only on random values.
+
+Names must be filesystem-safe and collision-resistant. Branch-to-path normalization must detect collisions rather than silently reusing a directory.
+
+### Worktree Invariants
+
+- The worktree branch belongs to the Component Repository, not the Workspace Repository.
+- A branch must not be assigned to two writable worktrees.
+- The selected worktree path must propagate to build, test, format, logs, and generated-output operations.
+- Parallel worktrees must receive distinct mutable runtime state.
+- Removing a worktree must not delete the branch automatically unless the command explicitly owns that separate action.
+
+## 4. Recommended Top-Level Layout
+
+```text
+<workspace>/
+├─ Makefile
+├─ <public-wrapper>
+├─ compose.yml
+├─ docker/
+├─ scripts/
+├─ documents/
+├─ <component-a>/
+├─ <component-b>/
+└─ .worktrees/
+   ├─ <component-a>/
+   │  └─ <task-identity>/
+   └─ <component-b>/
+      └─ <task-identity>/
+```
+
+The exact filenames are ecosystem-specific. The responsibilities are normative.
+
+```yaml
+Makefile: "discoverable public operation names and delegation"
+public_wrapper: "optional common CLI entry and target selection"
+compose: "container topology and runtime definitions"
+docker: "Dockerfiles and container-specific support"
+scripts: "owned implementation of environment operations"
+documents: "AI-facing project documentation; governed by documentation-strategy"
+component_paths: "Primary Checkouts of independent Component Repositories"
+worktrees: "temporary Task Worktrees"
+```
+
+Do not use this structure to prescribe application-internal modules. Source-code module placement belongs to `design-principles`.
+
+## 5. Git Tracking Boundaries
+
+### Workspace Repository
+
+The Workspace Repository should ignore:
+
+- embedded Component Repository checkouts that have independent Git histories;
+- `.worktrees/`;
+- environment-local secrets;
+- generated build/export output;
+- runtime caches;
+- editor and OS noise unless intentionally shared.
+
+Ignoring an embedded repository is not sufficient documentation by itself. Agent entry files or project documents must state that the path is an independent repository.
+
+### Component Repository
+
+Each Component Repository owns its own ignore rules for product caches, build outputs, generated files, and tool-specific state.
+
+The Workspace Repository must not become the accidental owner of files generated inside a Component Repository.
+
+## 6. Multi-Component Workspace
+
+A Workspace Repository may coordinate multiple Component Repositories.
+
+```yaml
+requirements:
+  - "each component has a stable Primary Checkout path"
+  - "commands identify the selected component when the operation is not workspace-wide"
+  - "worktrees are namespaced by component"
+  - "resource names include the component when collision is possible"
+  - "cross-component validation is a separate explicit operation"
+```
+
+Do not create a Workspace Repository solely to place unrelated repositories in one folder. The workspace must own real shared tooling, coordination, or environment behavior.
+
+## 7. Resource Identity Propagation
+
+Use one logical task identity across environment surfaces.
+
+```yaml
+propagate_to:
+  - "branch or task metadata"
+  - "worktree path"
+  - "Compose project/container namespace"
+  - "mutable volumes and host ports when isolated"
+  - "logs"
+  - "temporary and generated output paths"
+```
+
+The exact formatted string may differ by subsystem, but the mapping must be deterministic and diagnosable.
+
+Resource names should distinguish:
+
+```yaml
+workspace: "which development workspace owns the resource"
+component: "which Component Repository it belongs to"
+task: "which worktree or task owns mutable state"
+role: "what the resource does"
+```
+
+## 8. Workspace-to-Component Tool Dependency
+
+A Component Repository may rely on tools stored in a separate Workspace Repository.
+
+The dependency selection must be explicit.
+
+```yaml
+selection_modes:
+  moving_ref:
+    meaning: "use a documented branch or current workspace checkout"
+    tradeoff: "easy updates, weaker historical reproducibility"
+  fixed_ref:
+    meaning: "use a tag or commit"
+    tradeoff: "strong reproducibility, requires deliberate updates"
+rule: "CI and release validation must not accidentally consume an unspecified workspace version"
+```
+
+Record the selected mode in project documentation or CI configuration. Local convenience may use the current workspace checkout, while formal validation may require a fixed ref.
+
+## 9. Cross-Artifact Boundaries
+
+```yaml
+development_environment_strategy:
+  owns: "repository/worktree placement and environment-facing top-level directories"
+design_principles:
+  owns: "application modules, public code surfaces, dependency direction, and test architecture"
+documentation_strategy:
+  owns: "documents/ internal layout, routing, and maintenance"
+```
+
+When a folder has mixed significance, apply each strategy only to the concern it owns.
~~~~
