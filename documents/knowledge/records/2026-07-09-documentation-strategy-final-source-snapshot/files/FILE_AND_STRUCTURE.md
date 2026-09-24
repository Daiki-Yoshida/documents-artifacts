# File Roles & Directory Structure

```yaml
document_type: "file_and_structure"
target_audience: "ai_agents"
language: "english"
strategy_version: "2.2.0"
scope: "file roles, directory layout, versioning, git conventions, hierarchy"
```

```yaml
ownership_split:
  this_doc: "HOW + WHERE — file roles, directory layout, versioning, git conventions, hierarchy"
  DOCUMENTATION_PHILOSOPHY.md: "WHY — accuracy priority, scope, git as recording"
  DOCUMENT_WORKFLOW.md: "FLOW — setup, update, version bumping, brownfield"
  INDEX.md: "routes to all of the above"
```

---

## 1. Top-Level Directory Layout

```yaml
project_root:
  documents: "AI-facing documentation (all content under here is for AI agents)"
  docs-jp: "Human-facing documentation (Japanese, for project owners and developers)"
  artifacts: "Exported strategy files (this set) — copied into target projects"
  CLAUDE_md: "Claude Code entry point (project root)"
  AGENTS_md: "Devin / Codex entry point (project root)"
  GEMINI_md: "Gemini entry point (project root, if used)"
  README_md: "Brief human-facing project description (points to docs-jp/ for details)"
```

### documents/ — AI-Facing

```yaml
rule: "Everything under documents/ is written for AI agents to read."
language: "English by default. Japanese is allowed when the AI agent needs Japanese context (e.g., Japanese API specs, Japanese domain terms)."
structure:
  - "documents/INDEX.md — routing hub + version registry (required)"
  - "documents/project/ — project-level context (overview, architecture, constraints)"
  - "documents/reference/ — reference materials (specs, standards, examples)"
  - "documents/<topic>/ — topic-specific directories (see §7 Directory Splitting Guide)"
principle: "Split by concern, not by audience. There is no audience split inside documents/ — it is all AI-facing."
```

### docs-jp/ — Human-Facing

```yaml
rule: "Human-facing content lives here, never under documents/."
language: "Japanese"
naming: "descriptive.md or descriptive_JP.md"
content_examples:
  - "Project background and motivation"
  - "Setup tutorials for human developers"
  - "Design rationale and decision records"
  - "Japanese translations of AI-facing documents (for human review)"
```

---

## 2. File Roles

### documents/INDEX.md (Required)

```yaml
purpose: "Routing hub + document version registry"
placement: "documents/INDEX.md"
required: true
content:
  - "Document inventory: every file under documents/ with its purpose"
  - "Routing map: which document to read for which task"
  - "Version registry: each document's version + last-updated git commit hash"
  - "Cross-reference map: which documents link to which"
versioning: "INDEX.md has its own version (index_version). Bump it when the inventory or routing changes. See §4."
```

See §4 "Document Versioning System" for the version registry format.

### Agent Entry Files (CLAUDE.md, AGENTS.md, GEMINI.md)

```yaml
purpose: "AI agent entry point — conventions + routing"
placement: "project root (one per agent tool)"
role: "the first file an AI agent reads when entering a project"
content:
  conventions:
    - "language settings (e.g., respond in Japanese, think in English)"
    - "execution rules (e.g., commit after changes, no sudo)"
    - "emergency_action: what to do if intent is unclear"
  routing:
    - "primary_ref: documents/INDEX.md"
  efficiency:
    - "focus_files: glob patterns the agent should prioritize"
    - "current_priority: the current development focus"
design_rule: |
  The entry file holds conventions + routing.
  Conventions (language, execution rules, constraints) live in the entry file itself — they are agent-specific and project-specific.
  Project detail (architecture, specs, constraints documentation) lives under documents/.
  The entry file is a template created by the AI agent during setup; the user customizes it thereafter (adding rules like 'no sudo', 'commit after every change', etc.).
when_to_create: "One file per AI tool the project actually uses. Do not create files for unused tools (YAGNI)."
```

