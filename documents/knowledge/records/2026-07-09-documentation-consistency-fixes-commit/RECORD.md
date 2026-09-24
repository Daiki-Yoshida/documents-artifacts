# Source record: 2026-07-09-documentation-consistency-fixes-commit

```yaml
record_type: "verbatim_external_source_snapshot"
source_kind: "Git commit message + GitHub API patch"
source_repository: "Daiki-Yoshida/documentation-strategy"
source_commit: "f34db94ad05e6a32733e540ae0f2d7e309594425"
source_url: "https://github.com/Daiki-Yoshida/documentation-strategy/commit/f34db94ad05e6a32733e540ae0f2d7e309594425"
source_author_date: "2026-07-09T14:20:42Z"
retrieved_date: "2026-09-24"
source_text_status: "GitHub APIで取得したcommit messageとpatchのsnapshot"
record_body_policy: "commit messageとpatchは無加工。commit stateで導入・変更された内容の証拠であり、元チャットの提案・承認原文とは区別する"
```

## Commit message原文

~~~~text
fix: artifacts/の矛盾・欠落・改善点を15項目まとめて修正

矛盾・バグ修正:
- バージョンヘッダーフォーマットの矛盾を解消（YAML front matterではなく既存コードブロック使用を明記）
- クロス参照パスの誤りを修正（相対パス基準を明確化、例を追加）
- バージョンバンプの鶏卵問題を解決（二段階コミットワークフローを導入）
- INDEX.md自体のバージョン管理ルールを定義（index_version）
- タイポ修正（Govers → Governs）

欠落補完:
- design-principlesとの関係セクションを復元（ドメイン境界、使用パターン、同時読みガイダンス）
- 古いドキュメントの発見・更新フローを追加（Use Case 4: Staleness Handling）
- artifacts/自体のバージョン管理としてstrategy_versionを2.1.0に更新
- ディレクトリ分割タイミングガイドを追加（Rule of Three、§7新設）
- デシジョンツリー質問4の矛盾を修正（3+ファイル基準を明記）

改善:
- INDEX.mdにFoundational Lensセクションを追加
- ステイルネス検知の実践ガイドを追加（git logコマンド例）
- Quick Task Routingを16項目に拡充（stale検知、コミットハッシュ記録、ディレクトリ分割、削除等）
- ドキュメント削除時のルールを追加（§9 + Deletion Workflow）
- 複数人でのINDEX.md競合について言及（§10）

