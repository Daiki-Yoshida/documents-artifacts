# Source record: 2026-07-09-documentation-split-commit

```yaml
record_type: "verbatim_external_source_snapshot"
source_kind: "Git commit message + GitHub API patch"
source_repository: "Daiki-Yoshida/documentation-strategy"
source_commit: "cf3c5330525cbbfa13d4b729a54db168983f82a8"
source_url: "https://github.com/Daiki-Yoshida/documentation-strategy/commit/cf3c5330525cbbfa13d4b729a54db168983f82a8"
source_author_date: "2026-07-09T12:27:16Z"
retrieved_date: "2026-09-24"
source_text_status: "GitHub APIで取得したcommit messageとpatchのsnapshot"
record_body_policy: "commit messageとpatchは無加工。commit stateで導入・変更された内容の証拠であり、元チャットの提案・承認原文とは区別する"
```

## Commit message原文

~~~~text
Split AI_DOC_STRATEGY.md into 4-file structure and align examples

Split the monolithic AI_DOC_STRATEGY.md into a design-principles-style
multi-file structure with clear ownership boundaries:

- INDEX.md: entry point, read order, ownership map, task routing
- DOCUMENTATION_PHILOSOPHY.md: WHY — core principles, misreadings, scope boundary
- FILE_AND_STRUCTURE.md: HOW+WHERE — file roles, token limits, directory layout, hierarchy
- DOCUMENT_WORKFLOW.md: FLOW — new project setup, brownfield adoption, ongoing updates, re-read triggers

Update all routing references:
- CLAUDE.md/AGENTS.md route to artifacts/INDEX.md as primary ref
- README.md and PROJECT_OVERVIEW_JP.md list the new 4-file artifact set

Align examples with the new strategy:
- Move PROJECT.md to documents/agents/project.md (preferred placement)
- Move AI-facing docs (security, testing, architecture, children, authentication) to documents/agents/
- Add AGENTS.md to all example projects (single, multi parent, UserService, ProductService)
- Update all routing references in CLAUDE.md, GEMINI.md, and PROJECT.md files
- api-specs.md remains in documents/ (shared spec, both audiences)

