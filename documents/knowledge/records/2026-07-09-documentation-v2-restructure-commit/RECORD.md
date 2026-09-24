# Source record: 2026-07-09-documentation-v2-restructure-commit

```yaml
record_type: "verbatim_external_source_snapshot"
source_kind: "Git commit message + GitHub API patch"
source_repository: "Daiki-Yoshida/documentation-strategy"
source_commit: "4b7e8e224845b1b62f0d026bae41220a5ecab6ee"
source_url: "https://github.com/Daiki-Yoshida/documentation-strategy/commit/4b7e8e224845b1b62f0d026bae41220a5ecab6ee"
source_author_date: "2026-07-09T13:53:57Z"
retrieved_date: "2026-09-24"
source_text_status: "GitHub APIで取得したcommit messageとpatchのsnapshot"
record_body_policy: "commit messageとpatchは無加工。commit stateで導入・変更された内容の証拠であり、元チャットの提案・承認原文とは区別する"
```

## Commit message原文

~~~~text
refactor: 戦略v2.0.0 — 精度優先・版管理・docs-jp分離・INDEX.md新設

artifacts/全面書き直し:
- 優先順位を「精度 > ルーティング > トークン効率」に変更
- documents/は完全AI向け、人間向けはdocs-jp/へ分離
- documents/INDEX.md新設（ルーティングハブ+版レジストリ）
- ドキュメント版管理システム（semantic version + git commit hash）
- gitコミット規約（Conventional Commits接頭辞 + 日本語記述）
- gitコミットタイミング・ブランチ戦略は管轄外と明記
- コード設計には言及しない（スコープをdocuments/のみに限定）

構造変更:
- documents/artifacts_jp/ → docs-jp/artifacts_jp/ へ移動
- documents/project/PROJECT_OVERVIEW_JP.md → docs-jp/ へ移動
- documents/INDEX.md 新設（プロジェクトのルーティング+版レジストリ）
- examples/を新構造へ適合（documents/agents/ → documents/project/ + documents/reference/）
- 全examplesにINDEX.mdを新設
- 全examplesのエントリファイルをdocuments/INDEX.mdへルーティング更新

