# Source record: documentation v2.2 review fixes

```yaml
record_type: "verbatim_external_source_snapshot"
source_kind: "Git commit message + GitHub API patch"
source_repository: "Daiki-Yoshida/documentation-strategy"
source_commit: "c53be461410e315f55c5aeee2cd972d3b471acdf"
source_url: "https://github.com/Daiki-Yoshida/documentation-strategy/commit/c53be461410e315f55c5aeee2cd972d3b471acdf"
source_author_date: "2026-07-09T15:46:16Z"
retrieved_date: "2026-09-24"
source_text_status: "GitHub APIで取得したcommit messageとartifact patchのsnapshot"
record_body_policy: "commit messageとpatchは無加工。commit stateでの修正内容を示すが、元チャットの提案・承認原文とは区別する"
```

## Commit message原文

~~~~text
fix: Claudeレビューの15項目に対応、戦略v2.2.0

major修正:
- F1: artifacts/配置先を「プロジェクトごとに異なる、固定しない」に修正
- F2: 二段階コミットワークフロー手順をFILE_AND_STRUCTURE.mdに集約、WORKFLOW.mdはリンクのみ（SSOT違反解消）
- F3: ドキュメント版major定義を「再構成・全面書き直し」に変更、file追加/削除はindex_versionへ分離
- F4: Scopeのgovernsリストにdocs-jp/・エントリファイル・README.mdを追加（Domain Boundaryとの矛盾解消）

minor修正:
- F5: --onanceタイポを--onelineに修正
- F6: index_version minor定義に「file removed」を追加
- F7: refactor型定義に「deleting files」を追加
- F8: Quick Task Routingの参照先名を実際の見出し・§番号に合わせる
- F9: still_accurate時のハッシュ更新手順を定義（patchバンプ、chore:コミット）
- F10: INDEX.mdの版管理を明確化（index_versionのみ、document_versionなし、自己登録なし）
- F11: デシジョンツリーq4-noに確定的デフォルト（reference/<topic>.md配置）を設定

suggestion対応:
- F14: レジストリpathはルート相対、リンクはファイル相対の注記を追加
- F15: Quick Task RoutingにConfirmation Gate/Brownfield Guard/エントリファイル追加/マージコンフリクトを追加

追加修正:
- エントリファイル定義を「ルーティングのみ」から「規約+ルーティング」に変更
  ひな形はAIが作成、ユーザーがカスタマイズ（sudo禁止、コミット習慣等）する前提を明記

非対応（ユーザー判断）:
- F12: 最小構成は定義せず現在のまま
- F13: ステップ順序は対応しない

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
-strategy_version: "2.1.0"
+strategy_version: "2.2.0"
 ```
 
 ## Core Principle: Information Accuracy First
@@ -36,6 +36,9 @@ right_approach: "Split the document by concern so the agent loads only the relev
 governs:
   - "documents/ directory — all content, structure, routing, and maintenance"
   - "documents/INDEX.md — the routing hub and version registry"
+  - "docs-jp/ directory — human-facing documentation placement and separation"
+  - "Agent entry files (CLAUDE.md, AGENTS.md, GEMINI.md) — role, routing, and convention template"
+  - "README.md — role as human-facing entry point"
   - "Git commit message conventions for documentation changes"
   - "Document versioning — tracking which commit a document reflects"
 
@@ -166,7 +169,7 @@ pattern_1_independent:
 pattern_2_combined:
   description: "User references both sets at once for a full-project task."
   examples:
-    - "'Develop this project following @documents/artifacts/' (both folders)"
+    - "'Develop this project following @<strategy_artifacts_path>/' (path varies per project — e.g., documents/artifacts/, artifacts/, or a submodule path)"
     - "Project AGENTS.md lists both artifact sets as references"
   implication: "The AI agent holds both contexts simultaneously."
 ```
~~~~

### `artifacts/DOCUMENT_WORKFLOW.md`

~~~~diff
@@ -4,7 +4,7 @@
 document_type: "workflow"
 target_audience: "ai_agents"
 language: "english"
-strategy_version: "2.1.0"
+strategy_version: "2.2.0"
 ```
 
 ```yaml
@@ -241,7 +241,7 @@ step_3_classify:
   needs_update: "Code changes affect the documented information."
   needs_full_rewrite: "Code changes are so significant that the document must be restructured."
 step_4_act:
