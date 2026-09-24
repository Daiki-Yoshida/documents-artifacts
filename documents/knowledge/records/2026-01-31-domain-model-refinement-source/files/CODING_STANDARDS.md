# Coding Standards & patterns - AI Agent Reference

```yaml
document_type: "coding_standards"
target_audience: "ai_agents"
document_type: "coding_standards"
target_audience: "ai_agents"
language_context: "Language-Agnostic"
optimization: "implementation_accuracy"
```

This guideline assumes a statically typed, interface-capable language.
Concepts must be adapted when applied to other ecosystems.

## Interface Design Rules

Interfaces are the backbone of our architecture.

### Naming & Granularity
*   **Prefix**: **MUST** follow the specific language's standard idiom.
    *   **CRITICAL RULE**: The constraints of the specific programming language ALWAYS take precedence over the examples provided here.
    *   *C#*: Use `I` prefix (e.g., `IJobFetcher`).
    *   *TypeScript/Python*: Do NOT use `I` prefix. Use descriptive names (e.g., `JobFetcher` (protocol) vs `JobFetcherCode` (impl)).
*   **Granularity**: Cohesive Capability (not just Atomic).

### Entity & ValueObject Exception
*   **Rule**: Domain Entities and Value Objects (which represent state rather than interchangeable behavior) generally **DO NOT** require an `I` interface, unless polymorphism is explicitly required by the domain.
*   **Reason**: Entities are often final/sealed and do not benefit from interface decoupling in the same way services do.

### Documentation (The "Semantics")
The `interface` keyword only defines the signature. You MUST define the semantics.
*   **Rule**: XML Documentation or clear comments MUST explain:
    *   **What** it does (not how).
    *   **Side Effects** (e.g., "Writes to DB", "Sends Email").
    *   **Constraints** (e.g., "Throws if ID not found", "Returns cached result").

```csharp
/// <summary>
/// Persists the job state.
/// Constraint: Throws DbException if connection fails.
/// Constraint: Idempotent - repeated calls with same job have no effect.
/// </summary>
void Save(Job job);
```

### Interface Segregation (ISP)
Clients should not be forced to depend on methods they do not use.

```csharp
// BAD: Fat Interface
interface ISmartDevice {
    void Print();
    void Scan();
    void Fax();
}

// GOOD: Segregated Interfaces
interface IPrinter { void Print(); }
interface IScanner { void Scan(); }
interface IFax { void Fax(); }

// Composition for convenience
interface IMultiFunctionDevice : IPrinter, IScanner, IFax { }
```

---

## Architectural Boundaries (Layering)

Physical layer structure: App / Infra / Domain
Dependency rule:
- App depends only on Domain abstractions
- Infra depends on Domain (and optionally App interfaces)
- Concrete implementations live in Infra
Think of these as **Boundaries**, not just folders.

### 1. Domain Boundary (`src/Domain`)
*   **Contains**: **Contracts** (Interfaces), Entities, Value Objects, Domain Errors.
*   **Dependencies**: ZERO dependencies on outer layers.
*   **Role**: Defines the "What" (Business Logic Contracts).

### 2. Infrastructure Boundary (`src/Infrastructure`)
*   **Contains**: Concrete implementations (Database access, API clients).
*   **Dependencies**: Depends on **Domain**.
*   **Role**: The "How" (Plumbing).

### 3. Application Boundary (`src/Application`)
*   **Contains**: Use Cases, Services, Orchestration.
*   **Dependencies**: Depends on **Domain**.
*   **Role**: High-level flow control.
*   **Boundary Rule**: MUST define its own Request/Response DTOs. NEVER expose Domain Entities directly to external boundaries (API/CLI).

### Type Placement Guidelines
| Type | Layer | Purpose |
| :--- | :--- | :--- |
| **Domain Entity/ValueObject** | Domain | Business rules, Invariants |
| **UseCase DTO (Request/Response)** | Application | Boundary data transfer, UI/API formatting |
| **Tech DTO (DbModel/ApiSchema)** | Infrastructure | Storage/Network serialization format |

**Rule**: Application Layer handles mapping between Domain Entities and Boundary DTOs. Infrastructure handles mapping between Domain Entities and Tech DTOs.

---

## Dependency Injection (DI)

### Connector Injection Only
All dependencies MUST be provided via the constructor.

```csharp
public class JobSyncService {
    private readonly IJobFetcher _fetcher;
    private readonly IJobStore _store;

    // Explicit dependencies
    public JobSyncService(IJobFetcher fetcher, IJobStore store) {
        _fetcher = fetcher;
        _store = store;
    }
}
```

*   **No Service Locator**: Do not use `Container.Resolve<T>()` inside classes.
*   **Volatile Dependencies**: Do not instantiate volatile dependencies (IO, Config, Random, Time) with `new`. Use DI.
*   **Stable Dependencies**: You MAY use `new` for Value Objects, Entities, and Pure Utility classes.

