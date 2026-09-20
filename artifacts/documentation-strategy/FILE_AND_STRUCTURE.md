# File Roles & Directory Structure

```yaml
document_type: "file_and_structure"
target_audience: "ai_agents"
language: "english"
strategy_version: "2.5.0"
scope: "file roles, canonical and Work Document layout, managed-guidance ownership, versioning, git conventions, hierarchy"
```

```yaml
ownership_split:
  this_doc: "HOW + WHERE — file roles, directory layout, managed guidance, versioning, git conventions, hierarchy"
  DOCUMENTATION_PHILOSOPHY.md: "WHY — accuracy priority, scope, ownership boundaries, git as recording"
  DOCUMENT_WORKFLOW.md: "FLOW — setup, update, managed-artifact handling, version bumping, brownfield"
  INDEX.md: "routes to all of the above"
```

---

## 1. Top-Level Directory Layout

```yaml
project_root:
  documents: "AI-facing canonical Project Documents plus optional distributor-managed guidance under documents/artifacts/"
  work_documents: ".worktrees/<work-type>/<work-name>/documents/ — AI-facing documentation for one active Work Identity, when Work Identity is used"
  docs-jp: "Human-facing documentation (Japanese, for project owners and developers)"
  CLAUDE_md: "Claude Code entry point (project root)"
  AGENTS_md: "Devin / Codex entry point (project root)"
  GEMINI_md: "Gemini entry point (project root, if used)"
  README_md: "Brief human-facing project description (points to docs-jp/ for details)"
```

### documents/ — AI-Facing

```yaml
rule: "Everything under documents/ is written for AI agents to read, but ownership differs by subtree."
language: "English by default. Japanese is allowed when the AI agent needs Japanese context (e.g., Japanese API specs, Japanese domain terms)."
structure:
  - "documents/INDEX.md — project-owned routing hub + version registry (required)"
  - "documents/project/ — project-level context (overview, architecture, constraints)"
  - "documents/reference/ — project-owned reference materials (specs, standards, examples)"
  - "documents/<topic>/ — project-owned topic-specific directories (see §7 Directory Splitting Guide)"
  - "documents/artifacts/<module>/ — optional distributor-managed guidance; each module owns its own INDEX.md"
principle: "Split by concern, not by audience. There is no audience split inside documents/ — it is all AI-facing — but project-owned documents and managed artifact guidance have different maintenance rules."
```

### Ownership Zones Inside `documents/`

```yaml
project_owned:
  examples: ["documents/INDEX.md", "documents/project/", "documents/reference/", "documents/<topic>/"]
  owner: "target project"
  governed_by: "this strategy's routing, versioning, staleness, and deletion rules"

managed_guidance:
  path: "documents/artifacts/<module>/"
  owner: "artifact canonical source + target project's distribution/sync mechanism"
  governed_by: "the installed artifact module for its content; the distribution mechanism for install/update/remove"
  project_registry: "excluded from documents/INDEX.md document inventory/version registry"
  direct_edit: "do not add target-project document metadata or directly rewrite installed guidance as ordinary project documentation"
```

Managed artifact files may be committed as a snapshot in the target project's Git history.
That records what was installed; it does not transfer content ownership to the target project's
documentation workflow.

### Work Documents — Active Work Scope

When the project uses Work Identity, the documentation area for one active Work is:

```text
.worktrees/<work-type>/<work-name>/documents/
```

```yaml
owner: "target project; Git-tracked by the Project Repository that owns the Project Root"
purpose: "design, investigation, decisions, verification, migration context, and other durable context needed while that Work is active"
canonicality: "not canonical Project state; authoritative only for the active Work's context"
project_index: "do not register Work Documents in documents/INDEX.md"
versioning: "do not require project-document semantic version / last_updated_commit metadata; Git history records the active-work document evolution"
completion: "reconcile durable knowledge into canonical documents/, then remove Work Documents that no longer need to remain active"
placement_owner: "development-environment-strategy owns the .worktrees/ topology and Git/worktree boundary"
```

