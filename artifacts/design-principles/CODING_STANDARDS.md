# Coding Standards & patterns - AI Agent Reference

```yaml
document_type: "coding_standards"
target_audience: "ai_agents"
language: "english"
language_context: "Language-Agnostic, optimized for statically typed interface-capable ecosystems"
primary_ecosystems:
  - "C#"
  - "TypeScript"
  - "Kotlin"
optimization: "implementation_accuracy"
```

This guideline assumes a statically typed, interface-capable language.
It is intentionally close to C#, TypeScript, Kotlin, and similar ecosystems.
For other languages, map `interface` to the nearest contract mechanism: protocol, trait, abstract base class, type class, or tested structural contract.
Language-specific idioms and compiler constraints take precedence over example syntax.

## Interface Design Rules

Interfaces are the backbone of our architecture — **at boundaries**. Apply them where they earn their keep, not everywhere.

### Interface Requirement Threshold
**Behavioral Boundary Components** (services, repositories, managers, adapters, use-case ports) **MUST define or reuse a project-owned contract** (`interface`). Define one when ANY of these holds:
*   It is **public** or **shared across modules**.
*   It is **DI-injected**, or is a **volatile dependency** (IO, DB, network, filesystem, clock, randomness — see DI rules).
*   It **protects Domain/Application from Infrastructure** (crosses a layer boundary).
*   It must be **replaceable / test-substitutable / runtime-swappable**.

**Do NOT require an `interface` for:**
*   `private`/`internal` helper classes that cross no boundary.
*   Single-implementation logic forming no boundary (e.g., pure internal computation, a one-off internal use case).
*   Short-lived prototypes / spikes.

**Rule (YAGNI)**: Be interface-first **at architectural boundaries**, but do NOT create meaningless interfaces for tiny internal helpers. Prefer a concrete class first; extract a contract when a real boundary, a genuine second implementation, or a volatile dependency appears. (Per **Mistake Prevention Priority** in `DESIGN_PHILOSOPHY.md`, over-engineering ranks *below* boundary/dependency discipline — do not overcorrect into zero interfaces.) This mirrors the **Entity & ValueObject Exception** below: an interface decouples boundaries, it is not a default wrapper.

**Timing guards**: harden a boundary only when its responsibility is **stable** and the seam is **cheap** — criteria: `DESIGN_PHILOSOPHY.md` → "Encapsulation Horizon".

**Module-local vs public/cross-module**:
*   **Module-local** interface: welcome **even with a single implementation** when it clarifies the module's internal world or expresses a cohesive capability. Being interface-friendly here is fine.
*   **Public / cross-module** interface: design more carefully as a **stable contract** — it is a published boundary.

**Good reasons** for an interface: caller-facing capability, module shell, volatile dependency, DI/test substitution, external-dependency isolation, a meaningful internal role, plausible future replacement, useful contract tests.
**Bad reasons** (avoid): "every class needs one" by habit; `IUserService` exists only because `UserService` exists; no semantic documentation; name differs from the implementation only by an `I` prefix; no boundary or substitution value.

### Concept Generality (consumer-neutral modeling)

The one-sentence responsibility test from `DESIGN_PHILOSOPHY.md` → "Concept Altitude" is a **signal for neutrality**, not proof that several contexts share one semantic concept.

```yaml
neutrality_rule: "If the responsibility does not require the first consumer's feature name, keep naming and types consumer-neutral from day one."
semantic_identity_check:
  - "Invariants: must the same conditions always hold?"
  - "Pre/postconditions: does success establish the same state/guarantees?"
  - "Failure semantics: do the same kinds of failure mean the same thing?"
  - "Lifecycle/state transitions: does the concept move through equivalent states for equivalent reasons?"
  - "Reason to change: would the candidate concepts evolve for the same business reason?"
identity_rule: "Treat multiple consumers as one general contract only when their shared meaning survives the semantic-identity check. Similar names or a generalized sentence are insufficient."
unknown_rule: "If semantic identity is not yet evidenced, keep a consumer-neutral LOCAL model. Do not declare a broad shared abstraction merely to anticipate reuse."
```

