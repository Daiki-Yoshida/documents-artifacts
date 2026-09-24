# Source record: 2026-01-31-code-standards-refinement-commit

```yaml
record_type: "verbatim_external_source_snapshot"
source_kind: "Git commit message"
source_repository: "Daiki-Yoshida/design-principles"
source_commit: "bd5e3dfc30fdd38d9b8a62053ecb7717524d2d45"
source_url: "https://github.com/Daiki-Yoshida/design-principles/commit/bd5e3dfc30fdd38d9b8a62053ecb7717524d2d45"
source_author_date: "2026-01-31T22:26:11Z"
retrieved_date: "2026-09-24"
source_text_status: "GitHub APIで取得したcommit messageのsnapshot"
record_body_policy: "commit message本文は無加工。changed_filesはprovenance metadata。具体的なdiff内容をcommit message以上の意思決定として推測しない"
changed_files:
  - "AI_WORKFLOW.md"
  - "CODING_STANDARDS.md"
  - "DESIGN_PHILOSOPHY.md"
  - "README.md"
```

## Commit message原文

~~~~text
docs: Refine coding standards for interfaces, error handling, entity mutability, and testing, clarify OOP definition and bounded contracts, and archive a temporary document.
~~~~

## GitHub API patch snapshot

この節は同commitについてGitHub APIが返したpatchを無加工で保存する。commit stateで何が変更されたかの証拠であり、チャットの提案・承認原文ではない。

### `AI_WORKFLOW.md`

~~~~diff
@@ -26,25 +26,36 @@ process_flow:
 
 **Rule**: Never start implementing logic until the Bounded Contract is defined.
 
-1.  **Draft Contracts**: Define the `interface` and the behavioral rules.
-    *   Focus on consistency, explicit side-effects, and return types.
+**Distinguish the Component Type**:
+*   **Case A: Behavioral Component** (Services, Repositories, Managers)
+    *   **MUST** define an `interface`.
+    *   **focus**: The "Contract" is the interaction boundary.
+*   **Case B: Domain Model** (Entities, Value Objects)
+    *   **MUST NOT** define an `interface` (unless for polymorphism).
+    *   **focus**: The "Contract" is the Class State invariant & public Behavior.
+
+### Process
+1.  **Draft Contracts**:
+    *   **Behavioral**: Define `interface` + Semantics (What happens? Side effects?).
+    *   **Domain**: Define `class` + Invariants (What state is valid? How does it transition?).
 2.  **Check Boundary Stability**: Is this boundary clear? Does it leak implementation details?
 3.  **Propose to User**: Show the contract definition.
     *   *Self-Correction*: "Is this contract stable enough to hide future implementation changes?"
 
 ---
 
-## Step 2: Implementation (Paradigm-Agnostic)
+## Step 2: Implementation (The Shell & The Engine)
 
-Once contracts are declared:
+**Mental Model (Behavioral Components)**: The Class is the **Shell** (OOP) containing the **Engine** (Logic).
+**Mental Model (Domain Models)**: The Class **IS** the logic and state definition.
 
-1.  **Select Internal Paradigm**:
-    *   Choose the best tool for the job (e.g., Functional for transformations, State Machines for workflows, OOP for resource management).
-2.  **Dependency Injection**:
-    *   Inject dependencies via constructor to enforce the boundary.
-3.  **Internal Logic**:
-    *   Implement freely. Use internal buffers, raw arrays, or static methods if it helps performance/clarity.
-    *   **Constraint**: Never leak these choices through the boundary.
+1.  **Build the Shell** (For Behavioral Components):
+    *   Define the class implementing the interface.
+    *   Inject dependencies via constructor (The "Plugs" of the shell).
+2.  **Build the Engine**:
+    *   Implement the logic *inside* the shell.
+    *   Select Internal Paradigm: Functional, Procedural, Data-Oriented.
+    *   **Constraint**: The engine must satisfy the Shell's Contract (Signature + Semantics).
 
 ---
 
~~~~

### `CODING_STANDARDS.md`

~~~~diff
@@ -3,8 +3,9 @@
 ```yaml
 document_type: "coding_standards"
 target_audience: "ai_agents"
-language_context: "C#"
-secondary_context: "TypeScript"
+document_type: "coding_standards"
+target_audience: "ai_agents"
+language_context: "Language-Agnostic"
 optimization: "implementation_accuracy"
 ```
 
@@ -13,12 +14,28 @@ optimization: "implementation_accuracy"
 Interfaces are the backbone of our architecture.
 
 ### Naming & Granularity