Generated with [Devin](https://devin.ai)

Co-Authored-By: Devin <158243242+devin-ai-integration[bot]@users.noreply.github.com>
~~~~

## GitHub API patch snapshot

### `artifacts/DOCUMENTATION_PHILOSOPHY.md`

~~~~diff
@@ -4,7 +4,7 @@
 document_type: "documentation_philosophy"
 target_audience: "ai_agents"
 language: "english"
-strategy_version: "2.0.0"
+strategy_version: "2.1.0"
 ```
 
 ## Core Principle: Information Accuracy First
@@ -30,7 +30,7 @@ right_approach: "Split the document by concern so the agent loads only the relev
 
 ---
 
-## Scope: What This Strategy Govers
+## Scope: What This Strategy Governs
 
 ```yaml
 governs:
@@ -135,6 +135,53 @@ scope:
 
 ---
 
+## Relationship to design-principles
+
+This strategy has a sibling: `design-principles`. They are independent artifact
+sets with different domains, but a target project typically uses both.
+
+### Domain Boundary
+
+```yaml
+this_artifact_set:
+  name: "documentation-strategy"
+  domain: "documents (documents/, docs-jp/, agent entry files)"
+  owns: "HOW to structure, route, version, and maintain documentation for AI agents"
+
+sibling_artifact_set:
+  name: "design-principles"
+  domain: "code (src/, tests/, packages/, etc.)"
+  owns: "HOW to design and write code that AI agents produce"
+```
+
+### Usage Patterns
+
+```yaml
+pattern_1_independent:
+  description: "User references one set for a domain-specific task."
+  examples:
+    - "Fix a code bug → reference design-principles/"
+    - "Update project documents → reference documentation-strategy/"
+
+pattern_2_combined:
+  description: "User references both sets at once for a full-project task."
+  examples:
+    - "'Develop this project following @documents/artifacts/' (both folders)"
+    - "Project AGENTS.md lists both artifact sets as references"
+  implication: "The AI agent holds both contexts simultaneously."
+```
+
+### When Both Are Read Simultaneously
+
+```yaml
+guidance:
+  domain_routing: "If the task touches code (src/, tests/), follow design-principles. If the task touches documents (documents/, README.md), follow documentation-strategy."
+  mixed_tasks: "If a task touches both code and documents, apply each set to its respective domain. Do not mix rules across domains."
+  shared_concepts: "SSOT, brownfield policy, confirmation gate, and proportionality exist in both sets. Each is applied per-domain, not merged."
+```
+
+---
+
 ## Common Misreadings
 
 ```yaml
~~~~

### `artifacts/DOCUMENT_WORKFLOW.md`

~~~~diff
@@ -4,7 +4,7 @@
 document_type: "workflow"
 target_audience: "ai_agents"
 language: "english"
-strategy_version: "2.0.0"
+strategy_version: "2.1.0"
 ```
 
 ```yaml
@@ -23,6 +23,7 @@ ownership_split:
 1_new_project: "Apply the strategy from scratch."
 2_existing_project: "Adopt the strategy in a project that already has documentation."
 3_ongoing_updates: "The project follows the strategy; update documents during development."
+4_staleness_handling: "Detect and fix stale documents whose commit hash is behind HEAD."
 ```
 
 ---
@@ -73,6 +74,7 @@ content:
   - "Version registry: each document's version + last-updated git commit hash"
   - "Cross-reference map"
 format: "See FILE_AND_STRUCTURE.md → §4 Document Versioning System"
+index_version: "Start at 1.0.0."
 ```
 
 ### Step 4: Create Project Documents
@@ -85,7 +87,7 @@ content:
   - "Constraints (business rules, compliance, performance)"
   - "Current status and roadmap"
 rule: "One file = one concern. Split when a file covers multiple concerns."
-versioning: "Each file starts at version 1.0.0 with the current commit hash."
+versioning: "Each file starts at version 1.0.0. Use the two-phase workflow for commit hash (see Version Bumping)."
 ```
 
 ### Step 5: Create docs-jp/ (If Human-Facing Content Is Needed)
@@ -104,9 +106,9 @@ rule: "Human-facing content does NOT go under documents/. It goes in docs-jp/."
 ```yaml
 action: "Create documents as the project grows — not all at once."
 trigger: "When a task requires context that does not fit in existing project documents, create a new file."
-placement: "documents/reference/<topic>.md or documents/<topic>/<topic>.md"
+placement: "documents/reference/<topic>.md or documents/<topic>/ (see FILE_AND_STRUCTURE.md → §7 Directory Splitting Guide)"
 rule: "Prefer fewer files with clear routing over many files with overlapping content."
-versioning: "Register every new file in documents/INDEX.md with version 1.0.0."
+versioning: "Register every new file in documents/INDEX.md with version 1.0.0. Bump index_version (minor)."
 ```
 
 ---
@@ -217,26 +219,73 @@ rules:
 
 ---
 
+## Use Case 4: Staleness Handling
+
+**When:** an AI agent detects that a document's `last_updated_commit` is behind
+HEAD and code relevant to the document has changed since then.
+
+### Detection
+
+```yaml
+detection: "See FILE_AND_STRUCTURE.md → §4 Staleness Detection in Practice."
+summary: "Compare the document's last_updated_commit with HEAD using git log on relevant code paths."
+```
+
+### Staleness Update Flow
+
+```yaml
+step_1_detect: "Run git log --oneline <last_updated_commit>..HEAD -- <relevant_code_paths>."
+step_2_assess: "Review the listed commits. Determine if the document is still accurate."
+step_3_classify:
+  still_accurate: "Code changes did not affect the documented information."
+  needs_update: "Code changes affect the documented information."
+  needs_full_rewrite: "Code changes are so significant that the document must be restructured."
+step_4_act:
+  still_accurate: "No action needed. Optionally update last_updated_commit to HEAD to confirm the document was reviewed."
+  needs_update: "Update the document content. Bump version (minor or patch). Use the two-phase commit workflow."
+  needs_full_rewrite: "Treat as a major version bump. Confirm with the user before restructuring (L2/L3 gate)."
+step_5_report: "Report what was detected, what was updated, and the new version."
+```
+
+---
+
 ## Version Bumping Workflow
 
+### When to Bump
+
 ```yaml
 when_to_bump:
   major: "Structural change — file added, removed, renamed, or routing significantly changed"
   minor: "Content addition or significant update — new section, new information"
   patch: "Small fix — typo, clarification, minor correction"
+```
+
+### How to Bump (Two-Phase Commit Workflow)
 
-how_to_bump:
-  1: "Update the document's version header (document_version, last_updated_commit, last_updated_date)."
-  2: "Update the corresponding entry in documents/INDEX.md version registry."
-  3: "Record the git commit hash of the commit that includes the update."
-  4: "Use the appropriate commit message prefix (see FILE_AND_STRUCTURE.md → Git Commit Conventions)."
+The commit hash cannot be known before the commit is made. Use this two-phase
+approach:
+
+```yaml
+phase_1:
+  1: "Update the document content."
+  2: "Bump the document_version in the document's YAML header."
+  3: "Set last_updated_commit to 'pending' (or leave blank)."
+  4: "Update the document's entry in documents/INDEX.md (version + date)."
+  5: "Bump index_version in INDEX.md if a new file was added or routing changed."
+  6: "Commit with the appropriate message prefix."
+phase_2:
+  1: "Get the commit hash: git rev-parse --short HEAD"
+  2: "Update last_updated_commit in the document's header."
+  3: "Update last_updated_commit in the document's INDEX.md entry."
+  4: "Commit: 'chore: <document>のコミットハッシュを記録'"
+alternative: "If the commit has not been pushed, use git commit --amend to fill in the hash in a single commit."
 
 example:
   document: "documents/project/architecture.md"
   change: "Added a new section about caching strategy"
   version_bump: "1.0.0 → 1.1.0 (minor — content addition)"
-  commit_message: "feat: アーキテクチャドキュメントにキャッシュ戦略セクションを追加"
-  index_update: "Update version to 1.1.0 and last_updated_commit to the new commit hash"
+  phase_1_commit: "feat: アーキテクチャドキュメントにキャッシュ戦略セクションを追加"
+  phase_2_commit: "chore: アーキテクチャドキュメントのコミットハッシュを記録"
 ```
 
 ---
@@ -256,15 +305,36 @@ question_3: "Is it reference material (specs, schemas, standards, examples)?"
   yes: "Place in documents/reference/<topic>.md."
   no: "Continue to question 4."
 
-question_4: "Is it a topic-specific concern that needs its own directory?"
-  yes: "Create documents/<topic>/ and place files there."
-  no: "Re-evaluate — it may be human-facing after all."
+question_4: "Is it a topic with 3+ files that form a cohesive, self-contained unit?"
+  yes: "Create documents/<topic>/ and place files there (see FILE_AND_STRUCTURE.md → §7)."
+  no: "Re-evaluate — it likely belongs in project/ or reference/ as a single file."
 
 anti_pattern: "Do not create a new file for every small piece of information. Prefer extending an existing file with a new section + INDEX.md routing update."
 ```
 
 ---
 
+## Document Deletion Workflow
+
+```yaml
+when_to_delete:
+  - "The document is obsolete — the content it described no longer exists."
+  - "The document was merged into another document and is now redundant."
+  - "The user explicitly asks to remove it."
+
+deletion_steps:
+  1: "Search the entire documents/ tree for references to the document."
+  2: "Update or remove all referencing links."
+  3: "Remove the document's entry from documents/INDEX.md."
+  4: "Bump index_version in INDEX.md (minor — file removed from registry)."
+  5: "Commit: 'refactor: <document>を削除' with a note explaining why in the body."
+
+rule: "Never delete a document that other documents still reference without fixing those references first."
+confirmation: "L2_structural — proceed only if clearly implied by the task; report explicitly."
+```
+
+---
+
 ## Re-read Triggers
 
 When an AI agent should reload this strategy before acting.
@@ -297,7 +367,7 @@ Before changing the documentation structure, assess the impact.
 ```yaml
 L0_content: "Updating content within an existing file (no structural change) — proceed."
 L1_additive: "Adding a new file in an existing directory — proceed and report."
-L2_structural: "Moving files, changing routing paths, renaming files — proceed only if clearly implied by the task; report explicitly."
-L3_breaking: "Removing a document, restructuring the entire documents/ tree, changing project from single to hierarchical — MUST confirm before implementation."
+L2_structural: "Moving files, changing routing paths, renaming files, deleting a document — proceed only if clearly implied by the task; report explicitly."
+L3_breaking: "Removing a core document, restructuring the entire documents/ tree, changing project from single to hierarchical — MUST confirm before implementation."
 rule: "When in doubt, ask the user. Structural changes affect every future AI agent session."
 ```
~~~~

### `artifacts/FILE_AND_STRUCTURE.md`

~~~~diff
@@ -4,7 +4,7 @@
 document_type: "file_and_structure"
 target_audience: "ai_agents"
 language: "english"
-strategy_version: "2.0.0"
+strategy_version: "2.1.0"
 scope: "file roles, directory layout, versioning, git conventions, hierarchy"
 ```
 
@@ -40,7 +40,7 @@ structure:
   - "documents/INDEX.md — routing hub + version registry (required)"
   - "documents/project/ — project-level context (overview, architecture, constraints)"
   - "documents/reference/ — reference materials (specs, standards, examples)"
-  - "documents/<topic>/ — topic-specific directories as needed"
+  - "documents/<topic>/ — topic-specific directories (see §7 Directory Splitting Guide)"
 principle: "Split by concern, not by audience. There is no audience split inside documents/ — it is all AI-facing."
 ```
 
@@ -72,6 +72,7 @@ content:
   - "Routing map: which document to read for which task"
   - "Version registry: each document's version + last-updated git commit hash"
   - "Cross-reference map: which documents link to which"
+versioning: "INDEX.md has its own version (index_version). Bump it when the inventory or routing changes. See §4."
 ```
 
 See §4 "Document Versioning System" for the version registry format.
@@ -139,23 +140,25 @@ principles:
   - "Each document links to related documents instead of duplicating content."
   - "One file = one concern. A task that touches one concern should require reading one file."
   - "The agent follows the routing chain only as far as needed."
-  - "Cross-references use relative paths from the project root."
+  - "Cross-references use relative paths from the referencing file."
 ```
 
 ### Reference Format
 
 ```yaml
 format: "markdown links with brief context"
-example: "See [documents/project/architecture.md](../project/architecture.md) for the architecture overview."
+example_from_index: "See [project/architecture.md](project/architecture.md) for the architecture overview."
+example_from_project_doc: "See [../reference/api-specs.md](../reference/api-specs.md) for API specifications."
 rule: "Never duplicate content that exists elsewhere. Link to it with a one-sentence description."
+path_note: "Paths are relative to the file containing the link. From documents/INDEX.md, a link to documents/project/overview.md is written as project/overview.md."
 ```
 
 ---
 
 ## 4. Document Versioning System
 
-Every document under `documents/` (except INDEX.md itself) has a version and
-tracks the git commit at which it was last updated.
+Every document under `documents/` has a version and tracks the git commit at
+which it was last updated. This includes INDEX.md itself.
 
 ### Version Format
 
@@ -167,34 +170,65 @@ patch: "Small fix — typo, clarification, minor correction"
 initial_version: "1.0.0"
 ```
 
+### Per-Document Version Header
+
+Each document includes a version block in its top YAML front matter:
+
+```yaml
+# At the top of each document, inside the existing YAML block:
+document_version: "1.2.0"
+last_updated_commit: "abc1234"
+last_updated_date: "2025-07-09"
+```
+
+```yaml
+format_rule: "Use the same YAML code block (```yaml) that already holds document_type, target_audience, etc. Do NOT use a separate front-matter block (---)."
+```
+
 ### Version Registry in INDEX.md
 
+INDEX.md maintains a registry of all documents. INDEX.md itself has an
+`index_version` field that tracks the registry's version.
+
 ```yaml
