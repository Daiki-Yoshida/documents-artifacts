# Project Knowledge Model

```yaml
document_type: "canonical_knowledge"
authority: "canonical_source"
audience: ["ai_agents", "human_maintainers"]
scope: "project documentation, routing, provenance, and maintenance"
artifact_projection: "derived"
```

This document owns the model for accepted/current project knowledge and its routing. Active Work knowledge is owned by `WORK_LIFECYCLE.md`.

## 1. Purpose

Project documentation exists to give agents and maintainers accurate information at the right time.

```yaml
priority:
  1: "accuracy"
  2: "routing and ownership"
  3: "progressive disclosure"
  4: "token efficiency"
```

Do not truncate load-bearing knowledge merely to fit a token budget. Improve concept ownership and routing instead.

## 2. Knowledge Zones

Recommended semantic roles:

```text
documents/                  # canonical AI-facing project knowledge
docs-jp/                    # human-facing explanation/rationale when useful
README.md                   # human project entry
AGENTS.md / CLAUDE.md ...   # small tool-specific routing + local constraints
```

Within `documents/`, a useful default is:

```text
documents/
├─ INDEX.md                 # small routing hub
├─ project/                 # accepted/current broadly useful project context
├─ reference/               # on-demand factual/reference material
└─ artifacts/               # optional derived reusable-guidance snapshot
```

The exact directories are adaptable. Semantic role matters more than rigid template compliance.

## 3. Canonical Project Documents

Project Documents describe the accepted/current state of the target project.

Typical concerns include:

- overview and scope;
- architecture;
- current constraints;
- supported execution and validation;
- domain vocabulary;
- reference contracts;
- current operational facts.

They are project-owned and maintained with the project.

Active Work intent, provisional decisions, and investigation results do not belong here until accepted. See `WORK_LIFECYCLE.md`.

## 4. Work Documents Relationship

Work Documents live with the active Work and are not canonical Project Documents.

```text
active Work knowledge
  → Work Documents

accepted/current durable knowledge
  → Project Documents
```

At Work completion, reconcile rather than copy blindly.

This document governs how accepted Project Documents are structured after promotion. Work Identity, Work Document location/ownership, and completion semantics are owned by `WORK_LIFECYCLE.md`.

## 5. Reusable Guidance as a Derived Projection

Reusable AI guidance distributed into a target project is a **derived knowledge projection**, not target-project-owned canonical knowledge.

A target project may commit the derived snapshot for reproducibility, but:

- the target project does not become the canonical semantic owner;
- the project's own document registry need not version every derived file;
- updates should come through the projection's publication/sync mechanism;
- explicit target-project rules may override generic guidance.

In this repository:

```text
documents/knowledge/   canonical reusable engineering knowledge
artifacts/             derived AI-facing publication/projection
```

Artifact layout, packaging, file count, and read order may change without changing canonical meaning.

## 6. Human-Facing Knowledge

Human-facing tutorials, background, rationale, and historical narrative may live under `docs-jp/` or another explicit human-facing area.

AI-facing vs human-facing is an optimization/routing distinction, not an access restriction.

Japanese or another language may appear in AI-facing knowledge when the information itself requires it. Language choice must not destroy domain meaning.

## 7. Agent Entry Files

Tool-specific files such as `AGENTS.md`, `CLAUDE.md`, and `GEMINI.md` should remain small.

They may own:

- project-specific constraints;
- emergency/ambiguity behavior;
- language/output conventions;
- the primary project-knowledge entry point;
- high-priority task routing;
- truly global current context.

They should link to canonical project/reusable knowledge rather than duplicate detailed architecture or generic rules.

## 8. documents/INDEX.md

The project index should primarily be a routing hub.

It may also carry an inventory/version registry when useful, but routing is the essential role.

A good index answers:

- what knowledge exists;
- which document owns a question;
- which documents are always relevant vs on-demand;
- where derived/external guidance is entered.

Avoid turning the index into an independently maintained summary of every document.

## 9. Routing

Prefer:

```text
agent entry
  ↓
documents/INDEX.md
  ↓
one owning project/reference document
  ↓
additional detail only when needed
```

A task should not require reading every project document merely to discover one fact.

Split and route by semantic concern and lifecycle, not arbitrary file-size thresholds.

Use stable relative links within the repository.

## 10. Single Semantic Owner

Each project fact or rule has one owning document.

Allowed:

- a one-sentence contextual restatement;
- a link to the owner;
- a concise routing summary.

Avoid:

- independently maintained copies;
- project documents mirroring reusable derived guidance;
- parent and child projects duplicating detailed internal knowledge.

Cross-cutting owner principles are defined in `ENGINEERING_OPERATING_MODEL.md`.

## 11. Project vs Reference Documents

Useful defaults:

```yaml
project:
  role: "current project-level context needed broadly during development"
reference:
  role: "detailed facts/contracts consulted on demand"
```

Create a topic directory when it establishes a clear routing, ownership, or lifecycle boundary — not because a fixed number of files exists.

Avoid speculative empty structure.

## 12. Glossary

