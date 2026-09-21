# Legacy Artifact → Canonical Knowledge Traceability

```yaml
document_type: "migration_traceability"
authority: "migration_evidence"
canonical_source: "documents/knowledge/"
legacy_source: "artifacts/"
purpose: "prove semantic preservation while retiring legacy knowledge boundaries"
```

This document maps the current legacy artifact tree to the new canonical semantic owners.

It is a migration aid, not a second specification. If this file conflicts with a canonical knowledge document, the canonical owner wins.

## Classification

```yaml
preserved:
  meaning: "legacy semantic knowledge remains in a canonical owner"

centralized:
  meaning: "the same/cross-cutting knowledge appeared in several legacy places and now has one canonical owner"

derived_only:
  meaning: "useful AI publication/routing material that may exist in future artifacts but is not canonical engineering meaning"

legacy_packaging_only:
  meaning: "legacy module/adoption/read-order structure intentionally not preserved as canonical knowledge"

evidence_only:
  meaning: "experiment/history/proof stays in source logs or Git history rather than becoming a normative canonical rule"
```

## Migration Invariant

The redesign changes **knowledge architecture**, not engineering meaning.

Intentionally discarded as canonical premises:

- selectable artifact modules as the knowledge boundary;
- the three-domain packaging boundary `design-principles / documentation-strategy / development-environment-strategy`;
- WHY / HOW / WHERE / FLOW file partitioning;
- "read every file in this module on first contact";
- sibling-module relationship text whose only purpose was explaining the old packaging.

These may still exist temporarily in the derived `artifacts/` tree until the publication layer is redesigned.

## Canonical Owners

```yaml
ENGINEERING_OPERATING_MODEL.md:
  owns: "cross-cutting authority, safety, proportionality, confirmation, brownfield, validation, semantic ownership, Git-history principle, progressive disclosure"

WORK_LIFECYCLE.md:
  owns: "Work Identity, Work Root, Work Documents, repository participation, branches/worktrees/resources, integration, reconciliation, completion"

CODE_DESIGN.md:
  owns: "code contracts, boundaries, responsibilities, architecture, state, dependencies, errors/async, structure, evolution, testing, code change process"

DEVELOPMENT_EXECUTION.md:
  owns: "host/container execution, Docker, commands, runtime resources, secrets, diagnostics, reproducibility, CI"

PROJECT_KNOWLEDGE.md:
  owns: "accepted/current Project Documents, routing, document roles, provenance, staleness, agent entries, hierarchy, maintenance, derived-guidance semantics"
```

# 1. Legacy design-principles

## `design-principles/DESIGN_PHILOSOPHY.md`

| Legacy concern | Canonical owner | Status |
|---|---|---|
| Redefining OOP; shell vs internal implementation | `CODE_DESIGN.md` §§2,17 | preserved |
| Bounded Contracts / explicit interfaces | `CODE_DESIGN.md` §1; cross-domain contract idea also in `ENGINEERING_OPERATING_MODEL.md` §4 | centralized |
| Recursive boundaries | `CODE_DESIGN.md` §3 | preserved |
| Module as primary boundary | `CODE_DESIGN.md` §§3,8 | preserved |
| Encapsulation Horizon | `CODE_DESIGN.md` §4 | preserved |
| Responsibility-driven design / anti-patterns | `CODE_DESIGN.md` §5 | preserved |
| State ownership / consistency responsibility | `CODE_DESIGN.md` §6 | preserved |
| Composition over inheritance | `CODE_DESIGN.md` §23 | preserved |
| Reliability / fail fast / type-driven state / side effects | `CODE_DESIGN.md` §24 | preserved |
| Appropriate complexity / YAGNI | `CODE_DESIGN.md` §25 | preserved |
| Concept Altitude / consumer-neutral modeling | `CODE_DESIGN.md` §7 | preserved |
| External dependency containment / domain purity | `CODE_DESIGN.md` §§12,15 | preserved |
| Internal paradigm agnosticism | `CODE_DESIGN.md` §§2,17 | preserved |
| Design priority / mistake-prevention / confirmation implications | `CODE_DESIGN.md` + `ENGINEERING_OPERATING_MODEL.md` §§5–9 | centralized |
| Performance vs abstraction | `CODE_DESIGN.md` §21 | preserved |
| Legacy philosophy-vs-standards ownership split | none | legacy_packaging_only |

