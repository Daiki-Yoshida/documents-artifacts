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
