# Code Design and Change Model

```yaml
document_type: "canonical_knowledge"
authority: "canonical_source"
audience: ["ai_agents", "human_maintainers"]
scope: "software boundaries, implementation, structure, evolution, and verification"
artifact_projection: "derived"
```

This document owns reusable knowledge for designing and changing software. It keeps design rationale, normative rules, structural placement, and the change process near the concepts they govern instead of splitting them into separate WHY/HOW/WHERE/FLOW documents.

## 1. Foundational Model: Bounded Contracts

The core design principle is **Bounded Contracts**.

```text
Contract = Signature / Shape + Semantics / Behavior + Constraints
```

A boundary is understood from the outside through what callers may rely on. Its implementation is replaceable when those observable guarantees remain stable.

Constraints may include side effects, failure behavior, resource/performance bounds, determinism, ordering, concurrency, cancellation, data/persistence guarantees, compatibility, and lifecycle guarantees.

An interface keyword is only one possible syntax for a contract. The contract is the design boundary itself.

## 2. OOP as Shell, Flexible Logic as Interior

For behavioral components such as services, repositories, adapters, and UI components:

- the shell owns communication, dependencies, and caller-visible guarantees;
- the interior may use functional, procedural, data-oriented, or object-oriented techniques.

For domain entities, the class may itself own state and business logic.

Do not interpret object orientation as class taxonomy or inheritance-heavy modeling. Prefer message-based interaction, explicit boundaries, encapsulation, and composition.

## 3. Boundaries Are Recursive

Contract discipline applies at multiple scales:

```text
function → class → module → library → service → application / public API
```

The module is usually the primary operating boundary because it is often the smallest unit that can be owned, replaced, tested, and reasoned about coherently. This is a pragmatic default, not a universal floor.

The cost of a broken boundary grows with scale.

## 4. Encapsulation Horizon

The **Encapsulation Horizon** is the scale at which a hard contract is worth maintaining.

Default:

- harden stable public surfaces at and above the module boundary;
- keep the interior below the horizon flexible unless a concrete reason appears.

Move the horizon downward when a large interior develops independently changing sub-responsibilities. Move it upward when several parts form one tightly coupled caller-coherent capability.

Do not create hard interfaces at every scale.

### Harden when

A seam is a good candidate for a hard contract when:

- its responsibility is stable enough to name;
- ownership is clear;
- callers benefit from replacement, isolation, or independent verification;
- the seam is not so chatty/shared-state-heavy that the boundary itself becomes accidental complexity.

### Redraw reactively

An "AND" in a responsibility sentence is a warning, not an automatic split.

Split peer-level meanings with different actors, policies, or lifecycles. Keep subordinate steps inside one higher-level capability.

When an internal responsibility matures into several inner boundaries, preserve the existing outer contract when possible.

## 5. Responsibility-Driven Design

A component should have one coherent reason to change.

Judge responsibility primarily by:

1. reason to change;
2. caller-visible capability;
3. whether multiple meanings are peer-level or subordinate;
4. state ownership and consistency consequences;
5. size or method count only as weaker evidence.

Avoid:

- god/everything services;
- business rules in Controller/Page/UI;
- UI display concerns in Domain/Core;
- infrastructure exceptions leaking into Application/Domain;
- DTOs used as Domain models;
- Utility/Helper dumping grounds;
- Config/Logger/HttpClient appearing everywhere;
- `any` / `object` / `dynamic` used to escape needed modeling;
- bloated Managers that accumulate unrelated responsibilities.

A large component is not automatically wrong. It is wrong when unrelated responsibilities or ownership become entangled.

### Responsibility types

| Type | Meaning | Example |
|---|---|---|
| Functional | business logic/calculation | `TaxCalculator` |
| Technical | I/O, networking, serialization/formatting | `JsonSerializer` |
| Orchestration | coordinating flow/wiring | `OrderProcessingUseCase` |

Do not mix ownership of these peer-level responsibilities in one component. An orchestrator may coordinate Functional and Technical work without owning their internal decisions.

## 6. State Ownership and Cross-Boundary Consistency

Each mutable business state has one clear owning boundary.

When one business outcome spans several owners:

- one orchestration boundary owns coordination and failure policy;
- participants retain ownership of their internal state;
- the required consistency model is explicit.

Possible models include atomic transactions, retry/idempotency, compensation, and explicit intermediate states.

A cross-boundary invariant does not automatically imply the modules should merge. Reconsider a split when the seam becomes chronically chatty, shares mutable state, or repeatedly forces both sides to change together.

## 7. Concept Altitude

Place a concept at the altitude of its **meaning**, not at the location of its first consumer.

A responsibility sentence that does not need a feature/consumer name is evidence that the concept may be consumer-neutral. It is not proof that several consumers share one semantic abstraction.

Before sharing/extracting a concept, compare invariants, pre/postconditions, failure semantics, lifecycle/state transitions, and reasons to change.

If semantic identity is not yet established, keep the model consumer-neutral when truthful, keep it local, and delay shared-module extraction.

Rules:

- name the concept by what it is rather than by its first consumer when the meaning is genuinely consumer-neutral;
- a consumer-neutral contract/type must not import or reference the first consumer's feature types unless that feature-specific meaning is part of the concept;
- feature-specific variation enters through implementation, composition, or parameters and remains owned by that feature;
- neutral meaning does not imply shared physical placement; promotion is earned only when another consumer genuinely needs the same semantics.

YAGNI constrains speculative mechanisms and placement. It does not justify giving a general concept a feature-specific meaning. Concept altitude, physical code sharing, and hardening depth are separate decisions.

## 8. Module Organization

Prefer feature/module-first organization.

```text
<module>/
├─ domain/
├─ application/
├─ infrastructure/
└─ ui/                 # optional
```

Technical layers normally live inside the feature/module boundary instead of becoming the repository's top-level organization. A module is a semantic boundary, not merely a folder.

## 9. Module Public Surface

Modules are default-internal.

Expose the smallest stable public surface required by external callers. External modules depend on that public surface rather than deep internal paths.

A normal module may expose one primary surface such as `index` or `contracts`. Additional audience-scoped surfaces are allowed when their audience, stable scope, and evolution policy are explicit.

"One public surface" does not mean "one giant facade".

## 10. Interface Requirement Threshold

Do not create an interface automatically for every class.

A hard interface/port is justified by a meaningful boundary such as external dependency isolation, genuinely replaceable implementation, cross-layer/module capability, a reusable contract-test seam, or a published/long-lived contract.

Private/local implementation may remain concrete. The goal is meaningful isolation, not maximizing interface count.

Domain Entities and Value Objects generally do **not** require an interface merely to represent their state. Introduce polymorphic contracts there only when the domain actually requires interchangeable behavior.

## 11. Interface Design

Design capabilities, not implementation-shaped method bags.

Interfaces/ports help with dependency inversion and testability: high-level policy depends on owned abstractions, and tests can substitute mocks/fakes/stubs without coupling to a concrete mechanism.

Names should express what the caller can rely on. Document only load-bearing contract semantics, not verbose comments everywhere: side effects, failures, ordering, cancellation, concurrency, resource/performance bounds, determinism, ownership, lifetime, and relevant pre/postconditions.

Follow Interface Segregation: callers should depend only on the capabilities they actually need.


## 12. Layer Responsibilities

### Domain

Owns business concepts, invariants, state transitions, and domain policy.

Domain should not depend on infrastructure mechanisms. Keep DB/HTTP/filesystem I/O, external API DTOs, framework attributes, vendor SDK types, and UI-framework types out of Domain/Core.

A normal concept such as time, text, names, colors, randomness, settings, or records is not automatically impure; judge whether it exists because of the domain or because of UI/technical mechanism.

Examples:

| Case | Rule |
|---|---|
| `DateTime.Now` inside an Entity | avoid; inject a `Clock` via an outer boundary |
| `ExpiresAt` | valid Domain concept |
| Entity directly using `Logger` | avoid |
| outer layer logs a Domain event | acceptable |
| audit logging is itself a business requirement | may belong to Domain/Application |
| button color | UI |
| rarity/team color or official/legal name | may be Domain |
| i18n display text | usually UI/Application |

Origin and meaning decide placement, not the primitive type alone.

### Application

Owns use cases, Application Services, orchestration, Application-owned ports, boundary DTOs, and transaction/consistency flow.