*   **Naming**: name the local concept by what it IS (`Stairs`, `ItemGenerator`), NOT by its first consumer (`DungeonStairs`, `DungeonItemGenerator`) — unless the behavior is genuinely feature-specific.
*   **Types**: the concept's contract and types MUST NOT import or reference the consuming feature's types unless that feature-specific meaning is part of the concept itself.
*   **Feature policy**: feature-specific variation enters through the concept's contract (an implementation, composition, or parameters) and is OWNED by the feature.
*   **Placement (YAGNI intact)**: neutral meaning does **not** imply shared placement. Keep the concept local until another consumer genuinely needs the same semantics and promotion is earned (`PROJECT_STRUCTURE.md` → Shared Kernel).

### Naming & Granularity
*   **Prefix**: **MUST** follow the specific language's standard idiom.
    *   **CRITICAL RULE**: The constraints of the specific programming language ALWAYS take precedence over the examples provided here.
    *   *C#*: Use `I` prefix (e.g., `IJobFetcher`).
    *   *TypeScript/Kotlin*: Do NOT use `I` prefix. Use descriptive names (e.g., `JobFetcher` (interface) vs `HttpJobFetcher` (impl)).
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
    *   **Resource / Performance bounds** *(when load-bearing)*: complexity, memory, connection/time limits the caller may rely on — a contained internal blow-up still exhausts shared resources, so this is part of the contract.
    *   **Determinism & Ordering** *(when relied upon)*: deterministic vs best-effort results, result ordering, repeatability — internal parallelism/optimization MUST NOT silently break these.

**Document only load-bearing semantics** — what a caller may rely on, what constrains the implementation, or what is not obvious from the signature. Do NOT restate the method name, narrate implementation, or add meaningless guesses (e.g. "Returns the user. Side effects: none. Performance: O(1)."). Noise is not a contract.

```csharp
/// <summary>
/// Persists the job state.
/// Constraint: Throws JobStoreUnavailable if persistence is unavailable; the infrastructure cause remains internal.
/// Constraint: Idempotent - repeated calls with same job have no effect.
/// </summary>
void Save(Job job);
```

```typescript
/**
 * Persists the job state.
 * Constraint: Throws JobStoreUnavailable if persistence is unavailable; the infrastructure cause remains internal.
 * Constraint: Idempotent — repeated calls with the same job have no effect.
 */
save(job: Job): void;
```

### Interface Segregation (ISP)
Clients should not be forced to depend on methods they do not use. Split a fat interface by **caller-facing capability** (`Printer` / `Scanner` / `Fax` instead of one `SmartDevice`; compose them into a `MultiFunctionDevice` where convenient). A client that only prints depends only on `Printer`.

---

## Contract Evolution & Versioning

Priority #2 (External Interface Stability) requires disciplined evolution.

**Additive describes change shape; compatibility describes impact. They are not the same thing.** Adding a required member to an interface may leave callers unchanged while breaking every existing implementation or fake.