## `design-principles/CODING_STANDARDS.md`

| Legacy concern | Canonical owner | Status |
|---|---|---|
| Interface requirement threshold / naming / granularity / semantics / ISP | `CODE_DESIGN.md` §§10–11 | preserved |
| Contract evolution/versioning/compatibility | `CODE_DESIGN.md` §22 | preserved |
| Performance-shaped contracts | `CODE_DESIGN.md` §21 | preserved |
| Domain/application/infrastructure/UI boundaries | `CODE_DESIGN.md` §12 | preserved |
| State ownership / cross-boundary consistency | `CODE_DESIGN.md` §6 | centralized |
| Type placement / domain purity | `CODE_DESIGN.md` §§12,16 | preserved |
| External dependency boundary policy | `CODE_DESIGN.md` §15 | preserved |
| Dependency injection / connector injection / entity constraint | `CODE_DESIGN.md` §14 | preserved |
| Error strategy / boundary translation | `CODE_DESIGN.md` §19 | preserved |
| Concurrency / async contracts | `CODE_DESIGN.md` §20 | preserved |
| Rich vs lightweight domain model / entity mutability | `CODE_DESIGN.md` §16 | preserved |
| Internal flexibility | `CODE_DESIGN.md` §17 | preserved |
| Mapping / conversion | `CODE_DESIGN.md` §18 | preserved |
| Testing strategy / contract verification | `CODE_DESIGN.md` §§29–30 | preserved |

## `design-principles/PROJECT_STRUCTURE.md`

| Legacy concern | Canonical owner | Status |
|---|---|---|
| Module public surface / default-internal / deep-import boundary | `CODE_DESIGN.md` §9 | preserved |
| Shared kernel / cross-cutting placement | `CODE_DESIGN.md` §26 | preserved |
| Frontend/backend and multi-deployable topology | `CODE_DESIGN.md` §27 | preserved |
| Runtime seam as Bounded Contract | `CODE_DESIGN.md` §§1,27 | centralized |
| Monorepo layout flexibility | `CODE_DESIGN.md` §27 | preserved |
| Composition root | `CODE_DESIGN.md` §28 | preserved |
| Test file placement / contract suite beside port / fakes / E2E | `CODE_DESIGN.md` §§29–30 | preserved |

## `design-principles/AI_WORKFLOW.md`

| Legacy concern | Canonical owner | Status |
|---|---|---|
| Define required outcome / pre-implementation scan | `CODE_DESIGN.md` §31 | preserved |
| Define boundaries/contracts before implementation | `CODE_DESIGN.md` §§1,31 | preserved |
| Shell vs core implementation discipline | `CODE_DESIGN.md` §§2,17,31 | centralized |
| Verification: contract + requested outcome | `ENGINEERING_OPERATING_MODEL.md` §9 and `CODE_DESIGN.md` §29 | centralized |
| Operational discipline / safe scope | `ENGINEERING_OPERATING_MODEL.md` §§5–7 | centralized |
| Brownfield policy | `ENGINEERING_OPERATING_MODEL.md` §8; code specialization in `CODE_DESIGN.md` §32 | centralized |
| "How to approach" / analysis before implementation | `CODE_DESIGN.md` §31 | preserved |
| Worked example | future derived artifact/playbook if useful | derived_only |

## `design-principles/INDEX.md`

| Legacy concern | Canonical owner | Status |
|---|---|---|
| Bounded Contracts foundational lens | `CODE_DESIGN.md` §1 | preserved |
| Legacy WHY/HOW/WHERE/FLOW read order | none | legacy_packaging_only |
| Legacy file ownership map | `documents/knowledge/INDEX.md` routes to concept owners | centralized |
| Quick task routing | future derived artifact/publication routing | derived_only |
| "read all four on first contact" | none | legacy_packaging_only |
| design-principles as selectable adoption module | none | legacy_packaging_only |