Create a domain glossary when repeated, ambiguous, or cross-language vocabulary materially affects accuracy.

A glossary owns term meaning. Other documents use the vocabulary instead of redefining it.

Do not create a glossary merely to satisfy a template.

## 13. Versioning

Project-document semantic versioning is optional project policy.

When used:

```text
major = structural/semantic break
minor = meaningful content addition/change
patch = correction/clarification
```

The index may carry an `index_version` separately from individual documents.

Derived reusable guidance may use its own publication versioning and should not be forced into the target project's per-document registry.


## 14. Commit/State Provenance

When a project records the Git state a document reflects, remember that a commit cannot contain its own final hash as mutable tracked content.

A two-phase process may be used:

1. update content and version;
2. commit the content;
3. record the reflected commit/state in a follow-up metadata update.

The recorded hash refers to the state reviewed/reflected by the document, not the metadata-recording commit itself.

Do not recursively chase the metadata commit.

## 15. Staleness

A recorded reflected commit/state can help detect possible staleness.

Example:

```bash
git log --oneline <last-reviewed-ref>..HEAD -- <relevant-paths>
```

Changes after that state are a signal to review the document, not automatic proof that it is wrong.

Do not apply target-project staleness metadata rules to derived reusable guidance as though it were project-owned content.

## 16. Documentation Git Commits

A project may use a convention such as:

```text
<conventional-type>: <project-language description>
```

Useful semantic categories include:

- `docs:` content/routing;
- `fix:` incorrect information;
- `refactor:` restructuring;
- `chore:` metadata/version maintenance.

Exact language and conventions are project-owned.

This knowledge model does not decide when the project should commit.

## 17. New Project Knowledge Setup

For a new project:

1. create a small agent entry file for each supported tool only when needed;
2. create `documents/INDEX.md`;
3. create only the project/reference documents needed now;
4. add human-facing documentation separately when useful;
5. link derived reusable guidance instead of copying its rules into project-owned documents;
6. add glossary/topic directories only when a real routing need appears.

## 18. Brownfield Documentation Adoption

For an existing project:

1. audit documentation by audience, ownership, accuracy, and current use;
2. classify each relevant path as canonical project knowledge, reference, human-facing, derived/external guidance, or obsolete;
3. move/rewrite only when a clearer owner exists;
4. preserve project-specific facts;
5. update links/routing;
6. remove genuine duplication and obsolete material;
7. do not rewrite unrelated working documentation merely for stylistic uniformity.

General brownfield scope rules live in `ENGINEERING_OPERATING_MODEL.md`.

## 19. Ongoing Updates

Update a Project Document when the accepted/current state it owns changes materially.

Do not update every document after every code commit.

When information belongs to an active Work and is not yet accepted, keep it in Work Documents.

When one concern outgrows a document, split it by semantic ownership and update routing.

## 20. Document Creation Decision

Create a new canonical Project Document when:

- a distinct semantic owner is needed;
- the concern has a useful independent lifecycle;
- routing to the concern improves;
- keeping it in the existing owner would mix unrelated meanings.

Do not split merely to reduce line count.

## 21. Document Deletion

Before deleting a canonical Project Document:

1. verify it is obsolete or ownership moved;
2. update inbound references;
3. update/remove index entries;
4. preserve any still-current knowledge at its new owner;
5. rely on Git history for historical recovery.

Do not delete individual derived artifact files through project-document deletion rules; update the derived projection through its owner.

## 22. Hierarchical / Multi-Project Repositories

Parent and child projects may each own independent `documents/` trees.

Principles:

- child detailed knowledge stays child-owned;
- parent documents describe child boundaries/high-level coordination rather than duplicating child internals;
- a child need not depend on parent-internal documentation;
- reusable derived guidance may be installed independently per project.

A parent may keep a high-level children overview, but children should remain self-contained unless explicit coordination requires otherwise.

## 23. Multi-Developer Index Conflicts

If an index is also a central version registry, concurrent updates may conflict.

Mitigations:

- stable sorting;
- minimal edits;
- retain both independent entries during conflict resolution;
- separate registry metadata commits when useful.

If registry conflict cost becomes high, reconsider whether all metadata belongs in one central file.

## 24. File Format

Default to Markdown for explanatory knowledge and YAML/JSON for structured blocks when they improve precision.

Use format to clarify semantics rather than decorate the document.

Naming/layout follow project convention.

## 25. Re-read / Loading Strategy

Do not require every documentation rule for every project task.

Always-on context should normally include only:

- project routing;
- hard local constraints;
- current task-relevant project knowledge.

Load detailed document-maintenance rules when creating/restructuring documentation, changing routing/ownership, diagnosing staleness, or changing version/provenance policy.

## 26. Common Misreadings

- `documents/` being AI-facing does not mean every file beneath it is project-owned.
- Work Documents are not canonical accepted knowledge merely because they are Git-tracked.
- derived reusable guidance committed in a project is not automatically editable project documentation.
- "routing over truncation" does not mean infinite tiny files.
- "single source of truth" does not prohibit short contextual references.
- version metadata is a tool for provenance, not the knowledge itself.