A UseCase may coordinate:

- Domain behavior;
- project-owned ports such as persistence, clock, email, queue, or external API access;
- authorization and transactions when appropriate;
- Application Request/Response DTO ↔ Domain mapping;
- expected-failure translation into the project's explicit failure model.

It must not own provider-specific HTTP/SDK details, Domain invariants, large unrelated formatting logic, or raw infrastructure exception types.

**Boundary rule:** Application defines its own Request/Response DTOs. Do not expose Domain Entities directly to external API/CLI boundaries.

### Contract placement

Place a contract at the boundary that owns the reason it exists.

| Contract type | Owner | Examples |
|---|---|---|
| Domain Contract | Domain | business capability, domain policy, domain error semantics |
| Application Port | Application | storage, email, clock, external API, queue |
| Infrastructure Implementation | Infrastructure | database repository, HTTP client, filesystem adapter, message queue adapter |

Do not put every interface into Domain by default. Domain owns business contracts; Application owns orchestration/integration ports; Infrastructure implements them without leaking mechanism outward.

### Infrastructure

Owns databases, network/filesystem/provider implementations, external SDK/client adapters, technical serialization, and provider-specific error/lifecycle translation.

### UI

Owns presentation, user interaction, UI-specific formatting, and UI state.

Do not put business policy in controllers/pages/components merely because they are convenient entry points.

### Type placement

| Type | Owning layer | Purpose |
|---|---|---|
| Domain Entity / Value Object | Domain | Business rules and invariants |
| UseCase DTO / Request / Response | Application | Boundary transfer and application-facing formatting |
| Tech DTO / DbModel / ApiSchema | Infrastructure | Storage/network/provider serialization |
| ViewModel / Presentation Model | UI | UI-shaped state; never referenced inward |

Application owns mapping between Domain Entities and application-boundary DTOs. Infrastructure owns mapping between Domain Entities and technical persistence/network DTOs.

## 13. Dependency Direction

High-level policy depends on stable abstractions rather than low-level mechanisms.

Layer diagrams describe responsibility placement; dependency direction remains toward owned contracts.

Concrete composition/wiring belongs at a composition root or equivalent application/runtime assembly boundary.

## 14. Dependency Injection

Use constructor injection or the ecosystem-equivalent for boundary dependencies.

Rules:

- dependencies are explicit constructor parameters/properties;
- do not resolve dependencies through a Service Locator from inside business classes;
- do not instantiate volatile dependencies such as I/O, configuration, randomness, or current time directly inside business/application logic;
- stable Values, Entities, and pure utility objects may be constructed normally when they are not replaceable boundary dependencies;
- inject capabilities/connectors, not every trivial helper.

Domain Entities and Value Objects do **not** receive service dependencies through constructor injection. Keep them pure. If an entity operation temporarily needs a domain/application capability, pass that capability explicitly as a method argument rather than storing an injected service.

Do not introduce DI ceremony where a concrete local object/value is sufficient.

## 15. External Dependency Containment

External dependencies are allowed, but their influence must be contained. Domain/core code depends on project-owned language and contracts, not vendor SDK types, framework models, DB schemas, HTTP clients, UI-framework types, or external API DTOs.

Wrap/adapt an external dependency when any of these holds:

- it would appear in Domain/core;
- its types would spread across modules;
- replacing it would force unrelated changes;
- vendor terminology would redefine domain vocabulary;
- it pushes technical errors/lifecycle/async/side effects into business logic;
- several modules would otherwise depend on the same vendor API directly;
- a widely depended-on module uses it;
- it touches a core domain concept.

Direct dependency is acceptable when it remains UI-specific, Infrastructure-specific, local to a small internal implementation without public leakage, or the module intentionally is a thin integration layer.

Prohibited:

- expose external SDK types from Domain contracts;
- use DB/API DTOs as Domain Entities;
- let one external model become the implicit shared model of the system;
- make most modules depend directly on one vendor API when a project-owned abstraction would localize the change.

UI may depend on UI frameworks and Infrastructure may depend on SDKs/clients because those mechanisms belong there. Do not push those types inward into Application or Domain.

When Domain/Application needs an external capability, define a project-owned port at the owning boundary and implement it in Infrastructure.

