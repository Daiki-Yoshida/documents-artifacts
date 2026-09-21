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

Human-facing project content lives under `docs-jp/`, not under the AI-facing `documents/` tree.

```yaml
docs_jp:
  language: "Japanese"
  examples:
    - "project background and motivation"
    - "setup tutorials for human developers"
    - "design rationale and decision explanations"
    - "Japanese companion/translation material for human review"
```

AI-facing vs human-facing is an optimization/routing distinction, not an access restriction: humans may read `documents/`.

AI-facing documents are English by default, but Japanese or another language is allowed when the AI needs that original context and translation could degrade meaning.

### README.md

`README.md` is a brief human-facing project entry. It should summarize the project and route humans to `docs-jp/` when more detail is needed.

AI agents should not rely on README as the canonical project-context source when `documents/` exists; enter through the project knowledge routing instead.

## 7. Agent Entry Files

Tool-specific files such as `AGENTS.md`, `CLAUDE.md`, and `GEMINI.md` are the first project entry for the corresponding agent tool and should remain small.

Create one only for an agent tool the project actually uses.

They own project/tool-specific conventions such as:

- role;
- language/output settings;
- execution constraints;
- emergency behavior when intent is unclear;
- `project_ref: documents/INDEX.md`;
- optional routing to installed derived reusable guidance;
- focus-file hints;
- current development priority when genuinely useful across the session.

They should link to canonical project/reusable knowledge rather than duplicate architecture, specifications, or generic guidance.

The generated entry is a project-owned starting template; project maintainers may customize local rules afterward.

## 8. documents/INDEX.md

`documents/INDEX.md` is required for a project using this knowledge model.

It owns the routing hub **and** version registry for canonical project-owned documents under `documents/`.

It must provide:

- inventory of every canonical project-owned document and its purpose;
- task/question routing to the owning project/reference document;
- each registered document's version and reflected Git commit/state;
- cross-reference relationships when useful for maintenance;
- optional entry links to installed derived reusable guidance.

Exclude from the project registry:

- active Work Documents;
- individual files inside distributor-managed derived guidance.

`INDEX.md` has its own `index_version`, `last_updated_commit`, and `last_updated_date`. It does not list itself as a registry entry and does not carry a second `document_version`.

Avoid turning the index into an independently maintained semantic summary of every document. It routes and records metadata; the target document owns the detail.

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

Markdown cross-references are relative to the referencing file. Registry `path` values, by contrast, are repository-root-relative identifiers used for unique document identification.

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

## 13. Project Document Versioning

Canonical project-owned documents under `documents/` use semantic document versions.

```text
major = document restructuring/rewrite or scope change that invalidates prior structural understanding
minor = meaningful content addition or significant update
patch = small correction, clarification, typo fix, or metadata refresh
initial = 1.0.0
```

Each canonical project-owned document records in its existing top YAML code block:

```yaml
document_version: "1.2.0"
last_updated_commit: "abc1234"
last_updated_date: "2026-09-21"
```

Do not use a separate YAML front-matter delimiter merely for these fields.

Exceptions:

- active Work Documents do not require Project Document semantic-version/hash metadata;
- distributor-managed derived reusable guidance preserves the metadata owned by its publication source and is excluded from the target project's per-file registry.

### INDEX version

`documents/INDEX.md` uses `index_version` as its sole semantic version:

```text
major = registry/routing structure substantially reorganized
minor = canonical project-owned document added/removed or routing changed
patch = metadata/entry correction
```

A derived-guidance content update alone does not create project-registry entries. Bump the project index only when the project's routing to that guidance changes.


## 14. Commit/State Provenance

A commit cannot contain its own final hash as mutable tracked content. Therefore `last_updated_commit` identifies the **content/code state the document was updated or reviewed against**, not the later metadata-recording commit.

Use the two-phase workflow:

1. update document content and bump `document_version`;
2. leave `last_updated_commit` blank or `pending` when the reflected commit is not yet known;
3. commit the content;
4. resolve the reflected commit/state;
5. update `last_updated_commit` in both the document header and its `documents/INDEX.md` registry entry;
6. commit that metadata update separately.

For a content update, the reflected state is normally the content commit. For a staleness review with no content change, it may be the reviewed code HEAD/state.

Do **not** amend a commit trying to embed its own hash. Do **not** recursively update the recorded hash merely because the metadata-recording commit now exists.

The established metadata follow-up form is:

```text
chore: <document>のコミットハッシュを記録
```

## 15. Staleness

A recorded reflected commit/state can help detect possible staleness.

Example:

```bash
git log --oneline <last-reviewed-ref>..HEAD -- <relevant-paths>
```

Changes after that state are a signal to review the document, not automatic proof that it is wrong.

Do not apply target-project staleness metadata rules to derived reusable guidance as though it were project-owned content.

## 16. Documentation Git Commits

Documentation commits use a Conventional Commits-style English prefix with a Japanese description.

```text
<type>: <Japanese description>
```

Types:

- `docs:` documentation content/routing changes;
- `feat:` new documentation feature/section/versioning entry;
- `fix:` correcting inaccurate information;
- `refactor:` moving/reorganizing/deleting documentation;
- `chore:` version/metadata/hash maintenance.

Rules:

- use Japanese after the English prefix;
- describe what changed concisely;
- when a documentation commit accompanies a code change, reference the code commit hash in the commit body.

This knowledge model does not decide **when** to commit, whether to branch, or commit granularity; those remain development-workflow decisions.

## 17. New Project Knowledge Setup

For a new project:

1. create one small agent entry file per AI tool actually used;
2. create the project-owned `documents/` structure;
3. create required `documents/INDEX.md` with `index_version: 1.0.0`;
4. create the needed Project Documents, each starting at `document_version: 1.0.0`;
5. register every canonical project-owned document in the index with version, reflected commit/state, date, and purpose;
6. create `docs-jp/` when human-facing content is needed;
7. add reference/topic documents only when current project knowledge requires them;
8. link installed derived reusable guidance instead of copying its rules into project-owned documents.

Do not speculatively create empty directories or documentation merely to satisfy a template.

## 18. Brownfield Documentation Adoption

For an existing project:

1. audit documentation by audience, ownership, accuracy, and current use;
2. classify each relevant path as AI-facing project-owned, distributor-managed derived guidance, human-facing, shared, or obsolete;
3. map project-owned AI knowledge into `documents/project/`, `documents/reference/`, or a justified topic owner;
4. keep distributor-managed guidance in its managed location and do not add project-document metadata to it;
5. move human-facing content to `docs-jp/`;
6. merge genuine project-owned duplication into one owner and update links;
7. register migrated project-owned documents in `documents/INDEX.md`;
8. preserve information — do not delete existing content merely as part of structural migration without user authorization;
9. report what moved, merged, remained managed, or was identified as obsolete.

Structural migration and content improvement are separate changes. Do not let documentation adoption expand into an unrelated content rewrite.

General brownfield scope rules live in `ENGINEERING_OPERATING_MODEL.md`.

## 19. Ongoing Updates

Update canonical Project Documents when accepted/current knowledge materially changes, including architecture, features, constraints, technology, or routing structure.

Do not update every document after every code commit.

When information belongs to an active Work and is not yet accepted, keep it in Work Documents.

Discipline:

- when a canonical document changes, bump its semantic version appropriately;
- update its INDEX registry metadata through the two-phase workflow;
- when adding a canonical Project Document, register and route it;
- when project routing changes, bump `index_version`;
- check that newly added information does not duplicate an existing semantic owner;
- do not directly edit distributor-managed guidance merely to encode a target-project exception.

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
