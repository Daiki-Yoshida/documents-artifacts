# Artifact v2 — Legacy Semantic Regression Audit

```yaml
document_type: "repository_local_artifact_regression_audit"
date: "2026-09-24"
candidate_head: "d58ea9e8b4986da8378ff322dd971d71d4222994"
legacy_baseline: "e760eb38841650d60739750953c8342b639ce6f0"
legacy_files: 14
legacy_h2_sections: 129
current_subjects: 8
current_non_history_subject_files: 50
```

## Purpose

Artifact v2 is **not** a rewrite of the legacy artifacts.

Regression review therefore asks:

> Does the candidate preserve the currently adopted meaning that was recovered from legacy artifacts and later decisions, without resurrecting obsolete packaging or superseded rules?

The existing migration audits already classify all 129 legacy H2 sections into a current owner, replacement decision, or intentional history. This audit checks the next link:

```text
legacy 129 H2
  → current subject / history classification
  → current non-history subject
  → artifact-v2 projection
  → task-routed candidate leaf
```

It does not claim line-by-line identity with the legacy English artifacts.

## Coverage chain

Existing migration state:

- design-principles: 48 H2 classified;
- documentation-strategy: 37 H2 classified;
- development-environment-strategy: 44 H2 classified;
- total: **129 / 129**.

Artifact v2 projection state:

- all **50 current non-history subject body files** are represented in `ARTIFACT_PROJECTION_MAP_V2.md`;
- history files are excluded by default;
- glossary-only material is embedded locally where needed rather than forcing a glossary read;
- candidate currently contains 41 AI-facing files: root router + 7 directory routers + 33 leaves.

## High-risk design regressions checked

### Boundary / contract

Preserved in candidate:

- boundary strict / interior flexible;
- module is an initial prior, not a permanent hardening floor;
- hardening depends on responsibility stability and seam cost;
- creation cost alone does not justify deleting a known hardening need;
- YAGNI is strong against speculative surface and speculative internal machinery;
- YAGNI is strongly restricted against weakening selected contract completeness;
- contract includes semantics / side effects / failure / resource / determinism / data / lifecycle where load-bearing;
- small surface, strong contract;
- additive shape is **not** automatically compatible;
- consumer and provider/implementer compatibility are both checked;
- performance-driven contract reshaping requires a load-bearing requirement plus evidence;
- Concept Altitude neutrality is a signal, not proof of shared semantic identity;
- graduation should preferably preserve the outer surface.

### Code realization

Preserved in candidate:

- feature/module-first structure with layers inside when useful;
- Domain / Application / Infrastructure / UI responsibility split;
- coordinate ≠ own;
- project-owned dependency direction;
- DI only where a real boundary/volatile role exists;
- Service Locator avoidance;
- Entity/Value Object DI caveat;
- vendor/framework containment at edges;
- Rich vs lightweight domain model based on domain complexity;
- DTO/mapping ownership by crossing boundary;
- expected business failure vs system failure;
- infrastructure exception translation;
- async/cancellation/thread-safety when caller-visible;
- contract conformance ≠ requested-outcome verification;
- contract/integration/E2E test roles and placement;
- single-runtime vs multi-deployable runtime seam;
- compatibility dimensions by medium;
- no generic shared dumping ground;
- side effects contained and explicit rather than "purity" hiding them.

### Engineering operation

Preserved in candidate:

- intent/outcome → scan → route → confirm → implement → verify → report;
- proportional pre-implementation scan;
- local convention priority;
- no silent scope expansion into unrelated cleanup;
- clarification only when ambiguity affects high-impact/public meaning;
- owner-specific confirmation routing;
- verification distinguishes contract from requested outcome;
- unrun/failed checks are reported honestly;
- commit/push not assumed authorized;
- default-branch direct commit is not the reusable default;
- brownfield violation hunt is not the task;
- an approach question does not silently become an implementation request.

### Documentation

Preserved in candidate:

- information accuracy > routing > token efficiency;
- token cost is solved primarily by routing/file structure, not semantic truncation;
- `documents/` is the canonical Project Documentation root;
- `documents/project/` and `documents/reference/` are examples, not required shape;
- `documents/INDEX.md` is the routing hub;
- agent entry files route rather than duplicate authority;
- README is human-facing and not a replacement authority;
- topic-directory choice is routing-based, not a hard file-count law;
- hierarchical child projects remain documentation-self-contained;
- structural brownfield migration does not silently become content rewrite;
- managed installed artifacts are derived snapshots, not project-owned editable authority;
- Work Documents are reconciled, not copied wholesale;
- document deletion updates incoming routing;
- DOC_L0..L3 distinction and re-read triggers are preserved.

### Project / Work / Execution / Safety

Preserved in candidate:

- Project Repository / Project Root / Component Repository static ownership;
- Work Identity is goal-derived and above Git/tool IDs;
- user explicitly confirms Work Identity before implementation begins;
- Work Root uses one single/multi-repository shape;
- Work Documents are Project Repository-tracked active knowledge visible from the project baseline;
- no redundant parallel `.work/` root;
- Project / Work / Run resource scopes;
- Work resources end as removed or intentionally-retained-with-reason; unexplained residual is invalid;
- worktree public input remains WORK + REPO;
- base ref and upstream are separate decisions;
- recursive project-level `.worktrees/` materialization is prevented in the validated case;
- create/status/remove semantics stay idempotent/fail-closed/non-destructive by default;
- worktree validation limitations (Git 2.43.0, WSL2/Linux, single-repo validated; other topologies/platforms not proven) are retained;
- Docker-first host/container role split;
- no unnecessary per-work images/resources;
- bind-mount ownership / cache / port / secret rules;
- routine commands do not require privilege escalation by default;
- public commands expose intent and local/CI converge on repository-managed paths;
- destructive effects have explicit scope and safety level;
- diagnosis precedes force/global cleanup;
- integration revalidates the integrated HEAD and respects repository ownership.

## Superseded / historical rules intentionally not reintroduced

Artifact v2 must **not** regress to these legacy states:

- legacy `design-principles / documentation-strategy / development-environment-strategy` packaging as semantic authority;
- WHY / HOW / WHERE / FLOW file split as the new architecture;
- fixed module = hardening floor;
- "additive public change = compatible L2";
- "contract test passing = task correctness";
- one-sentence consumer-neutral description = proof of shared semantic identity;
- mandatory per-task worktree / "Primary Checkout never for feature work";
- per-document version registry / `last_updated_commit` machinery;
- fixed historical thinking/interim response language;
- historical worked examples as independent normative rules;
- legacy artifact wording as authority when later source-backed decisions replaced it.

## Findings from candidate semantic review

Compression initially weakened several current rules. The review corrected them rather than accepting the shorter text:

1. explicit user confirmation of Work Identity before implementation;
2. Managed Artifact update/override semantics;
3. documentation re-read triggers;
4. README / hierarchical child self-containment / topic split guidance;
5. brownfield structural migration vs content rewrite;
6. side-effect containment and shared-placement guard;
7. Encapsulation Horizon graduation settlement cost;
8. Work Documents baseline visibility and Work resource identity propagation;
9. host privilege-escalation and command discoverability rules;
10. root artifact managed-snapshot guard.

This confirms the projection rule:

> **compression != semantic weakening**

## Verdict for this stage

No known legacy/current semantic area requires returning to the old 3-module artifact architecture.

The candidate is suitable for continued routing simulation and final semantic review.

This audit does **not** yet authorize replacing `artifacts/`; promotion remains gated on final candidate review and distribution-tool migration.