Translate at the boundary:

- request/response representations;
- provider errors;
- lifecycle and ownership;
- retry/timeout behavior;
- provider-specific semantics.

## 16. Domain Modeling

Use a rich model when the domain contains meaningful invariants, behavior, and state transitions.

Use a lightweight/anemic representation when the domain is genuinely simple.

Do not manufacture domain complexity merely to appear "DDD".

Entities may be mutable when mutation is controlled by invariants and clear ownership.

Two supported lifecycle patterns:

1. **Rich mutable model (standard)** — methods mutate internal state for ordinary granular business changes, and every method must leave the entity valid.
2. **Type-driven state transitions (recommended for critical flows)** — use when a state transition fundamentally changes capabilities/contracts. Example: `UnpaidOrder.Pay() -> PaidOrder`, where only `PaidOrder` exposes `Ship()`. If chosen, use it consistently for that lifecycle.

Use distinct types/state representations when making illegal states unrepresentable materially improves safety.

## 17. Internal Flexibility

Design the public/module shell precisely while allowing pragmatic implementation below the Encapsulation Horizon.

Strict shell concerns include:

- public/module contracts;
- request/response DTOs;
- caller-visible behavior and side effects;
- dependency direction;
- failure semantics;
- boundary translation.

Flexible interior concerns include:

- private helpers;
- inline one-off mapping;
- procedural/functional/data-oriented algorithms;
- small concrete classes;
- temporary internal structures.

Internal flexibility is safe only when the surface closes the observable leakage channels:

- signature/shape;
- semantics;
- resource bounds such as CPU, memory, pools, latency/time;
- failure behavior such as timeouts, retry storms, shared-state corruption;
- determinism;
- persisted/data invariants.

Interior freedom is bought by surface completeness. A loose contract around a complex interior leaks complexity outward; a complete contract lets the interior remain replaceable and fast to change.

Be precise where change impact escapes the module. Move quickly where the effect is truly contained.

## 18. Mapping and Conversion

Mapping is boundary translation. Domain is mapped **from/to**; it must not know outer representations.

**Strong rule:** Domain Entities / Value Objects must not expose `ToDto()`, `ToViewModel()`, `ToDbModel()`, or equivalent external-schema conversion methods.

Placement:

- **Application** maps Domain ↔ UseCase Request/Response DTOs.
- **Infrastructure** maps DB/API/filesystem models ↔ Domain. An Infrastructure-local `ToDomain()` is acceptable.
- **UI** maps Application responses ↔ UI ViewModels when needed.

Small one-off mappings may stay inline in the owning UseCase/Adapter. Reused, complex, or semantically meaningful mapping should be extracted within the owning boundary.

Useful naming:

| Name | Role |
|---|---|
| `Mapper` | structural DTO ↔ Domain |
| `Converter` | value/type conversion such as string → Money |
| `Assembler` | builds a response from multiple sources |
| `Adapter` | wraps an external API/SDK behind an owned contract |
| `Translator` | translates vendor/external concepts into owned concepts |

Do not reuse transport/persistence DTOs as domain models merely to avoid mapping. Avoid generic conversion/helper dumping grounds.

## 19. Error Handling

Distinguish expected business/operational deviations from system/programmer failures.

### Expected failure

Use the project's standard explicit failure type: `Result<T,E>`, `Either`, `Outcome`, or ecosystem-equivalent.

Rules:

- reuse the project's existing standard type;
- do not create another Result/Outcome type when one already exists;
- do not use `boolean` success/fail or `null` to represent expected business errors;
- do not use exceptions as control flow for expected business rules.

If no Result-like core type exists, a minimal project-owned shared-kernel implementation is authorized. This bootstrap utility is not itself a Domain public contract and does not require a separate public-contract confirmation gate.

If the project already standardizes on a Result/Either library, reuse it. When bootstrapping from zero, prefer a minimal project-owned kernel type; adopting a vendor library at the shared kernel is a system-wide external-dependency decision and should be treated as L2 unless already implied by project convention.

### System failure

For failures the system cannot reasonably recover from locally, standard exceptions/panics/top-level failure handling remain appropriate.

### Boundary translation