# 2. Legacy documentation-strategy

## `documentation-strategy/DOCUMENTATION_PHILOSOPHY.md`

| Legacy concern | Canonical owner | Status |
|---|---|---|
| Accuracy first / routing over truncation | `PROJECT_KNOWLEDGE.md` §§1,9 and `ENGINEERING_OPERATING_MODEL.md` §§2,11 | centralized |
| Project-owned vs managed/derived guidance | `PROJECT_KNOWLEDGE.md` §§3,5 | preserved |
| Work Documents semantics and reconciliation | `WORK_LIFECYCLE.md` §§7–8,14 | centralized |
| AI-facing vs human-facing separation | `PROJECT_KNOWLEDGE.md` §§2,6 | preserved |
| Git as recording / no parallel archive | `ENGINEERING_OPERATING_MODEL.md` §10; provenance in `PROJECT_KNOWLEDGE.md` §§14–15 | centralized |
| Single Source of Truth | `ENGINEERING_OPERATING_MODEL.md` §3; project specialization in `PROJECT_KNOWLEDGE.md` §10 | centralized |
| Universality / hierarchical applicability | `PROJECT_KNOWLEDGE.md` §22 | preserved |
| Relationship to design-principles sibling module | none | legacy_packaging_only |
| Common misreadings | distributed to the relevant canonical owner | preserved |

## `documentation-strategy/FILE_AND_STRUCTURE.md`

| Legacy concern | Canonical owner | Status |
|---|---|---|
| documents/docs-jp/ layout and knowledge zones | `PROJECT_KNOWLEDGE.md` §§2,6 | preserved |
| Work Documents location/role | `WORK_LIFECYCLE.md` §§3,7–8 | centralized |
| documents/INDEX.md | `PROJECT_KNOWLEDGE.md` §8 | preserved |
| Agent entry files | `PROJECT_KNOWLEDGE.md` §7 | preserved |
| Managed artifact guidance | `PROJECT_KNOWLEDGE.md` §5 | preserved with new canonical-vs-derived model |
| Project/reference documents | `PROJECT_KNOWLEDGE.md` §§3,11 | preserved |
| Domain glossary | `PROJECT_KNOWLEDGE.md` §12 | preserved |
| Cross-reference/routing strategy | `PROJECT_KNOWLEDGE.md` §§8–10 | preserved |
| Document versioning / index version | `PROJECT_KNOWLEDGE.md` §13 | preserved |
| Two-phase commit-hash semantics | `PROJECT_KNOWLEDGE.md` §14 | preserved |
| Staleness detection | `PROJECT_KNOWLEDGE.md` §15 | preserved |
| Documentation commit conventions | `PROJECT_KNOWLEDGE.md` §16 | preserved, project-specific exact language relaxed |
| File format | `PROJECT_KNOWLEDGE.md` §24 | preserved |
| Directory splitting guide | `PROJECT_KNOWLEDGE.md` §§11,20 | preserved |
| Hierarchical projects | `PROJECT_KNOWLEDGE.md` §22 | preserved |
| Document deletion | `PROJECT_KNOWLEDGE.md` §21 | preserved |
| Multi-developer INDEX conflicts | `PROJECT_KNOWLEDGE.md` §23 | preserved |

## `documentation-strategy/DOCUMENT_WORKFLOW.md`

