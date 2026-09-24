# Source record: 2026-06-13-external-boundary-refinement-commit

```yaml
record_type: "verbatim_external_source_snapshot"
source_kind: "Git commit message + GitHub API patch"
source_repository: "Daiki-Yoshida/design-principles"
source_commit: "1ee73402e6ac251ec7de826c0a8f4a0ebdbe2f68"
source_url: "https://github.com/Daiki-Yoshida/design-principles/commit/1ee73402e6ac251ec7de826c0a8f4a0ebdbe2f68"
source_author_date: "2026-06-13T09:07:18Z"
retrieved_date: "2026-09-24"
source_text_status: "GitHub APIで取得したcommit messageとpatchのsnapshot"
record_body_policy: "commit messageとpatchは無加工。commit stateで導入された変更の証拠であり、元チャットの提案・承認原文とは区別する"
```

## Commit message原文

~~~~text
更に更新
~~~~

## GitHub API patch snapshot

### `artifacts/AI_WORKFLOW.md`

~~~~diff
@@ -29,13 +29,21 @@ process_flow:
 **Rule**: Never start implementing logic until the Bounded Contract is defined.
 
 **Distinguish the Component Type**:
-*   **Case A: Behavioral Component** (Services, Repositories, Managers)
-    *   **MUST** define an `interface`.
+*   **Case A: Behavioral Component** (Services, Repositories, Managers, Adapters, Ports)
+    *   **Behavioral Boundary Components MUST define or reuse a project-owned contract**: define an `interface` when public, DI-injected, shared across modules, replaceable/test-substitutable, or protecting Domain/Application from Infrastructure. **Omit** it for `private`/`internal` helpers, single-implementation logic with no boundary, and short-lived prototypes — see `CODING_STANDARDS.md` → "Interface Requirement Threshold".
     *   **focus**: The "Contract" is the interaction boundary.
 *   **Case B: Domain Model** (Entities, Value Objects)
     *   **Do NOT** define an `interface` by default (only when the domain requires polymorphism — see `CODING_STANDARDS.md` → "Entity & ValueObject Exception").
     *   **focus**: The "Contract" is the Class State invariant & public Behavior.
 
