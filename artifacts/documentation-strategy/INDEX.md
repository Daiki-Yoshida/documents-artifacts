# Documentation Strategy - Index

```yaml
document_type: "index"
target_audience: "ai_agents"
language: "english"
role: "entry point for the documentation strategy artifact set"
strategy_version: "2.2.0"
```

This is the entry point for the exported strategy. Read it first.

## Read Order

```yaml
1_philosophy: "DOCUMENTATION_PHILOSOPHY.md"   # WHY:  accuracy priority, scope, git as recording, design-principles relationship
2_structure:  "FILE_AND_STRUCTURE.md"         # HOW+WHERE: file roles, directory layout, versioning, git conventions, hierarchy, deletion
3_workflow:   "DOCUMENT_WORKFLOW.md"           # FLOW: setup, update, brownfield, staleness handling, version bumping, deletion
```

On first contact, read 1 → 2 → 3. For a specific task, jump via Quick Task Routing.

## Foundational Lens

These artifacts assume an **accuracy-first, routing-driven** paradigm for documentation.

```yaml
core_idea: "Documentation gives AI agents accurate information at the right time. Token efficiency is achieved through file structure and routing, never through information truncation."
priority: "accuracy > routing > token efficiency"
scope: "documents/ only — not code design, not git timing, not branching"
audience: "documents/ is entirely AI-facing; human-facing content goes in docs-jp/"
recording: "Git is the recording tool — we govern commit message format and version tracking, not commit timing"
```

## Ownership Map (Single Source of Truth)

Each concept lives in exactly ONE document. Link, never duplicate.

```yaml
DOCUMENTATION_PHILOSOPHY.md:
  owns:
    - "Information accuracy as top priority (accuracy > token efficiency)"
    - "Scope boundary: documents/ only, not code"
    - "Git as a recording tool (principle, not timing)"
    - "AI-facing by default; human-facing is a separate concern"
    - "Routing over truncation: split files, do not shrink information"
    - "Relationship to design-principles (domain boundary, usage patterns, simultaneous-read guidance)"
    - "Common misreadings"

FILE_AND_STRUCTURE.md:
  owns:
    - "documents/ directory: all AI-facing"
    - "docs-jp/ directory: human-facing (Japanese)"
    - "INDEX.md role: routing hub + document version registry"
    - "File roles: agent entry files, INDEX.md, project docs, reference docs"
    - "Document versioning system: semantic version + git commit hash"
    - "Two-phase commit hash workflow"
    - "Staleness detection in practice (git log commands)"
    - "INDEX.md version bumping (index_version)"
    - "Git commit message conventions for documentation"
    - "Cross-reference and routing strategy (relative paths)"
    - "Directory splitting guide (Rule of Three)"
    - "Hierarchical projects (parent-child documentation)"
    - "Document deletion rules"
    - "Multi-developer INDEX.md conflict mitigation"
    - "File format standards"

DOCUMENT_WORKFLOW.md:
  owns:
    - "New project setup: step-by-step"
    - "Brownfield adoption: audit, classify, migrate"
    - "Ongoing document updates"
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
"updating an existing document":            "DOCUMENT_WORKFLOW.md (Use Case 3: Ongoing Document Updates) + FILE_AND_STRUCTURE.md (§2 File Roles)"
"document is stale (behind HEAD)":          "DOCUMENT_WORKFLOW.md (Use Case 4: Staleness Handling) + FILE_AND_STRUCTURE.md (§4 Staleness Detection in Practice)"
"bumping a document version":               "DOCUMENT_WORKFLOW.md (Version Bumping Workflow) + FILE_AND_STRUCTURE.md (§4 Document Versioning System)"
"recording commit hash after update":       "FILE_AND_STRUCTURE.md (§4 Commit Hash: Two-Phase Workflow) — DOCUMENT_WORKFLOW.md links here"
"writing a git commit message for docs":    "FILE_AND_STRUCTURE.md (Git Commit Conventions)"
"which file should hold this information":  "FILE_AND_STRUCTURE.md (§2 File Roles)"
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