Generated with [Devin](https://devin.ai)

Co-Authored-By: Devin <158243242+devin-ai-integration[bot]@users.noreply.github.com>
~~~~

## GitHub API patch snapshot

### `artifacts/DOCUMENTATION_PHILOSOPHY.md`

~~~~diff
@@ -0,0 +1,159 @@
+# Documentation Philosophy - AI Agent Reference
+
+```yaml
+document_type: "documentation_philosophy"
+target_audience: "ai_agents"
+optimization: "token_efficiency"
+language: "english"
+core_value: "AI_Agent_Priority"
+```
+
+## Core Philosophy: AI-Agent Priority
+
+Documentation is structured so AI agents locate the right context with minimal token cost. Human-facing documents are a separate, clearly-scoped concern — not the default.
+
+```yaml
+principle: "AI-Agent Priority"
+definition: "Optimize documentation structure for AI agent processing efficiency, not human readability."
+formula: "Efficient context = minimal tokens × correct routing × low cognitive load"
+rationale: |
+  AI agents operate under token limits and processing-cost constraints.
+  Every unnecessary token spent on prose, redundancy, or misrouted lookups
+  degrades performance and increases cost. Structure the documentation so
+  the agent reaches the right information in the fewest tokens possible.
+```
+
+## Design Priorities
+
+```yaml
+priority_order:
+  1: "AI agent processing efficiency (over human readability)"
+  2: "token optimization (minimize consumption per task)"
+  3: "cognitive load reduction (clear routing, no ambiguity)"
+  4: "single source of truth (eliminate duplication)"
+  5: "universality (single and hierarchical projects, any scale)"
+```
+
+When two priorities conflict, the higher number wins. For example: eliminating
+duplication (4) is good, but not if it forces the AI to read three files instead
+of one for a common task (violates 2 and 3).
+
+---
+
+## Token Optimization
+
+```yaml
+principle: "Minimize token consumption per task."
+guidelines:
+  - "Entry files (agent.md) stay under 200 tokens — they route, they do not explain."
+  - "Project files (PROJECT.md) stay under 800 tokens — enough for one processing pass."
+  - "Prefer dense YAML over prose for structured information."
+  - "Link to details instead of inlining them."
+  - "One sentence + link beats one paragraph of restatement."
+  - "No decorative language, no redundant headers, no preamble."
+```
+
+> **Single source of truth**: concrete token limits and file-size rules live in
+> `FILE_AND_STRUCTURE.md`. This section states only the principle (the *why*).
+
+---
+
+## Cognitive Load Reduction
+
+```yaml
+principle: "An AI agent should never guess where information lives."
+mechanisms:
+  routing: "Every entry file contains explicit routing to the next file."
+  single_owner: "Each concept has exactly ONE authoritative document (see INDEX.md → Ownership Map)."
+  directory_purpose: "Each directory has one clear purpose — no ambiguous placement."
+  gradual_disclosure: "Entry → project overview → task-specific detail. Never front-load everything."
+  no_split_by_audience: "All AI-facing docs are English; language is not a routing axis."
+```
+
+---
+
+## Single Source of Truth (Duplicate Elimination)
+
+```yaml
+principle: "Each piece of information lives in exactly one place."
+rules:
+  - "If a concept appears in two files, one must own it and the other must link."
+  - "Restatement is allowed only as AT MOST one sentence + a link to the owner."
+  - "On any apparent conflict between docs, the OWNING doc's wording is authoritative."
+  - "When a document needs a concept it does not own, link — do not re-derive."
+  - "Splitting a topic into 'why' and 'how' is allowed; join them with SSOT pointers."
+```
+
+---
+
+## Universality
+
+```yaml
+principle: "The strategy works for any project that uses AI agents — regardless of scale."
+scope:
+  single_project: "One repository, one set of agent files, one documents/ tree."
+  hierarchical_project: "Parent + child projects with OOP-style encapsulation."
+  scale_independence: "From a single-script repo to a multi-service monorepo."
+target: "projects using AI agents (any scale, any language, any stack)"
+```
+
+> **Single source of truth**: the hierarchical structure rules and child/parent
+> independence live in `FILE_AND_STRUCTURE.md` → "Hierarchical Projects". This
+> section states only the principle (the *why*).
+
+---
+
+## Format Priority
+
+```yaml
+principle: "AI efficiency > human readability."
+base_format: "markdown with embedded YAML blocks"
+rationale: |
+  YAML blocks are dense, parse-friendly, and carry structure without prose overhead.
+  Markdown provides readable section headers for navigation. JSON is used only when
+  the content is a machine schema (e.g., OpenAPI). Human-readable prose is reserved
+  for README.md — the one human-facing exception.
+```
+
+> **Single source of truth**: the format selection guide (when to use YAML vs
+> JSON vs Markdown) lives in `FILE_AND_STRUCTURE.md` → "File Format Standards".
+
+---
+
+## Scope Boundary: Documentation-Strategy vs Coding-Design
+
+This artifact set has a specific responsibility boundary.
+
+```yaml
+this_artifact_set:
+  name: "documentation-strategy"
+  owns: "HOW to structure, route, and maintain documentation for AI agents"
+  question_answered: "Where does this information go, and how does the agent find it?"
+
+sibling_artifact_set:
+  name: "design-principles"
+  owns: "HOW to design and write code that AI agents produce"
+  question_answered: "What patterns, boundaries, and contracts should the code follow?"
+
+boundary_rule: "documentation-strategy governs documents; design-principles governs code. They do not overlap."
+coordination: "A target project may use both. Each is referenced independently from the project's agent entry files."
+```
+
+---
+
+## Common Misreadings to Prevent
+
+These principles are easy to over-read. Do NOT collapse them into:
+
+```yaml
+misreadings:
+  - "'AI efficiency > human readability' != humans don't matter (README is explicitly human-facing; the rule applies to AI-facing files only)"
+  - "'token optimization' != make everything one file (routing and cognitive load also matter — see Design Priorities)"
+  - "'single source of truth' != never mention a concept twice (one-sentence restatement + link is allowed)"
+  - "'entry files ≤200 tokens' != starve the agent of information (the entry file ROUTES to detail; it is not the detail)"
+  - "'universality' != one rigid template (the strategy adapts to single and hierarchical projects; structure follows project shape)"
+  - "'YAML blocks preferred' != ban all prose (explanations and examples use markdown; YAML is for structured data)"
+  - "'documents/agents/ is AI-only' != humans cannot read it (they can; it is optimized for AI, not restricted from humans)"
+  - "'child independence' != children cannot coordinate with parent (they treat parent as an external project reference when needed)"
+  - "this strategy != a documentation generator (it defines structure and routing; the AI agent writes the content following these rules)"
+```
~~~~

### `artifacts/DOCUMENT_WORKFLOW.md`

~~~~diff
@@ -0,0 +1,298 @@
+# Document Workflow - Operational Guidelines
+
+```yaml
+document_type: "workflow"
+target_audience: "ai_agents"
+optimization: "process_consistency"
+language: "english"
+```
+
+This document defines the operational procedures for applying the documentation
+strategy: setting up a new project, adopting the strategy in an existing project,
+updating documents during development, and knowing when to re-read this strategy.
+
+```yaml
+ownership_split:
+  this_doc: "FLOW — when to act, what steps to follow, when to confirm"
+  FILE_AND_STRUCTURE.md: "HOW + WHERE — file roles, directory layout, token limits"
+  DOCUMENTATION_PHILOSOPHY.md: "WHY — principles behind the rules"
+  INDEX.md: "routes to all of the above"
+```
+
+---
+
+## Use Cases
+
+```yaml
+use_cases:
+  1_new_project: "Apply the strategy from scratch — no existing documentation structure."
+  2_existing_project: "Adopt the strategy in a project that already has documentation (brownfield)."
+  3_ongoing_updates: "The project already follows this strategy; update or add documents during development."
+```
+
+---
+
+## Use Case 1: New Project Setup
+
+**When:** starting a new project that will use AI agents.
+
+### Step 1: Create Agent Entry Files
+
+```yaml
+action: "Create one entry file per AI tool the project uses."
+files:
+  CLAUDE_md: "if using Claude Code"
+  AGENTS_md: "if using Devin or Codex"
+  GEMINI_md: "if using Gemini"
+token_limit: 200
+content_template:
+  essential:
+    - "role: the agent's responsibility in this project"
+    - "constraints: project-specific rules the agent must follow"
+    - "emergency_action: what to do if intent is unclear"
+  routing:
+    - "primary_ref: documents/agents/project.md (or documents/PROJECT.md)"
+    - "task_routing: map task types to specific documents"
+  efficiency:
+    - "focus_files: glob patterns for the agent to prioritize"
+    - "current_priority: the current development focus"
+```
+
+### Step 2: Create the Documents Directory
+
+```yaml
+action: "Create the directory tree."
+structure:
+  - "documents/ (shared specs)"
+  - "documents/agents/ (AI-facing docs, English)"
+  - "documents/users/ (human-facing docs, Japanese, _JP.md suffix)"
+rule: "Only create directories you will populate. Do not create empty directories speculatively (YAGNI)."
+```
+
+### Step 3: Create PROJECT.md
+
+```yaml
+action: "Create the project overview file."
+placement: "documents/agents/project.md (preferred) or documents/PROJECT.md"
+token_limit: 800
+content:
+  - "project name, status, priority"
+  - "tech stack and architecture"
+  - "constraints (test coverage, security, compliance)"
+  - "current phase and focus areas"
+  - "routing to task-specific documents"
+```
+
+### Step 4: Create README.md
+
+```yaml
+action: "Create the human-facing entry point."
+language: "project's human language (Japanese primary target)"
+content:
+  - "project description and purpose"
+  - "setup and usage instructions"
+  - "contribution guidelines"
+  - "project background"
+token_limit: none
+```
+
+### Step 5: Add Task-Specific Documents As Needed
+
+```yaml
+action: "Create documents as the project grows — not all at once."
+trigger: "When a task requires context that does not fit in PROJECT.md (800 tokens), extract it into a task-specific file."
+placement: "documents/agents/<topic>.md (AI-facing) or documents/users/<topic>_JP.md (human-facing)"
+rule: "Prefer fewer files with clear routing over many files with overlapping content."
+```
+
+---
+
+## Use Case 2: Existing Project Adoption (Brownfield)
+
+**When:** a project already has documentation but wants to adopt this strategy.
+
+### Step 1: Audit Existing Documentation
+
+```yaml
+action: "Read all existing documentation and classify each file."
+classification:
+  ai_facing: "content an AI agent needs during development (specs, constraints, architecture)"
+  human_facing: "content for human developers (setup, tutorials, background)"
+  shared: "content both audiences need (API schemas, data models)"
+  obsolete: "outdated or redundant content"
+```
+
+### Step 2: Map to the New Structure
+
+```yaml
+action: "Decide where each piece of information belongs."
+mapping:
+  ai_facing: "documents/agents/ (English, no suffix)"
+  human_facing: "documents/users/ (Japanese, _JP.md suffix)"
+  shared: "documents/ (context-dependent language)"
+  obsolete: "remove or archive — do not migrate"
+```
+
+### Step 3: Create Agent Entry Files
+
+```yaml
+action: "Create CLAUDE.md / AGENTS.md / GEMINI.md as needed."
+note: "These did not exist before — create them fresh following the New Project Setup steps."
+```
+
+### Step 4: Create or Consolidate PROJECT.md
+
+```yaml
+action: "Extract project-level context from existing docs into PROJECT.md."
+token_limit: 800
+rule: "Do NOT copy entire existing documents into PROJECT.md. Extract the essential context and route to details."
+conflict: "If existing docs contradict each other, flag the conflict to the user — do not silently pick one."
+```
+
+### Step 5: Migrate Documents
+
+```yaml
+action: "Move or rewrite existing documents into the new directory structure."
+rules:
+  - "Rewrite for token efficiency if the original was prose-heavy."
+  - "Convert structured data to YAML blocks where appropriate."
+  - "Eliminate duplication: if two files covered the same topic, merge into one and link from the other."
+  - "Preserve information — do not delete content without user confirmation."
+  - "Report what was moved, merged, or flagged as obsolete."
+```
+
+### Step 6: Update Cross-References
+
+```yaml
+action: "Fix any internal references broken by the migration."
+check: "All routing paths in agent entry files and PROJECT.md point to correct locations."
+```
+
+### Brownfield Guard
+
+```yaml
+guard:
+  scope: "Do NOT let a documentation migration expand into a content rewrite."
+  rule: "Structural migration and content improvement are separate tasks. Do one, then the other — not both at once."
+  violation_handling: "If you find existing documentation that violates the strategy, note it in the report. Do NOT silently fix it unless the task explicitly asks for it."
+  local_convention: "Explicit project conventions (existing lint, house style) OUTRANK this strategy where they conflict. Report the conflict once, then follow the local rule."
+```
+
+---
+
+## Use Case 3: Ongoing Document Updates
+
+**When:** the project already follows this strategy and documents need updating during development.
+
+### When to Update
+
+```yaml
+update_triggers:
+  architecture_change: "Update PROJECT.md and affected task-specific docs."
+  new_feature: "Add task-specific docs in documents/agents/ as needed; update PROJECT.md routing."
+  constraint_change: "Update PROJECT.md constraints section and agent entry files if the constraint affects agent behavior."
+  tech_stack_change: "Update PROJECT.md tech_stack; review whether existing docs are still accurate."
+  directory_restructure: "Update all routing references in agent entry files and PROJECT.md."
+```
+
+### What to Update
+
+```yaml
+decision_tree:
+  question: "Does the change affect what an AI agent needs to know?"
+  yes:
+    action: "Update the relevant AI-facing document."
+    check: "Is the information already in PROJECT.md, or does it need a task-specific file?"
+    in_project_md: "Update PROJECT.md (stay under 800 tokens)."
+    needs_own_file: "Create or update documents/agents/<topic>.md and add routing from PROJECT.md."
+  no:
+    action: "Update only human-facing docs (documents/users/) or README.md if needed."
+    ai_docs: "Leave AI-facing docs unchanged."
+```
+
+### Update Discipline
+
+```yaml
+rules:
+  - "Change-triggered: update documents when the code changes, not on a schedule."
+  - "Proportional: a one-line code fix does not require a full documentation review."
+  - "Routing-first: if you add a new document, add its routing reference in PROJECT.md or the agent entry file."
+  - "Token-check: if an update pushes a file over its token limit, split it — do not let it grow unbounded."
+  - "SSOT-check: if you add information, verify it does not duplicate an existing document. Link instead of duplicating."
+```
+
+---
+
+## Document Creation Decision Tree
+
+```yaml
+question_1: "Does an AI agent need this information during development?"
+  no: "Place in documents/users/ (human-facing) or README.md."
+  yes: "Continue to question 2."
+
+question_2: "Is it project-level context (overview, tech stack, constraints, status)?"
+  yes: "Place in PROJECT.md (if under 800 tokens) or extract a summary + link."
+  no: "Continue to question 3."
+
+question_3: "Is it a shared specification or schema (API, data model)?"
+  yes: "Place in documents/ (shared root)."
+  no: "Continue to question 4."
+
+question_4: "Is it task-specific AI-facing detail (workflow, optimization guide, development standard)?"
+  yes: "Place in documents/agents/<topic>.md."
+  no: "Re-evaluate — it may be human-facing after all."
+
+anti_pattern: "Do not create a new file for every small piece of information. Prefer extending an existing file with a new section + routing update."
+```
+
+---
+
+## Re-read Triggers
+
+When an AI agent should reload this strategy before acting.
+
+```yaml
+must_re_read:
+  - "First contact with a project using this strategy (read INDEX.md first)."
+  - "Creating or restructuring the documents/ directory tree."
+  - "Setting up a new project that will use AI agents."
+  - "Adopting this strategy in an existing project (brownfield)."
+
+should_re_read:
+  - "Adding a new agent entry file (e.g., project starts using a new AI tool)."
+  - "Restructuring documents (moving files between directories)."
+  - "Changing the project from single to hierarchical (or vice versa)."
+  - "Uncertainty about where a piece of information belongs."
+
+no_re_read_needed:
+  - "Routine content updates within an existing file."
+  - "Adding a new task-specific document in an established directory."
+  - "Updating constraints or status in PROJECT.md."
+```
+
+---
+
+## Confirmation Gate
+
+Before changing the documentation structure, assess the impact.
+
+```yaml
+L0_internal: "Updating content within an existing file (no structural change) — proceed."
+L1_local: "Adding a new task-specific file in an existing directory — proceed and report."
+L2_structural: "Moving files between directories, changing routing paths, renaming files — proceed only if clearly implied by the task; report explicitly."
+L3_breaking: "Changing the project from single to hierarchical, removing an agent entry file, or restructuring the entire documents/ tree — MUST confirm before implementation."
+rule: "When in doubt, ask the user. Structural changes to documentation affect every future AI agent session."
+```
+
+---
+
+## Operational Guidelines
+
+```yaml
+version_control: "Documents are managed in git alongside source code."
+multi_developer: "Standard git workflow (PR/merge) applies to documentation."
+update_frequency: "Change-triggered — update documents when the code or architecture changes."
+maintenance: "Review documentation during code review. If a PR changes architecture, it should also update PROJECT.md."
+document_sync: "The AI agent's constraint 'update_related_documents_when_changing_project' enforces this."
+reporting: "When updating documents, report what changed, why, and whether any routing references were updated."
+```
~~~~

### `artifacts/FILE_AND_STRUCTURE.md`

~~~~diff
@@ -0,0 +1,281 @@
+# File Roles & Directory Structure - AI Agent Reference
+
+```yaml
+document_type: "file_and_structure"
+target_audience: "ai_agents"
+optimization: "structural_consistency"
+language: "english"
+scope: "file roles, token limits, format standards, directory layout, hierarchy rules"
+```
+
+This document owns the **physical realization of the documentation strategy**:
+what each file does, how large it may be, where it lives, and how projects are
+structured — including hierarchical (multi-service) projects.
+
+```yaml
+ownership_split:
+  this_doc: "HOW + WHERE — file roles, token limits, format, directory layout, hierarchy"
+  DOCUMENTATION_PHILOSOPHY.md: "WHY — AI-agent priority, token optimization, SSOT, universality"
+  DOCUMENT_WORKFLOW.md: "FLOW — setup, update, brownfield, re-read triggers"
+  INDEX.md: "routes to all of the above"
+rule: "Do not duplicate the principles or the workflow here; link to the owning doc."
+```
+
+---
+
+## 1. File Role Definitions
+
+### Agent Entry Files (CLAUDE.md, AGENTS.md, GEMINI.md)
+
+```yaml
+purpose: "AI agent entry point — routes the agent to the right context"
+token_limit: 200
+placement: "project root (one per agent tool)"
+one_per_tool:
+  CLAUDE_md: "Claude Code entry point"
+  AGENTS_md: "Devin / Codex entry point"
+  GEMINI_md: "Gemini entry point"
+```
+
+**Priority structure within the file:**
+
+```yaml
+high_priority:
+  - "role and responsibility scope"
+  - "immediate action guidelines"
+  - "critical constraints and prohibitions"
+  - "routing to PROJECT.md"
+  - "task-specific document guidance"
+medium_priority:
+  - "frequently used information (direct inclusion to save a lookup)"
+  - "cost optimization processing guidelines"
+  - "unnecessary processing avoidance criteria"
+```
+
+**Critical design considerations:**
+- Information density must be maximized within the token limit.
+- The file must define an emergency action (what to do if other docs are unavailable).
+- The file routes; it does not explain. Detail lives in PROJECT.md and below.
+- A fallback strategy is required: minimum essential information for initial access.
+
+**When to create vs skip an agent file:**
+- Create one for each AI tool the project actually uses.
+- Do NOT create agent files for tools the project does not use (YAGNI).
+- If only one tool is used, create only that file. The structure scales.
+
+### PROJECT.md
+
+```yaml
+purpose: "project description and routing — the agent's second stop"
+token_limit: 800
+placement: "documents/ (root shared) or documents/agents/ (see Directory Structure)"
+routing_responsibility: true
+content:
+  - "project overview and objectives"
+  - "tech stack and architecture"
+  - "constraints and business rules"
+  - "current status and progress"
+  - "routing to task-specific documents"
+```
+
+**Why 800 tokens:** enough for a single AI processing pass that gives the agent
+project-level context without exceeding typical context-window efficiency
+thresholds. Larger than 800 → split into task-specific files and route to them.
+
+### README.md
+
+```yaml
+purpose: "human interface only — the one human-readable exception"
+token_limit: none
+placement: "project root"
+content:
+  - "basic project information"
+  - "setup and usage"
+  - "contribution guidelines"
+  - "project background"
+audience: "human developers, not AI agents"
+```
+
+**Rule:** AI agents should NOT rely on README.md for project context. It is
+human-facing and may contain prose, tutorials, and background that waste tokens.
+The agent entry files and PROJECT.md are the AI's context path.
+
+---
+
+## 2. Token Limits
+
+```yaml
+limits:
+  agent_entry_files: 200
+  PROJECT_md: 800
+  task_specific_docs: "no hard limit, but prefer splitting over 800"
+  README_md: "none (human-facing exception)"
+rationale:
+  "200": "entry files route, they do not explain. 200 tokens is enough for role + constraints + routing."
+  "800": "one processing pass of project-level context. Beyond this, the agent should be routed to task-specific files."
+enforcement: "soft — exceeding by a small margin is acceptable if it prevents a file split that would hurt routing clarity. Gross violation → restructure."
+```
+
+---
+
+## 3. File Format Standards
+
+```yaml
+format_priority: "AI efficiency > human readability"
+base_format: "markdown with embedded YAML blocks"
+processing_efficiency: "maximum AI parsing speed"
+```
+
+### Format Selection Guide
+
+```yaml
+structured_data: "YAML (settings, metadata, lists, configuration)"
+explanations: "markdown (procedures, guides, rationale)"
+api_specs: "JSON (OpenAPI, machine-readable schemas)"
+mixed: "markdown + YAML blocks (most efficient — structure + context in one file)"
+```
+
+### Format Usage by File Type
+
+```yaml
+agent_entry_files: "structured markdown with YAML blocks"
+PROJECT_md: "markdown with YAML sections"
+documents: "markdown / YAML / JSON (flexible — choose by content)"
+README_md: "standard markdown (human-facing exception — prose allowed)"
+```
+
+---
+
+## 4. Directory Structure
+
+### Single Project
+
+```yaml
+project_structure:
+  root_files:
+    - "CLAUDE.md      # ≤200 tokens (Claude Code entry)"
+    - "AGENTS.md      # ≤200 tokens (Devin/Codex entry)"
+    - "GEMINI.md      # ≤200 tokens (Gemini entry, if used)"
+    - "README.md      # human interface only"
+  documents:
+    root: "documents/ — shared specifications and schemas"
+    agents: "documents/agents/ — AI-optimized documentation (English, no suffix)"
+    users: "documents/users/ — human-readable documentation (Japanese, _JP.md suffix)"
+  source_code: true
+```
+
+### Directory Responsibilities
+
+```yaml
+"documents/":
+  content: "shared specifications, schemas, APIs"
+  audience: "both AI agents and humans"
+  language: "context-dependent (technical specs often English)"
+  naming: "descriptive.md or descriptive.json"
+
+"documents/agents/":
+  content: "project details, workflows, optimization guides for AI"
+  audience: "AI agents only"
+  language: "English (processing efficiency)"
+  naming: "descriptive.md (no language suffix)"
+  optimization: "token efficiency priority"
+
+"documents/users/":
+  content: "setup guides, explanations, tutorials for humans"
+  audience: "human developers"
+  language: "Japanese (primary target language)"
+  naming: "descriptive_JP.md (language suffix required)"
+  optimization: "comprehensibility priority"
+```
+
+### Reference & Routing Strategy
+
+```yaml
+ai_workflow: "agent.md → documents/agents/project.md → task-specific files"
+human_workflow: "README.md → documents/users/setup_JP.md → detailed guides"
+shared_specs: "both reference documents/ for API specs, schemas, standards"
+gradual_disclosure: "agent.md → PROJECT.md → documents/agents/ → documents/ (shared specs)"
+lost_prevention: "clear directory purpose prevents confusion — each directory has one role"
+```
+
+---
+
+## 5. Hierarchical Projects (OOP Design)
+
+For multi-service or multi-package projects, apply OOP-style encapsulation to
+the documentation structure.
+
+### Hierarchy Principles
+
+```yaml
+child_independence: "complete independence — child does not know parent exists"
+parent_containment: "parent manages all child project information"
+information_flow: "parent → child (unidirectional only)"
+external_reference: "child treats parent as external project if coordination needed"
+encapsulation: "child does not know parent implementation details"
+oop_analogy: "similar to object-oriented class containment design"
+```
+
+### Structure
+
+```yaml
+parent_project:
+  files: ["CLAUDE.md", "AGENTS.md", "GEMINI.md", "README.md"]
+  documents:
+    shared_root: "documents/ (shared specifications)"
+    agents: "documents/agents/ (parent project AI docs)"
+    users: "documents/users/ (parent project human docs)"
+    child_management: "documents/agents/children.md (child project coordination)"
+
+child_projects:
+  independence: "complete independence without parent knowledge"
+  structure:
+    files: ["CLAUDE.md", "AGENTS.md", "GEMINI.md", "README.md"]
+    documents:
+      shared_root: "documents/ (child-specific shared specs)"
+      agents: "documents/agents/ (child AI docs, parent unaware)"
+      users: "documents/users/ (child human docs, parent unaware)"
+  parent_awareness: false
+  external_reference: "treat parent as external project if coordination needed"
+```
+
+### Parent's children.md
+
+The parent project maintains a coordination file at `documents/agents/children.md`
+that lists child projects, their boundaries, and inter-service communication
+patterns. This file is parent-only — children do not reference it.
+
+---
+
+## 6. Information Priority
+
+### AI Agent Priority Order
+
+```yaml
+1: "agent.md (root directory entry point — CLAUDE.md / AGENTS.md / GEMINI.md)"
+2: "documents/agents/project.md (AI-specific project details)"
+3: "documents/agents/ (detailed AI-optimized information, task-specific)"
+4: "documents/ (shared specifications and schemas)"
+5: "README.md (human interface — last resort, not designed for AI)"
+```
+
+### Human Priority Order
+
+```yaml
+1: "README.md (human entry point)"
+2: "documents/users/setup_JP.md (setup and getting started)"
+3: "documents/ (shared specifications when needed)"
+4: "documents/users/ (detailed human-readable guides)"
+```
+
+---
+
+## How These Interlock
+
+```yaml
+entry_file_routes: "agent.md defines role + routes to PROJECT.md"
+project_file_routes: "PROJECT.md gives context + routes to task-specific docs"
+directory_purpose_routes: "documents/agents/ vs documents/users/ vs documents/ — audience decides placement"
+hierarchy_encapsulates: "parent and child each have independent doc trees; coordination via children.md (parent-only)"
+one_idea: "Make the entry file the router, PROJECT.md the context, and directories the audience boundary. Hierarchy repeats this pattern per level."
+```
~~~~

### `artifacts/INDEX.md`

~~~~diff
@@ -0,0 +1,97 @@
+# AI Agent Documentation Strategy - Index
+
+```yaml
+document_type: "index"
+target_audience: "ai_agents"
+optimization: "token_efficiency"
+language: "english"
+role: "entry point for the exported documentation strategy set"
+```
+
+This is the entry point for the exported guidance. Read it first.
+
+## Read Order
+
+```yaml
+1_philosophy: "DOCUMENTATION_PHILOSOPHY.md"   # WHY:  core values, AI-agent priority, token optimization, misreadings
+2_structure:  "FILE_AND_STRUCTURE.md"         # HOW+WHERE: file roles, token limits, directory layout, hierarchy
+3_workflow:   "DOCUMENT_WORKFLOW.md"           # FLOW: setup, update, brownfield, re-read triggers
+```
+
+On first contact, read 1 → 2 → 3. For a specific task, jump via the Quick Task Routing below.
+
+## Document Split Policy
+
+```yaml
+split_by: "the question each doc answers — WHY (philosophy) / HOW+WHERE (file roles & structure) / FLOW (workflow); INDEX routes."
+one_owner: "each concept lives in exactly ONE doc — see Ownership Map; link, never duplicate."
+restatement_cap: "when a doc needs a concept it does not own, restate AT MOST one sentence + a link to the owner; on any apparent conflict between docs, the OWNING doc's wording is authoritative."
+not_split_by: ["audience", "language", "feature/domain"]   # all docs are AI-facing, English
+```
+
+## Foundational Lens
+
+These artifacts assume an **AI-Agent Priority** paradigm for documentation.
+
+```yaml
+core_idea: "Documentation is structured so AI agents locate the right context with minimal token cost. Human-facing documents are a separate, clearly-scoped concern — not the default."
+interpret_through: ["token efficiency", "cognitive load reduction", "single source of truth", "routing clarity"]
+do_not_optimize_for: ["human readability (except README)", "exhaustive prose", "redundant explanation"]
+scale_invariant: "the strategy applies to single projects and hierarchical (multi-service) projects alike."
+```
+
+## Ownership Map (Single Source of Truth)
+
+Each concept has exactly ONE authoritative document. Do not duplicate; link instead.
+
+```yaml
+DOCUMENTATION_PHILOSOPHY.md:
+  owns:
+    - "AI-Agent Priority: definition & rationale"
+    - "Token optimization: the principle (the WHY)"
+    - "Cognitive load reduction: the principle (the WHY)"
+    - "Single source of truth / duplicate elimination: the principle (the WHY)"
+    - "Universality: single and hierarchical projects, any scale"
+    - "Format priority: AI efficiency > human readability (the WHY)"
+    - "Common misreadings to prevent"
+    - "Relationship to coding-design artifacts (design-principles vs documentation-strategy)"
+
+FILE_AND_STRUCTURE.md:
+  owns:
+    - "Agent entry files (CLAUDE.md, AGENTS.md, GEMINI.md): role, token limit, priority structure"
+    - "PROJECT.md: role, token limit, routing responsibility"
+    - "README.md: role as human-only interface"
+    - "Token limits: 200 / 800 and their rationale"
+    - "File format standards: markdown + YAML blocks, format selection guide"
+    - "Directory structure: documents/, documents/agents/, documents/users/"
+    - "Language and naming conventions per directory"
+    - "Hierarchical projects: OOP design, child independence, parent containment"
+    - "Information priority order (AI and human)"
+    - "Reference and routing strategy between files"
+
+DOCUMENT_WORKFLOW.md:
+  owns:
+    - "New project setup: step-by-step from strategy to project files"
+    - "Existing project adoption (brownfield): audit, classify, migrate"
+    - "Ongoing document updates: when to update, what to re-read"
+    - "Re-read triggers: when an AI agent should reload this strategy"
+    - "Document creation decision tree: when to create a new file vs extend"
+    - "Operational guidelines: version control, update frequency, maintenance"
+    - "Confirmation gate: when to ask the user before changing documentation structure"
+```
+
+## Quick Task Routing
+
+```yaml
+"setting up docs for a new project":           "DOCUMENT_WORKFLOW.md (New Project Setup) + FILE_AND_STRUCTURE.md (File Roles)"
+"adopting this strategy in an existing project": "DOCUMENT_WORKFLOW.md (Brownfield Adoption)"
+"updating an existing document":               "DOCUMENT_WORKFLOW.md (Ongoing Updates) + FILE_AND_STRUCTURE.md (find the right file)"
+"should I create a new doc or extend existing": "DOCUMENT_WORKFLOW.md (Creation Decision Tree)"
+"which file should hold this information":      "FILE_AND_STRUCTURE.md (File Role Definitions) + DOCUMENTATION_PHILOSOPHY.md (SSOT)"
+"how to structure a multi-service project":     "FILE_AND_STRUCTURE.md (Hierarchical Projects)"
+"token limit for a specific file":              "FILE_AND_STRUCTURE.md (Token Limits)"
+"which format to use (YAML/JSON/Markdown)":     "FILE_AND_STRUCTURE.md (File Format Standards)"
+"when should I re-read this strategy":          "DOCUMENT_WORKFLOW.md (Re-read Triggers)"
+"why is README the only human-readable file":   "DOCUMENTATION_PHILOSOPHY.md (AI-Agent Priority + Misreadings)"
+"how does this relate to design-principles":    "DOCUMENTATION_PHILOSOPHY.md (Scope Boundary)"
+```
~~~~