Raw infrastructure exceptions must not leak into Application or Domain.

Infrastructure catches technical failures such as DB/HTTP/filesystem exceptions and translates them into Domain/Application meaning. Preserve the original exception/cause internally for diagnostics while exposing only the owned semantic failure outward.

Caller-relevant failure semantics are part of the contract.

## 20. Concurrency and Async Contracts

Concurrency is part of the contract, not merely an implementation detail.

```yaml
async_policy:
  signature: "if an operation is asynchronous, the contract expresses it through Task / Promise / suspend / ecosystem equivalent; do not hide async behind a sync facade"
  thread_safety: "state thread-safety semantics such as thread-safe, caller-confined, or single-threaded only"
  cancellation: "long-running or I/O operations should accept and honor a cancellation token/signal when the ecosystem supports it"
  domain_purity: "threading/scheduling primitives do not leak into Domain contracts; concurrency belongs to Application/Infrastructure"
  shared_state: "do not share mutable state across a boundary without explicit synchronization or immutability"
```

Clarify caller-visible ordering, timeout, backpressure, idempotency, retry behavior, task ownership, and lifetime where relevant.

Never block on async with patterns such as `.Result` / `.Wait()` across a boundary you do not own; propagate async to the edge.

Do not label an escaping concurrency hazard as an "internal detail".

## 21. Performance-Shaped Contracts

Optimize **behind the existing contract first**. Do not redesign API interaction shape from intuition or speculative "this may be slow" reasoning.

A performance requirement becomes contract input only when it is load-bearing and caller-visible, such as a real latency, throughput, memory, bounded-work, cancellation, or backpressure requirement.

Before changing an existing interaction shape:

1. state the required bound and representative workload/conditions;
2. try implementation-only optimization while preserving the contract;
3. use representative measurement when practical, or a defensible structural lower bound such as unavoidable N remote round trips or unbounded materialization;
4. redesign only the interaction shape when evidence shows the current shape itself prevents the bound;
5. re-check semantic capability, ownership, failure semantics, and compatibility;
6. verify the resulting contract against the stated bound under the representative workload or an equivalent deterministic bound check.

Possible contract shapes include batch, streaming, pagination, async/cancellation, and bounded-concurrency/backpressure semantics.

Do not expose implementation tactics merely because they are faster. Caching, buffering strategy, vectorization, pooling, unmanaged-code choices, cache layout, arbitrary chunk sizes, or buffer ownership remain internal unless interoperability genuinely makes them caller-visible guarantees.

### Contract medium and blast radius

- **Module-local/internal port**: a shape change can remain contained when all participants are owned by the requested task; keep the published outer module contract stable where possible.
- **Published in-process/library API**: compatible added batch/stream capability may be additive; changing/removing required existing interaction is breaking unless migration is agreed.
- **Cross-runtime/wire protocol**: pagination tokens, stream framing, request batching, ordering, retry/idempotency, and backpressure are wire semantics; check rollout/schema compatibility and mixed-version behavior where relevant.
- **Persistent-data-facing contract**: if performance changes stored representation or migration requirements, classify persistence compatibility separately.

Performance does not bypass ordinary compatibility/deprecation rules.


## 22. Contract Evolution and Compatibility

"Additive" describes change shape; it does not prove compatibility.

When evolving an existing contract, identify:

- callers/consumers;
- providers/implementers/fakes;
- relevant compatibility dimensions such as source/binary, wire/schema, or persisted-data compatibility;
- existing guarantees.

A change is backward-compatible only when existing participants can continue without mandatory changes and previously valid interactions retain their guarantees.

Rules:

- prefer additive evolution when it truly preserves both consumer and provider behavior;
- a published breaking change follows the L3 confirmation path;
- a contained module-local break may remain L1/L2 when all participants are owned inside the requested scope;
- changed **Semantics** is breaking even when the Signature is identical;
- Application Ports evolve with their use case; version the port, not Domain merely to accommodate integration evolution;
- an internal maturation split adds inner boundaries while preserving the published outer contract; if the outer contract must break, route that through the normal confirmation gate.

### Deprecation

When a published replacement is needed:

1. mark the old contract deprecated and keep it working;
2. provide the replacement plus migration guidance in the contract semantics;
3. remove the old contract only after consumers migrate or at an explicitly agreed major-version boundary.

