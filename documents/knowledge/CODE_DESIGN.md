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