```yaml
compatibility_definition: "An evolution is backward-compatible only when existing contract participants can continue without mandatory changes and previously valid interactions retain their guarantees."
participants:
  consumer_side: "Existing callers/clients can keep using the contract without mandatory changes and with prior guarantees preserved."
  provider_side: "Existing implementations/adapters/fakes can keep satisfying the contract without mandatory changes."
dimensions: "Check only dimensions relevant to the contract medium — e.g. source/binary compatibility, wire/schema compatibility, or persisted-data compatibility."

evolution_policy:
  default: "Prefer additive evolution because it is often easier to keep compatible, but NEVER infer compatibility from additivity alone."
  compatible_public_change: "May use the L2 compatible-public-evolution path in AI_WORKFLOW.md when consumers, providers, and prior guarantees are preserved."
  published_breaking_change: "If an existing published participant must change or a previous guarantee becomes invalid, treat the evolution as breaking even when syntax is additive; use the L3 Contract Confirmation Gate."
  local_breaking_change: "A contained module-local contract may evolve with its owned participants inside the requested scope; classify by actual blast radius rather than mechanically escalating every local break to L3."
  deprecation:
    step_1: "Mark the old contract deprecated; keep it working."
    step_2: "Provide a replacement plus a migration note in the Semantics."
    step_3: "Remove only after consumers migrate (or at an agreed major version)."
  ports: "Application Ports evolve with their use case; version the port, not the Domain."
  internal_split: "An internal maturation-split (promoting a sub-responsibility to its own hardened unit) MUST preserve the published OUTER contract — add inner boundaries, do not break the outer one. An unavoidable outer break signals a mis-drawn original responsibility; route it through the Confirmation Gate."
rule: "A changed Semantics is a breaking change even if the Signature is identical. Never silently alter the observable behavior of a published contract."
```

---

## Performance-Shaped Contracts

Performance requirements belong in a contract only when they are **load-bearing and caller-visible**. Do not redesign an API from intuition alone.

```yaml
performance_contract_policy:
  requirement_gate:
    stated_requirement: "A user/product/system latency, throughput, memory, work, or backpressure budget is a legitimate contract requirement."
    evidence_to_redesign: "Before changing an existing interaction shape, show that the current shape is the limiting constraint using representative measurement when practical or a defensible structural lower bound."
    insufficient: "Speculation, micro-optimization preference, or 'batching is usually faster' is not enough."
  sequence:
    1: "State the required bound and representative workload/conditions."
    2: "Try implementation-only optimization while preserving the current contract."
    3: "If the interaction shape itself prevents the bound, redesign only that shape."
    4: "Re-check semantic capability, ownership, failure semantics, and compatibility."
    5: "Verify the resulting contract against the required bound."
  allowed_contract_shapes:
    - "batch operations when per-item boundary crossings dominate the required bound"
    - "streaming when full materialization violates latency/memory bounds or incremental consumption is required"
    - "pagination when result cardinality must be bounded across a remote/public boundary"
    - "async/cancellation/backpressure when waiting, cancellation, or producer/consumer rate is caller-visible"
  abstraction_guard: "Expose the interaction semantics needed by callers, not implementation tactics such as cache layout, pool internals, arbitrary buffer ownership, or vendor-specific optimization details."
```

### Contract medium and blast radius

* **Module-local/internal port**: if all participants are owned by the requested task, a shape change may be an L1 contained evolution. Keep the outer published module contract stable when possible.
* **Published in-process/library API**: apply `Contract Evolution & Versioning`. A compatible added batch/stream capability can be L2; changing/removing the existing required interaction is L3 unless the migration is explicitly agreed.
* **Cross-runtime / wire protocol**: treat pagination tokens, stream framing, request batching, ordering, retry/idempotency, and backpressure behavior as wire semantics. Check rollout/schema compatibility and mixed-version operation where relevant.
* **Persistent-data-facing contract**: if the performance redesign changes stored representation or migration requirements, classify the data change separately through the normal persistence compatibility gate.

### Verification

If performance drove the contract shape, verification MUST include the stated bound under a representative workload or an equivalent deterministic bound check. A faster microbenchmark that does not model the required workload is not sufficient evidence.

---

## Architectural Boundaries (Layering)

**The primary boundary is the feature/module; layers live inside each module.** (Principle/why: `DESIGN_PHILOSOPHY.md` → "Module — The Primary Boundary".) Organize by feature first, then by layer:

```text
src/
  coupon/                 # feature module = primary boundary
    domain/
    application/
    infrastructure/
    ui/
  billing/
    domain/ application/ infrastructure/ ui/
```