-  still_accurate: "No action needed. Optionally update last_updated_commit to HEAD to confirm the document was reviewed."
+  still_accurate: "Update last_updated_commit and last_updated_date in both the document header and INDEX.md entry. Bump document_version (patch — metadata refresh). Bump index_version (patch). Commit: 'chore: <document>のレビュー済みコミットハッシュを更新'. Follow the two-phase workflow (see FILE_AND_STRUCTURE.md → §4)."
   needs_update: "Update the document content. Bump version (minor or patch). Use the two-phase commit workflow."
   needs_full_rewrite: "Treat as a major version bump. Confirm with the user before restructuring (L2/L3 gate)."
 step_5_report: "Report what was detected, what was updated, and the new version."
@@ -255,37 +255,23 @@ step_5_report: "Report what was detected, what was updated, and the new version.
 
 ```yaml
 when_to_bump:
-  major: "Structural change — file added, removed, renamed, or routing significantly changed"
+  major: "Document restructured or rewritten — section reorganization, scope change, or full rewrite"
   minor: "Content addition or significant update — new section, new information"
-  patch: "Small fix — typo, clarification, minor correction"
+  patch: "Small fix — typo, clarification, minor correction, or metadata refresh"
 ```
 
-### How to Bump (Two-Phase Commit Workflow)
-
-The commit hash cannot be known before the commit is made. Use this two-phase
-approach:
+### How to Bump
 
 ```yaml
-phase_1:
-  1: "Update the document content."
-  2: "Bump the document_version in the document's YAML header."
-  3: "Set last_updated_commit to 'pending' (or leave blank)."
-  4: "Update the document's entry in documents/INDEX.md (version + date)."
-  5: "Bump index_version in INDEX.md if a new file was added or routing changed."
-  6: "Commit with the appropriate message prefix."
-phase_2:
-  1: "Get the commit hash: git rev-parse --short HEAD"
-  2: "Update last_updated_commit in the document's header."
-  3: "Update last_updated_commit in the document's INDEX.md entry."
-  4: "Commit: 'chore: <document>のコミットハッシュを記録'"
-alternative: "If the commit has not been pushed, use git commit --amend to fill in the hash in a single commit."
-
-example:
-  document: "documents/project/architecture.md"
-  change: "Added a new section about caching strategy"
-  version_bump: "1.0.0 → 1.1.0 (minor — content addition)"
-  phase_1_commit: "feat: アーキテクチャドキュメントにキャッシュ戦略セクションを追加"
-  phase_2_commit: "chore: アーキテクチャドキュメントのコミットハッシュを記録"
+procedure: "See FILE_AND_STRUCTURE.md → §4 Commit Hash: Two-Phase Workflow for the full procedure."
+summary:
+  - "Update document content and bump document_version."
+  - "Set last_updated_commit to 'pending'."
+  - "Update the document's INDEX.md entry (version + date)."
+  - "Bump index_version if a new file was added or routing changed."
+  - "Commit with the appropriate message prefix."
+  - "After committing, record the commit hash in the document header and INDEX.md entry."
+  - "Commit the hash update: 'chore: <document>のコミットハッシュを記録'"
 ```
 
 ---
@@ -307,7 +293,7 @@ question_3: "Is it reference material (specs, schemas, standards, examples)?"
 
 question_4: "Is it a topic with 3+ files that form a cohesive, self-contained unit?"
   yes: "Create documents/<topic>/ and place files there (see FILE_AND_STRUCTURE.md → §7)."
-  no: "Re-evaluate — it likely belongs in project/ or reference/ as a single file."
+  no: "Place in documents/reference/<topic>.md. Revisit when a third related file appears (Rule of Three)."
 
 anti_pattern: "Do not create a new file for every small piece of information. Prefer extending an existing file with a new section + INDEX.md routing update."
 ```
~~~~

### `artifacts/FILE_AND_STRUCTURE.md`

~~~~diff
@@ -4,7 +4,7 @@
 document_type: "file_and_structure"
 target_audience: "ai_agents"
 language: "english"
-strategy_version: "2.1.0"
+strategy_version: "2.2.0"
 scope: "file roles, directory layout, versioning, git conventions, hierarchy"
 ```
 
