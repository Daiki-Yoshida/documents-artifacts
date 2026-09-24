# Source record: 2026-06-13-module-mapping-testing-refinement-commit

```yaml
record_type: "verbatim_external_source_snapshot"
source_kind: "Git commit message + GitHub API patch"
source_repository: "Daiki-Yoshida/design-principles"
source_commit: "572bba2a635ce71db1f1eb16aa0c075fff5b693e"
source_url: "https://github.com/Daiki-Yoshida/design-principles/commit/572bba2a635ce71db1f1eb16aa0c075fff5b693e"
source_author_date: "2026-06-13T09:21:35Z"
retrieved_date: "2026-09-24"
source_text_status: "GitHub APIで取得したcommit messageとpatchのsnapshot"
record_body_policy: "commit messageとpatchは無加工。commit stateで導入された変更の証拠であり、元チャットの提案・承認原文とは区別する"
```

## Commit message原文

~~~~text
ｓ
~~~~

## GitHub API patch snapshot

### `artifacts/AI_WORKFLOW.md`

~~~~diff
@@ -36,13 +36,15 @@ process_flow:
     *   **Do NOT** define an `interface` by default (only when the domain requires polymorphism — see `CODING_STANDARDS.md` → "Entity & ValueObject Exception").
     *   **focus**: The "Contract" is the Class State invariant & public Behavior.
 
