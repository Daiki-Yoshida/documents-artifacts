# Source record: 2026-01-31-bounded-contracts-standardization-commit

```yaml
record_type: "verbatim_external_source_snapshot"
source_kind: "Git commit message"
source_repository: "Daiki-Yoshida/design-principles"
source_commit: "790c5a4642eaafca9a97d6cc328e4cf7ae0f74d1"
source_url: "https://github.com/Daiki-Yoshida/design-principles/commit/790c5a4642eaafca9a97d6cc328e4cf7ae0f74d1"
source_author_date: "2026-01-31T21:50:33Z"
retrieved_date: "2026-09-24"
source_text_status: "GitHub APIで取得したcommit messageのsnapshot"
record_body_policy: "commit message本文は無加工。changed_filesはprovenance metadata。具体的なdiff内容をcommit message以上の意思決定として推測しない"
changed_files:
  - "AI_WORKFLOW.md"
  - "CODING_STANDARDS.md"
  - "DESIGN_PHILOSOPHY.md"
```

## Commit message原文

~~~~text
feat: `AI_WORKFLOW`, `CODING_STANDARDS`, and `DESIGN_PHILOSOPHY` are updated to standardize on "bounded contracts" and "architectural boundaries" terminology, emphasizing internal implementation flexibility.
~~~~

## GitHub API patch snapshot

この節は同commitについてGitHub APIが返したpatchを無加工で保存する。commit stateで何が変更されたかの証拠であり、チャットの提案・承認原文ではない。

### `AI_WORKFLOW.md`

~~~~diff
@@ -13,50 +13,49 @@ Before writing any code, the AI must establish a mental model of the solution.
 
 ```yaml
 process_flow:
-  1_analysis: "Understand the Requirement & User Intent"
-  2_design: "Define Interfaces & Contracts (The 'What')"
-  3_approval: "Confirm Design with User"
-  4_implementation: "Implement Details (The 'How')"
+  1_analysis: "Understand Boundaries & User Intent"
+  2_design: "Define Bounded Contracts (The 'What')"
+  3_approval: "Confirm Contracts with User"
+  4_implementation: "Implement Internals (The 'How')"
   5_verification: "Validate against Contracts"
 ```
 
 ---
 
-## Step 1: Interface-First Design
+## Step 1: Define Boundaries & Contracts
 
-**Rule**: Never start implementing logic until the Interfaces are defined.
+**Rule**: Never start implementing logic until the Bounded Contract is defined.
 
-1.  **Draft Interfaces**: Propose the `interface` definitions first.
-    *   Focus on method signatures, return types (Result vs Task), and dependencies.
-    *   Do not write method bodies yet.
-2.  **Check Capability**: Ensure the interface represents a *Cohesive Capability* (from `DESIGN_PHILOSOPHY`).
-3.  **Propose to User**: Show the interface definition to the user.
-    *   *Self-Correction*: "Does this interface leak implementation details?"
+1.  **Draft Contracts**: Define the `interface` and the behavioral rules.
+    *   Focus on consistency, explicit side-effects, and return types.
+2.  **Check Boundary Stability**: Is this boundary clear? Does it leak implementation details?
+3.  **Propose to User**: Show the contract definition.
+    *   *Self-Correction*: "Is this contract stable enough to hide future implementation changes?"
 
 ---
 
-## Step 2: Implementation
+## Step 2: Implementation (Paradigm-Agnostic)
 
-Once interfaces are agreed upon (or if the task is trivial):
+Once contracts are declared:
 
-1.  **Dependency Injection**:
-    *   Define the class with `I...` dependencies in the constructor.
-    *   Do not `new` up volatile dependencies.
-2.  **Internal Logic**:
-    *   Implement the logic behind the interface.
-    *   You are free to optimize internals (buffering, caching) as long as the interface contract holds.
-    *   Follow `CODING_STANDARDS` for Error Handling (Result vs Exception).
+1.  **Select Internal Paradigm**:
+    *   Choose the best tool for the job (e.g., Functional for transformations, State Machines for workflows, OOP for resource management).
+2.  **Dependency Injection**:
+    *   Inject dependencies via constructor to enforce the boundary.
+3.  **Internal Logic**:
+    *   Implement freely. Use internal buffers, raw arrays, or static methods if it helps performance/clarity.
+    *   **Constraint**: Never leak these choices through the boundary.
 
 ---
 
 ## Step 3: Verification
 
 1.  **Contract Compliance**:
-    *   Does the implementation strictly adhere to the Interface contract?
-    *   Does it pass the Contract Tests (if applicable)?
-2.  **Constraint Check**:
-    *   did I introduce any illegal states? (Type-Driven Design check)
-    *   did I leak domain entities to the boundary? (Layer check)
+    *   Does the implementation strictly adhere to the Contract?
+    *   Does it pass the Contract Tests?
+2.  **Paradigm Check**:
+    *   Did I accidentally expose an internal detail (e.g., returning a mutable internal list)?
+    *   Did I maintain the boundary stability?
 
 ---
 
~~~~

### `CODING_STANDARDS.md`

~~~~diff
@@ -42,24 +42,25 @@ interface IMultiFunctionDevice : IPrinter, IScanner, IFax { }
 
 ---
 
-## Layered Architecture
+## Architectural Boundaries (Layering)
 
 Strict dependency flow: **App -> Infra -> Domain**.
+Think of these as **Boundaries**, not just folders.
 
-### 1. Domain Layer (`src/Domain`)
-*   **Contains**: Interfaces, Entities, Value Objects, Domain Errors.
-*   **Dependencies**: ZERO dependencies on outer layers (Infra/App).
-*   **Style**: Pure C# classes/interfaces.
+### 1. Domain Boundary (`src/Domain`)
+*   **Contains**: **Contracts** (Interfaces), Entities, Value Objects, Domain Errors.
+*   **Dependencies**: ZERO dependencies on outer layers.
+*   **Role**: Defines the "What" (Business Logic Contracts).
 
-### 2. Infrastructure Layer (`src/Infrastructure`)
-*   **Contains**: Concrete implementations (Database access, API clients, File IO).
+### 2. Infrastructure Boundary (`src/Infrastructure`)
+*   **Contains**: Concrete implementations (Database access, API clients).
 *   **Dependencies**: Depends on **Domain**.
-*   **Role**: "How" technical details are executed.
+*   **Role**: The "How" (Plumbing).
 
-### 3. Application Layer (`src/Application`)
+### 3. Application Boundary (`src/Application`)
 *   **Contains**: Use Cases, Services, Orchestration.
-*   **Dependencies**: Depends on **Domain** interfaces.
-*   **Role**: High-level flow control. Receives concrete Infra implementations via DI.
+*   **Dependencies**: Depends on **Domain**.
+*   **Role**: High-level flow control.
 *   **Boundary Rule**: MUST define its own Request/Response DTOs. NEVER expose Domain Entities directly to external boundaries (API/CLI).
 
 ### Type Placement Guidelines