@@ -80,16 +80,24 @@ See §4 "Document Versioning System" for the version registry format.
 ### Agent Entry Files (CLAUDE.md, AGENTS.md, GEMINI.md)
 
 ```yaml
-purpose: "AI agent entry point — routes to documents/INDEX.md"
+purpose: "AI agent entry point — conventions + routing"
 placement: "project root (one per agent tool)"
+role: "the first file an AI agent reads when entering a project"
 content:
-  - "role: the agent's responsibility in this project"
-  - "constraints: project-specific rules"
-  - "emergency_action: what to do if intent is unclear"
-  - "routing: documents/INDEX.md as primary reference"
-  - "focus_files: glob patterns the agent should prioritize"
-  - "current_priority: the current development focus"
-design_rule: "The entry file routes; it does not explain. Detail lives under documents/."
+  conventions:
+    - "language settings (e.g., respond in Japanese, think in English)"
+    - "execution rules (e.g., commit after changes, no sudo)"
+    - "emergency_action: what to do if intent is unclear"
+  routing:
+    - "primary_ref: documents/INDEX.md"
+  efficiency:
+    - "focus_files: glob patterns the agent should prioritize"
+    - "current_priority: the current development focus"
+design_rule: |
+  The entry file holds conventions + routing.
+  Conventions (language, execution rules, constraints) live in the entry file itself — they are agent-specific and project-specific.
+  Project detail (architecture, specs, constraints documentation) lives under documents/.
+  The entry file is a template created by the AI agent during setup; the user customizes it thereafter (adding rules like 'no sudo', 'commit after every change', etc.).
 when_to_create: "One file per AI tool the project actually uses. Do not create files for unused tools (YAGNI)."
 ```
 
@@ -164,9 +172,9 @@ which it was last updated. This includes INDEX.md itself.
 
 ```yaml
 scheme: "semantic versioning (MAJOR.MINOR.PATCH)"
-major: "Structural change — file added, removed, renamed, or routing significantly changed"
+major: "Document restructured or rewritten — section reorganization, scope change, or full rewrite that invalidates prior readers' understanding"
 minor: "Content addition or significant update — new section, new information"
-patch: "Small fix — typo, clarification, minor correction"
+patch: "Small fix — typo, clarification, minor correction, or metadata refresh"
 initial_version: "1.0.0"
 ```
 
@@ -206,15 +214,29 @@ documents:
     purpose: "Architecture summary"
 ```
 
+### Registry Path Convention
+
+```yaml
+note: "Registry 'path' fields are repo-root-relative identifiers (e.g., 'documents/project/overview.md'), used for unique identification. This is distinct from markdown cross-reference links, which follow §3's relative-path rule (e.g., 'project/overview.md' from INDEX.md)."
+```
+
 ### INDEX.md Version Bumping
 
 ```yaml
 index_version_bump:
   major: "Registry restructured — bulk reorganization, many files added/removed"
-  minor: "New file registered, or a file's routing entry changed"
+  minor: "File registered or removed, or a file's routing entry changed"
   patch: "Typo fix in an entry, metadata correction"
 ```
 
+### INDEX.md Self-Versioning
+
+```yaml
+rule: "INDEX.md uses index_version as its sole version field. It does NOT carry a separate document_version."
+registry_self_entry: "INDEX.md does NOT list itself in the version registry. Its version is tracked by index_version at the top of the file."
+commit_tracking: "INDEX.md carries its own last_updated_commit and last_updated_date at the top of the file, alongside index_version."
+```
+
 ### Commit Hash: Two-Phase Workflow
 
 The commit hash cannot be known before the commit is made. Use this workflow:
@@ -246,7 +268,7 @@ rationale: |
 ```yaml
 how_to_detect_staleness:
   step_1: "Read the document's last_updated_commit from its header."
-  step_2: "Run: git log --onance <last_updated_commit>..HEAD -- <relevant_code_paths>"
+  step_2: "Run: git log --oneline <last_updated_commit>..HEAD -- <relevant_code_paths>"
   step_3: "If the output is non-empty, code has changed since the document was last updated."
   step_4: "Review the listed commits to determine if the document is still accurate."
   step_5: "If inaccurate, update the document (see DOCUMENT_WORKFLOW.md → Staleness Update Flow)."
@@ -271,7 +293,7 @@ types:
   docs: "Documentation changes (new file, content update, routing change)"
   feat: "New documentation feature (new section, new versioning entry)"
   fix: "Documentation fix (correcting inaccurate information)"
-  refactor: "Documentation restructuring (moving files, reorganizing sections)"
+  refactor: "Documentation restructuring (moving, reorganizing, or deleting files)"
   chore: "Maintenance (version bump, metadata update, commit hash recording)"
 examples:
   - "docs: プロジェクト概要を更新"
~~~~

### `artifacts/INDEX.md`

~~~~diff
@@ -5,7 +5,7 @@ document_type: "index"
 target_audience: "ai_agents"
 language: "english"
 role: "entry point for the documentation strategy artifact set"
