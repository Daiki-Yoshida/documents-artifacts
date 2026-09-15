# Design Philosophy - AI Agent Reference

```yaml
document_type: "design_philosophy"
target_audience: "ai_agents"
optimization: "token_efficiency"
language: "english"
base_paradigm: "Contract-Oriented"
core_value: "Boundary_Stability"
```

## Redefining "Object-Oriented"

*   **The Shell (OOP)**: Handles communication, boundaries, and dependencies (Interfaces, DI). Applies primarily to **Services, Components, and Architectural Boundaries**.
*   **The Core Logic (Internal)**: Handles logic and computation (Functional, Procedural, etc.).

**Scope Clarification**:
This "Shell" metaphor applies to behavioral components (Services, Repositories).
**Domain Entities** are NOT "architectural shells" in the dependency-injection sense; they should follow the **Rich Domain Model** *when the domain logic is complex* (see `CODING_STANDARDS.md`), encapsulating state and business invariants strictly.
*   **Complex Domain**: Use Rich Model. Enforce invariants internally.
*   **Simple Domain**: Use Lightweight/Anemic Model. Do not force complexity where none exists.

AI should interpret OOP strictly as:
*   **Message-based interaction**
*   **Contract-driven boundaries**
*   **Black-box encapsulation**

It is **NOT**:
*   Class-centric modeling for the sake of taxonomy
*   Inheritance-heavy design
*   Taxonomic categorization of the world


## Core Philosophy: Bounded Contracts & Explicit Interfaces

The foundational principle of this project is strict decoupling through **Bounded Contracts**.

```yaml
principle: "Bounded Contracts"
definition: "Modules are black boxes defined SOLELY by their public contract."
formula: "Contract = Signature (Type) + Semantics (Behavior) + Constraints (Side-effects / Failure / Resource / Determinism / Data guarantees)"
rationale: |
  The contract is the design. Implementation is secondary and replaceable.
  The `interface` keyword is just the syntax; the *Contract* includes the behavior and constraints.
```


### The "Why" of Interfaces

1.  **Contract First**: Interfaces define the *capabilities* (what), not the *methods* (how).
2.  **Dependency Inversion**: High-level policies (Domain) should not depend on low-level details (Infrastructure). Both should depend on abstractions.

    Layer diagrams describe responsibility boundaries, not dependency direction.
    Dependency direction is always toward abstractions.
3.  **Testability**: Interfaces allow trivially creating Mocks/Stubs without complex frameworks.

---

## Boundaries Are Recursive (Scale-Invariant)

The contract/boundary principle is **fractal**: the same discipline applies at every scale, and a unit at one scale is composed of units at the scale below.

```yaml
recursion: "function / interface  ->  class  ->  module  ->  library  ->  service  ->  application / public API"
invariant: "At EVERY scale the unit is a black box defined by its contract = Signature + Semantics + Constraints. The application as a whole is itself a single bounded unit; its public API is its contract."
encapsulation_scope: ["classes", "modules", "subsystems", "libraries", "services", "entire applications"]
```

**The module is privileged for pragmatic reasons, not because the principle stops there.** It is the primary *operating* boundary because it is usually the smallest unit you can replace, own, test, and deploy independently (see "Module — The Primary Boundary"). Apply the same contract discipline **upward** (library / service / app API) and **downward** (class / interface / function); only the **cost of a mistake** scales — a broken app-level API is far more expensive than a broken internal function (see Design Priority Order).

## Module — The Primary Boundary

The unit of design is the **module** (a feature / functional area), not the technical layer. A module should feel like **its own small world**: callers understand it by its contract; its internals can start simple and evolve.

The module is the **default** hardening boundary, **not a fixed floor**: the actual line where you commit to a hard contract is chosen by responsibility and may sit below or above the module (see *Encapsulation Horizon*). Read "primary" as "the usual default", not "the only scale".

```yaml
choose_module_boundary_by: ["feature / functional area", "reason to change", "domain concept", "dependency direction", "state ownership / consistency responsibility"]
tech_type_split: "Controller / Service / Repository / DTO / Mapper live INSIDE a module, not as the top-level structure."
rule: "Module boundary first; layers (domain/application/infrastructure/ui) live inside the module."
```

> **Single source of truth**: concrete layout and the layer rules live in `CODING_STANDARDS.md` → "Architectural Boundaries (Layering)". The module **public surface** (default-internal), shared-kernel placement, and multi-runtime topology live in `PROJECT_STRUCTURE.md`. This section states only the principle (the *why*).

