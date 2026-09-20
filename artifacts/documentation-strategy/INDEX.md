# Documentation Strategy - Index

```yaml
document_type: "index"
target_audience: "ai_agents"
language: "english"
role: "entry point for the documentation strategy artifact set"
strategy_version: "2.5.0"
```

This is the entry point for the exported strategy. Read it first.

## Read Order

```yaml
1_philosophy: "DOCUMENTATION_PHILOSOPHY.md"   # WHY:  accuracy priority, scope, ownership boundaries, git as recording, design-principles relationship
2_structure:  "FILE_AND_STRUCTURE.md"         # HOW+WHERE: file roles, directory layout, managed guidance, versioning, git conventions, hierarchy, deletion
3_workflow:   "DOCUMENT_WORKFLOW.md"           # FLOW: setup, update, brownfield, managed-artifact handling, staleness, version bumping, deletion
```

On first contact, read 1 → 2 → 3. For a specific task, jump via Quick Task Routing.

## Foundational Lens

These artifacts assume an **accuracy-first, routing-driven** paradigm for documentation.

```yaml
core_idea: "Documentation gives AI agents accurate information at the right time. Token efficiency is achieved through file structure and routing, never through information truncation."
priority: "accuracy > routing > token efficiency"
scope: "canonical Project Documents, active Work Documents, human-facing separation, routing, and documentation recording/versioning — not source-code design or Work Identity topology"
audience: "documents/ holds canonical AI-facing project knowledge; active Work Documents live under .worktrees/<identity>/documents/ when Work Identity is used; documents/artifacts/ is distributor-managed; human-facing content goes in docs-jp/"
recording: "Git is the recording tool — we govern documentation commit format and project-document version tracking, not commit timing"
```

## Ownership Map (Single Source of Truth)

Each concept lives in exactly ONE document. Link, never duplicate.

```yaml
DOCUMENTATION_PHILOSOPHY.md:
  owns:
    - "Information accuracy as top priority (accuracy > token efficiency)"
    - "Scope boundary: canonical Project Documents vs active Work Documents vs distributor-managed guidance; not code/environment design"
    - "Git as a recording tool (principle, not timing)"
    - "AI-facing by default; human-facing is a separate concern"
    - "Routing over truncation: split files, do not shrink information"
    - "Relationship to design-principles (domain boundary, usage patterns, simultaneous-read guidance)"
    - "Common misreadings"

FILE_AND_STRUCTURE.md:
  owns:
    - "documents/ directory: canonical AI-facing project root with distinct ownership zones"
    - "Work Documents under .worktrees/<work-type>/<work-name>/documents/: active Work knowledge, Git-recorded but excluded from canonical document registry"
    - "documents/artifacts/ managed-guidance subtree: distributor-owned, excluded from project document registry/versioning"
    - "docs-jp/ directory: human-facing (Japanese)"
    - "INDEX.md role: routing hub + project-document version registry"
    - "File roles: agent entry files, INDEX.md, project docs, reference docs, managed guidance"
    - "Domain glossary guidance for repeated, ambiguous, or cross-language terms"
    - "Document versioning system: semantic version + git commit hash"
    - "Two-phase commit hash workflow and non-self-referential hash semantics"
    - "Staleness detection in practice (git log commands)"
    - "INDEX.md version bumping (index_version)"
    - "Git commit message conventions for documentation"
    - "Cross-reference and routing strategy (relative paths)"
    - "Directory splitting guide (permission-based; file count is a heuristic, not a threshold)"
    - "Hierarchical projects (parent-child documentation)"
    - "Document deletion rules"
    - "Multi-developer INDEX.md conflict mitigation"
    - "File format standards"

DOCUMENT_WORKFLOW.md:
  owns:
    - "New project setup: step-by-step"
    - "Brownfield adoption: audit, classify, migrate"
    - "Managed artifact guidance handling: preserve/sync/remove through its owning distribution mechanism, not project-doc editing"
    - "Ongoing canonical project-document updates"
    - "Work Documents: create/maintain/reconcile active-work knowledge"
    - "Staleness handling: detection, classification, update flow"
    - "Version bumping workflow (links to FILE_AND_STRUCTURE.md §4 for the two-phase procedure)"
    - "Document creation decision tree"
    - "Document deletion workflow"
    - "Re-read triggers"
    - "Confirmation gate (L0–L3)"
```