-# Example entry in documents/INDEX.md
+# Example entries in documents/INDEX.md
+index_version: "1.3.0"
 documents:
   - path: "documents/project/overview.md"
     version: "1.2.0"
     last_updated_commit: "abc1234"
-    last_updated_date: "2024-07-09"
+    last_updated_date: "2025-07-09"
     purpose: "Project overview and objectives"
   - path: "documents/project/architecture.md"
     version: "1.0.0"
     last_updated_commit: "def5678"
-    last_updated_date: "2024-07-09"
+    last_updated_date: "2025-07-09"
     purpose: "Architecture summary"
 ```
 
-### Per-Document Header
+### INDEX.md Version Bumping
 
-Each document includes a version header at the top:
+```yaml
+index_version_bump:
+  major: "Registry restructured — bulk reorganization, many files added/removed"
+  minor: "New file registered, or a file's routing entry changed"
+  patch: "Typo fix in an entry, metadata correction"
+```
+
+### Commit Hash: Two-Phase Workflow
+
+The commit hash cannot be known before the commit is made. Use this workflow:
 
 ```yaml
-# At the top of each document file
----
-document_version: "1.2.0"
-last_updated_commit: "abc1234"
-last_updated_date: "2024-07-09"
----
+phase_1_commit:
+  action: "Update the document content and bump the version number."
+  commit_hash_field: "Leave last_updated_commit blank or set to 'pending'."
+  commit: "Commit with the appropriate message prefix."
+phase_2_record:
+  action: "After committing, get the hash with: git rev-parse --short HEAD"
+  update: "Fill in last_updated_commit in the document header AND in INDEX.md."
+  commit: "Commit the hash update as a follow-up: 'chore: <document>のコミットハッシュを記録'"
+alternative: "Use git commit --amend to fill in the hash before finalizing, if the commit has not been pushed yet."
 ```
 
 ### Why Track Commit Hash
@@ -207,6 +241,22 @@ rationale: |
   and should be verified against the code before relying on it.
 ```
 
