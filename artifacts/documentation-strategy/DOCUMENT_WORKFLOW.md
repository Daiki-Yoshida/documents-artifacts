# Document Workflow

```yaml
document_type: "workflow"
target_audience: "ai_agents"
language: "english"
strategy_version: "2.5.0"
```

```yaml
ownership_split:
  this_doc: "FLOW — when to act, what steps to follow, when to confirm"
  FILE_AND_STRUCTURE.md: "HOW + WHERE — file roles, directory layout, managed guidance, versioning, git conventions"
  DOCUMENTATION_PHILOSOPHY.md: "WHY — accuracy priority, scope, ownership boundaries, git as recording"
  INDEX.md: "routes to all of the above"
```

---

## Use Cases

```yaml
1_new_project: "Apply the strategy from scratch."
2_existing_project: "Adopt the strategy in a project that already has documentation."
3_ongoing_updates: "The project follows the strategy; update project-owned documents during development."
4_staleness_handling: "Detect and fix stale project-owned documents whose recorded commit/state is behind relevant code changes."
5_managed_artifact_handling: "Install/update/remove guidance under documents/artifacts/ through its owning distribution mechanism rather than ordinary project-document editing."
6_work_documents: "Create, maintain, and reconcile active Work Documents when the project uses Work Identity."
```

---

## Use Case 1: New Project Setup

**When:** starting a new project that will use AI agents.

### Step 1: Create Agent Entry Files

```yaml
action: "Create one entry file per AI tool the project uses."
files:
  CLAUDE_md: "if using Claude Code"
  AGENTS_md: "if using Devin or Codex"
  GEMINI_md: "if using Gemini"
content:
  essential:
    - "role: the agent's responsibility in this project"
    - "constraints: project-specific rules"
    - "emergency_action: what to do if intent is unclear"
  routing:
    - "project_ref: documents/INDEX.md"
    - "artifact_refs: optional direct links to installed documents/artifacts/<module>/INDEX.md files"
  efficiency:
    - "focus_files: glob patterns for the agent to prioritize"
    - "current_priority: the current development focus"
rule: "The entry file routes to project context and installed guidance entry points. It does not duplicate their detail."
```

### Step 2: Create the Project-Owned documents/ Structure

```yaml
action: "Create the project-owned directory tree."
structure:
  - "documents/INDEX.md (required — create in Step 3)"
  - "documents/project/ (project-level context)"
  - "documents/reference/ (reference material)"
managed_guidance: "Do NOT create or populate documents/artifacts/ as project documentation. That subtree appears only when an artifact distribution/sync mechanism installs guidance there."
rule: "Only create project-owned directories you will populate. Do not create empty directories speculatively (YAGNI)."
```

### Step 3: Create documents/INDEX.md

```yaml
action: "Create the project-owned routing hub and version registry."
content:
  - "Document inventory: list every project-owned document under documents/ with its purpose"
  - "Routing map: which project-owned document to read for which task"
  - "Version registry: each project-owned document's version + last-updated git commit/state"
  - "Cross-reference map"
  - "Optional links to installed documents/artifacts/<module>/INDEX.md entry points"
exclusion: "Do NOT inventory/version-register individual files under documents/artifacts/."
format: "See FILE_AND_STRUCTURE.md → §4 Document Versioning System"
index_version: "Start at 1.0.0."
```

### Step 4: Create Project Documents

```yaml
action: "Create project-level context documents in documents/project/."
content:
  - "Project overview, objectives, scope"
  - "Architecture summary"
  - "Constraints (business rules, compliance, performance)"
  - "Current status and roadmap"
rule: "One file = one concern. Split when a file covers multiple concerns."
versioning: "Each project-owned file starts at version 1.0.0. Use the two-phase workflow for commit hash/state tracking (see Version Bumping)."
```

### Step 5: Create docs-jp/ (If Human-Facing Content Is Needed)