Classify confirmation/risk according to `ENGINEERING_OPERATING_MODEL.md`.

## 23. Composition Over Inheritance

Prefer composition and delegation.

Inheritance is appropriate mainly for capability/interface inheritance and strict framework/library extension contracts.

Do not use inheritance merely for implementation reuse.

## 24. Reliability and Side Effects

### Fail fast

Validate:

1. construction and invariants;
2. external input at boundaries;
3. preconditions before complex operations.

Do not allow invalid state to propagate invisibly.

### Type-driven state

Use distinct types/states when they materially prevent invalid transitions or boolean-flag state explosions.

### Side-effect control

Minimize and isolate side effects.

Prefer safe defaults, temporary/sandboxed resources when appropriate, explicit enablement for destructive effects, and deterministic disposal/cleanup mechanisms.

## 25. Appropriate Complexity

Accept essential domain complexity and remove accidental engineering complexity.

YAGNI means:

- no speculative features;
- no abstractions without demonstrated boundary value;
- no premature shared-module extraction.

An abstraction should reduce reasoning/change cost. Remove one that merely obscures a simpler correct design.

## 26. Shared Kernel and Cross-Cutting Placement

A single `shared/` dumping ground is an anti-pattern. Separate shared concepts into four tiers:

| Tier | Holds | Dependency rule | Stability |
|---|---|---|---|
| **T0 — Kernel** | Result/Option, base error, Id, VO base | depends on nothing; anyone may depend on it | near-frozen |
| **T1 — Cross-cutting ports** | Clock, Logger, Config, IdGenerator contracts | depend on the port; implementation stays in Infrastructure; wire at composition root | stable |
| **T2 — Shared contracts** | cross-module / cross-runtime DTOs and wire contracts | both sides may depend on it; keep separate from T0 | evolves under compatibility gate |
| **T3 — Shared Domain VOs** | truly universal, behavior-light VOs such as Money/Email | promote carefully; keep entity ownership local | deliberate |

Rules:

- T0 depends on nothing.
- Nothing in shared may depend on a feature module.
- Current time/randomness/logging/settings enter through T1 ports instead of direct Domain dependencies.
- Keep T2 separate from T0 because published contracts evolve while the kernel should remain stable.
- A concept earns shared placement only when at least two modules genuinely need the same semantics and it is stable enough to share.
- Share Value Objects with care; do not share Entities merely for convenience.

Do not promote code to shared merely because two implementations look similar.

Shared state and utility dumping grounds are especially risky.

## 27. Runtime Topology

Single-runtime UI and separately deployed frontend/backend are different topologies and should be chosen explicitly.

| | Single runtime | Multiple deployables |
|---|---|---|
| Example | SSR/server-rendered one process | SPA/browser + API/server |
| UI placement | inside each feature/module | frontend is its own bounded context |
| Use when | one runtime serves the system | runtimes/deploy targets are separate |

The runtime seam is itself a published Bounded Contract. HTTP/RPC DTOs carry signature, semantics, constraints, compatibility, authentication/authorization, failure, and retry expectations. Additive wire shape is not automatically compatible.

For a multi-deployable frontend:

- the frontend owns its own UI/application/infrastructure/domain-or-view-model structure;
- it depends only on the shared T2 contract;
- it must not import backend Domain/Application/Infrastructure code.

For monorepos, two common shapes are valid:

1. **runtime-first** (recommended for multiple runtimes): thin `apps/{api,web}` shells/composition roots, server feature packages, shared kernel/contracts, frontend features under the web runtime;
2. **feature-first**: feature packages contain server and UI/contracts together, with thin app entry points; use only when tooling and team ownership reliably prevent browser imports of server infrastructure.

Document the chosen topology.

Each runtime entry point is a composition root: read environment/bindings at the edge, construct adapters, inject use cases, and keep business logic out of the entry point.

## 28. Composition Root

Centralize concrete implementation wiring at an application/runtime composition boundary.

Business/domain modules should not construct provider clients throughout the codebase.

## 29. Testing Strategy

Testing serves two distinct goals:

1. **contract conformance**;
2. **requested-outcome verification**.

Prioritize tests at stable boundaries.