Do not create fixed filenames merely to satisfy a template. Split Work Documents by concern when that improves routing, and keep enough context to prevent design/verification meaning from degrading.

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
purpose: "Routing hub + version registry for canonical project-owned documents under documents/"
placement: "documents/INDEX.md"
required: true
content:
  - "Document inventory: every canonical project-owned document under documents/ with its purpose"
  - "Routing map: which project-owned document to read for which task"
  - "Version registry: each project-owned document's version + last-updated git commit/state"
  - "Cross-reference map: which project-owned documents link to which"
  - "Optional entry-point links to installed documents/artifacts/<module>/INDEX.md files when the project uses those modules"
exclusion: "Do NOT enumerate/version-register files inside documents/artifacts/ or active Work Documents under .worktrees/**/documents/. Managed artifacts route internally; Work Documents route by Work Identity."
versioning: "INDEX.md has its own version (index_version). Bump it when the project-owned inventory or routing changes. See §4."
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
    - "project_ref: documents/INDEX.md"
    - "artifact_refs: optional direct links to documents/artifacts/<module>/INDEX.md for installed guidance sets"
  efficiency:
    - "focus_files: glob patterns the agent should prioritize"
    - "current_priority: the current development focus"
design_rule: |
  The entry file holds conventions + routing.
  Conventions (language, execution rules, constraints) live in the entry file itself — they are agent-specific and project-specific.
  Project detail (architecture, specs, constraints documentation) lives under project-owned documents/ paths.
  Installed artifact guidance stays under documents/artifacts/ and is referenced by module INDEX, not copied into the entry file.
  The entry file is a template created by the AI agent during setup; the user customizes it thereafter (adding rules like 'no sudo', 'commit after every change', etc.).
when_to_create: "One file per AI tool the project actually uses. Do not create files for unused tools (YAGNI)."
```

### Work Documents (.worktrees/<work-type>/<work-name>/documents/)

```yaml
purpose: "AI-facing, Work Identity-scoped documentation for active development"
placement: ".worktrees/<work-type>/<work-name>/documents/"
owner: "target project / active Work Identity"
content_examples:
  - "design being implemented"
  - "investigation findings needed by the active Work"
  - "decisions and rejected alternatives when needed to prevent re-analysis"
  - "verification plan/results that remain relevant to completion"
  - "migration or cross-repository coordination context"
routing: "the Work Root itself identifies the active Work; documents/INDEX.md does not inventory these files"
git: "tracked by the Project Repository main/default coordination state"
lifecycle: "active Work -> reconciliation -> durable knowledge promoted to canonical Project Documents -> Work Documents removed when no longer active"
```

Work Documents are not raw output dumps. Large generated logs/results should remain in appropriate Work-scoped runtime/output locations unless a curated document is needed for reasoning or verification.

### Managed Artifact Guidance (documents/artifacts/)

```yaml
purpose: "Reusable AI-facing guidance installed from a canonical artifact source."
placement: "documents/artifacts/<module>/"
ownership: "Distributor-managed; not ordinary project-owned documentation."
routing: "Each module's INDEX.md is the entry point and owns routing inside that module."
project_index: "documents/INDEX.md may link to a module INDEX as a routing destination but MUST NOT inventory/version every managed artifact file."
versioning: "Do NOT add target-project document_version / last_updated_commit metadata to installed artifact files. Preserve metadata owned by the artifact itself."
updates: "Update by the target project's explicit artifact sync/distribution mechanism so the selected module is replaced from its canonical source."
removal: "Remove through the explicit artifact removal mechanism; do not use the ordinary project-document deletion workflow."
direct_edit: "If the guidance itself is wrong, change its canonical source and redistribute it; do not fork the installed copy silently."
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
purpose: "Project-owned reference material the agent reads on demand"
placement: "documents/reference/"
content_examples:
  - "API specifications, data models, schemas"
  - "Coding standards specific to the project"
  - "Example projects demonstrating the strategy"
  - "Glossary, domain terms"