+### Staleness Detection in Practice
+
+```yaml
+how_to_detect_staleness:
+  step_1: "Read the document's last_updated_commit from its header."
+  step_2: "Run: git log --onance <last_updated_commit>..HEAD -- <relevant_code_paths>"
+  step_3: "If the output is non-empty, code has changed since the document was last updated."
+  step_4: "Review the listed commits to determine if the document is still accurate."
+  step_5: "If inaccurate, update the document (see DOCUMENT_WORKFLOW.md → Staleness Update Flow)."
+example: |
+  # Document header says: last_updated_commit: "abc1234"
+  # Check if src/ changed since then:
+  git log --oneline abc1234..HEAD -- src/
+  # If output shows commits, the document may be stale.
+```
+
 ---
 
 ## 5. Git Commit Message Conventions
@@ -222,7 +272,7 @@ types:
   feat: "New documentation feature (new section, new versioning entry)"
   fix: "Documentation fix (correcting inaccurate information)"
   refactor: "Documentation restructuring (moving files, reorganizing sections)"
-  chore: "Maintenance (version bump, metadata update)"
+  chore: "Maintenance (version bump, metadata update, commit hash recording)"
 examples:
   - "docs: プロジェクト概要を更新"
   - "fix: API仕様のエンドポイントURLを修正"
