# documents-artifacts

Canonical repository for reusable engineering knowledge and the AI-facing guidance derived from it.

The repository separates **semantic knowledge ownership** from **artifact publication/distribution** so the artifact layout can be redesigned without changing engineering meaning.

## Source-of-truth model

```text
GitHub: Daiki-Yoshida/documents-artifacts
        │
        ├─ documents/
        │  ├─ knowledge/    canonical reusable engineering knowledge
        │  └─ project/      documentation about this repository itself
        │
        ├─ artifacts/       derived AI-facing projection (legacy projection during migration)
        ├─ docs-jp/         non-canonical human/rationale/experiment material
        └─ artifacts.sh     current legacy projection sync tool
                │
                ▼
Target project
└─ documents/
   └─ artifacts/            installed derived snapshot
```

### Authority

```text
documents/knowledge/
    ↓ defines reusable semantic meaning

artifacts/
    ↓ projects that meaning for AI consumption

target-project installed artifacts
    ↓ reproducible snapshot + local routing
```

Rules:

- `documents/knowledge/` is the canonical source for reusable engineering knowledge.
- `artifacts/` is derived. Its files, grouping, read order, profiles, or packaging may change without changing canonical meaning.
- If a future artifact requires a new reusable rule, update the canonical knowledge owner first.
- Target-project rules are more specific than reusable guidance.
- `docs-jp/` may preserve rationale, experiments, Japanese explanations, and migration evidence. It does not override canonical knowledge.
- Git owns history, rollback, comparison, and archival. Do not build a parallel history database.

## Canonical Knowledge

Start at:

```text
documents/knowledge/INDEX.md
```

Current semantic owners:

| Document | Scope |
|---|---|
| `ENGINEERING_OPERATING_MODEL.md` | Cross-cutting authority, safety, confirmation, brownfield, validation, semantic ownership, progressive disclosure |
| `WORK_LIFECYCLE.md` | Work Identity, Work Root, Work Documents, repositories/branches/worktrees/resources, reconciliation and completion |
| `CODE_DESIGN.md` | Bounded Contracts, code/module boundaries, architecture, state/dependencies/errors/async, evolution, testing and change process |
| `DEVELOPMENT_EXECUTION.md` | Host/container boundary, Docker, public commands, runtime resources, secrets, diagnostics, reproducibility and CI |
| `PROJECT_KNOWLEDGE.md` | Project Documents, routing, agent entry files, provenance/staleness, hierarchy and document maintenance |
| `TRACEABILITY.md` | Migration map from the legacy artifact files to canonical owners |

The canonical layer is organized by semantic concept/lifecycle rather than the legacy `design-principles / documentation-strategy / development-environment-strategy` packaging or WHY/HOW/WHERE/FLOW facets.

## Current Artifact Migration State

The existing `artifacts/` tree remains intact while the publication layer is redesigned.

Legacy directories currently present:

```text
artifacts/
├─ design-principles/
├─ documentation-strategy/
└─ development-environment-strategy/
```

These directories are **not the new canonical knowledge boundary**.

The previous premise that these directories are independently selectable knowledge modules has been retired for the redesign. The current files remain temporarily because they are deployed in existing projects and provide the baseline from which the new projection will be designed.

Do not delete or restructure the legacy artifact projection until the new publication/distribution design is explicitly completed.

## Traceability

`documents/knowledge/TRACEABILITY.md` maps all 14 legacy artifact Markdown files and their major concerns to the new semantic owners.

This provides a migration invariant:

```text
artifact structure may change
≠
engineering knowledge may silently disappear
```

Detailed historical design/experiment evidence remains in Git and `docs-jp/**/source-logs/`.

## Language Policy

Canonical reusable knowledge is currently written in English for technical consistency and AI use.

Human-facing Japanese material may live under `docs-jp/`.

This is a routing convention, not a claim that one language is inherently better. Preserve the language required for accurate domain meaning.

## Repository Layout

```text
.
├─ README.md
├─ artifacts.sh
├─ artifacts/                 # current derived/legacy AI projection
├─ docs-jp/                   # human/rationale/experiment material
├─ documents/
│  ├─ INDEX.md
│  ├─ knowledge/              # canonical reusable knowledge
│  └─ project/                # this repository's local documentation
└─ tests/
```

## Legacy Distribution During Migration

`artifacts.sh` still implements the existing selective-module sync contract.

That behavior is maintained temporarily for compatibility with projects that already consume the legacy projection. It is **not** the intended knowledge architecture going forward.

Until the publication redesign is complete:

- existing projects may continue syncing the legacy projection;
- do not interpret `--modules` choices as canonical knowledge boundaries;
- do not add new semantic rules only inside legacy artifacts;
- canonical changes begin under `documents/knowledge/`, then are reflected into whatever artifact projection is currently supported.

Current commands remain available for the legacy projection:

```bash
./artifacts.sh
./artifacts.sh --list
./artifacts.sh --target /path/to/project --modules all --non-interactive
```

The future distribution interface will be redesigned separately.

## Agent Integration

This repository does not impose one universal `AGENTS.md`, `CLAUDE.md`, or equivalent file on target projects.

Target-project entry files should remain small and route to:

1. project-specific canonical knowledge;
2. the relevant installed reusable guidance projection;
3. additional detail only when needed.

## Validation

Legacy distribution validation remains:

```bash
bash -n artifacts.sh
bash tests/test-artifacts.sh
```

Future canonical/artifact projection validation will be added as the publication redesign is implemented.