## Module Shell vs Internal Implementation

Design the **shell** (boundary + public contract) precisely; inside the shell, implementation may be **flexible and fast** as long as it obeys the boundary. The goal is **controlled change impact**, not abstract purity.

```yaml
shell_is_strict: ["public contract", "module-facing interfaces", "request/response DTOs", "public behavior", "caller-visible side effects", "dependency direction", "failure semantics", "boundary translation"]
internal_is_flexible: ["private helpers", "inline mapping", "procedural / functional code", "small concrete classes", "temporary internal structure"]
leakage_channels: ["signature", "semantics", "resource (CPU / memory / pool / time limits)", "failure (timeouts, retry storms, shared-state corruption)", "determinism", "data (persisted invariants)"]
duality: "Interior freedom is BOUGHT by surface completeness. The wilder the interior (pointers, threads, GPU), the more completely the surface contract MUST close ALL leakage_channels above — not just the signature. Loose contract + wild interior = leakage; complete contract + wild interior = robust x flexible. 'Internal is its own responsibility' holds ONLY when the surface closes every channel."
accuracy_vs_speed:
  accuracy_mandatory: "module shell, public contracts, Domain/Core models, dependency direction, external-dep isolation, Result/error semantics, DTO & mapping boundaries, public behavior, side effects."
  speed_acceptable: "private helper structure, internal algorithms, temporary classes, one-off inline mapping, refactorable internal organization."
rule: "Be precise where change impact escapes the module; be fast where it stays contained."
```

---

## Encapsulation Horizon (the hardening line)

The **horizon** is the scale at which you commit to a hard contract; **inside it is one flexible interior** ("its own responsibility"). Choosing the horizon is the design act — neither harden every scale (death by seams) nor none (mud ball).

```yaml
place_at: "a cohesive unit with ONE caller-coherent responsibility. The module is the DEFAULT horizon, NOT a fixed floor: it moves DOWN (a large interior regrows inner horizons) and UP (a tightly-coupled cluster shares one outer surface)."
search_direction: "Descend MACRO -> MICRO (outermost surface inward); default = harden the PUBLIC SURFACE at each level — NOT 'interface everywhere'. The interior below the horizon is flexible by default; relax-pressure rises with depth."
why_top_down: "Under-hardening macro = catastrophic (escapes); over-hardening micro = contained. And relaxing (harden->flexible) is cheap while graduating (flexible->harden) is expensive. So default to harden from the top and relax as you descend."
initial_horizon: "Default stop-depth of the descent = the module — a loose PRIOR, not a floor. At/above module: default harden. Below module: default flexible (need a reason to harden). Day-1: harden down to the module, no deeper."
early_stage: "In an immature domain do NOT descend below the module: over-hardening micro (that should stay flexible) wastes up-front work AND slows the exploration that finds the right seams. Harden only the outer API + STABLE module seams; the horizon descends later, reactively."
harden_when:
  - "the responsibility is STABLE — not still being discovered (early hardening ossifies the wrong split)"
  - "the seam is CHEAP — not a chatty, tightly-coupled boundary that becomes a high-traffic toll booth"
re_draw_reactively: "When the responsibility fractures — an 'AND' appears in its description (see Responsibility-Driven Design) — split it; promote an interior sub-part into its own hardened unit. Split on OBSERVED fracture, not in anticipation (YAGNI)."
preserve_outer_surface: "An internal maturation-split keeps the published OUTER contract fixed and adds INNER horizons. If the split forces an outer break, the original responsibility was mis-drawn."
graduation_cost: "Interior freedom is cheap UNTIL a sub-responsibility graduates into a hardened unit — then its surface (semantics / resource / failure) must be built retroactively over an interior that grew wild. Containment DEFERS this debt, it does not erase it; weigh interior laxity against the future graduation cost."
decision_cues: "SPLIT: peer-level AND / different change-rates / independently testable / outer surface stays intact. KEEP: subordinate steps under one meaning / change together / chatty seam / duplicate test setup. CHEAP seam: low cross-call freq, stable shape, clear ownership. EXPENSIVE seam: high back-and-forth, shared mutable state, both sides edited together."
consistency_guard: "Before splitting, keep each mutable state under one clear owner and assign an owner for any cross-boundary business outcome, consistency requirement, and failure policy. A cross-boundary invariant is a coordination problem first, not automatic evidence that the boundaries must merge."
rule: "SRP says WHERE a boundary can go; maturity + seam cost + consistency responsibility say WHETHER / WHEN to harden it; the 'AND' test says when to re-draw."
```