routing_rule: "Project documents and INDEX.md link to these when needed. The agent does not read them unless a task requires it."
```

### Domain Glossary (When Useful)

A glossary is an optional reference document, not a mandatory project ceremony.
Create one when shared vocabulary is important enough that inconsistent wording
would reduce accuracy.

```yaml
placement: "documents/reference/glossary.md"
create_when:
  - "The same domain terms appear across multiple documents or modules."
  - "A term is ambiguous, overloaded, or easy for an agent to misinterpret."
  - "The authoritative domain vocabulary is not English and translation could alter meaning."
  - "Aliases or historical names must be mapped to one canonical term."
do_not_create_when:
  - "The project has only ordinary technical vocabulary with no meaningful ambiguity."
  - "A term is used once and its meaning is already clear in the owning document."
  - "The only reason is to satisfy a template."
```

When a glossary is useful, prefer a compact structured form such as:

```yaml
terms:
  - term: "canonical domain term"
    english_equivalent: "optional English equivalent"
    definition: "meaning in this project"
    context: "where or when the term is used"
    aliases: ["optional alias"]
```

Rules:

- Preserve the canonical term used by the domain. Do not translate away meaning merely to keep a document English-only.
- `english_equivalent` is optional and exists to aid routing or explanation, not to replace the canonical term.
- Define terms that improve shared understanding; do not require every ordinary technical word to be registered first.
- If one glossary becomes difficult to navigate, it may be split by domain or concern. File count alone does not require a split.

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
project_routing_chain: "agent.md → documents/INDEX.md → project/ or reference/ → detail files"
artifact_routing_chain: "agent.md or documents/INDEX.md → documents/artifacts/<module>/INDEX.md → managed module detail files"
principles:
  - "documents/INDEX.md is the routing hub for project-owned documentation. Every project-owned document is listed there."
  - "Managed artifact modules route internally through their own INDEX.md; do not flatten them into the project registry."
  - "Each document links to related documents instead of duplicating content."
  - "One file = one concern. A task that touches one concern should require reading one file."
  - "The agent follows the routing chain only as far as needed."
  - "Cross-references use relative paths from the referencing file."
```

### Reference Format

```yaml
format: "markdown links with brief context"
example_from_index: "See [project/architecture.md](project/architecture.md) for the architecture overview."
example_artifact_from_index: "See [artifacts/design-principles/INDEX.md](artifacts/design-principles/INDEX.md) for installed design guidance."
example_from_project_doc: "See [../reference/api-specs.md](../reference/api-specs.md) for API specifications."
rule: "Never duplicate content that exists elsewhere. Link to it with a one-sentence description."
path_note: "Paths are relative to the file containing the link. From documents/INDEX.md, a link to documents/project/overview.md is written as project/overview.md."
```

---

## 4. Document Versioning System

The semantic version + reflected Git state system applies to **canonical project-owned documents under `documents/`**.

It does not apply to:

- distributor-managed guidance under `documents/artifacts/`;
- active Work Documents under `.worktrees/<work-type>/<work-name>/documents/`.

Work Documents are intentionally shorter-lived and already scoped by Work Identity; Git history records their evolution. When knowledge is promoted into canonical Project Documents, the destination document follows the normal canonical versioning workflow.

### Version Format

```yaml
scheme: "semantic versioning (MAJOR.MINOR.PATCH)"
major: "Document restructured or rewritten — section reorganization, scope change, or full rewrite that invalidates prior readers' understanding"
minor: "Content addition or significant update — new section, new information"
patch: "Small fix — typo, clarification, minor correction, or metadata refresh"
initial_version: "1.0.0"
```

### Per-Document Version Header

Each project-owned document includes a version block in its top YAML front matter:

```yaml
# At the top of each document, inside the existing YAML block:
document_version: "1.2.0"
last_updated_commit: "abc1234"
last_updated_date: "2025-07-09"
```