-### Responsibility & Dependency Scan (Pre-Implementation)
-Before drafting contracts, scan (criteria are owned elsewhere — link, don't re-derive):
-1.  **Responsibility**: Can this component's job be stated in one sentence? Does it mix Functional / Technical / Orchestration? If the description needs "and", split it. (See `DESIGN_PHILOSOPHY.md` → Responsibility-Driven Design.)
-2.  **External dependency**: Does this introduce or spread an external dependency? Does it leak into Domain, core Model, Application contracts, or public DTOs? If so, wrap it (port / adapter / anti-corruption layer). (See `CODING_STANDARDS.md` → External Dependency Boundary Policy.)
-3.  **UI exception**: UI-framework types may stay inside the UI boundary; never push them inward into Application/Domain.
-
-> Weigh findings by **Mistake Prevention Priority** (`DESIGN_PHILOSOPHY.md`): responsibility mixing and dependency spread outrank over-engineering.
+### Pre-Implementation Scan
+Before drafting contracts, run these checks (criteria are owned elsewhere — link, don't re-derive):
+1.  **Module Shell**: What module is this? What is its outer contract, and who calls it? What can change internally without affecting callers? What must NOT leak out? (See `DESIGN_PHILOSOPHY.md` → Module Shell vs Internal Implementation.)
+2.  **Responsibility**: One-sentence job? Judged by reason-to-change & caller-visible capability? Mixing Functional/Technical/Orchestration? Becoming a *god service*? Using DTOs as Domain models? UI/Infra logic flowing inward? (See `DESIGN_PHILOSOPHY.md` → Responsibility-Driven Design + Anti-Patterns.)
+3.  **Dependency Spread**: Introduce/spread an external dependency? Local, or will many modules depend on it? Does it touch Domain/Core language? Wrap with port/adapter/anti-corruption? Acceptable because it stays in UI/Infrastructure? (See `CODING_STANDARDS.md` → External Dependency Boundary Policy.)
+4.  **Mapping**: Is a conversion crossing a boundary? Which boundary owns it? Is Domain being made aware of an outer DTO/ViewModel/DB model? Inline or extract? (See `CODING_STANDARDS.md` → Mapping & Conversion Policy.)
+5.  **Accuracy vs Speed**: Module shell / foundation → prioritize correctness. Private/internal behind a stable shell → prioritize simplicity & speed. (See `DESIGN_PHILOSOPHY.md` → Module Shell vs Internal Implementation.)
+
+> Weigh findings by **Mistake Prevention Priority** (`DESIGN_PHILOSOPHY.md`): responsibility mixing, contract breakage, and dependency spread outrank over-engineering.
 
 ### Process
 1.  **Draft Contracts**:
~~~~

### `artifacts/CODING_STANDARDS.md`

~~~~diff
@@ -35,6 +35,13 @@ Interfaces are the backbone of our architecture — **at boundaries**. Apply the
 
 **Rule (YAGNI)**: Be interface-first **at architectural boundaries**, but do NOT create meaningless interfaces for tiny internal helpers. Prefer a concrete class first; extract a contract when a real boundary, a genuine second implementation, or a volatile dependency appears. (Per **Mistake Prevention Priority** in `DESIGN_PHILOSOPHY.md`, over-engineering ranks *below* boundary/dependency discipline — do not overcorrect into zero interfaces.) This mirrors the **Entity & ValueObject Exception** below: an interface decouples boundaries, it is not a default wrapper.
 
+**Module-local vs public/cross-module**:
+*   **Module-local** interface: welcome **even with a single implementation** when it clarifies the module's internal world or expresses a cohesive capability. Being interface-friendly here is fine.
+*   **Public / cross-module** interface: design more carefully as a **stable contract** — it is a published boundary.
+
+**Good reasons** for an interface: caller-facing capability, module shell, volatile dependency, DI/test substitution, external-dependency isolation, a meaningful internal role, plausible future replacement, useful contract tests.
+**Bad reasons** (avoid): "every class needs one" by habit; `IUserService` exists only because `UserService` exists; no semantic documentation; name differs from the implementation only by an `I` prefix; no boundary or substitution value.
+
 ### Naming & Granularity
 *   **Prefix**: **MUST** follow the specific language's standard idiom.
     *   **CRITICAL RULE**: The constraints of the specific programming language ALWAYS take precedence over the examples provided here.
@@ -123,13 +130,34 @@ rule: "A changed Semantics is a breaking change even if the Signature is identic
 
 ## Architectural Boundaries (Layering)
 
-Physical layer structure: App / Infra / Domain
-Dependency rule:
+**The primary boundary is the feature/module; layers live inside each module.** (Principle/why: `DESIGN_PHILOSOPHY.md` → "Module — The Primary Boundary".) Organize by feature first, then by layer:
+
+```text
+src/
+  coupon/                 # feature module = primary boundary
+    domain/
+    application/
+    infrastructure/
+    ui/
+  billing/
+    domain/ application/ infrastructure/ ui/
+```
+
+Small modules may stay flat and evolve later:
+
+```text
+coupon/
+  CouponService  CouponRepository  CouponDto  CouponMapper
+```
+
+Within each module the same dependency rule holds:
 - Domain depends on nothing outside itself.
 - Application depends on Domain.
 - Infrastructure depends on Domain and may depend on Application-owned ports when implementing use-case-specific integrations.
 - Concrete implementations live in Infrastructure.
-Think of these as **Boundaries**, not just folders.
+- UI depends inward on Application/Domain; never the reverse.
+
+Think of these as **Boundaries**, not just folders. Do NOT make the technical layer the top-level organizing principle.
 
 ### Contract Placement Rule
 Place contracts at the boundary that owns the reason for their existence.
@@ -142,21 +170,23 @@ Place contracts at the boundary that owns the reason for their existence.
 
 **Rule**: Do not put every interface into Domain by default. Domain owns business contracts. Application owns use-case orchestration ports. Infrastructure implements both without leaking technical details outward.
 
-### 1. Domain Boundary (`src/Domain`)
+### 1. Domain Boundary (`<module>/domain`)
 *   **Contains**: **Contracts** (Interfaces), Entities, Value Objects, Domain Errors.
 *   **Dependencies**: ZERO dependencies on outer layers.
 *   **Role**: Defines the "What" for business concepts, invariants, and domain-level policies.
 
-### 2. Infrastructure Boundary (`src/Infrastructure`)
+### 2. Infrastructure Boundary (`<module>/infrastructure`)
 *   **Contains**: Concrete implementations (Database access, API clients).
 *   **Dependencies**: Depends on **Domain** and, when necessary, **Application** ports.
 *   **Role**: The "How" (Plumbing).
 
-### 3. Application Boundary (`src/Application`)
-*   **Contains**: Use Cases, Services, Orchestration, Application-owned Ports.
+### 3. Application Boundary (`<module>/application`)
+*   **Contains**: Use Cases, Application Services, Orchestration, Application-owned Ports.
 *   **Dependencies**: Depends on **Domain**.
-*   **Role**: High-level flow control.
+*   **Role**: Orchestration boundary — high-level flow control, NOT a place to dump business logic.
+*   **UseCase responsibilities**: coordinate flow; call Domain behavior; call project-owned ports; handle authorization & transactions when appropriate; map Application Request/Response DTOs ↔ Domain models; translate expected failures into Result errors; keep Infrastructure details out.
 *   **Boundary Rule**: MUST define its own Request/Response DTOs. NEVER expose Domain Entities directly to external boundaries (API/CLI).
+*   **Placement Rule**: True business rules → Domain. Orchestration, boundary coordination, DTO mapping, transaction flow, and port calls → Application. UseCases MAY hold application-specific policy but MUST NOT replace Domain modeling.
 
 ### Type Placement Guidelines
 | Type | Layer | Purpose |
@@ -173,13 +203,17 @@ Place contracts at the boundary that owns the reason for their existence.
 
 External dependencies are allowed, but their influence must be **contained**. Domain and core Model code depend on **project-owned** types/contracts — not on external SDKs, framework models, DB schemas, HTTP clients, UI framework types, vendor abstractions, or external API DTOs. (Principle/why: `DESIGN_PHILOSOPHY.md` → External Dependency Containment.)
 
+**The project owns the core language**: external libraries may *implement* capabilities, but they MUST NOT *define* the domain vocabulary.
+
 **Wrap / adapt** (interface, adapter, facade, anti-corruption layer, or project-owned DTO) when ANY holds:
 *   The dependency appears in Domain or core Model code.
 *   Its types would spread across multiple modules.
 *   Replacing it would force changes in many unrelated places.
 *   It forces domain terminology to follow vendor terminology.
 *   It pushes technical errors, lifecycle, async, or side effects into business logic.
 *   Multiple modules start depending on the same external API directly.
+*   A **widely-depended-on module** relies on the dependency → wrap it **earlier**.
+*   The dependency **touches a core domain concept** → wrap it **from the start**.
 
 **Direct dependency is acceptable** when:
 *   The code is **UI-specific** and stays inside the UI boundary.
@@ -199,6 +233,29 @@ If a Domain/Application concept needs an external capability, define a **project
 
 ---
 
+## Domain Purity Rules
+
+Keep technical **mechanisms** out of Domain/Core; keep genuine **domain concepts** in, even if they involve time/names/colors/records. (Principle/why: `DESIGN_PHILOSOPHY.md` → "Domain Purity (Mechanism vs Concept)".)
+
+**Almost never in Domain/Core**: DB/HTTP/filesystem I/O, external API DTOs, framework attributes/annotations, vendor SDK types, UI framework types.
+
+**Contextual** (avoid as *direct* dependencies, but may be domain concepts): current time, randomness, settings, logging, display names, colors, textual labels.
+
+| Case | Verdict |
+| :--- | :--- |
+| `DateTime.Now` inside an Entity | avoid — inject a `Clock` from Application |
+| `ExpiresAt` as a domain value | valid domain concept |
+| Entity directly using `Logger` | avoid |
+| Domain event logged by an outer layer | acceptable |
+| Audit log as a business requirement | may be a Domain/Application concept |
+| Button color | UI concern |
+| Rarity/team color, official/legal name | may be a Domain concept |
+| i18n display text | usually UI/Application |
+
+**Decision rule**: does the value exist **because of the UI/tech**, or **because of the domain itself**? Origin decides where it lives.
+
+---
+
 ## Dependency Injection (DI)
 
 ### Connector Injection Only
@@ -359,6 +416,32 @@ Inside a boundary (e.g., inside a private method of a Service), you may use Anem
     *   **Rule**: If chosen, it MUST be consistent for that specific entity lifecycle.
 
 
+---
+
+## Mapping & Conversion Policy
+
+**Mapping is boundary translation.** Domain is something to be mapped *from/to*; it must not know outer representations.
+
+**Strong rule**: Domain Entities / Value Objects **MUST NOT** expose `ToDto()`, `ToViewModel()`, `ToDbModel()`, or any external-schema conversion — that pulls Application/UI/Infrastructure knowledge inward.
+
+**Placement**:
+*   **Application** maps Domain ↔ UseCase Request/Response DTOs.
+*   **Infrastructure** maps DB/API/filesystem models ↔ Domain (`ToDomain()` is acceptable **only if it stays inside Infrastructure**).
+*   **UI** maps Application responses ↔ UI ViewModels when needed.
+
+**Inline vs extract**:
+*   Small one-off mappings MAY be inline in the owning UseCase/Adapter.
+*   Reused / complex / semantically meaningful mappings SHOULD be extracted. Extension methods are fine **only** when defined in the owning boundary and do not make Domain depend outward.
+
+**Naming**:
+| Name | Role |
+| :--- | :--- |
+| `Mapper` | structural DTO ↔ Domain |
+| `Converter` | value/type conversion (e.g., `string → Money`) |
+| `Assembler` | builds a response from multiple sources |
+| `Adapter` | wraps an external API/SDK behind a project-owned contract |
+| `Translator` | translates external/vendor concepts into domain concepts |
+
 ---
 
 ## Testing Strategy
@@ -377,6 +460,15 @@ Write tests against **Contracts** (Interfaces), not Implementations.
     *   **Act**: Invoke the unit under test.
     *   **Assert**: Verify the output or side-effect on the mock.
 
+### Test Priority by Boundary
+Test the **most stable meaningful boundary**; do not test private details unless it materially improves confidence.
+*   **Domain / Core**: prioritize correctness + unit tests.
+*   **Public interfaces / ports**: prioritize contract tests.
+*   **Infrastructure adapters**: integration/contract tests against the external boundary or a test double.
+*   **Application UseCases**: test orchestration + expected-failure handling.
+*   **UI**: test pragmatically; invest only when behavior is complex/critical.
+*   **Internal private helpers**: test through the public/module contract unless the logic is complex & pure enough to justify direct tests.
+
 ### Contract Verification (The Primary Validation)
 **Rule**: The Contract Test IS the definition of correctness.
 
~~~~

### `artifacts/DESIGN_PHILOSOPHY.md`

~~~~diff
@@ -56,6 +56,33 @@ rationale: |
 
 ---
 
+## Module — The Primary Boundary
+
+The unit of design is the **module** (a feature / functional area), not the technical layer. A module should feel like **its own small world**: callers understand it by its contract; its internals can start simple and evolve.
+
+```yaml
+choose_module_boundary_by: ["feature / functional area", "reason to change", "domain concept", "dependency direction"]
+tech_type_split: "Controller / Service / Repository / DTO / Mapper live INSIDE a module, not as the top-level structure."
+rule: "Module boundary first; layers (domain/application/infrastructure/ui) live inside the module."
+```
+
+> **Single source of truth**: concrete layout and the layer rules live in `CODING_STANDARDS.md` → "Architectural Boundaries (Layering)". This section states only the principle (the *why*).
+
+## Module Shell vs Internal Implementation
+
+Design the **shell** (boundary + public contract) precisely; inside the shell, implementation may be **flexible and fast** as long as it obeys the boundary. The goal is **controlled change impact**, not abstract purity.
+
+```yaml
+shell_is_strict: ["public contract", "module-facing interfaces", "request/response DTOs", "public behavior", "caller-visible side effects", "dependency direction", "failure semantics", "boundary translation"]
+internal_is_flexible: ["private helpers", "inline mapping", "procedural / functional code", "small concrete classes", "temporary internal structure"]
+accuracy_vs_speed:
+  accuracy_mandatory: "module shell, public contracts, Domain/Core models, dependency direction, external-dep isolation, Result/error semantics, DTO & mapping boundaries, public behavior, side effects."
+  speed_acceptable: "private helper structure, internal algorithms, temporary classes, one-off inline mapping, refactorable internal organization."
+rule: "Be precise where change impact escapes the module; be fast where it stays contained."
+```
+
+---
+
 ## Responsibility-Driven Design
 
 We adhere to the Single Responsibility Principle (SRP) to minimize the impact of changes.
@@ -72,6 +99,18 @@ single_responsibility:
 
 ```
 
+**Judge SRP by *reason to change* and *caller-visible capability* — NOT by class size or method count.** A component may run several internal steps and still have one responsibility if the caller sees a single coherent capability (e.g., internally read a clock, format, and return → responsibility: *"tell the caller the current time"*). Criteria order: (1) reason to change, (2) caller-visible meaning, (3) needs "and"?, (4) size / method count, (5) test perspective.
+
+### Responsibility Anti-Patterns (actively avoid)
+*   **God / "everything" service** — one Service that knows too much and becomes the hidden center of the system. *(Most dangerous.)*
+*   **Business rules in Controller / Page / UI** layer.
+*   **UI display concerns inside Domain/Core** models (see Domain Purity).
+*   **Infrastructure exception types** leaking into Application/Domain (see Error Boundary Translation).
+*   **DTOs used as Domain models** (see Mapping & Conversion Policy).
+*   **Utility / Helper dumping grounds**; **Config / Logger / HttpClient appearing everywhere**.
+*   **`any` / `object` / `dynamic` used to escape modeling.**
+*   **Bloated Manager** — large is not automatically bad; it is bad when it *mixes unrelated responsibilities* or accumulates unrelated logic.
+
 ### Responsibility Types
 | Type | Description | Example (Conceptual) |
 | :--- | :--- | :--- |
@@ -168,6 +207,18 @@ ownership: "The project owns its core contracts; introduce an adapter / anti-cor
 
 > **Single source of truth**: the normative wrap/allow/prohibit rules and the UI & Infrastructure exceptions live in `CODING_STANDARDS.md` → "External Dependency Boundary Policy". This section states only the principle (the *why*).
 
+## Domain Purity (Mechanism vs Concept)
+
+Keep technical **mechanisms** out of Domain/Core — but do NOT treat every value involving time, color, text, or records as non-domain. Domain may hold **domain concepts** that happen to involve them.
+
+```yaml
+keep_out_always: ["DB / HTTP / filesystem I/O", "external API DTOs", "framework attributes/annotations", "vendor SDK types", "UI framework types"]
+contextual: ["current time", "randomness", "settings", "logging", "display names / colors / labels"]
+test: "Does this value exist because of the UI/tech, or because of the business/domain itself? Origin decides ownership."
+```
+
+> **Single source of truth**: concrete rules, examples, and the UI-value decision live in `CODING_STANDARDS.md` → "Domain Purity Rules". This section states only the principle (the *why*).
+
 ## Internal Paradigm Agnosticism
 
 Inside a boundary, the implementation style is flexible.
~~~~
