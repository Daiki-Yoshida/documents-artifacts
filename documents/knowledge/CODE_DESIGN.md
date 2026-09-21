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

Avoid god/everything services, unrelated functional/technical/UI responsibilities in one unit, helper/utility/manager dumping grounds, and infrastructure details leaking into higher-level policy.

A large component is not automatically wrong. It is wrong when unrelated responsibilities or ownership become entangled.

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

Names should express what the caller can rely on. Document load-bearing semantics where applicable: side effects, failures, ordering, cancellation, concurrency, resource/performance bounds, determinism, ownership, and lifetime.

Follow Interface Segregation: callers should depend only on the capabilities they actually need.


## 12. Layer Responsibilities

### Domain

Owns business concepts, invariants, state transitions, and domain policy.

Domain should not depend on infrastructure mechanisms. A normal language/runtime concept such as time, text, or color is not automatically impure; judge whether it represents domain meaning or a technical mechanism.

### Application

Owns use cases, orchestration, coordination of domain and technical ports, and transaction/consistency flow at the application boundary.

Application may coordinate technical work but should not own provider-specific implementation decisions.

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

Use constructor injection or the ecosystem-equivalent when a real boundary dependency exists.

Inject capabilities/connectors, not every trivial helper.

Domain entities should not become service locators or containers for infrastructure dependencies.

Do not introduce DI ceremony where a concrete local object/value is sufficient.

## 15. External Dependency Containment

Third-party SDK/API/framework types should not cross stable owned boundaries unless the external type is intentionally part of the contract.

Where change impact matters, wrap external capabilities behind owned ports/adapters.

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

Use distinct types/state representations when making illegal states unrepresentable materially improves safety.

## 17. Internal Flexibility

Below a hardened boundary, implementation may be pragmatic:

- private helpers;
- inline mapping;
- procedural or functional algorithms;
- small concrete classes;
- temporary internal structures.

Internal flexibility does not permit caller-visible leakage or unowned chaos.

The more freedom exists inside, the more completely the outer contract must close observable leakage channels.

## 18. Mapping and Conversion

Convert representations at ownership boundaries.

Typical conversions:

- external DTO ↔ application/domain type;
- persistence record ↔ domain model;
- application/domain result ↔ UI/presentation type.

Place mapping where knowledge of both representations legitimately exists.

Do not reuse transport/persistence DTOs as domain models merely to avoid mapping. Avoid generic conversion/helper dumping grounds.

## 19. Error Handling

Use explicit Result-like errors for expected business/operational failure when the language/ecosystem supports it well.

Programmer/system failures may still throw/panic according to language convention.

Translate errors at boundaries so provider/infrastructure exception types do not leak into higher-level contracts.

Caller-relevant failure semantics are part of the contract.

## 20. Concurrency and Async Contracts

Concurrency is part of a boundary contract whenever callers can observe it.

Clarify as applicable:

- thread-safety;
- ordering;
- cancellation;
- timeout;
- backpressure;
- idempotency;
- retry behavior;
- shared mutable state;
- task ownership/lifetime.

Do not label an escaping concurrency hazard as an "internal detail".

## 21. Performance-Shaped Contracts

Do not redesign API interaction shape from speculation.

A performance concern may shape a public contract when:

- a load-bearing requirement exists;
- measurement or a defensible structural bound shows the interaction shape is a limiter;
- implementation-only optimization is insufficient.

Possible contract shapes include batch, stream, pagination, asynchronous operations, and bounded concurrency.

When public shape changes, evaluate compatibility for the actual contract medium: source/binary API, wire/schema, persisted data, or another relevant medium.


## 22. Contract Evolution and Compatibility

"Additive" syntax is not proof of compatibility.

When evolving an existing contract, identify:

- callers/consumers;
- providers/implementers;
- relevant compatibility dimensions;
- existing guarantees.

A change is backward-compatible only when existing participants can continue without mandatory changes and previously valid interactions retain their guarantees.

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

Use shared placement conservatively.

A useful conceptual tier model is:

- small foundational kernel types;
- cross-cutting ports;
- stable shared contracts;
- shared value objects with genuinely shared semantics.

Do not promote code to shared merely because two implementations look similar.

Shared state and utility dumping grounds are especially risky.

## 27. Runtime Topology

When frontend/backend or several deployables exist, runtime boundaries are contracts too.

Each deployable may be its own bounded context with internal modules.

The wire/network seam owns:

- protocol/schema;
- compatibility;
- authentication/authorization semantics;
- failure/retry behavior.

Monorepo layout may use `apps/`, `services/`, `packages/`, or ecosystem-native equivalents. Semantic boundaries matter more than one universal directory template.

## 28. Composition Root

Centralize concrete implementation wiring at an application/runtime composition boundary.

Business/domain modules should not construct provider clients throughout the codebase.

## 29. Testing Strategy

Testing serves two distinct goals:

1. **contract conformance**;
2. **requested-outcome verification**.

Prioritize tests at stable boundaries.

### Contract tests

Reusable contract suites belong beside the contract/port rather than one implementation. Every implementation/fake should satisfy the same caller-visible guarantees.

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
