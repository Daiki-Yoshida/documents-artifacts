# Canonical Engineering Knowledge

```yaml
document_type: "knowledge_index"
authority: "canonical_source"
audience: ["ai_agents", "human_maintainers"]
role: "routing hub for reusable engineering knowledge"
```

This directory is the semantic source of truth for reusable engineering knowledge in this repository.

`artifacts/` is a **derived AI delivery surface**. Its layout, file count, read order, packaging, or distribution mechanism may change without changing the knowledge defined here.

## Knowledge Model

```text
documents/knowledge/              canonical meaning
        │
        ├─ ENGINEERING_OPERATING_MODEL.md
        ├─ WORK_LIFECYCLE.md
        ├─ CODE_DESIGN.md
        ├─ DEVELOPMENT_EXECUTION.md
        └─ PROJECT_KNOWLEDGE.md
                │
                ▼
artifacts/                        derived AI-facing projection(s)
                │
                ▼
target projects                   installed snapshot / local routing
```

Historical rationale, experiments, and migration evidence may live elsewhere in this repository, but they do not override canonical knowledge.

## Read Strategy

Do not read every document by default.

Start here, then load only the relevant owner.

```yaml
cross_cutting_engineering_behavior:
  target: "ENGINEERING_OPERATING_MODEL.md"
  examples:
    - "authority / precedence"
    - "safety"
    - "confirmation"
    - "brownfield behavior"
    - "validation"
    - "progressive disclosure"

active_development_work:
  target: "WORK_LIFECYCLE.md"
  examples:
    - "Work Identity"
    - "Work Root"
    - "Work Documents"
    - "branch / repository participation"
    - "optional worktrees"
    - "Work-scoped resources"
    - "completion / cleanup"

code_design:
  target: "CODE_DESIGN.md"
  examples:
    - "Bounded Contracts"
    - "module boundaries"
    - "domain/application/infrastructure/UI"
    - "state ownership"
    - "DI / errors / async"
    - "testing"
    - "code change process"

development_execution:
  target: "DEVELOPMENT_EXECUTION.md"
  examples:
    - "host/container boundary"
    - "Docker-first execution"
    - "public commands"
    - "ports / volumes / caches / secrets"
    - "diagnostics"
    - "CI parity"
    - "environment bootstrap/recovery"

project_knowledge:
  target: "PROJECT_KNOWLEDGE.md"
  examples:
    - "Project Documents"
    - "documents/INDEX.md"
    - "routing"
    - "agent entry files"
    - "version/staleness provenance"
    - "docs-jp"
    - "derived reusable guidance"
```

## Ownership Principles

1. A concept has one canonical semantic owner.
2. Organize primarily by concept/lifecycle, not by WHY/HOW/WHERE/FLOW facets.
3. Publication artifacts may split or combine canonical knowledge for AI retrieval efficiency.
4. Distribution bundles do not define canonical knowledge boundaries.
5. Target-project rules remain more specific than reusable knowledge.

## Canonical Documents

| Document | Owns |
|---|---|
| `ENGINEERING_OPERATING_MODEL.md` | cross-cutting authority, safety, proportionality, confirmation, brownfield, validation, Git-history principle, progressive disclosure |
| `WORK_LIFECYCLE.md` | complete Work model: Work Identity, Work Root, Work Documents, repositories/branches/worktrees/resources, integration, reconciliation, completion |
| `CODE_DESIGN.md` | code boundaries, contracts, architecture, domain/state, DI/errors/async, structure, evolution, implementation and verification |
| `DEVELOPMENT_EXECUTION.md` | host/container execution, Docker, command interfaces, runtime resources, secrets, diagnostics, reproducibility, CI |
| `PROJECT_KNOWLEDGE.md` | accepted/current project knowledge, routing, document roles, provenance, staleness, agent entry files, hierarchy, maintenance |
| `TRACEABILITY.md` | migration map from the legacy artifact files to canonical owners; evidence that knowledge was not intentionally discarded |

## Canonical vs Derived

If a future artifact projection disagrees with this directory, this directory owns the reusable semantic meaning.

Artifacts may intentionally:

- shorten;
- reorder;
- combine;
- split;
- rename;
- package by task/profile;
- add routing metadata.

They must not silently invent or delete canonical engineering rules.

If an artifact requires a new rule, update canonical knowledge first, then update the projection.

## Change Rule

A reusable knowledge change follows:

```text
new evidence / design decision
  ↓
update canonical owner under documents/knowledge/
  ↓
review semantic impact + traceability
  ↓
regenerate / edit affected artifact projection(s)
  ↓
sync into target projects as needed
```

Do not use artifact layout as the place where semantic design decisions originate.

## Migration Status

The existing `artifacts/` tree remains present during this migration. It is the source material from which this canonical layer was extracted.

Until the artifact redesign is completed:

- do not delete the legacy artifacts;
- do not assume the current module split is the future publication model;
- use `TRACEABILITY.md` when checking that a canonical rewrite preserves existing knowledge.