-*   **Prefix**: MUST use `I` prefix (e.g., `IJobFetcher`).
-*   **Granularity**: Cohesive Capability (not just Atomic)
-    *   *Rule*: Group methods that change together for the same business reason.
-    *   *Bad*: `IUserManager` (Create, Read, Update, Delete, Notify, Log) - Mixed concerns.
-    *   *Bad*: `IUserCreator`, `IUserUpdater`, `IUserDeleter` - Fragmented cohesion (anti-pattern: "method-as-service").
-    *   *Good*: `IUserRepository` (CRUD), `IUserNotifier` (Notification).
+*   **Prefix**: MUST use `I` prefix (e.g., `IJobFetcher`) for architectural components.
+*   **Granularity**: Cohesive Capability (not just Atomic).
+
+### Entity & ValueObject Exception
+*   **Rule**: Domain Entities and Value Objects (which represent state rather than interchangeable behavior) generally **DO NOT** require an `I` interface, unless polymorphism is explicitly required by the domain.
+*   **Reason**: Entities are often final/sealed and do not benefit from interface decoupling in the same way services do.
+
+### Documentation (The "Semantics")
+The `interface` keyword only defines the signature. You MUST define the semantics.
+*   **Rule**: XML Documentation or clear comments MUST explain:
+    *   **What** it does (not how).
+    *   **Side Effects** (e.g., "Writes to DB", "Sends Email").
+    *   **Constraints** (e.g., "Throws if ID not found", "Returns cached result").
+
+```csharp
+/// <summary>
+/// Persists the job state.
+/// Constraint: Throws DbException if connection fails.
+/// Constraint: Idempotent - repeated calls with same job have no effect.
+/// </summary>
+void Save(Job job);
+```
 
 ### Interface Segregation (ISP)
 Clients should not be forced to depend on methods they do not use.
@@ -105,30 +122,21 @@ Distinguish between "Expected Business Logic Deviations" and "System Failures".
 ### Pattern A: Result Pattern (Preferred for Logic)
 Use when the caller needs to handle simple failure cases (e.g., "Not Found", "Validation Failed") explicitly.
 