```yaml
format_rule: "Use the same YAML code block (```yaml) that already holds document_type, target_audience, etc. Do NOT use a separate front-matter block (---)."
managed_guidance_exception: "Do not add or rewrite these target-project fields inside documents/artifacts/."
```

### Version Registry in INDEX.md

INDEX.md maintains a registry of all **project-owned** documents. INDEX.md itself has an
`index_version` field that tracks the registry's version. Managed artifact files are not
registry entries; at most, link to a module's INDEX.md as an external routing destination.

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
  minor: "Project-owned file registered or removed, or project routing changed"
  patch: "Typo fix in an entry, metadata correction"
artifact_sync_note: "A managed artifact module's internal file changes do not require project registry entries or per-file version bumps. Bump project INDEX only if its routing link to that module changes."
```

### INDEX.md Self-Versioning

```yaml
rule: "INDEX.md uses index_version as its sole version field. It does NOT carry a separate document_version."
registry_self_entry: "INDEX.md does NOT list itself in the version registry. Its version is tracked by index_version at the top of the file."
commit_tracking: "INDEX.md carries its own last_updated_commit and last_updated_date at the top of the file, alongside index_version."
```

### Commit Hash: Two-Phase Workflow

A commit cannot contain its own final hash as tracked content: changing the file
changes the commit. `last_updated_commit` therefore identifies the **content/code
state that the document was updated or reviewed against**, not the later metadata
recording commit that writes that hash into the file.

Use this workflow:

```yaml
phase_1_commit:
  action: "Update the project-owned document content and bump the version number."
  commit_hash_field: "Leave last_updated_commit blank or set to 'pending' when the reflected commit is not yet known."
  commit: "Commit with the appropriate message prefix."
  reflected_commit: "For a content update, this phase-1 commit is normally the commit the document now reflects. For a staleness review with no content change, the reflected commit may instead be the reviewed code HEAD."
phase_2_record:
  action: "Resolve the reflected commit hash (for example: git rev-parse --short <reflected-commit>)."
  update: "Fill in last_updated_commit in the document header AND its INDEX.md entry."
  commit: "Commit the metadata update as a follow-up: 'chore: <document>のコミットハッシュを記録'."
  recursion_rule: "Do NOT update last_updated_commit again merely because this metadata-recording commit exists. The field intentionally points to the reflected content/code state."
amend_rule: "Do NOT use git commit --amend to try to embed a commit's own hash into that same commit. Amending tracked content creates a new hash and cannot solve the self-reference."
```

### Why Track Commit Hash

```yaml
rationale: |
  When an AI agent reads a project-owned document, it can use last_updated_commit
  as the code/content state the document was reviewed against. If relevant code has
  changed after that state, the document may be stale and should be verified before
  relying on it. The metadata-recording commit itself is not recursively tracked.
```

### Staleness Detection in Practice

```yaml
how_to_detect_staleness:
  step_1: "Read the project-owned document's last_updated_commit from its header."
  step_2: "Run: git log --oneline <last_updated_commit>..HEAD -- <relevant_code_paths>"
  step_3: "If the output is non-empty, code has changed since the document was last reviewed."
  step_4: "Review the listed commits to determine if the document is still accurate."
  step_5: "If inaccurate, update the document (see DOCUMENT_WORKFLOW.md → Staleness Update Flow)."
exclusion: "Do not apply this target-project staleness algorithm to managed files under documents/artifacts/. Update those through their artifact source/distribution mechanism."
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

Creating a `documents/<topic>/` directory is a structural option, not a file-count
mandate. Use a topic directory when it creates a clearer routing or ownership
boundary than placing the files directly under `documents/project/` or
`documents/reference/`.

```yaml
default_placement:
  project_level: "documents/project/ — canonical project-level context the agent needs during development"
  reference_level: "documents/reference/ — material the agent reads on demand"