```yaml
action: "Create docs-jp/ for human-facing documentation."
content:
  - "Project background and motivation"
  - "Setup tutorials"
  - "Design rationale"
rule: "Human-facing content does NOT go under documents/. It goes in docs-jp/."
```

### Step 6: Add Reference and Topic-Specific Documents As Needed

```yaml
action: "Create project-owned documents as the project grows — not all at once."
trigger: "When a task requires project context that does not fit in existing project documents, create a new file."
placement: "documents/reference/<topic>.md or documents/<topic>/ (see FILE_AND_STRUCTURE.md → §7 Directory Splitting Guide)"
reserved_path: "Never place a canonical project-owned document under documents/artifacts/. Work Documents, when Work Identity is used, belong under the Work Root rather than canonical documents/."
glossary: "If repeated, ambiguous, or cross-language domain vocabulary is reducing accuracy, consider documents/reference/glossary.md. Do not create one merely to satisfy a template."
rule: "Prefer fewer files with clear routing over many files with overlapping content."
versioning: "Register every new project-owned file in documents/INDEX.md with version 1.0.0. Bump index_version (minor)."
```

---

## Use Case 2: Existing Project Adoption (Brownfield)

**When:** a project already has documentation but wants to adopt this strategy.

### Step 1: Audit Existing Documentation

```yaml
action: "Read existing documentation and classify each relevant path by audience and ownership."
classification:
  ai_facing_project_owned: "project context an AI agent needs during development"
  managed_guidance: "installed reusable guidance under documents/artifacts/ or an equivalent explicitly distributor-managed path"
  human_facing: "content for human developers (setup, tutorials, background)"
  shared: "content both audiences need"
  obsolete: "outdated or redundant content"
```

### Step 2: Map to the New Structure

```yaml
mapping:
  ai_facing_project_owned: "documents/project/ or documents/reference/ (AI-facing, project-owned)"
  managed_guidance: "preserve under its owned managed path; do not migrate into project docs or add project version metadata"
  human_facing: "docs-jp/ (human-facing)"
  shared: "project-owned documents/ by default; extract human summary to docs-jp/ if needed"
  obsolete: "remove or archive — do not migrate"
```

### Step 3: Create Agent Entry Files and INDEX.md

```yaml
action: "Create CLAUDE.md / AGENTS.md / GEMINI.md as needed, and documents/INDEX.md."
note: "Follow Use Case 1 Steps 1–3 for these."
```

### Step 4: Migrate Project-Owned Documents

```yaml
action: "Move or rewrite project-owned documents into the new structure."
rules:
  - "Project-owned AI-facing content goes to documents/ with proper versioning, excluding the reserved documents/artifacts/ subtree."
  - "Managed artifact guidance stays managed; do not rewrite or add target-project version metadata to it."
  - "Human-facing content goes to docs-jp/."
  - "Eliminate duplication: if two project-owned files covered the same topic, merge into one and link from the other."
  - "Preserve information — do not delete content without user confirmation."
  - "Report what was moved, merged, preserved as managed guidance, or flagged as obsolete."
```

### Step 5: Update INDEX.md and Cross-References

```yaml
action: "Register all migrated project-owned documents in documents/INDEX.md with version 1.0.0."
managed_guidance: "Link to installed module INDEX files when useful, but do not register their internal files."
check: "All routing paths in agent entry files and INDEX.md point to correct locations."
```

### Brownfield Guard

```yaml
guard:
  scope: "Do NOT let a documentation migration expand into a content rewrite."
  rule: "Structural migration and content improvement are separate tasks. Do one, then the other."
  violation_handling: "If you find documentation that violates the strategy, note it in the report. Do NOT silently fix it unless the task explicitly asks."
  managed_guidance: "Do not silently fork or normalize installed artifact guidance; corrections belong in its canonical source."
  local_convention: "Explicit project conventions OUTRANK this strategy where they conflict. Report the conflict once, then follow the local rule."
```

---

## Use Case 3: Ongoing Document Updates

**When:** the project follows this strategy and project-owned documents need updating.