### Entity Dependency Constraint
*   **Rule**: Domain Entities and Value Objects **MUST NOT** have dependencies injected via constructor. They must remain pure.
*   **Method Injection**: If an entity needs a service (e.g., for calculation), pass it as a **Method Argument**.

---

## Error Handling Strategy

Distinguish between "Expected Business Logic Deviations" and "System Failures".

### Pattern A: Result Pattern (Preferred for Logic)
Use when the caller needs to handle simple failure cases (e.g., "Not Found", "Validation Failed") explicitly.

**Constraint: Use Existing Types**
*   **MUST** use the project's standard `Result<T, E>`, `Either`, or `Outcome` type.
*   **PROHIBITED**: Do **NOT** define a new `Result` or `Outcome` class/type in the code. Assume one exists in the project's core utilities.
*   **PROHIBITED**: Do **NOT** use `boolean` (success/fail) or `null` to indicate business errors.
*   **PROHIBITED**: Do **NOT** rely on exceptions for control flow or expected business rules.
*   **Bootstrap Exception**: If the core types (`Result<T>`, etc.) do not exist in the project, you are **AUTHORIZED** to create a minimal implementation in the project's shared kernel/utilities following standard Result pattern practices.

**Conceptual Usage**:
1.  Check `result.IsSuccess` (or equivalent method).
2.  If Success, access `.Value`.
3.  If Failure, handle `.Error` explicitly.

### Pattern B: Panics / System Failures
Use when the system cannot recover gracefully (e.g., "Database Down", "Out of Memory", "Configuration Missing").
*   Let it crash or be caught by a top-level global handler.
*   Standard Exceptions are acceptable here.

---

## Data Model & Internal Implementation

**Principle**: The public contract is strict. The internal implementation is flexible.

### 1. Domain Modeling Strategy
Choose the sophistication of the model based on the complexity of the subdomain.

#### A. Rich Domain Model (Complex Logic)
**Use when**: The specific domain entity has complex invariants, state transitions, or business rules.
*   Entities contain both state and behavior.
*   Enforce invariants strictly within the entity.

```csharp
// Rich Model: Enforces rules (e.g., distinct items, max quantity)
public class Order {
    public List<LineItem> Items { get; private set; }
    public void AddItem(Product product, int quantity) { ... }
}
```

#### B. Anemic/Lightweight Model (Simple Logic)
**Use when**: The entity is primarily a data holder, or the logic is purely CRUD.
*   Entities are simple data carriers (Properties/Fields).
*   **Goal**: Simplify maintenance for simple data. Do not force behavior if none exists.

### 2. Internal Flexibility (Allowed)
Inside a boundary (e.g., inside a private method of a Service), you may use Anemic Models, Functional Pipelines, or raw data structures if it simplifies the implementation.

**Constraint**: These internal details MUST NOT leak out of the interface.

**Rule**: Keep internal paradigm consistent within a specifically cohesive module or file.

### 3. Entity Mutability Strategy

*   **Pattern A: Rich Mutable Model (Standard)**
    *   Methods modify internal state (e.g., `void AddItem(...)`).
    *   **Use Case**: Standard business objects where identity is constant, and state changes are granular updates.
    *   **Invariant**: The object MUST ensure it is always in a valid state after any method call.

*   **Pattern B: Type-Driven State Transitions (Recommended for Critical Flows)**
    *   Use when a state change fundamentally alters the capabilities or contract of the object.
    *   **Example**: `UnpaidOrder.Pay()` returns `PaidOrder` (which has a `Ship()` method, whereas `UnpaidOrder` does not).
    *   **Reason**: Enforces flow correctness at compile time and aligns with `DESIGN_PHILOSOPHY`.
    *   **Rule**: If chosen, it MUST be consistent for that specific entity lifecycle.


---

## Testing Strategy

Write tests against **Contracts** (Interfaces), not Implementations.

### Core Principles
1.  **Scope**:
    *   **Unit Tests**: Verify isolated logic (Domain Entities, Pure Functions).
    *   **Integration Tests**: Verify interaction between components (Services).
    *   **Contract Tests**: Verify that an implementation fulfills its Interface.
2.  **No Side Effects**: Tests MUST NOT modify global state or persist data outside their transaction/sandbox.
3.  **Black-Box**: Test the public contract (inputs/outputs). Do NOT test private methods or internal state.
4.  **Structure (AAA)**:
    *   **Arrange**: Setup inputs and mocks.
    *   **Act**: Invoke the unit under test.
    *   **Assert**: Verify the output or side-effect on the mock.

### Contract Verification (The Primary Validation)
**Rule**: The Contract Test IS the definition of correctness.

1.  **Define Contract Suite**: A test suite that runs against the mental model of the `Interface`.
2.  **Verify Implementations**: All concrete implementations (Mocks, Fakes, Real) MUST pass this suite.

```pseudocode
// Conceptual Contract Test
function test_save_persists_item(storeFactory) {
  store = storeFactory();
  item = new Item("id1");
  store.save(item);
  fetched = store.get("id1");
  assert(fetched == item);
}
```