---

## Common Misreadings to Prevent

These abstractions are easy to over-read. Do NOT collapse them into:

```yaml
misreadings:
  - "'harden public surfaces by default' != interface everywhere (the interior below the horizon is flexible by default)"
  - "'AND' appears != always split (keep subordinate steps; split peer-level meanings)"
  - "Domain purity != banning Date/Color/Text from Domain (origin decides; a domain concept may stay)"
  - "one public surface != one giant facade (audience-named, governed extra surfaces are allowed)"
  - "a UseCase may COORDINATE technical work but must not OWN technical details"
  - "contract documentation = load-bearing guarantees only, not verbose comments everywhere"
  - "module != folder (resolve: semantic / code / deployable / hardening-horizon)"
  - "Result handles EXPECTED failures; system failures may still throw"
  - "internal flexibility != careless internal chaos (only true when the surface closes every leakage channel)"
  - "public contract != method signature only (semantics + constraints + side effects + failure + resource + determinism + data)"
  - "YAGNI / 'flexible below the module' != model a general concept as feature-specific (YAGNI bounds mechanism & placement, NOT the concept's meaning — see Concept Altitude)"
  - "a feature-free responsibility sentence != proof that multiple consumers share one semantic concept (semantic identity must be earned)"
  - "consumer-neutral modeling != a shared abstraction (neutrality may be early; sharing waits for semantic evidence and reuse)"
  - "a cross-boundary invariant != merge the boundaries (keep state ownership clear and assign explicit consistency / failure coordination)"
```

---

## Responsibility-Driven Design

We adhere to the Single Responsibility Principle (SRP) to minimize the impact of changes.

```yaml
single_responsibility:
  principle: "A component should have one, and only one, reason to change."
  interpretation: "Focus on 'Cohesive Capability' rather than just 'Single Function'."
  granularity: "Cohesive Capability (not just Atomic)"
  validation:
    - "Can I describe the class's responsibility in one simple sentence?"
    - "Does 'AND' appear? It is a WARNING, not an auto-split: KEEP subordinate steps under one higher meaning (evaluate AND cost AND reconstruct → 'find a path'); SPLIT peer-level meanings with different actors/policies/lifecycles (find-path AND charge AND notify)."
    - "Do these methods change together for the same business reason?"
    - "If this responsibility is split, do state ownership and cross-boundary consistency / failure responsibilities remain explicit?"

```

**Judge SRP by *reason to change* and *caller-visible capability* — NOT by class size or method count.** A component may run several internal steps and still have one responsibility if the caller sees a single coherent capability (e.g., internally read a clock, format, and return → responsibility: *"tell the caller the current time"*). Criteria order: (1) reason to change, (2) caller-visible meaning, (3) needs "and"?, (4) consistency/ownership impact of a split, (5) size / method count, (6) test perspective.

### Responsibility Anti-Patterns (actively avoid)
*   **God / "everything" service** — one Service that knows too much and becomes the hidden center of the system. *(Most dangerous.)*
*   **Business rules in Controller / Page / UI** layer.
*   **UI display concerns inside Domain/Core** models (see Domain Purity).
*   **Infrastructure exception types** leaking into Application/Domain (see Error Boundary Translation).
*   **DTOs used as Domain models** (see Mapping & Conversion Policy).
*   **Utility / Helper dumping grounds**; **Config / Logger / HttpClient appearing everywhere**.
*   **`any` / `object` / `dynamic` used to escape modeling.**
*   **Bloated Manager** — large is not automatically bad; it is bad when it *mixes unrelated responsibilities* or accumulates unrelated logic.

### Responsibility Types
| Type | Description | Example (Conceptual) |
| :--- | :--- | :--- |
| **Functional** | Business logic, calculations | `TaxCalculator` |
| **Technical** | IO, Networking, Formatting | `JsonSerializer` |
| **Orchestration** | Coordinating flow, wiring | `OrderProcessingUseCase` |

**Rule**: Do not mix these responsibilities in a single class. *Coordinating ≠ owning*: an Orchestrator (UseCase) MAY coordinate Functional & Technical work but MUST NOT own their internal decisions (see `CODING_STANDARDS.md` → Application Boundary).

### State Ownership & Consistency Responsibility

A boundary split is valid only when it leaves ownership and failure responsibility understandable.

