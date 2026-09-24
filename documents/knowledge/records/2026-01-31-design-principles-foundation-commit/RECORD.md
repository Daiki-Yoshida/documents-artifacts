# Source record: 2026-01-31-design-principles-foundation-commit

```yaml
record_type: "verbatim_external_source_snapshot"
source_kind: "Git commit message"
source_repository: "Daiki-Yoshida/design-principles"
source_commit: "9439fb1dea375d7665c546fc76923843597bbb88"
source_url: "https://github.com/Daiki-Yoshida/design-principles/commit/9439fb1dea375d7665c546fc76923843597bbb88"
source_author_date: "2026-01-31T21:42:51Z"
retrieved_date: "2026-09-24"
source_text_status: "GitHub APIで取得したcommit messageのsnapshot"
record_body_policy: "commit message本文は無加工。changed_filesはprovenance metadata。具体的なdiff内容をcommit message以上の意思決定として推測しない"
changed_files:
  - "AI_WORKFLOW.md"
  - "CODING_STANDARDS.md"
  - "DESIGN_PHILOSOPHY.md"
  - "README.md"
  - "documents/agents/AI_DOC_STRATEGY.md"
  - "documents/agents/PROGRAMMING_PARADIGM.md"
```

## Commit message原文

~~~~text
feat: 新しい設計原則とAIエージェントのドキュメント戦略を確立する。
~~~~

## GitHub API patch snapshot

この節は同commitについてGitHub APIが返したpatchを無加工で保存する。commit stateで何が変更されたかの証拠であり、チャットの提案・承認原文ではない。

### `AI_WORKFLOW.md`

~~~~diff
@@ -0,0 +1,69 @@
+# AI Agent Workflow - Operational Guidelines
+
+```yaml
+document_type: "daily_workflow"
+target_audience: "ai_agents"
+optimization: "process_consistency"
+language: "english"
+```
+
+## Core Thinking Process
+
+Before writing any code, the AI must establish a mental model of the solution.
+
+```yaml
+process_flow:
+  1_analysis: "Understand the Requirement & User Intent"
+  2_design: "Define Interfaces & Contracts (The 'What')"
+  3_approval: "Confirm Design with User"
+  4_implementation: "Implement Details (The 'How')"
+  5_verification: "Validate against Contracts"
+```
+
+---
+
+## Step 1: Interface-First Design
+
+**Rule**: Never start implementing logic until the Interfaces are defined.
+
+1.  **Draft Interfaces**: Propose the `interface` definitions first.
+    *   Focus on method signatures, return types (Result vs Task), and dependencies.
+    *   Do not write method bodies yet.
+2.  **Check Capability**: Ensure the interface represents a *Cohesive Capability* (from `DESIGN_PHILOSOPHY`).
+3.  **Propose to User**: Show the interface definition to the user.
+    *   *Self-Correction*: "Does this interface leak implementation details?"
+
+---
+
+## Step 2: Implementation
+
+Once interfaces are agreed upon (or if the task is trivial):
+
+1.  **Dependency Injection**:
+    *   Define the class with `I...` dependencies in the constructor.
+    *   Do not `new` up volatile dependencies.
+2.  **Internal Logic**:
+    *   Implement the logic behind the interface.
+    *   You are free to optimize internals (buffering, caching) as long as the interface contract holds.
+    *   Follow `CODING_STANDARDS` for Error Handling (Result vs Exception).
+
+---
+
+## Step 3: Verification
+
+1.  **Contract Compliance**:
+    *   Does the implementation strictly adhere to the Interface contract?
+    *   Does it pass the Contract Tests (if applicable)?
+2.  **Constraint Check**:
+    *   did I introduce any illegal states? (Type-Driven Design check)
+    *   did I leak domain entities to the boundary? (Layer check)
+
+---
+
+## Special Instructions
+
+### Handling "How to Approach" Questions
+When the user asks "How should I do this?", do NOT jump to code.
+1.  Explain multiple approaches (Option A vs Option B).
+2.  Compare trade-offs (Complexity vs Performance vs Maintainability).
+3.  Recommend one based on `DESIGN_PHILOSOPHY`.
~~~~

### `CODING_STANDARDS.md`