signals_that_support_a_topic_directory:
  - "The files form a cohesive concern that should be routed together."
  - "The topic is sufficiently self-contained that an agent can load that directory for the concern."
  - "The files have a distinct lifecycle or ownership boundary from surrounding project/reference documents."
  - "Keeping them directly under project/ or reference/ would reduce discoverability or create clutter."
  - "Three or more related files exist — useful evidence of a stable grouping, but not a threshold."

permission_rule: |
  File count is a heuristic, not a gate. One or two files MAY live in a topic
  directory when the routing boundary is already clear and useful. Conversely,
  three files do not REQUIRE a new directory if keeping them together in
  project/ or reference/ remains clearer.

avoid:
  - "Speculative empty or nearly-empty directories created for hypothetical future growth."
  - "Splitting solely to satisfy a numeric rule."
  - "Moving stable documents without a concrete routing, ownership, or navigation benefit."
  - "Creating a topic directory that duplicates an existing project/ or reference/ concern."
```

---

## 8. Hierarchical Projects

For multi-service or multi-package projects, each child has an independent
project-owned `documents/` tree and registry. Managed artifact guidance may also
be installed in a child's `documents/artifacts/`; it remains outside that child's
project-document registry.

### Principles

```yaml
child_independence: "Each child has its own documents/INDEX.md and project-document version registry."
parent_containment: "Parent's project-owned documents describe children at a high level but do not duplicate child details."
information_flow: "Parent → child (unidirectional). Child does not reference parent's internal project documents."
external_reference: "If a child needs parent context, it treats the parent as an external project."
managed_guidance: "Parent and child may independently install artifact modules; those managed files are not inherited through the project-document registry."
```

### Structure

```yaml
parent_project:
  documents:
    index: "documents/INDEX.md (parent's project routing + version registry)"
    project: "documents/project/ (parent project context)"
    reference: "documents/reference/ (shared reference, child-overview)"
    artifacts: "documents/artifacts/ (optional managed guidance; excluded from registry)"
    children_overview: "documents/project/children.md (high-level child descriptions, parent-only)"

child_projects:
  each_child:
    documents: "Independent project-owned documents/ tree with its own INDEX.md; may also contain its own managed documents/artifacts/"
    parent_awareness: false
    rule: "Child's INDEX.md does not list parent project documents. Child is self-contained."
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

When a **project-owned** document is removed:

```yaml
deletion_steps:
  1: "Confirm the document is truly obsolete — check all cross-references first."
  2: "Remove or update all project-owned links pointing to the deleted document."
  3: "Remove the document's entry from documents/INDEX.md version registry."
  4: "Bump index_version in INDEX.md (minor — a project-owned file was removed from the registry)."
  5: "Commit with: 'refactor: <document>を削除' and note why in the body."
rule: "Never delete a project-owned document that other documents still reference without fixing those references first."
managed_guidance_exception: "Do not delete individual files under documents/artifacts/ through this workflow. Remove or update the owning module through the artifact distribution mechanism."
```

---

## 10. Multi-Developer INDEX.md Conflict Mitigation

The version registry in INDEX.md is a single file that all project-documentation
changes touch, which can cause merge conflicts when multiple developers update
documents in parallel.

```yaml
mitigation:
  - "Keep INDEX.md entries sorted by path to reduce conflict surface."
  - "Each developer updates only their own project-owned document's entry."
  - "If conflicts occur, they are typically in the version registry block — resolve by keeping both entries and sorting."
  - "For large teams, consider updating INDEX.md in a separate commit from the document change, to isolate conflicts."
note: "Managed artifact files do not create per-file project-registry conflicts because they are excluded from the registry."
```

---

## How These Interlock

```text
Work Identity active
    ↓
.worktrees/<identity>/documents/      # active Work knowledge; Git-tracked, no canonical doc-version registry
    ↓ reconcile at completion
documents/...                         # canonical project knowledge; normal routing/versioning applies
```

Managed artifact guidance remains a separate ownership zone under `documents/artifacts/`.