### When to Update

```yaml
update_triggers:
  architecture_change: "Update project architecture docs and INDEX.md version registry."
  new_feature: "Add project reference docs as needed; update INDEX.md routing."
  constraint_change: "Update project constraints document and INDEX.md version registry."
  tech_stack_change: "Update project docs; review whether existing project docs are still accurate."
  directory_restructure: "Update all affected project routing references in INDEX.md and agent entry files."
```

### What to Update

```yaml
decision_tree:
  first_question: "Is the target an active Work Document under .worktrees/<work-type>/<work-name>/documents/?"
  yes_work_document: "Use the Work Documents lifecycle below; do not register/version it as a canonical Project Document."
  no:
    second_question: "Is the target under documents/artifacts/ and distributor-managed?"
    yes_managed: "Do NOT edit it through this workflow. Use Managed Artifact Handling below."
    no_project_owned:
      question: "Does the change affect canonical project knowledge an AI agent needs after the active Work ends?"
      yes:
        action: "Update the relevant canonical project-owned document under documents/."
        check: "Is the information already in an existing file, or does it need a new file?"
        existing_file: "Update the file and bump its version."
        new_file: "Create the file outside documents/artifacts/, register it in INDEX.md, and add routing."
      no:
        action: "Keep active-work-only knowledge in Work Documents, or update docs-jp/ when the content is human-facing."
```

### Update Discipline

```yaml
rules:
  - "Change-triggered: update project-owned documents when the code changes, not on a schedule."
  - "Proportional: a one-line code fix does not require a full documentation review."
  - "Routing-first: if you add a new project-owned document, register it in INDEX.md."
  - "Accuracy-first: if an update makes a project-owned document inaccurate, fix the inaccuracy — do not leave stale information."
  - "SSOT-check: if you add information, verify it does not duplicate an existing owner. Link instead of duplicating."
  - "Managed-guidance guard: do not edit documents/artifacts/ merely because the target project needs different local wording; project-specific information belongs in project-owned docs."
```

---

## Use Case 4: Staleness Handling

**When:** an AI agent detects that a **project-owned** document's `last_updated_commit`
is behind HEAD and code relevant to the document has changed since the reflected state.

This workflow does **not** apply to managed files under `documents/artifacts/`; update those
through their artifact source/distribution mechanism.

### Detection

```yaml
detection: "See FILE_AND_STRUCTURE.md → §4 Staleness Detection in Practice."
summary: "Compare the project-owned document's last_updated_commit with HEAD using git log on relevant code paths."
```

### Staleness Update Flow

```yaml
step_1_detect: "Run git log --oneline <last_updated_commit>..HEAD -- <relevant_code_paths>."
step_2_assess: "Review the listed commits. Determine if the project-owned document is still accurate."
step_3_classify:
  still_accurate: "Code changes did not affect the documented information."
  needs_update: "Code changes affect the documented information."
  needs_full_rewrite: "Code changes are so significant that the document must be restructured."
step_4_act:
  still_accurate: "Set last_updated_commit to the reviewed code HEAD/state and update last_updated_date in both the document header and INDEX.md entry. Bump document_version (patch — metadata refresh). Bump index_version (patch). Commit: 'chore: <document>のレビュー済みコミットハッシュを更新'. The metadata commit is not recursively recorded as the reflected commit."
  needs_update: "Update the document content. Bump version (minor or patch). Use the two-phase commit workflow."
  needs_full_rewrite: "Treat as a major version bump. Confirm with the user before restructuring (L2/L3 gate)."
step_5_report: "Report what was detected, what was updated, and the new version."
```

---

## Use Case 5: Managed Artifact Handling

**When:** the target project has reusable guidance under `documents/artifacts/<module>/`.