| Legacy concern | Canonical owner | Status |
|---|---|---|
| New project documentation setup | `PROJECT_KNOWLEDGE.md` §17 | preserved |
| Brownfield audit/migration | `PROJECT_KNOWLEDGE.md` §18 + cross-cutting rule in `ENGINEERING_OPERATING_MODEL.md` §8 | centralized |
| Ongoing Project Document updates | `PROJECT_KNOWLEDGE.md` §19 | preserved |
| Staleness flow | `PROJECT_KNOWLEDGE.md` §15 | preserved |
| Managed artifact handling | `PROJECT_KNOWLEDGE.md` §5 | preserved as derived-projection semantics |
| Work Document create/maintain/reconcile | `WORK_LIFECYCLE.md` §§7–8,14 | centralized |
| Version bumping | `PROJECT_KNOWLEDGE.md` §§13–14 | preserved |
| Document creation decision | `PROJECT_KNOWLEDGE.md` §20 | preserved |
| Document deletion workflow | `PROJECT_KNOWLEDGE.md` §21 | preserved |
| Re-read triggers | `PROJECT_KNOWLEDGE.md` §25; publication routing may specialize | centralized |
| Confirmation gate | `ENGINEERING_OPERATING_MODEL.md` §7 | centralized |

## `documentation-strategy/INDEX.md`

| Legacy concern | Canonical owner | Status |
|---|---|---|
| Accuracy/routing foundational lens | `PROJECT_KNOWLEDGE.md` §1 | preserved |
| Legacy WHY/HOW+WHERE/FLOW split | none | legacy_packaging_only |
| Legacy ownership map | concept ownership in `documents/knowledge/INDEX.md` | centralized |
| Quick task routing | future derived artifact/publication routing | derived_only |
| "read all three on first contact" | none | legacy_packaging_only |
| documentation-strategy as selectable adoption module | none | legacy_packaging_only |


# 3. Legacy development-environment-strategy

## `development-environment-strategy/DEVELOPMENT_ENVIRONMENT_PHILOSOPHY.md`

| Legacy concern | Canonical owner | Status |
|---|---|---|
| Development environment contract / priority order | `DEVELOPMENT_EXECUTION.md` §§1–2 | preserved |
| Host control plane / container execution plane | `DEVELOPMENT_EXECUTION.md` §3 | preserved |
| Work Identity definition / establishment / Git relation | `WORK_LIFECYCLE.md` §§1–2 | centralized |
| Workspace topology concepts | `WORK_LIFECYCLE.md` §§3–4 | centralized |
| Checkout selection rule | `WORK_LIFECYCLE.md` §6 | centralized |
| Parallel-agent isolation / one writable owner | `WORK_LIFECYCLE.md` §10 | centralized |
| Explicit operation semantics | `DEVELOPMENT_EXECUTION.md` §9 and `ENGINEERING_OPERATING_MODEL.md` §§4–7 | centralized |
| Reproducibility | `DEVELOPMENT_EXECUTION.md` §15 | preserved |
| Safety without friction | `ENGINEERING_OPERATING_MODEL.md` §5 | centralized |
| Environment scope boundary | represented by canonical owner boundaries | centralized |
| Common misreadings | relevant canonical owner sections | preserved |

## `development-environment-strategy/ENVIRONMENT_STANDARDS.md`

| Legacy concern | Canonical owner | Status |
|---|---|---|
| Host dependency boundary | `DEVELOPMENT_EXECUTION.md` §3 | preserved |
| Docker-first execution | `DEVELOPMENT_EXECUTION.md` §4 | preserved |
| Resource identity | `DEVELOPMENT_EXECUTION.md` §5 | preserved |
| Project/Work/Run resource scope | `WORK_LIFECYCLE.md` §9 | centralized |
| Resource creation/reuse | `WORK_LIFECYCLE.md` §10 + runtime specialization in `DEVELOPMENT_EXECUTION.md` §6 | centralized |
| Files/ownership/mounts | `DEVELOPMENT_EXECUTION.md` §7 | preserved |
| Caches/volumes/ports/networks | `DEVELOPMENT_EXECUTION.md` §7 | preserved |
| Secrets | `DEVELOPMENT_EXECUTION.md` §8 | preserved |
| Public command interface / Makefile / scripts / naming | `DEVELOPMENT_EXECUTION.md` §9 | preserved |
| Worktree public command contract | `WORK_LIFECYCLE.md` §11 | centralized |
| Git operation safety | `DEVELOPMENT_EXECUTION.md` §10 + Work-specific rules in `WORK_LIFECYCLE.md` | centralized |
| Worktree materialization support | `WORK_LIFECYCLE.md` §13 | centralized |
| Destructive operations | `ENGINEERING_OPERATING_MODEL.md` §§5,7 + execution specialization in `DEVELOPMENT_EXECUTION.md` §11 | centralized |
| Diagnostics/final validation | `DEVELOPMENT_EXECUTION.md` §§12–13 + shared validation model in `ENGINEERING_OPERATING_MODEL.md` §9 | centralized |
| Local/CI parity | `DEVELOPMENT_EXECUTION.md` §14 | preserved |