Generated with [Devin](https://devin.ai)

Co-Authored-By: Devin <158243242+devin-ai-integration[bot]@users.noreply.github.com>
~~~~

## GitHub API patch snapshot

### `artifacts/DOCUMENTATION_PHILOSOPHY.md`

~~~~diff
@@ -1,220 +1,150 @@
-# Documentation Philosophy - AI Agent Reference
+# Documentation Philosophy
 
 ```yaml
 document_type: "documentation_philosophy"
 target_audience: "ai_agents"
-optimization: "token_efficiency"
 language: "english"
-core_value: "AI_Agent_Priority"
+strategy_version: "2.0.0"
 ```
 
-## Core Philosophy: AI-Agent Priority
+## Core Principle: Information Accuracy First
 
-Documentation is structured so AI agents locate the right context with minimal token cost. Human-facing documents are a separate, clearly-scoped concern — not the default.
-
-```yaml
-principle: "AI-Agent Priority"
-definition: "Optimize documentation structure for AI agent processing efficiency, not human readability."
-formula: "Efficient context = minimal tokens × correct routing × low cognitive load"
-rationale: |
-  AI agents operate under token limits and processing-cost constraints.
-  Every unnecessary token spent on prose, redundancy, or misrouted lookups
-  degrades performance and increases cost. Structure the documentation so
-  the agent reaches the right information in the fewest tokens possible.
-```
-
-## Design Priorities
+The purpose of documentation is to give AI agents accurate, complete information
+at the right time. Token efficiency matters, but **never at the cost of
+information degradation**.
 
 ```yaml
 priority_order:
-  1: "AI agent processing efficiency (over human readability)"
-  2: "token optimization (minimize consumption per task)"
-  3: "cognitive load reduction (clear routing, no ambiguity)"
-  4: "single source of truth (eliminate duplication)"
-  5: "universality (single and hierarchical projects, any scale)"
+  1: "Information accuracy — the document must be correct and complete"
+  2: "Proper routing — the agent reads only what it needs, when it needs it"
+  3: "Token efficiency — minimize waste, but never truncate information to save tokens"
 ```
 
-When two priorities conflict, the higher number wins. For example: eliminating
-duplication (4) is good, but not if it forces the AI to read three files instead
-of one for a common task (violates 2 and 3).
-
----
-
-## Token Optimization
+When accuracy and token efficiency conflict, accuracy wins. The solution to
+token cost is **better file structure and routing**, not thinner documents.
 
 ```yaml
-principle: "Minimize token consumption per task."
-guidelines:
-  - "Entry files (agent.md) stay under 200 tokens — they route, they do not explain."
-  - "Project files (PROJECT.md) stay under 800 tokens — enough for one processing pass."
-  - "Prefer dense YAML over prose for structured information."
-  - "Link to details instead of inlining them."
-  - "One sentence + link beats one paragraph of restatement."
-  - "No decorative language, no redundant headers, no preamble."
+wrong_approach: "Shrink a document to fit a token budget, losing critical detail."
+right_approach: "Split the document by concern so the agent loads only the relevant part."
 ```
 
-> **Single source of truth**: concrete token limits and file-size rules live in
-> `FILE_AND_STRUCTURE.md`. This section states only the principle (the *why*).
-
 ---
 
-## Cognitive Load Reduction
+## Scope: What This Strategy Govers
 
 ```yaml
-principle: "An AI agent should never guess where information lives."
-mechanisms:
-  routing: "Every entry file contains explicit routing to the next file."
-  single_owner: "Each concept has exactly ONE authoritative document (see INDEX.md → Ownership Map)."
-  directory_purpose: "Each directory has one clear purpose — no ambiguous placement."
-  gradual_disclosure: "Entry → project overview → task-specific detail. Never front-load everything."
-  no_split_by_audience: "All AI-facing docs are English; language is not a routing axis."
+governs:
+  - "documents/ directory — all content, structure, routing, and maintenance"
+  - "documents/INDEX.md — the routing hub and version registry"
+  - "Git commit message conventions for documentation changes"
+  - "Document versioning — tracking which commit a document reflects"
+
+does_not_govern:
+  - "Source code design, architecture, or patterns"
+  - "Git commit timing — when to commit is a code-side concern"
+  - "Git branching strategy — that is a development workflow concern"
+  - "Code review process — that is a development process concern"
 ```
 
----
-
-## Single Source of Truth (Duplicate Elimination)
-
-```yaml
-principle: "Each piece of information lives in exactly one place."
-rules:
-  - "If a concept appears in two files, one must own it and the other must link."
-  - "Restatement is allowed only as AT MOST one sentence + a link to the owner."
-  - "On any apparent conflict between docs, the OWNING doc's wording is authoritative."
-  - "When a document needs a concept it does not own, link — do not re-derive."
-  - "Splitting a topic into 'why' and 'how' is allowed; join them with SSOT pointers."
-```
+This strategy is about **recording and documentation**, not about code. Git is
+partially governed because it is the recording tool: how to label a documentation
+commit (message conventions) and how to track which code state a document
+describes (version + commit hash). When to commit, whether to branch, and how
+to review are code-side decisions.
 
 ---
 
-## Universality
+## AI-Facing by Default
 
 ```yaml
-principle: "The strategy works for any project that uses AI agents — regardless of scale."
-scope:
-  single_project: "One repository, one set of agent files, one documents/ tree."
-  hierarchical_project: "Parent + child projects with OOP-style encapsulation."
-  scale_independence: "From a single-script repo to a multi-service monorepo."
-target: "projects using AI agents (any scale, any language, any stack)"
+principle: "Everything under documents/ is written for AI agents."
+rationale: |
+  Users instruct AI agents with "@documents/ — understand this and develop."
+  If documents/ contained human-facing prose, the agent would waste tokens
+  parsing non-actionable content. Therefore documents/ is entirely AI-facing.
+
+human_facing:
+  location: "docs-jp/ (separate top-level directory)"
+  language: "Japanese"
+  purpose: "Project background, setup tutorials, design rationale for humans"
+  rule: "Human-facing content does NOT live under documents/"
 ```
 
-> **Single source of truth**: the hierarchical structure rules and child/parent
-> independence live in `FILE_AND_STRUCTURE.md` → "Hierarchical Projects". This
-> section states only the principle (the *why*).
-
 ---
 
-## Format Priority
+## Routing Over Truncation
 
 ```yaml
-principle: "AI efficiency > human readability."
-base_format: "markdown with embedded YAML blocks"
-rationale: |
-  YAML blocks are dense, parse-friendly, and carry structure without prose overhead.
-  Markdown provides readable section headers for navigation. JSON is used only when
-  the content is a machine schema (e.g., OpenAPI). Human-readable prose is reserved
-  for README.md — the one human-facing exception.
+principle: "Split files by concern; route the agent to the right file. Do not compress information."
+mechanisms:
+  index_file: "documents/INDEX.md lists every document with its purpose and routing."
+  cross_references: "Each document links to related documents instead of duplicating content."
+  concern_separation: "One file = one concern. A change to one concern should require reading one file."
+  gradual_disclosure: "INDEX → overview → detail. The agent follows the chain only as far as needed."
 ```
 
-> **Single source of truth**: the format selection guide (when to use YAML vs
-> JSON vs Markdown) lives in `FILE_AND_STRUCTURE.md` → "File Format Standards".
+The agent should never read everything to find one answer. The file structure
+itself is the routing system.
 
 ---
 
-## Relationship to design-principles
-
-This artifact set has a sibling: `design-principles`. They are independent
-artifact sets with different domains, but a target project typically uses both.
-
-### Domain Boundary
+## Git as a Recording Tool
 
 ```yaml
-this_artifact_set:
-  name: "documentation-strategy"
-  domain: "documents (documents/, docs/, README.md, agent entry files)"
-  owns: "HOW to structure, route, and maintain documentation for AI agents"
-  question_answered: "Where does this information go, and how does the agent find it?"
-
-sibling_artifact_set:
-  name: "design-principles"
-  domain: "code (src/, tests/, packages/, etc.)"
-  owns: "HOW to design and write code that AI agents produce"
-  question_answered: "What patterns, boundaries, and contracts should the code follow?"
+principle: "Git records what changed and when. Documentation uses this record to stay accountable."
+governed_aspects:
+  commit_message_format: "Conventional Commits prefix (docs:, feat:, fix:) + Japanese description. See FILE_AND_STRUCTURE.md."
+  version_tracking: "Each document records its version and the git commit hash it was last updated at. See FILE_AND_STRUCTURE.md."
+not_governed:
+  - "When to commit (code-side decision)"
+  - "Whether to branch (code-side decision)"
+  - "Review process (code-side decision)"
 ```
 
-### Usage Patterns
+Documentation commits should be identifiable in git history. A documentation
+change that describes a code change should record which commit that code change
+was in, so the reader can verify the document matches the code.
 
-Both sets are designed to be placed in a target project and read by AI agents.
-Two usage patterns are expected:
-
-```yaml
-pattern_1_independent:
-  description: "User references one set for a domain-specific task."
-  examples:
-    - "Fix a code bug → reference design-principles/"
-    - "Update project documents → reference documentation-strategy/"
-
-pattern_2_combined:
-  description: "User references both sets at once for a full-project task."
-  examples:
-    - "'Develop this project following @documents/artifacts/' (both folders)"
-    - "Project AGENTS.md lists both artifact sets as references"
-  implication: "The AI agent holds both contexts simultaneously."
-```
-
-### Shared Concepts (Intentional Overlap)
+---
 
-Some concepts appear in both sets. This is intentional — each set applies the
-concept to its own domain independently. When both are read simultaneously,
-the agent applies the concept from the set whose domain matches the task.
+## Single Source of Truth
 
 ```yaml
-shared_concepts:
-  single_source_of_truth: "Both define SSOT for their own artifacts. No conflict — each owns its own doc set."
-  brownfield_policy: "Both define how to handle existing non-conforming work. Code violations follow design-principles; document violations follow documentation-strategy."
-  confirmation_gate: "Both define L0–L3 severity levels. Code changes use design-principles' gate; document changes use documentation-strategy's gate."
-  operational_discipline: "Both define reporting and clarification rules. Apply the one matching the task domain."
-  proportionality: "Both scale effort to blast radius. Each within its own domain."
+principle: "Each piece of information lives in exactly one document."
+rules:
+  - "If a concept appears in two files, one owns it and the other links."
+  - "Restatement is allowed as at most one sentence + a link to the owner."
+  - "On conflict between documents, the owning document is authoritative."
+  - "Splitting a topic into 'why' and 'how' is allowed; join them with cross-references."
 ```
 
-### Divergent Policies (Intentional Difference)
+---
 
-Some policies intentionally differ between the two sets because documents and
-code have different version-control needs.
+## Universality
 
 ```yaml
-divergent_policies:
-  version_control:
-    design_principles: "Code changes may use branches. If on the default branch, create a branch before committing."
-    documentation_strategy: "Documentation changes commit directly to the working branch. Do NOT create branches for documentation-only changes."
-    rationale: "Documentation requires atomicity — all related documents must stay consistent in one commit. A branch with different documentation state from the main branch is a defect, not a feature. Code, by contrast, benefits from branch isolation for review and rollback."
-  reporting_language:
-    note: "Both sets defer to the project's global agent rules (e.g., AGENTS.md) for reporting language. Neither overrides global communication policy."
+principle: "The strategy works for any project that uses AI agents."
+scope:
+  single_project: "One repository, one documents/ tree, one INDEX.md."
+  hierarchical_project: "Parent + child projects, each with independent documents/ trees."
+  scale_independence: "From a single-script repo to a multi-service monorepo."
 ```
 
-### When Both Are Read Simultaneously
-
-```yaml
-guidance:
-  domain_routing: "If the task touches code (src/, tests/), follow design-principles. If the task touches documents (documents/, README.md), follow documentation-strategy."
-  mixed_tasks: "If a task touches both code and documents (e.g., add a feature AND update PROJECT.md), apply each set to its respective domain. Do not mix rules across domains."
-  conflict_resolution: "If a concept exists in both sets, the set whose domain matches the current action is authoritative. Shared concepts (SSOT, Brownfield, Gate) are applied per-domain, not merged."
-```
+> **Single source of truth**: hierarchical structure rules live in
+> `FILE_AND_STRUCTURE.md` → "Hierarchical Projects".
 
 ---
 
-## Common Misreadings to Prevent
-
-These principles are easy to over-read. Do NOT collapse them into:
+## Common Misreadings
 
 ```yaml
 misreadings:
-  - "'AI efficiency > human readability' != humans don't matter (README is explicitly human-facing; the rule applies to AI-facing files only)"
-  - "'token optimization' != make everything one file (routing and cognitive load also matter — see Design Priorities)"
+  - "'accuracy > tokens' != ignore token cost (structure files well so the agent reads efficiently; just never delete information to save tokens)"
+  - "'documents/ is AI-facing' != humans cannot read it (they can; it is optimized for AI, not restricted from humans)"
+  - "'routing over truncation' != make infinite tiny files (one file = one concern; split when a file covers multiple concerns, not when it hits a token count)"
+  - "'git as recording' != we control git workflow (we control commit message format and version tracking; timing and branching are code-side)"
+  - "'docs-jp/ for humans' != documents/ cannot have Japanese (it can if the AI agent needs Japanese context; the default is English for processing efficiency)"
   - "'single source of truth' != never mention a concept twice (one-sentence restatement + link is allowed)"
-  - "'entry files ≤200 tokens' != starve the agent of information (the entry file ROUTES to detail; it is not the detail)"
-  - "'universality' != one rigid template (the strategy adapts to single and hierarchical projects; structure follows project shape)"
-  - "'YAML blocks preferred' != ban all prose (explanations and examples use markdown; YAML is for structured data)"
-  - "'documents/agents/ is AI-only' != humans cannot read it (they can; it is optimized for AI, not restricted from humans)"
-  - "'child independence' != children cannot coordinate with parent (they treat parent as an external project reference when needed)"
-  - "this strategy != a documentation generator (it defines structure and routing; the AI agent writes the content following these rules)"
+  - "'universality' != one rigid template (the strategy adapts to single and hierarchical projects)"
+  - "this strategy != a documentation generator (it defines structure and routing; the AI agent writes content following these rules)"
 ```
~~~~

### `artifacts/DOCUMENT_WORKFLOW.md`

~~~~diff
@@ -1,21 +1,17 @@
-# Document Workflow - Operational Guidelines
+# Document Workflow
 
 ```yaml
 document_type: "workflow"
 target_audience: "ai_agents"
-optimization: "process_consistency"
 language: "english"
+strategy_version: "2.0.0"
 ```
 
-This document defines the operational procedures for applying the documentation
-strategy: setting up a new project, adopting the strategy in an existing project,
-updating documents during development, and knowing when to re-read this strategy.
-
 ```yaml
 ownership_split:
   this_doc: "FLOW — when to act, what steps to follow, when to confirm"
-  FILE_AND_STRUCTURE.md: "HOW + WHERE — file roles, directory layout, token limits"
-  DOCUMENTATION_PHILOSOPHY.md: "WHY — principles behind the rules"
+  FILE_AND_STRUCTURE.md: "HOW + WHERE — file roles, directory layout, versioning, git conventions"
+  DOCUMENTATION_PHILOSOPHY.md: "WHY — accuracy priority, scope, git as recording"
   INDEX.md: "routes to all of the above"
 ```
 
@@ -24,10 +20,9 @@ ownership_split:
 ## Use Cases
 
 ```yaml
-use_cases:
-  1_new_project: "Apply the strategy from scratch — no existing documentation structure."
-  2_existing_project: "Adopt the strategy in a project that already has documentation (brownfield)."
-  3_ongoing_updates: "The project already follows this strategy; update or add documents during development."
+1_new_project: "Apply the strategy from scratch."
+2_existing_project: "Adopt the strategy in a project that already has documentation."
+3_ongoing_updates: "The project follows the strategy; update documents during development."
 ```
 
 ---
@@ -44,65 +39,74 @@ files:
   CLAUDE_md: "if using Claude Code"
   AGENTS_md: "if using Devin or Codex"
   GEMINI_md: "if using Gemini"
-token_limit: 200
-content_template:
+content:
   essential:
     - "role: the agent's responsibility in this project"
-    - "constraints: project-specific rules the agent must follow"
+    - "constraints: project-specific rules"
     - "emergency_action: what to do if intent is unclear"
   routing:
-    - "primary_ref: documents/agents/project.md (or documents/PROJECT.md)"
-    - "task_routing: map task types to specific documents"
+    - "primary_ref: documents/INDEX.md"
   efficiency:
     - "focus_files: glob patterns for the agent to prioritize"
     - "current_priority: the current development focus"
+rule: "The entry file routes to documents/INDEX.md. It does not contain project detail."
 ```
 
-### Step 2: Create the Documents Directory
+### Step 2: Create the documents/ Directory
 
 ```yaml
 action: "Create the directory tree."
 structure:
-  - "documents/ (shared specs)"
-  - "documents/agents/ (AI-facing docs, English)"
-  - "documents/users/ (human-facing docs, Japanese, _JP.md suffix)"
+  - "documents/INDEX.md (required — create in Step 3)"
+  - "documents/project/ (project-level context)"
+  - "documents/reference/ (reference material)"
 rule: "Only create directories you will populate. Do not create empty directories speculatively (YAGNI)."
 ```
 
-### Step 3: Create PROJECT.md
+### Step 3: Create documents/INDEX.md
+
+```yaml
+action: "Create the routing hub and version registry."
+content:
+  - "Document inventory: list every file under documents/ with its purpose"
+  - "Routing map: which document to read for which task"
+  - "Version registry: each document's version + last-updated git commit hash"
+  - "Cross-reference map"
+format: "See FILE_AND_STRUCTURE.md → §4 Document Versioning System"
+```
+
+### Step 4: Create Project Documents
 
 ```yaml
-action: "Create the project overview file."
-placement: "documents/agents/project.md (preferred) or documents/PROJECT.md"
-token_limit: 800
+action: "Create project-level context documents in documents/project/."
 content:
-  - "project name, status, priority"
-  - "tech stack and architecture"
-  - "constraints (test coverage, security, compliance)"
-  - "current phase and focus areas"
-  - "routing to task-specific documents"
+  - "Project overview, objectives, scope"
+  - "Architecture summary"
+  - "Constraints (business rules, compliance, performance)"
+  - "Current status and roadmap"
+rule: "One file = one concern. Split when a file covers multiple concerns."
+versioning: "Each file starts at version 1.0.0 with the current commit hash."
 ```
 
-### Step 4: Create README.md
+### Step 5: Create docs-jp/ (If Human-Facing Content Is Needed)
 
 ```yaml
-action: "Create the human-facing entry point."
-language: "project's human language (Japanese primary target)"
+action: "Create docs-jp/ for human-facing documentation."
 content:
-  - "project description and purpose"
-  - "setup and usage instructions"
-  - "contribution guidelines"
-  - "project background"
-token_limit: none
+  - "Project background and motivation"
+  - "Setup tutorials"
+  - "Design rationale"
+rule: "Human-facing content does NOT go under documents/. It goes in docs-jp/."
 ```
 
-### Step 5: Add Task-Specific Documents As Needed
+### Step 6: Add Reference and Topic-Specific Documents As Needed
 
 ```yaml
 action: "Create documents as the project grows — not all at once."
-trigger: "When a task requires context that does not fit in PROJECT.md (800 tokens), extract it into a task-specific file."
-placement: "documents/agents/<topic>.md (AI-facing) or documents/users/<topic>_JP.md (human-facing)"
+trigger: "When a task requires context that does not fit in existing project documents, create a new file."
+placement: "documents/reference/<topic>.md or documents/<topic>/<topic>.md"
 rule: "Prefer fewer files with clear routing over many files with overlapping content."
+versioning: "Register every new file in documents/INDEX.md with version 1.0.0."
 ```
 
 ---
@@ -116,83 +120,73 @@ rule: "Prefer fewer files with clear routing over many files with overlapping co
 ```yaml
 action: "Read all existing documentation and classify each file."
 classification:
-  ai_facing: "content an AI agent needs during development (specs, constraints, architecture)"
+  ai_facing: "content an AI agent needs during development"
   human_facing: "content for human developers (setup, tutorials, background)"
-  shared: "content both audiences need (API schemas, data models)"
+  shared: "content both audiences need"
   obsolete: "outdated or redundant content"
 ```
 
 ### Step 2: Map to the New Structure
 
 ```yaml
-action: "Decide where each piece of information belongs."
 mapping:
-  ai_facing: "documents/agents/ (English, no suffix)"
-  human_facing: "documents/users/ (Japanese, _JP.md suffix)"
-  shared: "documents/ (context-dependent language)"
+  ai_facing: "documents/project/ or documents/reference/ (AI-facing)"
+  human_facing: "docs-jp/ (human-facing)"
+  shared: "documents/ (AI-facing by default; extract human summary to docs-jp/ if needed)"
   obsolete: "remove or archive — do not migrate"
 ```
 
-### Step 3: Create Agent Entry Files
-
-```yaml
-action: "Create CLAUDE.md / AGENTS.md / GEMINI.md as needed."
-note: "These did not exist before — create them fresh following the New Project Setup steps."
-```
-
-### Step 4: Create or Consolidate PROJECT.md
+### Step 3: Create Agent Entry Files and INDEX.md
 
 ```yaml
-action: "Extract project-level context from existing docs into PROJECT.md."
-token_limit: 800
-rule: "Do NOT copy entire existing documents into PROJECT.md. Extract the essential context and route to details."
-conflict: "If existing docs contradict each other, flag the conflict to the user — do not silently pick one."
+action: "Create CLAUDE.md / AGENTS.md / GEMINI.md as needed, and documents/INDEX.md."
+note: "Follow Use Case 1 Steps 1–3 for these."
 ```
 
-### Step 5: Migrate Documents
+### Step 4: Migrate Documents
 
 ```yaml
-action: "Move or rewrite existing documents into the new directory structure."
+action: "Move or rewrite existing documents into the new structure."
 rules:
-  - "Rewrite for token efficiency if the original was prose-heavy."
-  - "Convert structured data to YAML blocks where appropriate."
+  - "AI-facing content goes to documents/ with proper versioning."
+  - "Human-facing content goes to docs-jp/."
   - "Eliminate duplication: if two files covered the same topic, merge into one and link from the other."
   - "Preserve information — do not delete content without user confirmation."
   - "Report what was moved, merged, or flagged as obsolete."
 ```
 
-### Step 6: Update Cross-References
+### Step 5: Update INDEX.md and Cross-References
 
 ```yaml
-action: "Fix any internal references broken by the migration."
-check: "All routing paths in agent entry files and PROJECT.md point to correct locations."
+action: "Register all migrated documents in documents/INDEX.md with version 1.0.0."
+check: "All routing paths in agent entry files and INDEX.md point to correct locations."
 ```
 
 ### Brownfield Guard
 
 ```yaml
 guard:
   scope: "Do NOT let a documentation migration expand into a content rewrite."
-  rule: "Structural migration and content improvement are separate tasks. Do one, then the other — not both at once."
-  violation_handling: "If you find existing documentation that violates the strategy, note it in the report. Do NOT silently fix it unless the task explicitly asks for it."
-  local_convention: "Explicit project conventions (existing lint, house style) OUTRANK this strategy where they conflict. Report the conflict once, then follow the local rule."
+  rule: "Structural migration and content improvement are separate tasks. Do one, then the other."
+  violation_handling: "If you find documentation that violates the strategy, note it in the report. Do NOT silently fix it unless the task explicitly asks."
+  local_convention: "Explicit project conventions OUTRANK this strategy where they conflict. Report the conflict once, then follow the local rule."
 ```
 
 ---
 
 ## Use Case 3: Ongoing Document Updates
 
-**When:** the project already follows this strategy and documents need updating during development.
+**When:** the project follows this strategy and documents need updating.
 
 ### When to Update
 
 ```yaml
 update_triggers:
-  architecture_change: "Update PROJECT.md and affected task-specific docs."
-  new_feature: "Add task-specific docs in documents/agents/ as needed; update PROJECT.md routing."
-  constraint_change: "Update PROJECT.md constraints section and agent entry files if the constraint affects agent behavior."
-  tech_stack_change: "Update PROJECT.md tech_stack; review whether existing docs are still accurate."
-  directory_restructure: "Update all routing references in agent entry files and PROJECT.md."
+  architecture_change: "Update project architecture docs and INDEX.md version registry."
+  new_feature: "Add reference docs as needed; update INDEX.md routing."
+  constraint_change: "Update project constraints document and INDEX.md version registry."
+  tech_stack_change: "Update project docs; review whether existing docs are still accurate."
+  directory_restructure: "Update all routing references in INDEX.md and agent entry files."
 ```
 
 ### What to Update
@@ -201,13 +195,13 @@ update_triggers:
 decision_tree:
   question: "Does the change affect what an AI agent needs to know?"
   yes:
-    action: "Update the relevant AI-facing document."
-    check: "Is the information already in PROJECT.md, or does it need a task-specific file?"
-    in_project_md: "Update PROJECT.md (stay under 800 tokens)."
-    needs_own_file: "Create or update documents/agents/<topic>.md and add routing from PROJECT.md."
+    action: "Update the relevant document under documents/."
+    check: "Is the information already in an existing file, or does it need a new file?"
+    existing_file: "Update the file and bump its version."
+    new_file: "Create the file, register it in INDEX.md, and add routing."
   no:
-    action: "Update only human-facing docs (documents/users/) or README.md if needed."
-    ai_docs: "Leave AI-facing docs unchanged."
+    action: "Update docs-jp/ if human-facing content is affected."
+    ai_docs: "Leave documents/ unchanged."
 ```
 
 ### Update Discipline
@@ -216,33 +210,57 @@ decision_tree:
 rules:
   - "Change-triggered: update documents when the code changes, not on a schedule."
   - "Proportional: a one-line code fix does not require a full documentation review."
-  - "Routing-first: if you add a new document, add its routing reference in PROJECT.md or the agent entry file."
-  - "Token-check: if an update pushes a file over its token limit, split it — do not let it grow unbounded."
+  - "Routing-first: if you add a new document, register it in INDEX.md."
+  - "Accuracy-first: if an update makes a document inaccurate, fix the inaccuracy — do not leave stale information."
   - "SSOT-check: if you add information, verify it does not duplicate an existing document. Link instead of duplicating."
 ```
 
 ---
 
+## Version Bumping Workflow
+
+```yaml
+when_to_bump:
+  major: "Structural change — file added, removed, renamed, or routing significantly changed"
+  minor: "Content addition or significant update — new section, new information"
+  patch: "Small fix — typo, clarification, minor correction"
+
+how_to_bump:
+  1: "Update the document's version header (document_version, last_updated_commit, last_updated_date)."
+  2: "Update the corresponding entry in documents/INDEX.md version registry."
+  3: "Record the git commit hash of the commit that includes the update."
+  4: "Use the appropriate commit message prefix (see FILE_AND_STRUCTURE.md → Git Commit Conventions)."
+
+example:
+  document: "documents/project/architecture.md"
+  change: "Added a new section about caching strategy"
+  version_bump: "1.0.0 → 1.1.0 (minor — content addition)"
+  commit_message: "feat: アーキテクチャドキュメントにキャッシュ戦略セクションを追加"
+  index_update: "Update version to 1.1.0 and last_updated_commit to the new commit hash"
+```
+
+---
+
 ## Document Creation Decision Tree
 
 ```yaml
 question_1: "Does an AI agent need this information during development?"
-  no: "Place in documents/users/ (human-facing) or README.md."
+  no: "Place in docs-jp/ (human-facing)."
   yes: "Continue to question 2."
 
-question_2: "Is it project-level context (overview, tech stack, constraints, status)?"
-  yes: "Place in PROJECT.md (if under 800 tokens) or extract a summary + link."
+question_2: "Is it project-level context (overview, architecture, constraints, status)?"
+  yes: "Place in documents/project/<topic>.md."
   no: "Continue to question 3."
 
-question_3: "Is it a shared specification or schema (API, data model)?"
-  yes: "Place in documents/ (shared root)."
+question_3: "Is it reference material (specs, schemas, standards, examples)?"
+  yes: "Place in documents/reference/<topic>.md."
   no: "Continue to question 4."
 
-question_4: "Is it task-specific AI-facing detail (workflow, optimization guide, development standard)?"
-  yes: "Place in documents/agents/<topic>.md."
+question_4: "Is it a topic-specific concern that needs its own directory?"
+  yes: "Create documents/<topic>/ and place files there."
   no: "Re-evaluate — it may be human-facing after all."
 
-anti_pattern: "Do not create a new file for every small piece of information. Prefer extending an existing file with a new section + routing update."
+anti_pattern: "Do not create a new file for every small piece of information. Prefer extending an existing file with a new section + INDEX.md routing update."
 ```
 
 ---
@@ -259,15 +277,15 @@ must_re_read:
   - "Adopting this strategy in an existing project (brownfield)."
 
 should_re_read:
-  - "Adding a new agent entry file (e.g., project starts using a new AI tool)."
+  - "Adding a new agent entry file."
   - "Restructuring documents (moving files between directories)."
   - "Changing the project from single to hierarchical (or vice versa)."
   - "Uncertainty about where a piece of information belongs."
 
 no_re_read_needed:
   - "Routine content updates within an existing file."
-  - "Adding a new task-specific document in an established directory."
-  - "Updating constraints or status in PROJECT.md."
+  - "Adding a new document in an established directory."
+  - "Updating constraints or status in an existing project document."
 ```
 
 ---
@@ -277,23 +295,9 @@ no_re_read_needed:
 Before changing the documentation structure, assess the impact.
 
 ```yaml
-L0_internal: "Updating content within an existing file (no structural change) — proceed."
-L1_local: "Adding a new task-specific file in an existing directory — proceed and report."
-L2_structural: "Moving files between directories, changing routing paths, renaming files — proceed only if clearly implied by the task; report explicitly."
-L3_breaking: "Changing the project from single to hierarchical, removing an agent entry file, or restructuring the entire documents/ tree — MUST confirm before implementation."
-rule: "When in doubt, ask the user. Structural changes to documentation affect every future AI agent session."
-```
-
----
-
-## Operational Guidelines
-
-```yaml
-version_control: "Documents are managed in git alongside source code."
-atomicity: "Documentation must stay atomic — all related documents are updated together in one commit. Do NOT split documentation updates across branches; a branch with different documentation state from the main branch is a defect, not a feature."
-no_branch_for_docs: "Do NOT create branches for documentation-only changes. Commit directly to the working branch. Branching is a code-development concern (see design-principles AI_WORKFLOW.md), not a documentation concern."
-update_frequency: "Change-triggered — update documents when the code or architecture changes."
-maintenance: "Review documentation during code review. If a PR changes architecture, it should also update PROJECT.md."
-document_sync: "The AI agent's constraint 'update_related_documents_when_changing_project' enforces this."
-reporting: "When updating documents, report what changed, why, and whether any routing references were updated."
+L0_content: "Updating content within an existing file (no structural change) — proceed."
+L1_additive: "Adding a new file in an existing directory — proceed and report."
+L2_structural: "Moving files, changing routing paths, renaming files — proceed only if clearly implied by the task; report explicitly."
+L3_breaking: "Removing a document, restructuring the entire documents/ tree, changing project from single to hierarchical — MUST confirm before implementation."
+rule: "When in doubt, ask the user. Structural changes affect every future AI agent session."
 ```
~~~~

### `artifacts/FILE_AND_STRUCTURE.md`

~~~~diff
@@ -1,281 +1,320 @@
-# File Roles & Directory Structure - AI Agent Reference
+# File Roles & Directory Structure
 
 ```yaml
 document_type: "file_and_structure"
 target_audience: "ai_agents"
-optimization: "structural_consistency"
 language: "english"
-scope: "file roles, token limits, format standards, directory layout, hierarchy rules"
+strategy_version: "2.0.0"
+scope: "file roles, directory layout, versioning, git conventions, hierarchy"
 ```
 
-This document owns the **physical realization of the documentation strategy**:
-what each file does, how large it may be, where it lives, and how projects are
-structured — including hierarchical (multi-service) projects.
-
 ```yaml
 ownership_split:
-  this_doc: "HOW + WHERE — file roles, token limits, format, directory layout, hierarchy"
-  DOCUMENTATION_PHILOSOPHY.md: "WHY — AI-agent priority, token optimization, SSOT, universality"
-  DOCUMENT_WORKFLOW.md: "FLOW — setup, update, brownfield, re-read triggers"
+  this_doc: "HOW + WHERE — file roles, directory layout, versioning, git conventions, hierarchy"
+  DOCUMENTATION_PHILOSOPHY.md: "WHY — accuracy priority, scope, git as recording"
+  DOCUMENT_WORKFLOW.md: "FLOW — setup, update, version bumping, brownfield"
   INDEX.md: "routes to all of the above"
-rule: "Do not duplicate the principles or the workflow here; link to the owning doc."
 ```
 
 ---
 
-## 1. File Role Definitions
+## 1. Top-Level Directory Layout
 
-### Agent Entry Files (CLAUDE.md, AGENTS.md, GEMINI.md)
+```yaml
+project_root:
+  documents: "AI-facing documentation (all content under here is for AI agents)"
+  docs-jp: "Human-facing documentation (Japanese, for project owners and developers)"
+  artifacts: "Exported strategy files (this set) — copied into target projects"
+  CLAUDE_md: "Claude Code entry point (project root)"
+  AGENTS_md: "Devin / Codex entry point (project root)"
+  GEMINI_md: "Gemini entry point (project root, if used)"
+  README_md: "Brief human-facing project description (points to docs-jp/ for details)"
+```
+
+### documents/ — AI-Facing
 
 ```yaml
-purpose: "AI agent entry point — routes the agent to the right context"
-token_limit: 200
-placement: "project root (one per agent tool)"
-one_per_tool:
-  CLAUDE_md: "Claude Code entry point"
-  AGENTS_md: "Devin / Codex entry point"
-  GEMINI_md: "Gemini entry point"
+rule: "Everything under documents/ is written for AI agents to read."
+language: "English by default. Japanese is allowed when the AI agent needs Japanese context (e.g., Japanese API specs, Japanese domain terms)."
+structure:
+  - "documents/INDEX.md — routing hub + version registry (required)"
+  - "documents/project/ — project-level context (overview, architecture, constraints)"
+  - "documents/reference/ — reference materials (specs, standards, examples)"
+  - "documents/<topic>/ — topic-specific directories as needed"
+principle: "Split by concern, not by audience. There is no audience split inside documents/ — it is all AI-facing."
 ```
 
-**Priority structure within the file:**
+### docs-jp/ — Human-Facing
 
 ```yaml
-high_priority:
-  - "role and responsibility scope"
-  - "immediate action guidelines"
-  - "critical constraints and prohibitions"
-  - "routing to PROJECT.md"
-  - "task-specific document guidance"
-medium_priority:
-  - "frequently used information (direct inclusion to save a lookup)"
-  - "cost optimization processing guidelines"
-  - "unnecessary processing avoidance criteria"
+rule: "Human-facing content lives here, never under documents/."
+language: "Japanese"
+naming: "descriptive.md or descriptive_JP.md"
+content_examples:
+  - "Project background and motivation"
+  - "Setup tutorials for human developers"
+  - "Design rationale and decision records"
+  - "Japanese translations of AI-facing documents (for human review)"
 ```
 
-**Critical design considerations:**
-- Information density must be maximized within the token limit.
-- The file must define an emergency action (what to do if other docs are unavailable).
-- The file routes; it does not explain. Detail lives in PROJECT.md and below.
-- A fallback strategy is required: minimum essential information for initial access.
+---
 
-**When to create vs skip an agent file:**
-- Create one for each AI tool the project actually uses.
-- Do NOT create agent files for tools the project does not use (YAGNI).
-- If only one tool is used, create only that file. The structure scales.
+## 2. File Roles
 
-### PROJECT.md
+### documents/INDEX.md (Required)
 
 ```yaml
-purpose: "project description and routing — the agent's second stop"
-token_limit: 800
-placement: "documents/ (root shared) or documents/agents/ (see Directory Structure)"
-routing_responsibility: true
+purpose: "Routing hub + document version registry"
+placement: "documents/INDEX.md"
+required: true
 content:
-  - "project overview and objectives"
-  - "tech stack and architecture"
-  - "constraints and business rules"
-  - "current status and progress"
-  - "routing to task-specific documents"
+  - "Document inventory: every file under documents/ with its purpose"
+  - "Routing map: which document to read for which task"
+  - "Version registry: each document's version + last-updated git commit hash"
+  - "Cross-reference map: which documents link to which"
 ```
 
-**Why 800 tokens:** enough for a single AI processing pass that gives the agent
-project-level context without exceeding typical context-window efficiency
-thresholds. Larger than 800 → split into task-specific files and route to them.
+See §4 "Document Versioning System" for the version registry format.
 
-### README.md
+### Agent Entry Files (CLAUDE.md, AGENTS.md, GEMINI.md)
 
 ```yaml
-purpose: "human interface only — the one human-readable exception"
-token_limit: none
-placement: "project root"
+purpose: "AI agent entry point — routes to documents/INDEX.md"
+placement: "project root (one per agent tool)"
 content:
-  - "basic project information"
-  - "setup and usage"
-  - "contribution guidelines"
-  - "project background"
-audience: "human developers, not AI agents"
+  - "role: the agent's responsibility in this project"
+  - "constraints: project-specific rules"
+  - "emergency_action: what to do if intent is unclear"
+  - "routing: documents/INDEX.md as primary reference"
+  - "focus_files: glob patterns the agent should prioritize"
+  - "current_priority: the current development focus"
+design_rule: "The entry file routes; it does not explain. Detail lives under documents/."
+when_to_create: "One file per AI tool the project actually uses. Do not create files for unused tools (YAGNI)."
 ```
 
-**Rule:** AI agents should NOT rely on README.md for project context. It is
-human-facing and may contain prose, tutorials, and background that waste tokens.
-The agent entry files and PROJECT.md are the AI's context path.
+### Project Documents (documents/project/)
 
----
+```yaml
+purpose: "Project-level context the AI agent needs for every task"
+placement: "documents/project/"
+content_examples:
+  - "Project overview, objectives, scope"
+  - "Architecture summary"
+  - "Constraints (business rules, compliance, performance)"
+  - "Current status and roadmap"
+routing_rule: "INDEX.md routes to these files. Each file covers one concern."
+```
 
-## 2. Token Limits
+### Reference Documents (documents/reference/)
 
 ```yaml
-limits:
-  agent_entry_files: 200
-  PROJECT_md: 800
-  task_specific_docs: "no hard limit, but prefer splitting over 800"
-  README_md: "none (human-facing exception)"
-rationale:
-  "200": "entry files route, they do not explain. 200 tokens is enough for role + constraints + routing."
-  "800": "one processing pass of project-level context. Beyond this, the agent should be routed to task-specific files."
-enforcement: "soft — exceeding by a small margin is acceptable if it prevents a file split that would hurt routing clarity. Gross violation → restructure."
+purpose: "Reference material the agent reads on demand"
+placement: "documents/reference/"
+content_examples:
+  - "API specifications, data models, schemas"
+  - "Coding standards specific to the project"
+  - "Example projects demonstrating the strategy"
+  - "Glossary, domain terms"
+routing_rule: "Project documents and INDEX.md link to these when needed. The agent does not read them unless a task requires it."
 ```
 
----
-
-## 3. File Format Standards
+### README.md
 
 ```yaml
-format_priority: "AI efficiency > human readability"
-base_format: "markdown with embedded YAML blocks"
-processing_efficiency: "maximum AI parsing speed"
+purpose: "Brief human-facing project description"
+placement: "project root"
+audience: "human developers, project owners"
+content: "One-paragraph project summary + pointer to docs-jp/ for details"
+rule: "AI agents should NOT rely on README.md for project context. It is human-facing."
 ```
 
-### Format Selection Guide
+---
+
+## 3. Cross-Reference and Routing Strategy
 
 ```yaml
-structured_data: "YAML (settings, metadata, lists, configuration)"
-explanations: "markdown (procedures, guides, rationale)"
-api_specs: "JSON (OpenAPI, machine-readable schemas)"
-mixed: "markdown + YAML blocks (most efficient — structure + context in one file)"
+routing_chain: "agent.md → documents/INDEX.md → project/ or reference/ → detail files"
+principles:
+  - "INDEX.md is the single routing hub. Every document is listed there."
+  - "Each document links to related documents instead of duplicating content."
+  - "One file = one concern. A task that touches one concern should require reading one file."
+  - "The agent follows the routing chain only as far as needed."
+  - "Cross-references use relative paths from the project root."
 ```
 
-### Format Usage by File Type
+### Reference Format
 
 ```yaml
-agent_entry_files: "structured markdown with YAML blocks"
-PROJECT_md: "markdown with YAML sections"
-documents: "markdown / YAML / JSON (flexible — choose by content)"
-README_md: "standard markdown (human-facing exception — prose allowed)"
+format: "markdown links with brief context"
+example: "See [documents/project/architecture.md](../project/architecture.md) for the architecture overview."
+rule: "Never duplicate content that exists elsewhere. Link to it with a one-sentence description."
 ```
 
 ---
 
-## 4. Directory Structure
+## 4. Document Versioning System
 
-### Single Project
+Every document under `documents/` (except INDEX.md itself) has a version and
+tracks the git commit at which it was last updated.
+
+### Version Format
 
 ```yaml
-project_structure:
-  root_files:
-    - "CLAUDE.md      # ≤200 tokens (Claude Code entry)"
-    - "AGENTS.md      # ≤200 tokens (Devin/Codex entry)"
-    - "GEMINI.md      # ≤200 tokens (Gemini entry, if used)"
-    - "README.md      # human interface only"
-  documents:
-    root: "documents/ — shared specifications and schemas"
-    agents: "documents/agents/ — AI-optimized documentation (English, no suffix)"
-    users: "documents/users/ — human-readable documentation (Japanese, _JP.md suffix)"
-  source_code: true
+scheme: "semantic versioning (MAJOR.MINOR.PATCH)"
+major: "Structural change — file added, removed, renamed, or routing significantly changed"
+minor: "Content addition or significant update — new section, new information"
+patch: "Small fix — typo, clarification, minor correction"
+initial_version: "1.0.0"
+```
+
+### Version Registry in INDEX.md
+
+```yaml
+# Example entry in documents/INDEX.md
+documents:
+  - path: "documents/project/overview.md"
+    version: "1.2.0"
+    last_updated_commit: "abc1234"
+    last_updated_date: "2024-07-09"
+    purpose: "Project overview and objectives"
+  - path: "documents/project/architecture.md"
+    version: "1.0.0"
+    last_updated_commit: "def5678"
+    last_updated_date: "2024-07-09"
+    purpose: "Architecture summary"
 ```
 
-### Directory Responsibilities
+### Per-Document Header
+
+Each document includes a version header at the top:
 
 ```yaml
-"documents/":
-  content: "shared specifications, schemas, APIs"
-  audience: "both AI agents and humans"
-  language: "context-dependent (technical specs often English)"
-  naming: "descriptive.md or descriptive.json"
-
-"documents/agents/":
-  content: "project details, workflows, optimization guides for AI"
-  audience: "AI agents only"
-  language: "English (processing efficiency)"
-  naming: "descriptive.md (no language suffix)"
-  optimization: "token efficiency priority"
-
-"documents/users/":
-  content: "setup guides, explanations, tutorials for humans"
-  audience: "human developers"
-  language: "Japanese (primary target language)"
-  naming: "descriptive_JP.md (language suffix required)"
-  optimization: "comprehensibility priority"
+# At the top of each document file
+---
+document_version: "1.2.0"
+last_updated_commit: "abc1234"
+last_updated_date: "2024-07-09"
+---
 ```
 
-### Reference & Routing Strategy
+### Why Track Commit Hash
 
 ```yaml
-ai_workflow: "agent.md → documents/agents/project.md → task-specific files"
-human_workflow: "README.md → documents/users/setup_JP.md → detailed guides"
-shared_specs: "both reference documents/ for API specs, schemas, standards"
-gradual_disclosure: "agent.md → PROJECT.md → documents/agents/ → documents/ (shared specs)"
-lost_prevention: "clear directory purpose prevents confusion — each directory has one role"
+rationale: |
+  When an AI agent reads a document, it can check the commit hash to verify
+  whether the document reflects the current state of the code. If the document's
+  last_updated_commit is behind HEAD, the agent knows the document may be stale
+  and should be verified against the code before relying on it.
 ```
 
 ---
 
-## 5. Hierarchical Projects (OOP Design)
+## 5. Git Commit Message Conventions
 
-For multi-service or multi-package projects, apply OOP-style encapsulation to
-the documentation structure.
+Documentation commits use Conventional Commits prefixes with Japanese descriptions.
 
-### Hierarchy Principles
+### Format
 
 ```yaml
-child_independence: "complete independence — child does not know parent exists"
-parent_containment: "parent manages all child project information"
-information_flow: "parent → child (unidirectional only)"
-external_reference: "child treats parent as external project if coordination needed"
-encapsulation: "child does not know parent implementation details"
-oop_analogy: "similar to object-oriented class containment design"
+format: "<type>: <Japanese description>"
+types:
+  docs: "Documentation changes (new file, content update, routing change)"
+  feat: "New documentation feature (new section, new versioning entry)"
+  fix: "Documentation fix (correcting inaccurate information)"
+  refactor: "Documentation restructuring (moving files, reorganizing sections)"
+  chore: "Maintenance (version bump, metadata update)"
+examples:
+  - "docs: プロジェクト概要を更新"
+  - "fix: API仕様のエンドポイントURLを修正"
+  - "refactor: documents/reference/ 配下を整理"
+  - "feat: セキュリティ要件ドキュメントを追加"
+  - "chore: ドキュメントバージョンを1.2.0に更新"
 ```
 
-### Structure
+### Rules
 
 ```yaml
-parent_project:
-  files: ["CLAUDE.md", "AGENTS.md", "GEMINI.md", "README.md"]
-  documents:
-    shared_root: "documents/ (shared specifications)"
-    agents: "documents/agents/ (parent project AI docs)"
-    users: "documents/users/ (parent project human docs)"
-    child_management: "documents/agents/children.md (child project coordination)"
+rules:
+  - "Use Japanese for the description after the prefix."
+  - "The prefix is English (docs:, feat:, fix:, refactor:, chore:)."
+  - "Description should be concise and describe what changed, not why (the diff shows why)."
+  - "If a documentation commit accompanies a code change, the documentation commit should reference the code commit hash in its body."
+```
 
-child_projects:
-  independence: "complete independence without parent knowledge"
-  structure:
-    files: ["CLAUDE.md", "AGENTS.md", "GEMINI.md", "README.md"]
-    documents:
-      shared_root: "documents/ (child-specific shared specs)"
-      agents: "documents/agents/ (child AI docs, parent unaware)"
-      users: "documents/users/ (child human docs, parent unaware)"
-  parent_awareness: false
-  external_reference: "treat parent as external project if coordination needed"
+### What We Do NOT Govern
+
+```yaml
+not_governed:
+  - "When to commit (that is a code-side / development workflow decision)"
+  - "Whether to branch (that is a code-side / development workflow decision)"
+  - "Commit size or granularity (that is a development practice decision)"
 ```
 
-### Parent's children.md
+---
 
-The parent project maintains a coordination file at `documents/agents/children.md`
-that lists child projects, their boundaries, and inter-service communication
-patterns. This file is parent-only — children do not reference it.
+## 6. File Format Standards
+
+```yaml
+base_format: "markdown with embedded YAML blocks"
+format_selection:
+  structured_data: "YAML (settings, metadata, version registries, lists)"
+  explanations: "markdown (procedures, guides, rationale)"
+  api_specs: "JSON or YAML (OpenAPI, machine-readable schemas)"
+  mixed: "markdown + YAML blocks (structure + context in one file)"
+naming: "lowercase, hyphen-separated for files; directories are lowercase"
+```
 
 ---
 
-## 6. Information Priority
+## 7. Hierarchical Projects
 
-### AI Agent Priority Order
+For multi-service or multi-package projects, each child has an independent
+`documents/` tree. The parent does not enter children's trees.
+
+### Principles
 
 ```yaml
-1: "agent.md (root directory entry point — CLAUDE.md / AGENTS.md / GEMINI.md)"
-2: "documents/agents/project.md (AI-specific project details)"
-3: "documents/agents/ (detailed AI-optimized information, task-specific)"
-4: "documents/ (shared specifications and schemas)"
-5: "README.md (human interface — last resort, not designed for AI)"
+child_independence: "Each child has its own documents/INDEX.md and version registry."
+parent_containment: "Parent's documents/ describes children at a high level but does not duplicate child details."
+information_flow: "Parent → child (unidirectional). Child does not reference parent's internal documents."
+external_reference: "If a child needs parent context, it treats the parent as an external project."
 ```
 
-### Human Priority Order
+### Structure
+
+```yaml
+parent_project:
+  documents:
+    index: "documents/INDEX.md (parent's routing + version registry)"
+    project: "documents/project/ (parent project context)"
+    reference: "documents/reference/ (shared reference, child-overview)"
+    children_overview: "documents/project/children.md (high-level child descriptions, parent-only)"
+
+child_projects:
+  each_child:
+    documents: "Independent documents/ tree with its own INDEX.md"
+    parent_awareness: false
+    rule: "Child's INDEX.md does not list parent documents. Child is self-contained."
+```
+
+### Parent's children.md
 
 ```yaml
-1: "README.md (human entry point)"
-2: "documents/users/setup_JP.md (setup and getting started)"
-3: "documents/ (shared specifications when needed)"
-4: "documents/users/ (detailed human-readable guides)"
+placement: "documents/project/children.md"
+purpose: "High-level overview of child projects — names, boundaries, responsibilities, inter-service communication"
+audience: "parent-level AI agents only"
+rule: "Children do not reference this file. Children are unaware of each other unless explicitly coordinated."
 ```
 
 ---
 
 ## How These Interlock
 
 ```yaml
-entry_file_routes: "agent.md defines role + routes to PROJECT.md"
-project_file_routes: "PROJECT.md gives context + routes to task-specific docs"
-directory_purpose_routes: "documents/agents/ vs documents/users/ vs documents/ — audience decides placement"
-hierarchy_encapsulates: "parent and child each have independent doc trees; coordination via children.md (parent-only)"
-one_idea: "Make the entry file the router, PROJECT.md the context, and directories the audience boundary. Hierarchy repeats this pattern per level."
+entry_file_routes: "agent.md routes to documents/INDEX.md"
+index_routes: "INDEX.md routes to project/ or reference/ based on the task"
+version_registry: "INDEX.md tracks every document's version + commit hash for staleness detection"
+cross_references: "Documents link to each other instead of duplicating content"
+hierarchy: "Parent and child each have independent documents/ trees; coordination via parent's children.md"
+one_idea: "INDEX.md is the map, documents are the destinations, version headers are the timestamps. The agent reads the map, picks a destination, and follows links only as far as needed."
 ```
~~~~

### `artifacts/INDEX.md`

~~~~diff
@@ -1,97 +1,72 @@
-# AI Agent Documentation Strategy - Index
+# Documentation Strategy - Index
 
 ```yaml
 document_type: "index"
 target_audience: "ai_agents"
-optimization: "token_efficiency"
 language: "english"
-role: "entry point for the exported documentation strategy set"
+role: "entry point for the documentation strategy artifact set"
+strategy_version: "2.0.0"
 ```
 
-This is the entry point for the exported guidance. Read it first.
+This is the entry point for the exported strategy. Read it first.
 
 ## Read Order
 
 ```yaml
-1_philosophy: "DOCUMENTATION_PHILOSOPHY.md"   # WHY:  core values, AI-agent priority, token optimization, misreadings
-2_structure:  "FILE_AND_STRUCTURE.md"         # HOW+WHERE: file roles, token limits, directory layout, hierarchy
-3_workflow:   "DOCUMENT_WORKFLOW.md"           # FLOW: setup, update, brownfield, re-read triggers
+1_philosophy: "DOCUMENTATION_PHILOSOPHY.md"   # WHY:  accuracy priority, scope, git as recording
+2_structure:  "FILE_AND_STRUCTURE.md"         # HOW+WHERE: file roles, directory layout, versioning, git conventions
+3_workflow:   "DOCUMENT_WORKFLOW.md"           # FLOW: setup, update, brownfield, version bumping
 ```
 
-On first contact, read 1 → 2 → 3. For a specific task, jump via the Quick Task Routing below.
-
-## Document Split Policy
-
-```yaml
-split_by: "the question each doc answers — WHY (philosophy) / HOW+WHERE (file roles & structure) / FLOW (workflow); INDEX routes."
-one_owner: "each concept lives in exactly ONE doc — see Ownership Map; link, never duplicate."
-restatement_cap: "when a doc needs a concept it does not own, restate AT MOST one sentence + a link to the owner; on any apparent conflict between docs, the OWNING doc's wording is authoritative."
-not_split_by: ["audience", "language", "feature/domain"]   # all docs are AI-facing, English
-```
-
-## Foundational Lens
-
-These artifacts assume an **AI-Agent Priority** paradigm for documentation.
-
-```yaml
-core_idea: "Documentation is structured so AI agents locate the right context with minimal token cost. Human-facing documents are a separate, clearly-scoped concern — not the default."
-interpret_through: ["token efficiency", "cognitive load reduction", "single source of truth", "routing clarity"]
-do_not_optimize_for: ["human readability (except README)", "exhaustive prose", "redundant explanation"]
-scale_invariant: "the strategy applies to single projects and hierarchical (multi-service) projects alike."
-```
+On first contact, read 1 → 2 → 3. For a specific task, jump via Quick Task Routing.
 
 ## Ownership Map (Single Source of Truth)
 
-Each concept has exactly ONE authoritative document. Do not duplicate; link instead.
+Each concept lives in exactly ONE document. Link, never duplicate.
 
 ```yaml
 DOCUMENTATION_PHILOSOPHY.md:
   owns:
-    - "AI-Agent Priority: definition & rationale"
-    - "Token optimization: the principle (the WHY)"
-    - "Cognitive load reduction: the principle (the WHY)"
-    - "Single source of truth / duplicate elimination: the principle (the WHY)"
-    - "Universality: single and hierarchical projects, any scale"
-    - "Format priority: AI efficiency > human readability (the WHY)"
-    - "Common misreadings to prevent"
-    - "Relationship to design-principles: domain boundary, shared concepts, divergent policies, simultaneous-read guidance"
+    - "Information accuracy as top priority (accuracy > token efficiency)"
+    - "Scope boundary: documents/ only, not code"
+    - "Git as a recording tool (principle, not timing)"
+    - "AI-facing by default; human-facing is a separate concern"
+    - "Routing over truncation: split files, do not shrink information"
+    - "Common misreadings"
 
 FILE_AND_STRUCTURE.md:
   owns:
-    - "Agent entry files (CLAUDE.md, AGENTS.md, GEMINI.md): role, token limit, priority structure"
-    - "PROJECT.md: role, token limit, routing responsibility"
-    - "README.md: role as human-only interface"
-    - "Token limits: 200 / 800 and their rationale"
-    - "File format standards: markdown + YAML blocks, format selection guide"
-    - "Directory structure: documents/, documents/agents/, documents/users/"
-    - "Language and naming conventions per directory"
-    - "Hierarchical projects: OOP design, child independence, parent containment"
-    - "Information priority order (AI and human)"
-    - "Reference and routing strategy between files"
+    - "documents/ directory: all AI-facing"
+    - "docs-jp/ directory: human-facing (Japanese)"
+    - "INDEX.md role: routing hub + document version registry"
+    - "File roles: agent entry files, INDEX.md, project docs, reference docs"
+    - "Document versioning system: semantic version + git commit hash"
+    - "Git commit message conventions for documentation"
+    - "Cross-reference and routing strategy"
+    - "Hierarchical projects (parent-child documentation)"
+    - "File format standards"
 
 DOCUMENT_WORKFLOW.md:
   owns:
-    - "New project setup: step-by-step from strategy to project files"
-    - "Existing project adoption (brownfield): audit, classify, migrate"
-    - "Ongoing document updates: when to update, what to re-read"
-    - "Re-read triggers: when an AI agent should reload this strategy"
-    - "Document creation decision tree: when to create a new file vs extend"
-    - "Operational guidelines: version control, update frequency, maintenance"
-    - "Confirmation gate: when to ask the user before changing documentation structure"
+    - "New project setup: step-by-step"
+    - "Brownfield adoption: audit, classify, migrate"
+    - "Ongoing document updates"
+    - "Version bumping workflow"
+    - "Re-read triggers"
+    - "Confirmation gate (L0–L3)"
 ```
 
 ## Quick Task Routing
 
 ```yaml
-"setting up docs for a new project":           "DOCUMENT_WORKFLOW.md (New Project Setup) + FILE_AND_STRUCTURE.md (File Roles)"
-"adopting this strategy in an existing project": "DOCUMENT_WORKFLOW.md (Brownfield Adoption)"
-"updating an existing document":               "DOCUMENT_WORKFLOW.md (Ongoing Updates) + FILE_AND_STRUCTURE.md (find the right file)"
-"should I create a new doc or extend existing": "DOCUMENT_WORKFLOW.md (Creation Decision Tree)"
-"which file should hold this information":      "FILE_AND_STRUCTURE.md (File Role Definitions) + DOCUMENTATION_PHILOSOPHY.md (SSOT)"
-"how to structure a multi-service project":     "FILE_AND_STRUCTURE.md (Hierarchical Projects)"
-"token limit for a specific file":              "FILE_AND_STRUCTURE.md (Token Limits)"
-"which format to use (YAML/JSON/Markdown)":     "FILE_AND_STRUCTURE.md (File Format Standards)"
-"when should I re-read this strategy":          "DOCUMENT_WORKFLOW.md (Re-read Triggers)"
-"why is README the only human-readable file":   "DOCUMENTATION_PHILOSOPHY.md (AI-Agent Priority + Misreadings)"
-"how does this relate to design-principles":    "DOCUMENTATION_PHILOSOPHY.md (Relationship to design-principles)"
+"setting up docs for a new project":       "DOCUMENT_WORKFLOW.md (New Project Setup) + FILE_AND_STRUCTURE.md (File Roles)"
+"adopting strategy in existing project":    "DOCUMENT_WORKFLOW.md (Brownfield Adoption)"
+"updating an existing document":            "DOCUMENT_WORKFLOW.md (Ongoing Updates) + FILE_AND_STRUCTURE.md (find the right file)"
+"bumping a document version":               "DOCUMENT_WORKFLOW.md (Version Bumping) + FILE_AND_STRUCTURE.md (Versioning System)"
+"writing a git commit message for docs":    "FILE_AND_STRUCTURE.md (Git Commit Conventions)"
+"which file should hold this information":  "FILE_AND_STRUCTURE.md (File Role Definitions)"
+"how to structure a multi-service project": "FILE_AND_STRUCTURE.md (Hierarchical Projects)"
+"setting up documents/INDEX.md":            "FILE_AND_STRUCTURE.md (INDEX.md Role) + DOCUMENT_WORKFLOW.md (New Project Setup)"
+"when should I re-read this strategy":      "DOCUMENT_WORKFLOW.md (Re-read Triggers)"
+"what does this strategy govern":           "DOCUMENTATION_PHILOSOPHY.md (Scope Boundary)"
 ```
~~~~