@@ -266,7 +316,32 @@ naming: "lowercase, hyphen-separated for files; directories are lowercase"
 
 ---
 
-## 7. Hierarchical Projects
+## 7. Directory Splitting Guide
+
+When to create a new `documents/<topic>/` directory vs. placing a file in
+`documents/project/` or `documents/reference/`.
+
+```yaml
+default_placement:
+  project_level: "documents/project/ — context the agent needs for every task"
+  reference_level: "documents/reference/ — material the agent reads on demand"
+
+when_to_create_topic_directory:
+  criteria:
+    - "The topic has 3 or more files that form a cohesive unit."
+    - "The topic is self-contained — an agent can read only that directory for the topic."
+    - "Placing the files in project/ or reference/ would make those directories cluttered."
+  rule: "Do NOT create a topic directory for 1–2 files. Place them in project/ or reference/ until a third file appears (Rule of Three)."
+
+when_not_to_create:
+  - "The topic overlaps with project/ or reference/ content."
+  - "The files would need to cross-reference each other heavily (keep them together in one directory)."
+  - "The topic is a single file — use project/ or reference/ instead."
+```
+
+---
+
+## 8. Hierarchical Projects
 
 For multi-service or multi-package projects, each child has an independent
 `documents/` tree. The parent does not enter children's trees.