Small modules may stay flat and evolve later:

```text
coupon/
  CouponService  CouponRepository  CouponDto  CouponMapper
```

Within each module the same dependency rule holds:
- Domain depends on nothing outside itself.
- Application depends on Domain.
- Infrastructure depends on Domain and may depend on Application-owned ports when implementing use-case-specific integrations.
- Concrete implementations live in Infrastructure.
- UI depends inward on Application/Domain; never the reverse.

Think of these as **Boundaries**, not just folders. Do NOT make the technical layer the top-level organizing principle. (Module public surface / default-internal, shared-kernel placement, and multi-runtime/monorepo topology live in `PROJECT_STRUCTURE.md`.)

### Contract Placement Rule
Place contracts at the boundary that owns the reason for their existence.

| Contract Type | Owner | Example |
| :--- | :--- | :--- |
| **Domain Contract** | Domain | Business capability required by domain rules, domain policy, domain error semantics |
| **Application Port** | Application | Storage, email, clock, external API, queue, or other integration needed to execute a use case |
| **Infrastructure Implementation** | Infrastructure | Database repository, HTTP client, filesystem adapter, message queue adapter |

**Rule**: Do not put every interface into Domain by default. Domain owns business contracts. Application owns use-case orchestration ports. Infrastructure implements both without leaking technical details outward.

### 1. Domain Boundary (`<module>/domain`)
*   **Contains**: **Contracts** (Interfaces), Entities, Value Objects, Domain Errors.
*   **Dependencies**: ZERO dependencies on outer layers.
*   **Role**: Defines the "What" for business concepts, invariants, and domain-level policies.

### 2. Infrastructure Boundary (`<module>/infrastructure`)
*   **Contains**: Concrete implementations (Database access, API clients).
*   **Dependencies**: Depends on **Domain** and, when necessary, **Application** ports.
*   **Role**: The "How" (Plumbing).

### 3. Application Boundary (`<module>/application`)
*   **Contains**: Use Cases, Application Services, Orchestration, Application-owned Ports.
*   **Dependencies**: Depends on **Domain**.
*   **Role**: Orchestration boundary — high-level flow control, NOT a place to dump business logic.
*   **UseCase responsibilities**: coordinate flow; call Domain behavior; call project-owned ports; handle authorization & transactions when appropriate; map Application Request/Response DTOs ↔ Domain models; translate expected failures into Result errors; keep Infrastructure details out.
*   **Boundary Rule**: MUST define its own Request/Response DTOs. NEVER expose Domain Entities directly to external boundaries (API/CLI).
*   **Placement Rule**: True business rules → Domain. Orchestration, boundary coordination, DTO mapping, transaction flow, and port calls → Application. UseCases MAY hold application-specific policy but MUST NOT replace Domain modeling.
*   **Ownership Rule (coordinate ≠ own)**: A UseCase MAY *coordinate* Functional & Technical responsibilities — call `Order.confirm()`, call a `PaymentPort`, run a transaction, map DTOs — but MUST NOT *own* their internals: no payment-provider HTTP details, no domain invariants that belong in Domain, no large email-formatting logic, no infrastructure exception types.

### State Ownership & Cross-Boundary Consistency

Boundary separation must not orphan ownership of mutable state or the responsibility for a multi-step business outcome.

```yaml
state_ownership:
  rule: "Each mutable business state has one clear owning boundary."
  mutation: "Other boundaries request changes through the owner's contract; they MUST NOT directly mutate another owner's internal state."

cross_state_outcome:
  rule: "When one business outcome spans multiple state owners, assign one orchestration boundary to own the coordination and failure policy."
  limitation: "The orchestrator owns the outcome/flow, NOT the participants' internal invariants or storage details."

consistency_model:
  question: "What must be true when one step succeeds and another fails?"
  atomic: "Use one transaction when the required consistency and topology genuinely support it."
  non_atomic: "When atomicity is unavailable or undesirable, make retry, idempotency, compensation, or an explicit intermediate/failure state part of the coordination design."

boundary_rule: "A cross-boundary invariant does NOT automatically require merging boundaries. It DOES require an explicit consistency model and failure owner. Reconsider the split when coordination becomes chatty, mutable state is shared, or both sides repeatedly change together."
```