~~~~diff
@@ -0,0 +1,206 @@
+# Coding Standards & patterns - AI Agent Reference
+
+```yaml
+document_type: "coding_standards"
+target_audience: "ai_agents"
+language_context: "C#"
+secondary_context: "TypeScript"
+optimization: "implementation_accuracy"
+```
+
+## Interface Design Rules
+
+Interfaces are the backbone of our architecture.
+
+### Naming & Granularity
+*   **Prefix**: MUST use `I` prefix (e.g., `IJobFetcher`).
+*   **Granularity**: Cohesive Capability (not just Atomic)
+    *   *Rule*: Group methods that change together for the same business reason.
+    *   *Bad*: `IUserManager` (Create, Read, Update, Delete, Notify, Log) - Mixed concerns.
+    *   *Bad*: `IUserCreator`, `IUserUpdater`, `IUserDeleter` - Fragmented cohesion (anti-pattern: "method-as-service").
+    *   *Good*: `IUserRepository` (CRUD), `IUserNotifier` (Notification).
+
+### Interface Segregation (ISP)
+Clients should not be forced to depend on methods they do not use.
+
+```csharp
+// BAD: Fat Interface
+interface ISmartDevice {
+    void Print();
+    void Scan();
+    void Fax();
+}
+
+// GOOD: Segregated Interfaces
+interface IPrinter { void Print(); }
+interface IScanner { void Scan(); }
+interface IFax { void Fax(); }
+
+// Composition for convenience
+interface IMultiFunctionDevice : IPrinter, IScanner, IFax { }
+```
+
+---
+
+## Layered Architecture
+
+Strict dependency flow: **App -> Infra -> Domain**.
+
+### 1. Domain Layer (`src/Domain`)
+*   **Contains**: Interfaces, Entities, Value Objects, Domain Errors.
+*   **Dependencies**: ZERO dependencies on outer layers (Infra/App).
+*   **Style**: Pure C# classes/interfaces.
+
+### 2. Infrastructure Layer (`src/Infrastructure`)
+*   **Contains**: Concrete implementations (Database access, API clients, File IO).
+*   **Dependencies**: Depends on **Domain**.
+*   **Role**: "How" technical details are executed.
+
+### 3. Application Layer (`src/Application`)
+*   **Contains**: Use Cases, Services, Orchestration.
+*   **Dependencies**: Depends on **Domain** interfaces.
+*   **Role**: High-level flow control. Receives concrete Infra implementations via DI.
+*   **Boundary Rule**: MUST define its own Request/Response DTOs. NEVER expose Domain Entities directly to external boundaries (API/CLI).
+
+### Type Placement Guidelines
+| Type | Layer | Purpose |
+| :--- | :--- | :--- |
+| **Domain Entity/ValueObject** | Domain | Business rules, Invariants |
+| **UseCase DTO (Request/Response)** | Application | Boundary data transfer, UI/API formatting |
+| **Tech DTO (DbModel/ApiSchema)** | Infrastructure | Storage/Network serialization format |
+
+**Rule**: Application Layer handles mapping between Domain Entities and Boundary DTOs. Infrastructure handles mapping between Domain Entities and Tech DTOs.
+
+---
+
+## Dependency Injection (DI)
+
+### Connector Injection Only
+All dependencies MUST be provided via the constructor.
+
+```csharp
+public class JobSyncService {
+    private readonly IJobFetcher _fetcher;
+    private readonly IJobStore _store;
+
+    // Explicit dependencies
+    public JobSyncService(IJobFetcher fetcher, IJobStore store) {
+        _fetcher = fetcher;
+        _store = store;
+    }
+}
+```
+
+*   **No Service Locator**: Do not use `Container.Resolve<T>()` inside classes.
+*   **Volatile Dependencies**: Do not instantiate volatile dependencies (IO, Config, Random, Time) with `new`. Use DI.
+*   **Stable Dependencies**: You MAY use `new` for Value Objects, Entities, and Pure Utility classes.
+
+---
+
+## Error Handling Strategy
+
+Distinguish between "Expected Business Logic Deviations" and "System Failures".
+
+### Pattern A: Result Pattern (Preferred for Logic)
+Use when the caller needs to handle simple failure cases (e.g., "Not Found", "Validation Failed") explicitly.
+
+**Constraint**: The Error type `E` MUST be a discriminated union or enum. It MUST NOT be a string or primitive exception.
+**Constraint**: The Error type `E` MUST NOT contain UI text, localization, or log strings. It serves logic branching only.
+
+```csharp
+// E is a specific Enum or Discriminated Union
+public enum UserError { NotFound, AlreadyExists, InvalidEmail }
+
+```csharp
+// Return a Result<T, E> type
+public async Task<Result<User, UserError>> FindUserAsync(UserId id);
+
+// Usage
+var result = await repo.FindUserAsync(id);
+if (result.IsSuccess) {
+    HandleUser(result.Value);
+} else {
+    HandleError(result.Error); // Explicit branching
+}
+```
+
+### Pattern B: Exceptions (Preferred for Infrastructure/Panics)
+Use when the system cannot recover gracefully (e.g., "Database Down", "Out of Memory", "Configuration Missing").
+*   Let it crash or be caught by a top-level global handler.
+*   Do not use exceptions for control flow.
+
+---
+
+## Data Model Patterns
+
+### 1. Rich Domain Model (Default)
+Entities contain both state and behavior.
+
+```csharp
+public class Order {
+    public List<LineItem> Items { get; private set; }
+    public bool IsPaid { get; private set; }
+
+    // Behavior encapsulates state mutation
+    public void AddItem(Product product, int quantity) {
+        if (IsPaid) throw new InvalidOperationException("Cannot modify paid order");
+        Items.Add(new LineItem(product, quantity));
+    }
+}
+```
+
+### 2. Anemic Model + Service (Alternative)
+Use ONLY when logic relies heavily on creating external dependencies that don't belong in the entity.
+*   *Entity*: Pure data structure (POCO).
+*   *Service*: Contains the logic.
+
+---
+
+## Testing Strategy
+
+Write tests against **Interfaces**, not Implementations.
+
+1.  **Mocking**: specific scenarios can be tested by injecting Mocks that implement domain interfaces.
+2.  **No Logic in Mocks**: Mocks should return fixed data.
+3.  **Test the Use Case**: Validate the orchestration logic in the Application layer.
+
+```csharp
+[Fact]
+public async Task Sync_ShouldStoreJobs_WhenFetcherReturnsJobs() {
+    // Arrange
+    var mockFetcher = new Mock<IJobFetcher>();
+    mockFetcher.Setup(f => f.FetchAsync()).ReturnsAsync(new[] { new Job("Job1") });
+    
+    var mockStore = new Mock<IJobStore>();
+    
+    var service = new JobSyncService(mockFetcher.Object, mockStore.Object);
+
+    // Act
+    await service.SyncAsync();
+
+    // Assert
+    mockStore.Verify(s => s.SaveAsync(It.Is<Job>(j => j.Title == "Job1")), Times.Once);
+}
+```
+
+### Contract Testing (Required for Interfaces)
+To prevent "MockDrift" (where mocks pass but real impl fails), every Domain Interface MUST have a Contract Test Suite.
+
+1.  **Define Contract**: A test suite that runs against `TInterface`.
+2.  **Verify Implementations**: All concrete implementations (Infra) MUST pass this suite.
+
+```csharp
+// The Contract (Abstract Test)
+public abstract class JobStoreContractTests {
+    protected abstract IJobStore CreateStore();
+
+    [Fact]
+    public async Task Save_ShouldPersistJob() {
+        var store = CreateStore();
+        var job = new Job("J1");
+        await store.SaveAsync(job);
+        var fetched = await store.GetAsync("J1");
+        Assert.NotNull(fetched); // All impls must pass this behavior
+    }
+}
+```
~~~~

### `DESIGN_PHILOSOPHY.md`

~~~~diff
@@ -0,0 +1,145 @@
+# Design Philosophy - AI Agent Reference
+
+```yaml
+document_type: "design_philosophy"
+target_audience: "ai_agents"
+optimization: "token_efficiency"
+language: "english"
+base_paradigm: "OOP"
+core_value: "robustness_and_maintainability"
+```
+
+## Core Philosophy: Interface-Driven Decoupling
+
+The foundational principle of this project is strict decoupling through interfaces.
+
+```yaml
+principle: "Interface-Driven Decoupling"
+definition: "Modules must depend ONLY on abstract interfaces, never on concrete implementations."
+rationale: |
+  Enables parallel development, isolated testing, and flexible behavior replacement.
+  In C# terms, this means relying on `interface` definitions, not `class` types for dependencies.
+```
+
+### The "Why" of Interfaces
+
+1.  **Contract First**: Interfaces define the *capabilities* (what), not the *methods* (how).
+2.  **Dependency Inversion**: High-level policies (Domain) should not depend on low-level details (Infrastructure). Both should depend on abstractions.
+3.  **Testability**: Interfaces allow trivially creating Mocks/Stubs without complex frameworks.
+
+---
+
+## Responsibility-Driven Design
+
+We adhere to the Single Responsibility Principle (SRP) to minimize the impact of changes.
+
+```yaml
+single_responsibility:
+  principle: "A component should have one, and only one, reason to change."
+  interpretation: "Focus on 'Cohesive Capability' rather than just 'Single Function'."
+  granularity: "Cohesive Unit (not necessarily Atomic)"
+  validation:
+    - "Can I describe the class's responsibility in one simple sentence?"
+    - "Does 'AND' appear in the description? If so, split it."
+    - "Do these methods change together for the same business reason?"
+
+```
+
+### Responsibility Types
+| Type | Description | Example (Conceptual) |
+| :--- | :--- | :--- |
+| **Functional** | Business logic, calculations | `TaxCalculator` |
+| **Technical** | IO, Networking, Formatting | `JsonSerializer` |
+| **Orchestration** | Coordinating flow, wiring | `OrderProcessingUseCase` |
+
+**Rule**: Do not mix these responsibilities in a single class.
+
+---
+
+## Composition Over Inheritance
+
+We favor object composition to achieve polymorphic behavior and code reuse.
+
+```yaml
+inheritance_policy:
+  status: "Restricted"
+  allowed_usage:
+    - "Interface inheritance (composition of capabilities)"
+    - "Framework/Library specification (e.g., Unity MonoBehaviour, Template Method Pattern)"
+  prohibited_usage:
+    - "Pure code reuse (DRY) without defining a strict 'is-a' specification"
+  reason: "Inheritance creates strong coupling. It should be used only when enforcing a strict contract or framework behavior."
+```
+
+### The Composition Approach
+Instead of:
+`class Derived : Base` (inheriting behavior)
+
+Use:
+`class Component(IDependency dependency)` (delegating behavior)
+
+*   **State**: Held by the encapsulating object.
+*   **Behavior**: Delegated to injected interface components.
+*   **Flexibility**: Behavior can be changed at runtime by injecting different implementations.
+
+---
+
+## Reliability & Safety
+
+### Fail Fast
+Detect anomalies immediately. Do not allow invalid state to propagate.
+
+```yaml
+fail_fast_strategy:
+  1_construction: "Validate arguments in constructors. An object must never exist in an invalid state."
+  2_boundary: "Validate external inputs at the system boundary (API/UI Entry)."
+  3_invocation: "Check invariants before complex operations."
+
+### Type-Driven State Design
+Make illegal states unrepresentable. Do not rely on boolean flags + exceptions for critical state transitions.
+
+```yaml
+type_driven_policy:
+  principle: "Use distinct types to represent distinct states."
+  goal: "Eliminate runtime state checks by enforcing compile-time type constraints."
+  example:
+    bad: "Order.IsPaid (bool) -> Order.ProcessShipping() throws if false"
+    good: "UnpaidOrder -> pay() -> PaidOrder -> ship()"
+  rule: "If a method is valid only in a specific state, that method must belong ONLY to the type representing that state."
+```
+
+```
+
+### Environment Protection (Side-Effect Control)
+Explicitly manage how the software interacts with the outside world.
+
+```yaml
+environment_protection:
+  principle: "Minimize and isolate side effects."
+  guidelines:
+    explicit_permissions: "Destructive operations should need explicit enablement (e.g., config flags)."
+    isolation: "Use temporary resources or sandboxes by default."
+    safety_first: "Prefer safety mechanisms (dry-run, confirmations) over convenience."
+    raii: "Use `IDisposable` (using statements in C#) to guarantee resource cleanup."
+```
+
+---
+
+## Appropriate Complexity
+
+Accept necessary complexity (domain logic) but ruthlessly eliminate accidental complexity (bad engineering).
+
+*   **YAGNI**: do not implement features "just in case".
+*   **Abstraction**: Abstractions should simplify the problem, not obscure it. If an abstraction makes the code harder to follow without providing flexibility, remove it.
+
+## Performance vs. Abstraction Policy
+
+Performance optimization must not degrade interface abstraction.
+
+```yaml
+performance_policy:
+  interface_layer: "Strictly Abstract. Do NOT warp signatures for performance."
+  implementation_layer: "Optimize Freely. Use internal buffering, caching, or unmanaged code if needed."
+  cost_acceptance: "The overhead of the interface boundary (boxing, virtual calls) is an accepted cost."
+  rule: "Optimize BEHIND the interface. Never expose optimization complexity (like manual buffer management) in the domain API."
+```
~~~~