## Quick Task Routing

```yaml
"setting up docs for a new project":       "DOCUMENT_WORKFLOW.md (New Project Setup) + FILE_AND_STRUCTURE.md (File Roles)"
"adopting strategy in existing project":    "DOCUMENT_WORKFLOW.md (Brownfield Adoption)"
"working with installed guidance under documents/artifacts/": "FILE_AND_STRUCTURE.md (Managed Artifact Guidance) + DOCUMENT_WORKFLOW.md (Managed Artifact Handling)"
"working with active Work Documents":             "DOCUMENTATION_PHILOSOPHY.md (Work Documents: Active-Work Knowledge) + FILE_AND_STRUCTURE.md (Work Documents) + DOCUMENT_WORKFLOW.md (Use Case 6: Work Documents)"
"promoting Work knowledge into Project Documents": "DOCUMENT_WORKFLOW.md (Use Case 6: Work Documents)"
"updating an existing project document":    "DOCUMENT_WORKFLOW.md (Use Case 3: Ongoing Document Updates) + FILE_AND_STRUCTURE.md (§2 File Roles)"
"document is stale (behind HEAD)":          "DOCUMENT_WORKFLOW.md (Use Case 4: Staleness Handling) + FILE_AND_STRUCTURE.md (§4 Staleness Detection in Practice)"
"bumping a document version":               "DOCUMENT_WORKFLOW.md (Version Bumping Workflow) + FILE_AND_STRUCTURE.md (§4 Document Versioning System)"
"recording commit hash after update":       "FILE_AND_STRUCTURE.md (§4 Commit Hash: Two-Phase Workflow) — DOCUMENT_WORKFLOW.md links here"
"writing a git commit message for docs":    "FILE_AND_STRUCTURE.md (Git Commit Conventions)"
"which file should hold this information":  "FILE_AND_STRUCTURE.md (§2 File Roles)"
"defining domain or cross-language terms":  "FILE_AND_STRUCTURE.md (§2 Domain Glossary)"
"should I create a new directory":          "FILE_AND_STRUCTURE.md (§7 Directory Splitting Guide)"
"how to structure a multi-service project": "FILE_AND_STRUCTURE.md (Hierarchical Projects)"
"setting up documents/INDEX.md":            "FILE_AND_STRUCTURE.md (§2 documents/INDEX.md) + DOCUMENT_WORKFLOW.md (Use Case 1: New Project Setup)"
"deleting a document":                      "DOCUMENT_WORKFLOW.md (Document Deletion Workflow) + FILE_AND_STRUCTURE.md (§9 Document Deletion Rules)"
"splitting a document into two":            "FILE_AND_STRUCTURE.md (§7 Directory Splitting Guide) + DOCUMENT_WORKFLOW.md (Version Bumping Workflow)"
"when should I re-read this strategy":      "DOCUMENT_WORKFLOW.md (Re-read Triggers)"
"what does this strategy govern":           "DOCUMENTATION_PHILOSOPHY.md (Scope Boundary)"
"how does this relate to design-principles": "DOCUMENTATION_PHILOSOPHY.md (Relationship to design-principles)"
"is this change safe to make without asking": "DOCUMENT_WORKFLOW.md (Confirmation Gate)"
"project convention conflicts with strategy": "DOCUMENT_WORKFLOW.md (Brownfield Guard)"
"adding an agent entry file":               "FILE_AND_STRUCTURE.md (§2 Agent Entry Files)"
"INDEX.md merge conflict":                  "FILE_AND_STRUCTURE.md (§10 Multi-Developer INDEX.md Conflict Mitigation)"
```
