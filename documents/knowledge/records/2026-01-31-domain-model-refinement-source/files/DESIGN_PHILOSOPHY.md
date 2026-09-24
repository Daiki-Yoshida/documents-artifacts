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
**Domain Entities** should follow the **Rich Domain Model** *when the domain logic is complex* (see `CODING_STANDARDS.md`), encapsulating state and business invariants strictly.
*   **Complex Domain**: Use Rich Model. Enforce invariants internally.
*   **Simple Domain**: Use Lightweight/Anemic Model. Do not force complexity where none exists.

They are not "architectural shells" in the dependency injection sense.

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
formula: "Contract = Signature (Type) + Semantics (Behavior) + Constraints (Side-effects)"
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

## Responsibility-Driven Design

We adhere to the Single Responsibility Principle (SRP) to minimize the impact of changes.

```yaml
single_responsibility:
  principle: "A component should have one, and only one, reason to change."
  interpretation: "Focus on 'Cohesive Capability' rather than just 'Single Function'."
  granularity: "Cohesive Unit (not necessarily Atomic)"
  validation:
    - "Can I describe the class's responsibility in one simple sentence?"
    - "Does 'AND' appear in the description? If so, split it."
    - "Do these methods change together for the same business reason?"

```

### Responsibility Types
| Type | Description | Example (Conceptual) |
| :--- | :--- | :--- |
| **Functional** | Business logic, calculations | `TaxCalculator` |
| **Technical** | IO, Networking, Formatting | `JsonSerializer` |
| **Orchestration** | Coordinating flow, wiring | `OrderProcessingUseCase` |

**Rule**: Do not mix these responsibilities in a single class.

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

### Type-Driven State Design
Make illegal states unrepresentable. Do not rely on boolean flags + exceptions for critical state transitions.

```yaml
type_driven_policy:
  principle: "Use distinct types to represent distinct states."
  goal: "Eliminate runtime state checks by enforcing compile-time type constraints."
  example:
    bad: "Order.IsPaid (bool) -> Order.ProcessShipping() throws if false"
    good: "UnpaidOrder -> pay() -> PaidOrder -> ship()"
  rule: "If a method is valid only in a specific state, that method must belong ONLY to the type representing that state."
```

```

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

## Internal Paradigm Agnosticism

Inside a boundary, the implementation style is flexible.

```yaml
internal_paradigm:
  flexibility: "High"
  rule: "As long as the contract is honored, the internal implementation can be Functional, Procedural, or OOP."
  goal: "Use the best tool for the specific task (e.g., pure functions for logic, state machines for protocols)."
  restriction: "Internal implementation details MUST NOT leak into the public contract."
  consistency: "Keep internal paradigm consistent within a specifically cohesive module or file."
```

## Design Priority Order

When making design decisions, prioritize in this order:

1.  **Clarity of Boundary and Contract** (Most Important)
2.  **Stability of External Interface**
3.  **Locality of Change**
4.  **Explicitness of Side Effects**
5.  **Internal Elegance or Purity**

## Performance vs. Abstraction Policy

Performance optimization must not degrade interface abstraction.

```yaml
performance_policy:
  interface_layer: "Strictly Abstract. Do NOT warp signatures for performance."
  implementation_layer: "Optimize Freely. Use internal buffering, caching, or unmanaged code if needed."
  cost_acceptance: "The overhead of the interface boundary (boxing, virtual calls) is an accepted cost."
  rule: "Optimize BEHIND the interface. Never expose optimization complexity (like manual buffer management) in the domain API."
```