### Project Documents (documents/project/)

```yaml
purpose: "Project-level context the AI agent needs for every task"
placement: "documents/project/"
content_examples:
  - "Project overview, objectives, scope"
  - "Architecture summary"
  - "Constraints (business rules, compliance, performance)"
  - "Current status and roadmap"
routing_rule: "INDEX.md routes to these files. Each file covers one concern."
```

### Reference Documents (documents/reference/)

```yaml
purpose: "Reference material the agent reads on demand"
placement: "documents/reference/"
content_examples:
  - "API specifications, data models, schemas"
  - "Coding standards specific to the project"
  - "Example projects demonstrating the strategy"
  - "Glossary, domain terms"
routing_rule: "Project documents and INDEX.md link to these when needed. The agent does not read them unless a task requires it."
```

### README.md

```yaml
purpose: "Brief human-facing project description"
placement: "project root"
audience: "human developers, project owners"
content: "One-paragraph project summary + pointer to docs-jp/ for details"
rule: "AI agents should NOT rely on README.md for project context. It is human-facing."
```

---

## 3. Cross-Reference and Routing Strategy

```yaml
routing_chain: "agent.md → documents/INDEX.md → project/ or reference/ → detail files"
principles:
  - "INDEX.md is the single routing hub. Every document is listed there."
  - "Each document links to related documents instead of duplicating content."
  - "One file = one concern. A task that touches one concern should require reading one file."
  - "The agent follows the routing chain only as far as needed."
  - "Cross-references use relative paths from the referencing file."
```

### Reference Format

```yaml
format: "markdown links with brief context"
example_from_index: "See [project/architecture.md](project/architecture.md) for the architecture overview."
example_from_project_doc: "See [../reference/api-specs.md](../reference/api-specs.md) for API specifications."
rule: "Never duplicate content that exists elsewhere. Link to it with a one-sentence description."
path_note: "Paths are relative to the file containing the link. From documents/INDEX.md, a link to documents/project/overview.md is written as project/overview.md."
```

---

## 4. Document Versioning System

Every document under `documents/` has a version and tracks the git commit at
which it was last updated. This includes INDEX.md itself.

### Version Format

```yaml
scheme: "semantic versioning (MAJOR.MINOR.PATCH)"
major: "Document restructured or rewritten — section reorganization, scope change, or full rewrite that invalidates prior readers' understanding"
minor: "Content addition or significant update — new section, new information"
patch: "Small fix — typo, clarification, minor correction, or metadata refresh"
initial_version: "1.0.0"
```

### Per-Document Version Header

Each document includes a version block in its top YAML front matter:

```yaml
# At the top of each document, inside the existing YAML block:
document_version: "1.2.0"
last_updated_commit: "abc1234"
last_updated_date: "2025-07-09"
```

```yaml
format_rule: "Use the same YAML code block (```yaml) that already holds document_type, target_audience, etc. Do NOT use a separate front-matter block (---)."
```

### Version Registry in INDEX.md

INDEX.md maintains a registry of all documents. INDEX.md itself has an
`index_version` field that tracks the registry's version.

```yaml
# Example entries in documents/INDEX.md
index_version: "1.3.0"
documents:
  - path: "documents/project/overview.md"
    version: "1.2.0"
    last_updated_commit: "abc1234"
    last_updated_date: "2025-07-09"
    purpose: "Project overview and objectives"
  - path: "documents/project/architecture.md"
    version: "1.0.0"
    last_updated_commit: "def5678"
    last_updated_date: "2025-07-09"
    purpose: "Architecture summary"
```

### Registry Path Convention

```yaml
note: "Registry 'path' fields are repo-root-relative identifiers (e.g., 'documents/project/overview.md'), used for unique identification. This is distinct from markdown cross-reference links, which follow §3's relative-path rule (e.g., 'project/overview.md' from INDEX.md)."
```

### INDEX.md Version Bumping

```yaml
index_version_bump:
  major: "Registry restructured — bulk reorganization, many files added/removed"
  minor: "File registered or removed, or a file's routing entry changed"
  patch: "Typo fix in an entry, metadata correction"