Example: a purchase may coordinate `Wallet.debit()` and `Inventory.grant()` while Wallet still owns balance invariants and Inventory still owns item-ownership invariants. The Purchase use case owns what to do if one succeeds and the other fails; it does not reach into either module's state directly.

### 4. UI Boundary (`<module>/ui`)
*   **Contains**: UI components/pages, view models, presentation logic, input formatting.
*   **Dependencies**: Depends inward on **Application** (and Domain types only as exposed via Application). NEVER the reverse — UI/presentation types MUST NOT flow inward.
*   **Role**: Render state and capture intent; translate Application responses ↔ UI ViewModels.
*   **Applicability**: This in-module `ui/` placement assumes a **single-runtime** topology. When the UI is a **separate deployable/runtime** (e.g., SPA + API), it is its own bounded context — see `PROJECT_STRUCTURE.md` → "Runtime Topology".

### Type Placement Guidelines
| Type | Layer | Purpose |
| :--- | :--- | :--- |
| **Domain Entity/ValueObject** | Domain | Business rules, Invariants |
| **UseCase DTO (Request/Response)** | Application | Boundary data transfer, UI/API formatting |
| **Tech DTO (DbModel/ApiSchema)** | Infrastructure | Storage/Network serialization format |
| **ViewModel / Presentation Model** | UI | UI-shaped state; never referenced inward |

**Rule**: Application Layer handles mapping between Domain Entities and Boundary DTOs. Infrastructure handles mapping between Domain Entities and Tech DTOs.

---

## External Dependency Boundary Policy

External dependencies are allowed, but their influence must be **contained**. Domain and core Model code depend on **project-owned** types/contracts — not on external SDKs, framework models, DB schemas, HTTP clients, UI framework types, vendor abstractions, or external API DTOs. (Principle/why: `DESIGN_PHILOSOPHY.md` → External Dependency Containment.)

**The project owns the core language**: external libraries may *implement* capabilities, but they MUST NOT *define* the domain vocabulary.

**Wrap / adapt** (interface, adapter, facade, anti-corruption layer, or project-owned DTO) when ANY holds:
*   The dependency appears in Domain or core Model code.
*   Its types would spread across multiple modules.
*   Replacing it would force changes in many unrelated places.
*   It forces domain terminology to follow vendor terminology.
*   It pushes technical errors, lifecycle, async, or side effects into business logic.
*   Multiple modules start depending on the same external API directly.
*   A **widely-depended-on module** relies on the dependency → wrap it **earlier**.
*   The dependency **touches a core domain concept** → wrap it **from the start**.

**Direct dependency is acceptable** when:
*   The code is **UI-specific** and stays inside the UI boundary.
*   The code is **Infrastructure-specific** (that is its role).
*   The dependency is local to a small internal implementation and does not leak through a public contract.
*   The module is intentionally a thin integration module.

**Prohibited:**
*   Exposing external SDK types from Domain contracts.
*   Using DB/API DTOs as Domain Entities.
*   Letting one external module become the implicit shared model of the whole system.
*   Making most modules depend directly on the same vendor API when a project-owned abstraction would localize the change.

**UI & Infrastructure scope**: UI may depend on UI frameworks/platform types, and Infrastructure may depend on external SDKs/clients — that is their role. The rule is one-directional: **do NOT push UI or Infrastructure types inward** into Application or Domain.

If a Domain/Application concept needs an external capability, define a **project-owned port** at the owning boundary (Application owns use-case ports) and implement it in Infrastructure.