+### Responsibility & Dependency Scan (Pre-Implementation)
+Before drafting contracts, scan (criteria are owned elsewhere — link, don't re-derive):
+1.  **Responsibility**: Can this component's job be stated in one sentence? Does it mix Functional / Technical / Orchestration? If the description needs "and", split it. (See `DESIGN_PHILOSOPHY.md` → Responsibility-Driven Design.)
+2.  **External dependency**: Does this introduce or spread an external dependency? Does it leak into Domain, core Model, Application contracts, or public DTOs? If so, wrap it (port / adapter / anti-corruption layer). (See `CODING_STANDARDS.md` → External Dependency Boundary Policy.)
+3.  **UI exception**: UI-framework types may stay inside the UI boundary; never push them inward into Application/Domain.
+
+> Weigh findings by **Mistake Prevention Priority** (`DESIGN_PHILOSOPHY.md`): responsibility mixing and dependency spread outrank over-engineering.
+
 ### Process
 1.  **Draft Contracts**:
     *   **Behavioral**: Define `interface` + Semantics (What happens? Side effects?).
~~~~

### `artifacts/CODING_STANDARDS.md`

~~~~diff
@@ -19,7 +19,21 @@ Language-specific idioms and compiler constraints take precedence over example s
 
 ## Interface Design Rules
 
-Interfaces are the backbone of our architecture.
+Interfaces are the backbone of our architecture — **at boundaries**. Apply them where they earn their keep, not everywhere.
+
+### Interface Requirement Threshold
+**Behavioral Boundary Components** (services, repositories, managers, adapters, use-case ports) **MUST define or reuse a project-owned contract** (`interface`). Define one when ANY of these holds:
+*   It is **public** or **shared across modules**.
+*   It is **DI-injected**, or is a **volatile dependency** (IO, DB, network, filesystem, clock, randomness — see DI rules).
+*   It **protects Domain/Application from Infrastructure** (crosses a layer boundary).
+*   It must be **replaceable / test-substitutable / runtime-swappable**.
+
+**Do NOT require an `interface` for:**
+*   `private`/`internal` helper classes that cross no boundary.
+*   Single-implementation logic forming no boundary (e.g., pure internal computation, a one-off internal use case).
+*   Short-lived prototypes / spikes.
+
+**Rule (YAGNI)**: Be interface-first **at architectural boundaries**, but do NOT create meaningless interfaces for tiny internal helpers. Prefer a concrete class first; extract a contract when a real boundary, a genuine second implementation, or a volatile dependency appears. (Per **Mistake Prevention Priority** in `DESIGN_PHILOSOPHY.md`, over-engineering ranks *below* boundary/dependency discipline — do not overcorrect into zero interfaces.) This mirrors the **Entity & ValueObject Exception** below: an interface decouples boundaries, it is not a default wrapper.
 
 ### Naming & Granularity
 *   **Prefix**: **MUST** follow the specific language's standard idiom.
@@ -155,6 +169,36 @@ Place contracts at the boundary that owns the reason for their existence.
 
 ---
 
+## External Dependency Boundary Policy
+
+External dependencies are allowed, but their influence must be **contained**. Domain and core Model code depend on **project-owned** types/contracts — not on external SDKs, framework models, DB schemas, HTTP clients, UI framework types, vendor abstractions, or external API DTOs. (Principle/why: `DESIGN_PHILOSOPHY.md` → External Dependency Containment.)
+
+**Wrap / adapt** (interface, adapter, facade, anti-corruption layer, or project-owned DTO) when ANY holds:
+*   The dependency appears in Domain or core Model code.
+*   Its types would spread across multiple modules.
+*   Replacing it would force changes in many unrelated places.
+*   It forces domain terminology to follow vendor terminology.
+*   It pushes technical errors, lifecycle, async, or side effects into business logic.
+*   Multiple modules start depending on the same external API directly.
+
+**Direct dependency is acceptable** when:
+*   The code is **UI-specific** and stays inside the UI boundary.
+*   The code is **Infrastructure-specific** (that is its role).
+*   The dependency is local to a small internal implementation and does not leak through a public contract.
+*   The module is intentionally a thin integration module.
+
+**Prohibited:**
+*   Exposing external SDK types from Domain contracts.
+*   Using DB/API DTOs as Domain Entities.
+*   Letting one external module become the implicit shared model of the whole system.
+*   Making most modules depend directly on the same vendor API when a project-owned abstraction would localize the change.
+
+**UI & Infrastructure scope**: UI may depend on UI frameworks/platform types, and Infrastructure may depend on external SDKs/clients — that is their role. The rule is one-directional: **do NOT push UI or Infrastructure types inward** into Application or Domain.
+
+If a Domain/Application concept needs an external capability, define a **project-owned port** at the owning boundary (Application owns use-case ports) and implement it in Infrastructure.
+
+---
+
 ## Dependency Injection (DI)
 
 ### Connector Injection Only
@@ -266,6 +310,8 @@ rule: "Never block on async (.Result/.Wait) across a boundary you do not own; pr
 ### 1. Domain Modeling Strategy
 Choose the sophistication of the model based on the complexity of the subdomain.
 
+**Rule**: Whichever you choose, keep meaningful domain rules **inside the Domain** — do NOT let them leak into UI, Infrastructure, or unrelated services. "Lightweight" means little behavior, NOT business logic scattered across layers.
+
 #### A. Rich Domain Model (Complex Logic)
 **Use when**: The specific domain entity has complex invariants, state transitions, or business rules.
 *   Entities contain both state and behavior.
~~~~

### `artifacts/DESIGN_PHILOSOPHY.md`

~~~~diff
@@ -156,6 +156,18 @@ Accept necessary complexity (domain logic) but ruthlessly eliminate accidental c
 *   **YAGNI**: do not implement features "just in case".
 *   **Abstraction**: Abstractions should simplify the problem, not obscure it. If an abstraction makes the code harder to follow without providing flexibility, remove it.
 
+## External Dependency Containment
+
+External libraries, SDKs, frameworks, and vendor types are allowed — but they must live **at the edges**, never become the architectural center.
+
+```yaml
+principle: "External dependencies may exist at the edges, but must not define the core domain language or spread across the architecture."
+domain_core: "Domain and core Model depend on project-owned types/contracts — never directly on external SDKs, framework models, DB schemas, or vendor DTOs."
+ownership: "The project owns its core contracts; introduce an adapter / anti-corruption layer when a dependency starts to spread inward."
+```
+
+> **Single source of truth**: the normative wrap/allow/prohibit rules and the UI & Infrastructure exceptions live in `CODING_STANDARDS.md` → "External Dependency Boundary Policy". This section states only the principle (the *why*).
+
 ## Internal Paradigm Agnosticism
 
 Inside a boundary, the implementation style is flexible.
@@ -180,6 +192,18 @@ When making design decisions, prioritize in this order:
 4.  **Explicitness of Side Effects**
 5.  **Internal Elegance or Purity**
 
+## Mistake Prevention Priority
+
+The *Design Priority Order* above ranks design **choices**. This ranks **mistakes to prevent** (1 = most important to avoid):
+
+1.  **Mixing responsibilities** in one class/module. (See *Responsibility-Driven Design*.)
+2.  **Mishandling expected business failures** with exceptions / `null` / `boolean` flags instead of the Result pattern. (See `CODING_STANDARDS.md` → Error Handling.)
+3.  **Silently changing a public contract / DTO / observable behavior.** (See `CODING_STANDARDS.md` → Contract Evolution + the Confirmation Gate.)
+4.  **Spreading an external dependency** into Domain/core or across unrelated modules. (See `CODING_STANDARDS.md` → External Dependency Boundary Policy.)
+5.  **Over-engineering** with unnecessary abstractions.
+
+**Calibration**: (5) is real but ranks **below** 1–4. Do NOT skip a justified boundary contract to avoid "over-engineering"; do NOT add meaningless ones either.
+
 ## Performance vs. Abstraction Policy
 
 Performance optimization must not degrade interface abstraction.
~~~~