```

### INDEX.md Self-Versioning

```yaml
rule: "INDEX.md uses index_version as its sole version field. It does NOT carry a separate document_version."
registry_self_entry: "INDEX.md does NOT list itself in the version registry. Its version is tracked by index_version at the top of the file."
commit_tracking: "INDEX.md carries its own last_updated_commit and last_updated_date at the top of the file, alongside index_version."
```

### Commit Hash: Two-Phase Workflow

The commit hash cannot be known before the commit is made. Use this workflow:

```yaml
phase_1_commit:
  action: "Update the document content and bump the version number."
  commit_hash_field: "Leave last_updated_commit blank or set to 'pending'."
  commit: "Commit with the appropriate message prefix."
phase_2_record:
  action: "After committing, get the hash with: git rev-parse --short HEAD"
  update: "Fill in last_updated_commit in the document header AND in INDEX.md."
  commit: "Commit the hash update as a follow-up: 'chore: <document>のコミットハッシュを記録'"
alternative: "Use git commit --amend to fill in the hash before finalizing, if the commit has not been pushed yet."
```

### Why Track Commit Hash

```yaml
rationale: |
  When an AI agent reads a document, it can check the commit hash to verify
  whether the document reflects the current state of the code. If the document's
  last_updated_commit is behind HEAD, the agent knows the document may be stale
  and should be verified against the code before relying on it.
```

### Staleness Detection in Practice

```yaml
how_to_detect_staleness:
  step_1: "Read the document's last_updated_commit from its header."
  step_2: "Run: git log --oneline <last_updated_commit>..HEAD -- <relevant_code_paths>"
  step_3: "If the output is non-empty, code has changed since the document was last updated."
  step_4: "Review the listed commits to determine if the document is still accurate."
  step_5: "If inaccurate, update the document (see DOCUMENT_WORKFLOW.md → Staleness Update Flow)."
example: |
  # Document header says: last_updated_commit: "abc1234"
  # Check if src/ changed since then:
  git log --oneline abc1234..HEAD -- src/
  # If output shows commits, the document may be stale.
```

---

## 5. Git Commit Message Conventions

Documentation commits use Conventional Commits prefixes with Japanese descriptions.

### Format

```yaml
format: "<type>: <Japanese description>"
types:
  docs: "Documentation changes (new file, content update, routing change)"
  feat: "New documentation feature (new section, new versioning entry)"
  fix: "Documentation fix (correcting inaccurate information)"
  refactor: "Documentation restructuring (moving, reorganizing, or deleting files)"
  chore: "Maintenance (version bump, metadata update, commit hash recording)"
examples:
  - "docs: プロジェクト概要を更新"
  - "fix: API仕様のエンドポイントURLを修正"
  - "refactor: documents/reference/ 配下を整理"
  - "feat: セキュリティ要件ドキュメントを追加"
  - "chore: ドキュメントバージョンを1.2.0に更新"
```

### Rules

```yaml
rules:
  - "Use Japanese for the description after the prefix."
  - "The prefix is English (docs:, feat:, fix:, refactor:, chore:)."
  - "Description should be concise and describe what changed, not why (the diff shows why)."
  - "If a documentation commit accompanies a code change, the documentation commit should reference the code commit hash in its body."
```

### What We Do NOT Govern

```yaml
not_governed:
  - "When to commit (that is a code-side / development workflow decision)"
  - "Whether to branch (that is a code-side / development workflow decision)"
  - "Commit size or granularity (that is a development practice decision)"
```

---

## 6. File Format Standards

```yaml
base_format: "markdown with embedded YAML blocks"
format_selection:
  structured_data: "YAML (settings, metadata, version registries, lists)"
  explanations: "markdown (procedures, guides, rationale)"
  api_specs: "JSON or YAML (OpenAPI, machine-readable schemas)"
  mixed: "markdown + YAML blocks (structure + context in one file)"