---

## Domain Purity Rules

Keep technical **mechanisms** out of Domain/Core; keep genuine **domain concepts** in, even if they involve time/names/colors/records. (Principle/why: `DESIGN_PHILOSOPHY.md` → "Domain Purity (Mechanism vs Concept)".)

**Almost never in Domain/Core**: DB/HTTP/filesystem I/O, external API DTOs, framework attributes/annotations, vendor SDK types, UI framework types.

**Contextual** (avoid as *direct* dependencies, but may be domain concepts): current time, randomness, settings, logging, display names, colors, textual labels.

| Case | Verdict |
| :--- | :--- |
| `DateTime.Now` inside an Entity | avoid — inject a `Clock` from Application |
| `ExpiresAt` as a domain value | valid domain concept |
| Entity directly using `Logger` | avoid |
| Domain event logged by an outer layer | acceptable |
| Audit log as a business requirement | may be a Domain/Application concept |
| Button color | UI concern |
| Rarity/team color, official/legal name | may be a Domain concept |
| i18n display text | usually UI/Application |

**Decision rule**: does the value exist **because of the UI/tech**, or **because of the domain itself**? Origin decides where it lives.

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

(Same shape in TypeScript/Kotlin: dependencies declared as constructor parameters/properties.)

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
*   **Bootstrap Exception**: If the core types (`Result<T>`, etc.) do not exist in the project, you are **AUTHORIZED** to create a minimal implementation in the project's shared kernel/utilities following standard Result pattern practices. This shared-kernel bootstrap is a utility, not a domain public contract, so it does NOT require the Contract Confirmation Gate.
*   **Library vs hand-rolled**: If the project already standardizes on a Result/Either library, reuse it — that IS the project's standard type. When bootstrapping from zero, prefer a minimal **project-owned** type: the shared kernel (T0 — see `PROJECT_STRUCTURE.md`) is depended on by everything, so adopting a vendor library there makes it a system-wide external dependency (see External Dependency Boundary Policy). Adopting a library at the kernel is an L2-level decision — do it only when clearly implied by the project's existing conventions, and report it.

**Conceptual Usage**:
1.  Check `result.IsSuccess` (or equivalent method).
2.  If Success, access `.Value`.
3.  If Failure, handle `.Error` explicitly.

### Pattern B: Panics / System Failures
Use when the system cannot recover gracefully (e.g., "Database Down", "Out of Memory", "Configuration Missing").
*   Let it crash or be caught by a top-level global handler.
*   Standard Exceptions are acceptable here.

### Error Boundary Translation
Errors MUST NOT leak technical details across an architectural boundary.

```yaml
boundary_translation:
  rule: "Infrastructure exceptions (DbException, HttpException, IOException) MUST be caught at the Infrastructure boundary and translated."
  outward_form: "Translate to a Domain/Application error (Result error or domain exception) that carries business meaning, not transport detail."
  prohibited: "Do NOT let a raw infrastructure exception propagate into Application or Domain code."
  preserve: "Keep the original as an inner cause for diagnostics; expose only the translated meaning."
```

```csharp
// Infrastructure adapter: translate a technical failure into a domain-meaningful Result
public Result<Job, JobError> Fetch(string id) {
    try {
        var dto = _http.Get(id);
        return Result.Ok(dto.ToDomain());
    } catch (HttpRequestException ex) {
        // Do not leak HttpRequestException outward
        return Result.Fail(JobError.SourceUnavailable(id, cause: ex));
    }
}
```

---

## Concurrency & Async Contracts

Concurrency is part of the contract, not an implementation detail.