@@ -131,28 +132,26 @@ Use when the system cannot recover gracefully (e.g., "Database Down", "Out of Me
 
 ---
 
-## Data Model Patterns
+## Data Model & Internal Implementation
+
+**Principle**: The public contract is strict. The internal implementation is flexible.
 
-### 1. Rich Domain Model (Default)
-Entities contain both state and behavior.
+### 1. Rich Domain Model (Recommended for Complex Logic)
+Entities contain both state and behavior. Best for enforcing invariants.
 
 ```csharp
 public class Order {
     public List<LineItem> Items { get; private set; }
-    public bool IsPaid { get; private set; }
-
-    // Behavior encapsulates state mutation
-    public void AddItem(Product product, int quantity) {
-        if (IsPaid) throw new InvalidOperationException("Cannot modify paid order");
-        Items.Add(new LineItem(product, quantity));
-    }
+    // Enforces strict invariant
+    public void AddItem(Product product, int quantity) { ... }
 }
 ```
 
-### 2. Anemic Model + Service (Alternative)
-Use ONLY when logic relies heavily on creating external dependencies that don't belong in the entity.
-*   *Entity*: Pure data structure (POCO).
-*   *Service*: Contains the logic.
+### 2. Internal Flexibility (Allowed)
+Inside a boundary (e.g., inside a private method of a Service), you may use Anemic Models, Functional Pipelines, or raw data structures if it simplifies the implementation.
+
+**Constraint**: These internal details MUST NOT leak out of the interface.
+
 
 ---
 
@@ -183,11 +182,12 @@ public async Task Sync_ShouldStoreJobs_WhenFetcherReturnsJobs() {
 }
 ```
 
-### Contract Testing (Required for Interfaces)
-To prevent "MockDrift" (where mocks pass but real impl fails), every Domain Interface MUST have a Contract Test Suite.
+### Contract Testing (The Primary Validation)
+**Rule**: The Contract Test IS the definition of correctness.
+
+1.  **Define Contract**: A test suite that runs against `TInterface`. This defines the "Behavioral Specification".
+2.  **Verify Implementations**: All concrete implementations (Infra, Mocks, Fakes) MUST pass this suite.
 
-1.  **Define Contract**: A test suite that runs against `TInterface`.
-2.  **Verify Implementations**: All concrete implementations (Infra) MUST pass this suite.
 
 ```csharp
 // The Contract (Abstract Test)
~~~~

### `DESIGN_PHILOSOPHY.md`

~~~~diff
@@ -5,22 +5,37 @@ document_type: "design_philosophy"
 target_audience: "ai_agents"
 optimization: "token_efficiency"
 language: "english"
-base_paradigm: "OOP"
-core_value: "robustness_and_maintainability"
+base_paradigm: "Contract-Oriented"
+core_value: "Boundary_Stability"
 ```
 
-## Core Philosophy: Interface-Driven Decoupling
+## Redefining "Object-Oriented"
 
-The foundational principle of this project is strict decoupling through interfaces.
+In this project, "Object-Oriented" (OOP) is interpreted strictly as:
+
+*   **Message-based interaction**
+*   **Contract-driven boundaries**
+*   **Black-box encapsulation**
+
+It is **NOT**:
+*   Class-centric modeling
+*   Inheritance-heavy design
+*   Taxonomic categorization of the world
+
+
+## Core Philosophy: Bounded Contracts & Explicit Interfaces
+
+The foundational principle of this project is strict decoupling through **Bounded Contracts**.
 
 ```yaml
-principle: "Interface-Driven Decoupling"
-definition: "Modules must depend ONLY on abstract interfaces, never on concrete implementations."
+principle: "Bounded Contracts"
+definition: "Modules are black boxes defined SOLELY by their public contract (interface + semantics)."
 rationale: |
-  Enables parallel development, isolated testing, and flexible behavior replacement.
-  In C# terms, this means relying on `interface` definitions, not `class` types for dependencies.
+  The contract is the design. Implementation is secondary and replaceable.
+  In C# terms, reliance on `interface` definitions creates the explicit boundary.
 ```
 
+
 ### The "Why" of Interfaces
 
 1.  **Contract First**: Interfaces define the *capabilities* (what), not the *methods* (how).
@@ -132,6 +147,28 @@ Accept necessary complexity (domain logic) but ruthlessly eliminate accidental c
 *   **YAGNI**: do not implement features "just in case".
 *   **Abstraction**: Abstractions should simplify the problem, not obscure it. If an abstraction makes the code harder to follow without providing flexibility, remove it.
 
+## Internal Paradigm Agnosticism
+
+Inside a boundary, the implementation style is flexible.
+
+```yaml
+internal_paradigm:
+  flexibility: "High"
+  rule: "As long as the contract is honored, the internal implementation can be Functional, Procedural, or OOP."
+  goal: "Use the best tool for the specific task (e.g., pure functions for logic, state machines for protocols)."
+  restriction: "Internal implementation details MUST NOT leak into the public contract."
+```
+
+## Design Priority Order
+
+When making design decisions, prioritize in this order:
+
+1.  **Clarity of Boundary and Contract** (Most Important)
+2.  **Stability of External Interface**
+3.  **Locality of Change**
+4.  **Explicitness of Side Effects**
+5.  **Internal Elegance or Purity**
+
 ## Performance vs. Abstraction Policy
 
 Performance optimization must not degrade interface abstraction.
@@ -143,3 +180,4 @@ performance_policy:
   cost_acceptance: "The overhead of the interface boundary (boxing, virtual calls) is an accepted cost."
   rule: "Optimize BEHIND the interface. Never expose optimization complexity (like manual buffer management) in the domain API."
 ```
+
~~~~