```yaml
ownership_rule: "Installed artifact guidance is distributor-managed, even when committed in the target project's Git history."
read: "Read each module through documents/artifacts/<module>/INDEX.md."
install_or_update: "Use the target project's explicit artifact distribution/sync mechanism. Review and commit the resulting normal Git diff in the target project."
remove: "Use the distribution mechanism's explicit module-removal operation. Omission from an update selection is not permission to remove a module."
project_index: "documents/INDEX.md may link to installed module INDEX files, but it does not inventory/version their internal files."
metadata: "Do not add target-project document_version / last_updated_commit fields to managed artifact files."
correction: "If installed guidance itself is wrong, correct the canonical artifact source and redistribute it. Do not silently patch only the target copy."
local_override: "If an explicit project convention overrides generic guidance, record the project-specific rule in project-owned instructions/docs rather than editing the installed artifact."
```

This strategy does not prescribe a universal distribution command; use the mechanism
owned by the artifact source or the target project's documented artifact workflow.

---

## Use Case 6: Work Documents

**When:** the project uses the Work Identity model and one concrete development goal has moved from design/discussion into implementation.

### Create / Establish

```yaml
precondition: "The Work Identity has been explicitly confirmed according to development-environment-strategy."
location: ".worktrees/<work-type>/<work-name>/documents/"
owner: "active Work Identity; Git-tracked by the Project Repository"
create_when: "The Work needs durable design, investigation, decision, verification, migration, or coordination context."
do_not_create_when: "No durable active-work context exists; an empty template directory is not required."
```

Do not turn every command result into a document. Prefer curated context that prevents information loss or repeated reasoning.

### Maintain During Work

Update Work Documents when active-work knowledge materially changes:

- design decisions change;
- an investigation resolves uncertainty that affects implementation;
- cross-repository coordination changes;
- verification evidence changes the completion judgment;
- a rejected alternative must be remembered to avoid repeating the same analysis.

Work Documents do not use the canonical Project Document version registry. Git records their evolution.

### Reconcile at Work Completion

Before the Work Identity is completed:

1. Read the active Work Documents.
2. Identify knowledge that remains true/useful after the Work is integrated.
3. Merge that durable knowledge into the appropriate canonical Project Documents under `documents/`.
4. Apply normal canonical routing/versioning to those destination documents.
5. Discard active-work-only material such as superseded hypotheses, raw logs, rejected alternatives that no longer aid the project, and one-off execution output.
6. Remove Work Documents that no longer represent active Work.

Do **not** archive the Work Documents into a second history tree solely for preservation. Git history already records them.

A single repository branch merge does not automatically mean Work Document reconciliation is complete; completion is governed by the Work Identity lifecycle in `development-environment-strategy`.

---

## Version Bumping Workflow

### When to Bump

```yaml
when_to_bump:
  major: "Project-owned document restructured or rewritten — section reorganization, scope change, or full rewrite"
  minor: "Content addition or significant update — new section, new information"
  patch: "Small fix — typo, clarification, minor correction, or metadata refresh"
managed_guidance: "Target-project version bumps do not apply to documents/artifacts/; preserve versions owned by the artifact itself."
```

### How to Bump

```yaml
procedure: "See FILE_AND_STRUCTURE.md → §4 Commit Hash: Two-Phase Workflow for the full procedure."
summary:
  - "Update project-owned document content and bump document_version."
  - "Set last_updated_commit to 'pending' when the reflected commit is not yet known."
  - "Update the document's INDEX.md entry (version + date)."
  - "Bump index_version if a new project-owned file was added/removed or routing changed."
  - "Commit with the appropriate message prefix."
  - "After committing, record the reflected content/code-state hash in the document header and INDEX.md entry."
  - "Commit the metadata update: 'chore: <document>のコミットハッシュを記録'. Do not recursively change the recorded hash to this metadata commit."
```

---

## Document Creation Decision Tree