```yaml
state_owner: "Each mutable business state has one clear owning boundary. Other boundaries interact with that state through the owner's contract."
cross_state_outcome: "When one business outcome spans multiple state owners, one orchestration boundary owns the coordination and failure policy without taking ownership of the participants' internal state."
consistency_model: "Choose the required consistency model explicitly — atomic transaction when available, or retry/idempotency/compensation/explicit intermediate state when the topology cannot be atomic."
merge_rule: "A cross-boundary invariant does NOT automatically require merging modules. Reconsider the split when the resulting seam becomes chatty, shares mutable state, or repeatedly forces both sides to change together."
```

> **Single source of truth**: the normative ownership and coordination rules live in `CODING_STANDARDS.md` → "State Ownership & Cross-Boundary Consistency". This section states the design principle (the *why*).

---

## Composition Over Inheritance

We favor object composition to achieve polymorphic behavior and code reuse.

```yaml
inheritance_policy:
  status: "Restricted"
  allowed_usage:
    - "Interface inheritance (composition of capabilities)"
    - "Framework/Library specification (e.g., Unity MonoBehaviour, Template Method Pattern)"
  prohibited_usage:
    - "Pure code reuse (DRY) without defining a strict 'is-a' specification"
  reason: "Inheritance creates strong coupling. It should be used only when enforcing a strict contract or framework behavior."
```

### The Composition Approach
Instead of:
`class Derived : Base` (inheriting behavior)

Use:
`class Component(IDependency dependency)` (delegating behavior)

*   **State**: Held by the encapsulating object.
*   **Behavior**: Delegated to injected interface components.
*   **Flexibility**: Behavior can be changed at runtime by injecting different implementations.

---

## Reliability & Safety

### Fail Fast
Detect anomalies immediately. Do not allow invalid state to propagate.

```yaml
fail_fast_strategy:
  1_construction: "Validate arguments in constructors. An object must never exist in an invalid state."
  2_boundary: "Validate external inputs at the system boundary (API/UI Entry)."
  3_invocation: "Check invariants before complex operations."
```

### Type-Driven State Design
Make illegal states unrepresentable. Do not rely on boolean flags + exceptions for critical state transitions.

```yaml
type_driven_policy:
  principle: "Use distinct types to represent distinct states."
  goal: "Eliminate runtime state checks by enforcing compile-time type constraints."
```

> **Single source of truth**: the normative pattern, rule, and concrete example live in `CODING_STANDARDS.md` → "Entity Mutability Strategy (Pattern B: Type-Driven State Transitions)". This section states only the principle (the *why*).

### Environment Protection (Side-Effect Control)
Explicitly manage how the software interacts with the outside world.

```yaml
environment_protection:
  principle: "Minimize and isolate side effects."
  guidelines:
    explicit_permissions: "Destructive operations should need explicit enablement (e.g., config flags)."
    isolation: "Use temporary resources or sandboxes by default."
    safety_first: "Prefer safety mechanisms (dry-run, confirmations) over convenience."
    raii: "Use `IDisposable` (using statements in C#) to guarantee resource cleanup."
```

---

## Appropriate Complexity

Accept necessary complexity (domain logic) but ruthlessly eliminate accidental complexity (bad engineering).

*   **YAGNI**: do not implement features "just in case".
*   **Abstraction**: Abstractions should simplify the problem, not obscure it. If an abstraction makes the code harder to follow without providing flexibility, remove it.

## Concept Altitude (YAGNI Bounds Mechanism, Not Meaning)

YAGNI restricts **mechanism** — speculative interfaces, unused seams, premature shared-module extraction. It does NOT license **feature-coupling a general concept**: modeling a concept as feature-specific merely because one feature needed it first.

```yaml
principle: "Place a concept at the altitude of its MEANING, not of its first consumer. The first caller is a consumer, NOT the owner."
altitude_signal: "State the unit's responsibility in one sentence. If that sentence needs no feature/consumer name, treat this as a SIGNAL to keep the concept consumer-neutral — not as proof of broader semantic identity."
semantic_identity: "Before treating concepts from different consumers as one general concept, compare their invariants, pre/postconditions, failure semantics, lifecycle/state transitions, and reasons to change. The shared meaning must survive those comparisons."
uncertain_case: "When semantic identity is not yet evidenced, keep the model consumer-neutral but local. Do not declare a broad shared contract merely because the names can be generalized."
independent_axes: "Concept altitude (where a MEANING naturally belongs) is independent of hardening depth (where contracts are enforced — see Encapsulation Horizon) and physical sharing (where code is extracted). Neutral modeling does NOT require a shared module."
asymmetry: "Keeping a concept consumer-neutral at creation is nearly free (naming + not importing feature types). De-contaminating it later is expensive (references and semantics have spread). The same correction-cost asymmetry that justifies default-hardening."
anti_pattern: "Either feature-locking a plainly neutral concept (`DungeonStairs`) OR inventing a broad shared abstraction from naming similarity alone. Neutrality may be early; generality and sharing must be earned."
```