### Contract tests

Reusable contract suites belong beside the contract/port rather than one implementation.

The contract suite verifies Signature + Semantics + Constraints. Every real implementation, fake, mock, or substitute that claims to implement the contract must satisfy the same suite/guarantees.

Contract conformance is not by itself proof that the user's requested outcome is reachable through composition, UI, runtime, or integration boundaries; verify that outcome separately through the narrowest meaningful path.

### Unit tests

Test meaningful domain/application behavior and edge cases.

### Integration tests

Use when behavior crosses real boundaries such as DB/provider/runtime integration.

### E2E/manual verification

Use when the meaningful requested outcome crosses the whole system or user interaction path.

Do not substitute expensive E2E testing for a narrow boundary test when narrower evidence is sufficient.

### Test priority by boundary

Test the most stable meaningful boundary; avoid private-detail tests unless they materially improve confidence.

- **Domain/Core**: prioritize correctness and unit tests.
- **Public interfaces/ports**: prioritize contract tests.
- **Infrastructure adapters**: use integration/contract tests against the real external boundary or an appropriate test double.
- **Application UseCases**: test orchestration and expected-failure handling.
- **UI**: test pragmatically; invest more when behavior is complex or critical.
- **Private helpers**: normally verify through the public/module contract unless complex pure logic justifies direct tests.

## 30. Test Placement

Co-locate tests with ownership when ecosystem conventions allow.

- module-internal tests live with/near the module;
- a contract suite lives beside the contract/port;
- fakes live where their test ownership is clear;
- cross-runtime E2E tests live at the system/application level.

## 31. Code Change Process

### Define the required outcome

State the observable result before designing internals.

### Pre-implementation scan

Scale depth to blast radius and inspect:

- affected module/public surface;
- responsibility and encapsulation horizon;
- concept altitude and semantic identity;
- state/consistency ownership;
- dependency spread and external mapping;
- caller-visible accuracy vs internal flexibility;
- load-bearing performance;
- compatibility when an existing contract changes.

### Resolve contracts

Clarify behavioral/domain guarantees before implementation where a meaningful boundary is involved.

### Classify confirmation

Use the shared confirmation model:

- private/internal change → L0/L1;
- compatible public capability clearly implied by the task → L2;
- published breaking behavior, destructive side effect, or persisted migration → L3.

### Implement

Keep the public shell precise and the interior pragmatic.

### Verify

Check contract conformance, requested outcome, boundary leakage, ownership/consistency, and performance evidence when applicable.

## 32. Brownfield Code

These rules govern code being added or modified; they do not require automatic repository cleanup.

- follow explicit target-project conventions when they conflict;
- do not silently rewrite unrelated violations;
- note relevant debt when useful;
- classify cleanup as its own change;
- prevent opportunistic refactoring from expanding scope.

## 33. Design Decision Priority

When making design choices, prioritize:

1. **Clarity of boundary and contract**
2. **Stability of external interface**
3. **Locality of change**
4. **Explicitness of side effects**
5. **Internal elegance or purity**

This priority order evaluates design choices.

### Mistakes to prevent

When reviewing risk, prevent these mistakes in roughly this order:

1. mixing responsibilities in one class/module;
2. mishandling expected business failures with exceptions, nulls, or boolean flags instead of an explicit expected-failure model;
3. silently changing a public contract, DTO, or observable behavior;
4. spreading an external dependency into Domain/core or across unrelated modules;
5. over-engineering with unnecessary abstractions.

Over-engineering is a real problem, but it ranks below the first four. Do not skip a justified boundary merely to avoid abstraction, and do not add meaningless boundaries either.

## 34. Common Misreadings

- "harden public surfaces" does not mean interface everywhere.
- an "AND" does not always require a split.
- domain purity does not ban normal concepts such as time/text/color.
- one public surface does not mean one giant facade.
- orchestration may coordinate technical work without owning provider internals.
- expected failures and system failures need not use the same mechanism.
- YAGNI does not justify giving a general concept a feature-specific meaning.
- consumer-neutral naming does not prove shared semantic identity.
- a cross-boundary invariant does not automatically require merging boundaries.
- passing contract tests does not prove the requested outcome is reachable through the real system.