-**Constraint**: The Error type `E` MUST be a discriminated union or enum. It MUST NOT be a string or primitive exception.
-**Constraint**: The Error type `E` MUST NOT contain UI text, localization, or log strings. It serves logic branching only.
-
-```csharp
-// E is a specific Enum or Discriminated Union
-public enum UserError { NotFound, AlreadyExists, InvalidEmail }
+**Constraint: Use Existing Types**
+*   **MUST** use the project's standard `Result<T, E>`, `Either`, or `Outcome` type.
+*   **PROHIBITED**: Do **NOT** define a new `Result` or `Outcome` class/type in the code. Assume one exists in the project's core utilities.
+*   **PROHIBITED**: Do **NOT** use `boolean` (success/fail) or `null` to indicate business errors.
+*   **PROHIBITED**: Do **NOT** rely on exceptions for control flow or expected business rules.
 
-```csharp
-// Return a Result<T, E> type
-public async Task<Result<User, UserError>> FindUserAsync(UserId id);
-
-// Usage
-var result = await repo.FindUserAsync(id);
-if (result.IsSuccess) {
-    HandleUser(result.Value);
-} else {
-    HandleError(result.Error); // Explicit branching
-}
-```
+**Conceptual Usage**:
+1.  Check `result.IsSuccess` (or equivalent method).
+2.  If Success, access `.Value`.
+3.  If Failure, handle `.Error` explicitly.
 
-### Pattern B: Exceptions (Preferred for Infrastructure/Panics)
+### Pattern B: Panics / System Failures
 Use when the system cannot recover gracefully (e.g., "Database Down", "Out of Memory", "Configuration Missing").
 *   Let it crash or be caught by a top-level global handler.
-*   Do not use exceptions for control flow.
+*   Standard Exceptions are acceptable here.
 
 ---
 
@@ -152,55 +160,51 @@ Inside a boundary (e.g., inside a private method of a Service), you may use Anem
 
 **Constraint**: These internal details MUST NOT leak out of the interface.
 
+### 3. Entity Mutability Strategy
 
----
+*   **Default: Rich Mutable Model**
+    *   Methods modify internal state (e.g., `void AddItem(...)`).
+    *   **Reason**: Performance and familiarity for standard business logic.
+    *   **Invariant**: The object MUST ensure it is always in a valid state after any method call.
 
-## Testing Strategy
+*   **Exception: Type-Driven State Transitions (Immutable-ish)**
+    *   Use when a state change fundamentally alters the capabilities of the object.
+    *   **Example**: `UnpaidOrder.Pay()` returns `PaidOrder`.
+    *   **Reason**: Enforces flow correctness at compile time (you can't `Ship` an `UnpaidOrder`).
+    *   **Rule**: If usage of Type-Driven transitions is chosen, it MUST be consistent for that specific entity lifecycle.
 
-Write tests against **Interfaces**, not Implementations.
 
-1.  **Mocking**: specific scenarios can be tested by injecting Mocks that implement domain interfaces.
-2.  **No Logic in Mocks**: Mocks should return fixed data.
-3.  **Test the Use Case**: Validate the orchestration logic in the Application layer.
+---
 
-```csharp
-[Fact]
-public async Task Sync_ShouldStoreJobs_WhenFetcherReturnsJobs() {
-    // Arrange
-    var mockFetcher = new Mock<IJobFetcher>();
-    mockFetcher.Setup(f => f.FetchAsync()).ReturnsAsync(new[] { new Job("Job1") });
-    
-    var mockStore = new Mock<IJobStore>();
-    
-    var service = new JobSyncService(mockFetcher.Object, mockStore.Object);
-
-    // Act
-    await service.SyncAsync();
-
-    // Assert
-    mockStore.Verify(s => s.SaveAsync(It.Is<Job>(j => j.Title == "Job1")), Times.Once);
-}
-```
+## Testing Strategy
 
-### Contract Testing (The Primary Validation)
+Write tests against **Contracts** (Interfaces), not Implementations.
+
+### Core Principles
+1.  **Scope**:
+    *   **Unit Tests**: Verify isolated logic (Domain Entities, Pure Functions).
+    *   **Integration Tests**: Verify interaction between components (Services).
+    *   **Contract Tests**: Verify that an implementation fulfills its Interface.
+2.  **No Side Effects**: Tests MUST NOT modify global state or persist data outside their transaction/sandbox.
+3.  **Black-Box**: Test the public contract (inputs/outputs). Do NOT test private methods or internal state.
+4.  **Structure (AAA)**:
+    *   **Arrange**: Setup inputs and mocks.
+    *   **Act**: Invoke the unit under test.
+    *   **Assert**: Verify the output or side-effect on the mock.
+
+### Contract Verification (The Primary Validation)
 **Rule**: The Contract Test IS the definition of correctness.
 
-1.  **Define Contract**: A test suite that runs against `TInterface`. This defines the "Behavioral Specification".
-2.  **Verify Implementations**: All concrete implementations (Infra, Mocks, Fakes) MUST pass this suite.
-
-
-```csharp
-// The Contract (Abstract Test)
-public abstract class JobStoreContractTests {
-    protected abstract IJobStore CreateStore();
-
-    [Fact]
-    public async Task Save_ShouldPersistJob() {
-        var store = CreateStore();
-        var job = new Job("J1");
-        await store.SaveAsync(job);
-        var fetched = await store.GetAsync("J1");
-        Assert.NotNull(fetched); // All impls must pass this behavior
-    }
+1.  **Define Contract Suite**: A test suite that runs against the mental model of the `Interface`.
+2.  **Verify Implementations**: All concrete implementations (Mocks, Fakes, Real) MUST pass this suite.
+
+```pseudocode
+// Conceptual Contract Test
+function test_save_persists_item(storeFactory) {
+  store = storeFactory();
+  item = new Item("id1");
+  store.save(item);
+  fetched = store.get("id1");
+  assert(fetched == item);
 }
 ```
~~~~

### `DESIGN_PHILOSOPHY.md`

~~~~diff
@@ -11,14 +11,20 @@ core_value: "Boundary_Stability"
 
 ## Redefining "Object-Oriented"
 
-In this project, "Object-Oriented" (OOP) is interpreted strictly as:
+*   **The Shell (OOP)**: Handles communication, boundaries, and dependencies (Interfaces, DI). Applies primarily to **Services, Components, and Architectural Boundaries**.
+*   **The Engine (Internal)**: Handles logic and computation (Functional, Procedural, etc.).
 
+**Scope Clarification**:
+This "Shell" metaphor applies to behavioral components (Services, Repositories).
+**Domain Entities** should still follow the **Rich Domain Model** (see `CODING_STANDARDS.md`), encapsulating state and business invariants strictly, but they are not "architectural shells" in the dependency injection sense.
+
+AI should interpret OOP strictly as:
 *   **Message-based interaction**
 *   **Contract-driven boundaries**
 *   **Black-box encapsulation**
 
 It is **NOT**:
-*   Class-centric modeling
+*   Class-centric modeling for the sake of taxonomy
 *   Inheritance-heavy design
 *   Taxonomic categorization of the world
 
@@ -29,10 +35,11 @@ The foundational principle of this project is strict decoupling through **Bounde
 
 ```yaml
 principle: "Bounded Contracts"
-definition: "Modules are black boxes defined SOLELY by their public contract (interface + semantics)."
+definition: "Modules are black boxes defined SOLELY by their public contract."
+formula: "Contract = Signature (Type) + Semantics (Behavior) + Constraints (Side-effects)"
 rationale: |
   The contract is the design. Implementation is secondary and replaceable.
-  In C# terms, reliance on `interface` definitions creates the explicit boundary.
+  The `interface` keyword is just the syntax; the *Contract* includes the behavior and constraints.
 ```
 
 
~~~~