```yaml
question_0: "Is this knowledge scoped only to an active Work Identity?"
  yes: "Place it in the active Work Documents when durable active-work context is needed; do not register it as canonical project documentation."
  no: "Continue to question 0b."

question_0b: "Is documents/artifacts/ being considered as the destination?"
  yes: "Stop. That path is reserved for distributor-managed artifact guidance; use the artifact installation mechanism instead of creating project docs there."
  no: "Continue to question 1."

question_1: "Does an AI agent need this project-specific information during development?"
  no: "Place in docs-jp/ (human-facing)."
  yes: "Continue to question 2."

question_2: "Is it project-level context (overview, architecture, constraints, status)?"
  yes: "Place in documents/project/<topic>.md."
  no: "Continue to question 3."

question_3: "Is it project-owned reference material (specs, schemas, standards, examples, glossary)?"
  yes: "Place in documents/reference/<topic>.md."
  no: "Continue to question 4."

question_4: "Would a dedicated topic directory create a clearer routing or ownership boundary?"
  yes: "Create documents/<topic>/ outside documents/artifacts/ and place the cohesive concern there (see FILE_AND_STRUCTURE.md → §7)."
  no: "Keep the file under documents/project/ or documents/reference/, whichever owns the concern."

heuristic: "Three or more related files are evidence that a topic directory may be useful, not a requirement. One or two files may use a topic directory when the boundary is already clear and useful."
anti_pattern: "Do not create a new file or directory for every small piece of information. Prefer the simplest structure that keeps ownership and routing clear."
```

---

## Document Deletion Workflow

```yaml
when_to_delete:
  - "A project-owned document is obsolete — the content it described no longer exists."
  - "A project-owned document was merged into another document and is now redundant."
  - "The user explicitly asks to remove a project-owned document."

deletion_steps:
  1: "Search project-owned documentation and relevant routing for references to the document."
  2: "Update or remove all referencing links."
  3: "Remove the document's entry from documents/INDEX.md."
  4: "Bump index_version in INDEX.md (minor — project-owned file removed from registry)."
  5: "Commit: 'refactor: <document>を削除' with a note explaining why in the body."

rule: "Never delete a project-owned document that other documents still reference without fixing those references first."
managed_guidance: "Do not delete individual files under documents/artifacts/ through this workflow. Use Managed Artifact Handling and the explicit module-removal/update mechanism."
confirmation: "L2_structural — proceed only if clearly implied by the task; report explicitly."
```

---

## Re-read Triggers

When an AI agent should reload this strategy before acting.

```yaml
must_re_read:
  - "First contact with a project using this strategy (read INDEX.md first)."
  - "Creating or restructuring the project-owned documents/ tree."
  - "Setting up a new project that will use AI agents."
  - "Adopting this strategy in an existing project (brownfield)."

should_re_read:
  - "Adding a new agent entry file."
  - "Restructuring project-owned documents (moving files between directories)."
  - "Changing the project from single to hierarchical (or vice versa)."
  - "Uncertainty about whether a documents/ path is project-owned or distributor-managed."

no_re_read_needed:
  - "Routine content updates within an existing project-owned file."
  - "Adding a new project-owned document in an established directory."
  - "Updating constraints or status in an existing project document."
  - "Routine artifact sync when the project's documented distribution mechanism is already clear."
  - "Routine edits within already-established Work Documents when the Work Identity and routing are clear."
```

---

## Confirmation Gate

Before changing the **project-owned documentation structure**, assess the impact.

```yaml
L0_content: "Updating content within an existing project-owned file (no structural change) — proceed."
L1_additive: "Adding a new project-owned file in an existing directory — proceed and report."
L2_structural: "Moving project-owned files, changing routing paths, renaming files, deleting a project-owned document — proceed only if clearly implied by the task; report explicitly."
L3_breaking: "Removing a core project document, restructuring the entire project-owned documents/ tree, changing project from single to hierarchical — MUST confirm before implementation."
managed_guidance_rule: "Install/update/remove of documents/artifacts/ follows the artifact distribution mechanism's own explicit semantics; do not disguise those operations as ordinary L0/L1 project-document edits."
rule: "When in doubt, ask the user. Structural changes affect every future AI agent session."
```