@@ -308,13 +383,47 @@ rule: "Children do not reference this file. Children are unaware of each other u
 
 ---
 
+## 9. Document Deletion Rules
+
+When a document under `documents/` is removed:
+
+```yaml
+deletion_steps:
+  1: "Confirm the document is truly obsolete — check all cross-references first."
+  2: "Remove or update all links pointing to the deleted document (search the entire documents/ tree)."
+  3: "Remove the document's entry from documents/INDEX.md version registry."
+  4: "Bump index_version in INDEX.md (minor — a file was removed from the registry)."
+  5: "Commit with: 'refactor: <document>を削除' and note why in the body."
+rule: "Never delete a document that other documents still reference without fixing those references first."
+```
+
+---
+
+## 10. Multi-Developer INDEX.md Conflict Mitigation
+
+The version registry in INDEX.md is a single file that all documentation
+changes touch, which can cause merge conflicts when multiple developers update
+documents in parallel.
+
+```yaml
+mitigation:
+  - "Keep INDEX.md entries sorted by path to reduce conflict surface."
+  - "Each developer updates only their own document's entry."
+  - "If conflicts occur, they are typically in the version registry block — resolve by keeping both entries and sorting."
+  - "For large teams, consider updating INDEX.md in a separate commit from the document change, to isolate conflicts."
+note: "This is a known trade-off of centralizing the version registry. The benefit (single routing hub) outweighs the conflict cost for most projects."
+```
+
+---
+
 ## How These Interlock
 
 ```yaml
 entry_file_routes: "agent.md routes to documents/INDEX.md"
 index_routes: "INDEX.md routes to project/ or reference/ based on the task"
 version_registry: "INDEX.md tracks every document's version + commit hash for staleness detection"
-cross_references: "Documents link to each other instead of duplicating content"
+cross_references: "Documents link to each other using relative paths from the referencing file"
 hierarchy: "Parent and child each have independent documents/ trees; coordination via parent's children.md"
+deletion: "Removing a document requires fixing references + updating INDEX.md"
 one_idea: "INDEX.md is the map, documents are the destinations, version headers are the timestamps. The agent reads the map, picks a destination, and follows links only as far as needed."
 ```
~~~~

### `artifacts/INDEX.md`

~~~~diff
@@ -5,21 +5,33 @@ document_type: "index"
 target_audience: "ai_agents"
 language: "english"
 role: "entry point for the documentation strategy artifact set"
-strategy_version: "2.0.0"
+strategy_version: "2.1.0"
 ```
 
 This is the entry point for the exported strategy. Read it first.
 
 ## Read Order
 
 ```yaml