> **Single source of truth**: the normative semantic-identity, consumer-neutral naming/types, feature-policy placement, and physical-promotion rules live in `CODING_STANDARDS.md` → "Concept Generality". This section states only the principle (the *why*).

## External Dependency Containment

External libraries, SDKs, frameworks, and vendor types are allowed — but they must live **at the edges**, never become the architectural center.

```yaml
principle: "External dependencies may exist at the edges, but must not define the core domain language or spread across the architecture."
domain_core: "Domain and core Model depend on project-owned types/contracts — never directly on external SDKs, framework models, DB schemas, or vendor DTOs."
ownership: "The project owns its core contracts; introduce an adapter / anti-corruption layer when a dependency starts to spread inward."
```

> **Single source of truth**: the normative wrap/allow/prohibit rules and the UI & Infrastructure exceptions live in `CODING_STANDARDS.md` → "External Dependency Boundary Policy". This section states only the principle (the *why*).

## Domain Purity (Mechanism vs Concept)

Keep technical **mechanisms** out of Domain/Core — but do NOT treat every value involving time, color, text, or records as non-domain. Domain may hold **domain concepts** that happen to involve them.

```yaml
keep_out_always: ["DB / HTTP / filesystem I/O", "external API DTOs", "framework attributes/annotations", "vendor SDK types", "UI framework types"]
contextual: ["current time", "randomness", "settings", "logging", "display names / colors / labels"]
test: "Does this value exist because of the UI/tech, or because of the business/domain itself? Origin decides ownership."
```

> **Single source of truth**: concrete rules, examples, and the UI-value decision live in `CODING_STANDARDS.md` → "Domain Purity Rules". This section states only the principle (the *why*).

## Internal Paradigm Agnosticism

Inside a boundary, the implementation style is flexible.

```yaml
internal_paradigm:
  flexibility: "High"
  rule: "As long as the contract is honored, the internal implementation can be Functional, Procedural, or OOP."
  goal: "Use the best tool for the specific task (e.g., pure functions for logic, state machines for protocols)."
  restriction: "Internal implementation details MUST NOT leak into the public contract."
```

> **Single source of truth**: the normative internal-implementation rules (what you may use internally, and keeping the paradigm consistent within a cohesive module/file) live in `CODING_STANDARDS.md` → "Internal Flexibility (Allowed)". This section states only the principle (the *why*).

## Design Priority Order

When making design decisions, prioritize in this order:

1.  **Clarity of Boundary and Contract** (Most Important)
2.  **Stability of External Interface**
3.  **Locality of Change**
4.  **Explicitness of Side Effects**
5.  **Internal Elegance or Purity**

## Mistake Prevention Priority

The *Design Priority Order* above ranks design **choices**. This ranks **mistakes to prevent** (1 = most important to avoid):

1.  **Mixing responsibilities** in one class/module. (See *Responsibility-Driven Design*.)
2.  **Mishandling expected business failures** with exceptions / `null` / `boolean` flags instead of the Result pattern. (See `CODING_STANDARDS.md` → Error Handling.)
3.  **Silently changing a public contract / DTO / observable behavior.** (See `CODING_STANDARDS.md` → Contract Evolution + the Confirmation Gate.)
4.  **Spreading an external dependency** into Domain/core or across unrelated modules. (See `CODING_STANDARDS.md` → External Dependency Boundary Policy.)
5.  **Over-engineering** with unnecessary abstractions.

**Calibration**: (5) is real but ranks **below** 1–4. Do NOT skip a justified boundary contract to avoid "over-engineering"; do NOT add meaningless ones either.

## Performance vs. Abstraction Policy

Performance optimization must not degrade interface abstraction.

```yaml
performance_policy:
  interface_layer: "Strictly Abstract. Do NOT warp signatures for performance."
  implementation_layer: "Optimize Freely. Use internal buffering, caching, or unmanaged code if needed."
  cost_acceptance: "The overhead of the interface boundary (boxing, virtual calls) is an accepted cost."
  rule: "Optimize BEHIND the interface. Never expose optimization complexity (like manual buffer management) in the domain API."
```