## `development-environment-strategy/WORKSPACE_STRUCTURE.md`

| Legacy concern | Canonical owner | Status |
|---|---|---|
| Workspace/Project/Component repository concepts | `WORK_LIFECYCLE.md` §4 | centralized |
| Project Root / Primary Checkout | `WORK_LIFECYCLE.md` §§3–4 | centralized |
| Work Root | `WORK_LIFECYCLE.md` §3 | centralized |
| Uniform single-/multi-repository shape | `WORK_LIFECYCLE.md` §3 | preserved |
| Work Documents placement / Git ownership | `WORK_LIFECYCLE.md` §7 | centralized |
| Repository selector / deterministic branch mapping | `WORK_LIFECYCLE.md` §5 | centralized |
| Checkout selection / worktree invariants | `WORK_LIFECYCLE.md` §§6,10–11 | centralized |
| Recommended top-level Work layout | `WORK_LIFECYCLE.md` §3 | preserved semantically |
| Git tracking vs materialization boundary | `WORK_LIFECYCLE.md` §§7,13 | centralized |
| Worktree Materialization Contract / recreation | `WORK_LIFECYCLE.md` §13 | centralized |
| Multi-repository coordination / resource identity | `WORK_LIFECYCLE.md` §§4–5,9–10,14 | centralized |
| Workspace-to-component tool dependency | `DEVELOPMENT_EXECUTION.md` §§5,15 and project-specific mappings | preserved at general level |
| Cross-artifact boundary explanation | none | legacy_packaging_only |

## `development-environment-strategy/ENVIRONMENT_WORKFLOW.md`

| Legacy concern | Canonical owner | Status |
|---|---|---|
| New project setup / bootstrap | `DEVELOPMENT_EXECUTION.md` §16 + Work setup in `WORK_LIFECYCLE.md` §14 | centralized |
| Brownfield environment adoption | `DEVELOPMENT_EXECUTION.md` §17 + shared brownfield rule in `ENGINEERING_OPERATING_MODEL.md` §8 | centralized |
| Establish Work Identity | `WORK_LIFECYCLE.md` §§1,14 | centralized |
| Checkout selection / repository preparation | `WORK_LIFECYCLE.md` §§5–6,11–13 | centralized |
| Worktree preflight / materialization / rollback / postconditions | `WORK_LIFECYCLE.md` §§11–13 | centralized |
| Implementation and validation | Work lifecycle in `WORK_LIFECYCLE.md` §14; validation principle in `ENGINEERING_OPERATING_MODEL.md` §9 | centralized |
| Preserve before integration | `WORK_LIFECYCLE.md` §14 | preserved |
| Multi-repository integration | `WORK_LIFECYCLE.md` §14 | centralized |
| Work completion / Work Document reconciliation | `WORK_LIFECYCLE.md` §§8,14–15 | centralized |
| Work-scoped resource reconciliation | `WORK_LIFECYCLE.md` §§9–10,15 | centralized |
| Worktree removal / Work Root completion | `WORK_LIFECYCLE.md` §§11,14–15 | centralized |
| Destructive purge | `WORK_LIFECYCLE.md` §16 + shared safety model | centralized |
| Diagnosis/recovery | `DEVELOPMENT_EXECUTION.md` §18 | preserved |
| Environment confirmation gate | `ENGINEERING_OPERATING_MODEL.md` §7 + `DEVELOPMENT_EXECUTION.md` §19 | centralized |
| Re-read triggers | future derived routing; canonical owners identify relevant concepts | derived_only |