naming: "lowercase, hyphen-separated for files; directories are lowercase"
```

---

## 7. Directory Splitting Guide

When to create a new `documents/<topic>/` directory vs. placing a file in
`documents/project/` or `documents/reference/`.

```yaml
default_placement:
  project_level: "documents/project/ — context the agent needs for every task"
  reference_level: "documents/reference/ — material the agent reads on demand"

when_to_create_topic_directory:
  criteria:
    - "The topic has 3 or more files that form a cohesive unit."
    - "The topic is self-contained — an agent can read only that directory for the topic."
    - "Placing the files in project/ or reference/ would make those directories cluttered."
  rule: "Do NOT create a topic directory for 1–2 files. Place them in project/ or reference/ until a third file appears (Rule of Three)."

when_not_to_create:
  - "The topic overlaps with project/ or reference/ content."
  - "The files would need to cross-reference each other heavily (keep them together in one directory)."
  - "The topic is a single file — use project/ or reference/ instead."
```

---

## 8. Hierarchical Projects

For multi-service or multi-package projects, each child has an independent
`documents/` tree. The parent does not enter children's trees.

### Principles

```yaml
child_independence: "Each child has its own documents/INDEX.md and version registry."
parent_containment: "Parent's documents/ describes children at a high level but does not duplicate child details."
information_flow: "Parent → child (unidirectional). Child does not reference parent's internal documents."
external_reference: "If a child needs parent context, it treats the parent as an external project."
```

### Structure

```yaml
parent_project:
  documents:
    index: "documents/INDEX.md (parent's routing + version registry)"
    project: "documents/project/ (parent project context)"
    reference: "documents/reference/ (shared reference, child-overview)"
    children_overview: "documents/project/children.md (high-level child descriptions, parent-only)"

child_projects:
  each_child:
    documents: "Independent documents/ tree with its own INDEX.md"
    parent_awareness: false
    rule: "Child's INDEX.md does not list parent documents. Child is self-contained."
```

### Parent's children.md

```yaml
placement: "documents/project/children.md"
purpose: "High-level overview of child projects — names, boundaries, responsibilities, inter-service communication"
audience: "parent-level AI agents only"
rule: "Children do not reference this file. Children are unaware of each other unless explicitly coordinated."
```

---

## 9. Document Deletion Rules

When a document under `documents/` is removed:

```yaml
deletion_steps:
  1: "Confirm the document is truly obsolete — check all cross-references first."
  2: "Remove or update all links pointing to the deleted document (search the entire documents/ tree)."
  3: "Remove the document's entry from documents/INDEX.md version registry."
  4: "Bump index_version in INDEX.md (minor — a file was removed from the registry)."
  5: "Commit with: 'refactor: <document>を削除' and note why in the body."
rule: "Never delete a document that other documents still reference without fixing those references first."
```

---

## 10. Multi-Developer INDEX.md Conflict Mitigation

The version registry in INDEX.md is a single file that all documentation
changes touch, which can cause merge conflicts when multiple developers update
documents in parallel.

```yaml
mitigation:
  - "Keep INDEX.md entries sorted by path to reduce conflict surface."
  - "Each developer updates only their own document's entry."
  - "If conflicts occur, they are typically in the version registry block — resolve by keeping both entries and sorting."
  - "For large teams, consider updating INDEX.md in a separate commit from the document change, to isolate conflicts."
note: "This is a known trade-off of centralizing the version registry. The benefit (single routing hub) outweighs the conflict cost for most projects."
```

---

## How These Interlock

```yaml
entry_file_routes: "agent.md routes to documents/INDEX.md"
index_routes: "INDEX.md routes to project/ or reference/ based on the task"
version_registry: "INDEX.md tracks every document's version + commit hash for staleness detection"
cross_references: "Documents link to each other using relative paths from the referencing file"
hierarchy: "Parent and child each have independent documents/ trees; coordination via parent's children.md"
deletion: "Removing a document requires fixing references + updating INDEX.md"
one_idea: "INDEX.md is the map, documents are the destinations, version headers are the timestamps. The agent reads the map, picks a destination, and follows links only as far as needed."
```