-1_philosophy: "DOCUMENTATION_PHILOSOPHY.md"   # WHY:  accuracy priority, scope, git as recording
-2_structure:  "FILE_AND_STRUCTURE.md"         # HOW+WHERE: file roles, directory layout, versioning, git conventions
-3_workflow:   "DOCUMENT_WORKFLOW.md"           # FLOW: setup, update, brownfield, version bumping
+1_philosophy: "DOCUMENTATION_PHILOSOPHY.md"   # WHY:  accuracy priority, scope, git as recording, design-principles relationship
+2_structure:  "FILE_AND_STRUCTURE.md"         # HOW+WHERE: file roles, directory layout, versioning, git conventions, hierarchy, deletion
+3_workflow:   "DOCUMENT_WORKFLOW.md"           # FLOW: setup, update, brownfield, staleness handling, version bumping, deletion
 ```
 
 On first contact, read 1 → 2 → 3. For a specific task, jump via Quick Task Routing.
 
+## Foundational Lens
+
+These artifacts assume an **accuracy-first, routing-driven** paradigm for documentation.
+
+```yaml
+core_idea: "Documentation gives AI agents accurate information at the right time. Token efficiency is achieved through file structure and routing, never through information truncation."
+priority: "accuracy > routing > token efficiency"
+scope: "documents/ only — not code design, not git timing, not branching"
+audience: "documents/ is entirely AI-facing; human-facing content goes in docs-jp/"
+recording: "Git is the recording tool — we govern commit message format and version tracking, not commit timing"
+```
+
 ## Ownership Map (Single Source of Truth)
 
 Each concept lives in exactly ONE document. Link, never duplicate.
@@ -32,6 +44,7 @@ DOCUMENTATION_PHILOSOPHY.md:
     - "Git as a recording tool (principle, not timing)"
     - "AI-facing by default; human-facing is a separate concern"
     - "Routing over truncation: split files, do not shrink information"
+    - "Relationship to design-principles (domain boundary, usage patterns, simultaneous-read guidance)"
     - "Common misreadings"
 
 FILE_AND_STRUCTURE.md:
@@ -41,17 +54,26 @@ FILE_AND_STRUCTURE.md:
     - "INDEX.md role: routing hub + document version registry"
     - "File roles: agent entry files, INDEX.md, project docs, reference docs"
     - "Document versioning system: semantic version + git commit hash"
+    - "Two-phase commit hash workflow"
+    - "Staleness detection in practice (git log commands)"
+    - "INDEX.md version bumping (index_version)"
     - "Git commit message conventions for documentation"
-    - "Cross-reference and routing strategy"
+    - "Cross-reference and routing strategy (relative paths)"
+    - "Directory splitting guide (Rule of Three)"
     - "Hierarchical projects (parent-child documentation)"
+    - "Document deletion rules"
+    - "Multi-developer INDEX.md conflict mitigation"
     - "File format standards"
 
 DOCUMENT_WORKFLOW.md:
   owns:
     - "New project setup: step-by-step"
     - "Brownfield adoption: audit, classify, migrate"
     - "Ongoing document updates"
-    - "Version bumping workflow"
+    - "Staleness handling: detection, classification, update flow"
+    - "Version bumping workflow (two-phase commit)"
+    - "Document creation decision tree"
+    - "Document deletion workflow"
     - "Re-read triggers"
     - "Confirmation gate (L0–L3)"
 ```
@@ -62,11 +84,17 @@ DOCUMENT_WORKFLOW.md:
 "setting up docs for a new project":       "DOCUMENT_WORKFLOW.md (New Project Setup) + FILE_AND_STRUCTURE.md (File Roles)"
 "adopting strategy in existing project":    "DOCUMENT_WORKFLOW.md (Brownfield Adoption)"
 "updating an existing document":            "DOCUMENT_WORKFLOW.md (Ongoing Updates) + FILE_AND_STRUCTURE.md (find the right file)"
+"document is stale (behind HEAD)":          "DOCUMENT_WORKFLOW.md (Staleness Handling) + FILE_AND_STRUCTURE.md (Staleness Detection)"
 "bumping a document version":               "DOCUMENT_WORKFLOW.md (Version Bumping) + FILE_AND_STRUCTURE.md (Versioning System)"
+"recording commit hash after update":       "DOCUMENT_WORKFLOW.md (Two-Phase Commit) + FILE_AND_STRUCTURE.md (Commit Hash Workflow)"
 "writing a git commit message for docs":    "FILE_AND_STRUCTURE.md (Git Commit Conventions)"
 "which file should hold this information":  "FILE_AND_STRUCTURE.md (File Role Definitions)"
+"should I create a new directory":          "FILE_AND_STRUCTURE.md (Directory Splitting Guide)"
 "how to structure a multi-service project": "FILE_AND_STRUCTURE.md (Hierarchical Projects)"
 "setting up documents/INDEX.md":            "FILE_AND_STRUCTURE.md (INDEX.md Role) + DOCUMENT_WORKFLOW.md (New Project Setup)"
+"deleting a document":                      "DOCUMENT_WORKFLOW.md (Document Deletion) + FILE_AND_STRUCTURE.md (Document Deletion Rules)"
+"splitting a document into two":            "FILE_AND_STRUCTURE.md (Directory Splitting Guide) + DOCUMENT_WORKFLOW.md (Version Bumping)"
 "when should I re-read this strategy":      "DOCUMENT_WORKFLOW.md (Re-read Triggers)"
 "what does this strategy govern":           "DOCUMENTATION_PHILOSOPHY.md (Scope Boundary)"
+"how does this relate to design-principles": "DOCUMENTATION_PHILOSOPHY.md (Relationship to design-principles)"
 ```
~~~~