## `development-environment-strategy/INDEX.md`

| Legacy concern | Canonical owner | Status |
|---|---|---|
| Environment foundational lens | `DEVELOPMENT_EXECUTION.md` §§1–4 and `WORK_LIFECYCLE.md` §§1–3 | centralized |
| Worktree selection summary | `WORK_LIFECYCLE.md` §6 | centralized |
| Legacy WHY/HOW/WHERE/FLOW read order | none | legacy_packaging_only |
| Legacy ownership map | concept ownership in `documents/knowledge/INDEX.md` | centralized |
| Quick task routing | future derived artifact/publication routing | derived_only |
| Relationship to sibling artifact sets | none | legacy_packaging_only |
| "read all four on first contact" | none | legacy_packaging_only |
| development-environment-strategy as selectable adoption module | none | legacy_packaging_only |

# 4. Source Logs, Experiments, and Implementation Evidence

The detailed Japanese source/rationale and experiment logs under `docs-jp/` are **not collapsed into canonical rules**.

They retain evidence such as:

- why Work Identity was introduced;
- alternative designs considered;
- Git materialization experiments;
- exact tested environments and commit evidence;
- reference helper implementation validation;
- failure observations and later fixes.

Canonical knowledge incorporates the accepted semantic result. Historical evidence remains evidence.

```text
docs-jp/.../source-logs/
  → rationale / experiment / proof

documents/knowledge/
  → accepted reusable semantic knowledge

artifacts/
  → derived AI delivery projection
```

This separation allows future canonical rewrites without erasing the reasoning/history that produced them.

# 5. Knowledge Intentionally Reframed

Some legacy rules remain semantically valid but are intentionally less rigid in canonical form.

| Legacy form | Canonical interpretation |
|---|---|
| exact documentation commit description language | project-owned convention; semantic categories retained |
| mandatory per-document version metadata as universal template | provenance/versioning is a project policy/tool; semantics preserved without forcing one registry everywhere |
| module-local confirmation gates | one cross-cutting confirmation model with domain specializations |
| repeated brownfield policies | one shared brownfield rule plus domain specialization |
| repeated SSOT rules | one semantic-owner principle plus domain-specific ownership |
| repeated validation rules | one shared evidence model plus code/execution specializations |
| Work Documents split between environment and documentation modules | one complete Work Lifecycle owner; Project Knowledge owns only accepted-project-document structure after reconciliation |

These are consolidations, not deletions.

# 6. Coverage Checklist

Legacy artifact files accounted for:

```yaml
design_principles:
  - "DESIGN_PHILOSOPHY.md"
  - "CODING_STANDARDS.md"
  - "PROJECT_STRUCTURE.md"
  - "AI_WORKFLOW.md"
  - "INDEX.md"

documentation_strategy:
  - "DOCUMENTATION_PHILOSOPHY.md"
  - "FILE_AND_STRUCTURE.md"
  - "DOCUMENT_WORKFLOW.md"
  - "INDEX.md"

development_environment_strategy:
  - "DEVELOPMENT_ENVIRONMENT_PHILOSOPHY.md"
  - "ENVIRONMENT_STANDARDS.md"
  - "WORKSPACE_STRUCTURE.md"
  - "ENVIRONMENT_WORKFLOW.md"
  - "INDEX.md"
```

Total legacy artifact files mapped: **14 / 14**.

# 7. Next Migration Boundary

This traceability establishes the semantic source layer only.

It does **not** decide the future artifact publication shape.

The next phase may redesign `artifacts/` around:

- a very small always-on core;
- concept-oriented references;
- task/playbook-oriented projections;
- generated or manually curated AI profiles;
- a single non-selectable delivery set;
- another progressive-disclosure structure.

Whatever publication model is selected, it should be evaluated against the canonical knowledge here rather than against the legacy module/file layout.