```yaml
async_policy:
  signature: "If an operation is asynchronous, the contract MUST express it (Task / Promise / suspend). Do not hide async behind a sync facade."
  thread_safety: "State thread-safety in the Semantics: 'thread-safe', 'caller-confined', or 'single-threaded only'."
  cancellation: "Long-running or IO operations SHOULD accept a cancellation token/signal and honor it."
  domain_purity: "Threading and scheduling primitives MUST NOT leak into Domain contracts. Keep concurrency in Application/Infrastructure."
  shared_state: "Do not share mutable state across a boundary without explicit synchronization or immutability."
rule: "Never block on async (.Result/.Wait) across a boundary you do not own; propagate async to the edge."
```

---

## Data Model & Internal Implementation

**Principle**: The public contract is strict. The internal implementation is flexible.

### 1. Domain Modeling Strategy
Choose the sophistication of the model based on the complexity of the subdomain.

**Rule**: Whichever you choose, keep meaningful domain rules **inside the Domain** — do NOT let them leak into UI, Infrastructure, or unrelated services. "Lightweight" means little behavior, NOT business logic scattered across layers.

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

```typescript
// Rich Model: enforces rules (e.g., distinct items, max quantity)
class Order {
  private items: LineItem[] = [];
  addItem(product: Product, quantity: number): void { /* ... */ }
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

## Mapping & Conversion Policy

**Mapping is boundary translation.** Domain is something to be mapped *from/to*; it must not know outer representations.

**Strong rule**: Domain Entities / Value Objects **MUST NOT** expose `ToDto()`, `ToViewModel()`, `ToDbModel()`, or any external-schema conversion — that pulls Application/UI/Infrastructure knowledge inward.

**Placement**:
*   **Application** maps Domain ↔ UseCase Request/Response DTOs.
*   **Infrastructure** maps DB/API/filesystem models ↔ Domain (`ToDomain()` is acceptable **only if it stays inside Infrastructure**).
*   **UI** maps Application responses ↔ UI ViewModels when needed.

**Inline vs extract**:
*   Small one-off mappings MAY be inline in the owning UseCase/Adapter.
*   Reused / complex / semantically meaningful mappings SHOULD be extracted. Extension methods are fine **only** when defined in the owning boundary and do not make Domain depend outward.

**Naming**:
| Name | Role |
| :--- | :--- |
| `Mapper` | structural DTO ↔ Domain |
| `Converter` | value/type conversion (e.g., `string → Money`) |
| `Assembler` | builds a response from multiple sources |
| `Adapter` | wraps an external API/SDK behind a project-owned contract |
| `Translator` | translates external/vendor concepts into domain concepts |

---

## Testing Strategy

Write tests against **Contracts** (Interfaces), not Implementations.

> **Test file placement** (co-location, the contract-suite beside the port, fakes, e2e location) lives in `PROJECT_STRUCTURE.md` → "Test File Placement". This section owns the testing *strategy*.

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

### Test Priority by Boundary
Test the **most stable meaningful boundary**; do not test private details unless it materially improves confidence.
*   **Domain / Core**: prioritize correctness + unit tests.
*   **Public interfaces / ports**: prioritize contract tests.
*   **Infrastructure adapters**: integration/contract tests against the external boundary or a test double.
*   **Application UseCases**: test orchestration + expected-failure handling.
*   **UI**: test pragmatically; invest only when behavior is complex/critical.
*   **Internal private helpers**: test through the public/module contract unless the logic is complex & pure enough to justify direct tests.

### Contract Verification (Primary Validation of Contract Conformance)

**Rule**: The Contract Test defines **contract conformance** — whether an implementation satisfies the contract's Signature + Semantics + Constraints. It is not, by itself, proof that the user's end requirement is satisfied.

1.  **Define Contract Suite**: A test suite that runs against the mental model of the `Interface`.
2.  **Verify Implementations**: All concrete implementations (Mocks, Fakes, Real) MUST pass this suite.
3.  **Verify Requested Outcome Separately**: When the task's required outcome crosses composition, UI, runtime, or integration boundaries, verify that outcome through the narrowest meaningful path (`AI_WORKFLOW.md` → Step 3: Verification).

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