-strategy_version: "2.1.0"
+strategy_version: "2.2.0"
 ```
 
 This is the entry point for the exported strategy. Read it first.
@@ -71,7 +71,7 @@ DOCUMENT_WORKFLOW.md:
     - "Brownfield adoption: audit, classify, migrate"
     - "Ongoing document updates"
     - "Staleness handling: detection, classification, update flow"
-    - "Version bumping workflow (two-phase commit)"
+    - "Version bumping workflow (links to FILE_AND_STRUCTURE.md §4 for the two-phase procedure)"
     - "Document creation decision tree"
     - "Document deletion workflow"
     - "Re-read triggers"
@@ -83,18 +83,22 @@ DOCUMENT_WORKFLOW.md:
 ```yaml
 "setting up docs for a new project":       "DOCUMENT_WORKFLOW.md (New Project Setup) + FILE_AND_STRUCTURE.md (File Roles)"
 "adopting strategy in existing project":    "DOCUMENT_WORKFLOW.md (Brownfield Adoption)"
-"updating an existing document":            "DOCUMENT_WORKFLOW.md (Ongoing Updates) + FILE_AND_STRUCTURE.md (find the right file)"
-"document is stale (behind HEAD)":          "DOCUMENT_WORKFLOW.md (Staleness Handling) + FILE_AND_STRUCTURE.md (Staleness Detection)"
-"bumping a document version":               "DOCUMENT_WORKFLOW.md (Version Bumping) + FILE_AND_STRUCTURE.md (Versioning System)"
-"recording commit hash after update":       "DOCUMENT_WORKFLOW.md (Two-Phase Commit) + FILE_AND_STRUCTURE.md (Commit Hash Workflow)"
+"updating an existing document":            "DOCUMENT_WORKFLOW.md (Use Case 3: Ongoing Document Updates) + FILE_AND_STRUCTURE.md (§2 File Roles)"
+"document is stale (behind HEAD)":          "DOCUMENT_WORKFLOW.md (Use Case 4: Staleness Handling) + FILE_AND_STRUCTURE.md (§4 Staleness Detection in Practice)"
+"bumping a document version":               "DOCUMENT_WORKFLOW.md (Version Bumping Workflow) + FILE_AND_STRUCTURE.md (§4 Document Versioning System)"
+"recording commit hash after update":       "FILE_AND_STRUCTURE.md (§4 Commit Hash: Two-Phase Workflow) — DOCUMENT_WORKFLOW.md links here"
 "writing a git commit message for docs":    "FILE_AND_STRUCTURE.md (Git Commit Conventions)"
-"which file should hold this information":  "FILE_AND_STRUCTURE.md (File Role Definitions)"
-"should I create a new directory":          "FILE_AND_STRUCTURE.md (Directory Splitting Guide)"
+"which file should hold this information":  "FILE_AND_STRUCTURE.md (§2 File Roles)"
+"should I create a new directory":          "FILE_AND_STRUCTURE.md (§7 Directory Splitting Guide)"
 "how to structure a multi-service project": "FILE_AND_STRUCTURE.md (Hierarchical Projects)"
-"setting up documents/INDEX.md":            "FILE_AND_STRUCTURE.md (INDEX.md Role) + DOCUMENT_WORKFLOW.md (New Project Setup)"
-"deleting a document":                      "DOCUMENT_WORKFLOW.md (Document Deletion) + FILE_AND_STRUCTURE.md (Document Deletion Rules)"
-"splitting a document into two":            "FILE_AND_STRUCTURE.md (Directory Splitting Guide) + DOCUMENT_WORKFLOW.md (Version Bumping)"
+"setting up documents/INDEX.md":            "FILE_AND_STRUCTURE.md (§2 documents/INDEX.md) + DOCUMENT_WORKFLOW.md (Use Case 1: New Project Setup)"
+"deleting a document":                      "DOCUMENT_WORKFLOW.md (Document Deletion Workflow) + FILE_AND_STRUCTURE.md (§9 Document Deletion Rules)"
+"splitting a document into two":            "FILE_AND_STRUCTURE.md (§7 Directory Splitting Guide) + DOCUMENT_WORKFLOW.md (Version Bumping Workflow)"
 "when should I re-read this strategy":      "DOCUMENT_WORKFLOW.md (Re-read Triggers)"
 "what does this strategy govern":           "DOCUMENTATION_PHILOSOPHY.md (Scope Boundary)"
 "how does this relate to design-principles": "DOCUMENTATION_PHILOSOPHY.md (Relationship to design-principles)"
+"is this change safe to make without asking": "DOCUMENT_WORKFLOW.md (Confirmation Gate)"
+"project convention conflicts with strategy": "DOCUMENT_WORKFLOW.md (Brownfield Guard)"
+"adding an agent entry file":               "FILE_AND_STRUCTURE.md (§2 Agent Entry Files)"
+"INDEX.md merge conflict":                  "FILE_AND_STRUCTURE.md (§10 Multi-Developer INDEX.md Conflict Mitigation)"
 ```
~~~~
