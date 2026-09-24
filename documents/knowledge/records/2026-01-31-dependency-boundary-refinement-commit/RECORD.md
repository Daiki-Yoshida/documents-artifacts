# Source record: 2026-01-31-dependency-boundary-refinement-commit

```yaml
record_type: "verbatim_external_source_snapshot"
source_kind: "Git commit message"
source_repository: "Daiki-Yoshida/design-principles"
source_commit: "02c8d31981164be8c0ab789b82c28346bdaf3d54"
source_url: "https://github.com/Daiki-Yoshida/design-principles/commit/02c8d31981164be8c0ab789b82c28346bdaf3d54"
source_author_date: "2026-01-31T23:02:30Z"
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
feat: Refine design principles by renaming "Engine" to "Core Logic", clarifying dependency rules, and updating coding standards for interface naming and architectural boundaries.
~~~~

## GitHub API patch snapshot

この節は同commitについてGitHub APIが返したpatchを無加工で保存する。commit stateで何が変更されたかの証拠であり、チャットの提案・承認原文ではない。

### `AI_WORKFLOW.md`

~~~~diff
@@ -44,18 +44,18 @@ process_flow:
 
 ---
 
-## Step 2: Implementation (The Shell & The Engine)
+## Step 2: Implementation (The Shell & The Core Logic)
 
-**Mental Model (Behavioral Components)**: The Class is the **Shell** (OOP) containing the **Engine** (Logic).
+**Mental Model (Behavioral Components)**: The Class is the **Shell** (OOP) containing the **Core Logic** (Internal).
 **Mental Model (Domain Models)**: The Class **IS** the logic and state definition.
 
 1.  **Build the Shell** (For Behavioral Components):
     *   Define the class implementing the interface.
     *   Inject dependencies via constructor (The "Plugs" of the shell).
-2.  **Build the Engine**:
+2.  **Build the Core Logic**:
     *   Implement the logic *inside* the shell.
     *   Select Internal Paradigm: Functional, Procedural, Data-Oriented.
-    *   **Constraint**: The engine must satisfy the Shell's Contract (Signature + Semantics).
+    *   **Constraint**: The Core Logic must satisfy the Shell's Contract (Signature + Semantics).
 
 ---
 
~~~~

### `CODING_STANDARDS.md`

~~~~diff
@@ -9,12 +9,18 @@ language_context: "Language-Agnostic"
 optimization: "implementation_accuracy"
 ```
 
+This guideline assumes a statically typed, interface-capable language.
+Concepts must be adapted when applied to other ecosystems.
+
 ## Interface Design Rules
 
 Interfaces are the backbone of our architecture.
 
 ### Naming & Granularity
-*   **Prefix**: MUST use `I` prefix (e.g., `IJobFetcher`) for architectural components.
+*   **Prefix**: **MUST** follow the specific language's standard idiom.
+    *   **CRITICAL RULE**: The constraints of the specific programming language ALWAYS take precedence over the examples provided here.
+    *   *C#*: Use `I` prefix (e.g., `IJobFetcher`).
+    *   *TypeScript/Python*: Do NOT use `I` prefix. Use descriptive names (e.g., `JobFetcher` (protocol) vs `JobFetcherCode` (impl)).
 *   **Granularity**: Cohesive Capability (not just Atomic).
 
 ### Entity & ValueObject Exception
@@ -61,7 +67,11 @@ interface IMultiFunctionDevice : IPrinter, IScanner, IFax { }
 
 ## Architectural Boundaries (Layering)
 
-Strict dependency flow: **App -> Infra -> Domain**.
+Physical layer structure: App / Infra / Domain
+Dependency rule:
+- App depends only on Domain abstractions
+- Infra depends on Domain (and optionally App interfaces)
+- Concrete implementations live in Infra
 Think of these as **Boundaries**, not just folders.
 
 ### 1. Domain Boundary (`src/Domain`)
@@ -113,6 +123,10 @@ public class JobSyncService {
 *   **Volatile Dependencies**: Do not instantiate volatile dependencies (IO, Config, Random, Time) with `new`. Use DI.
 *   **Stable Dependencies**: You MAY use `new` for Value Objects, Entities, and Pure Utility classes.
 
+### Entity Dependency Constraint
+*   **Rule**: Domain Entities and Value Objects **MUST NOT** have dependencies injected via constructor. They must remain pure.
+*   **Method Injection**: If an entity needs a service (e.g., for calculation), pass it as a **Method Argument**.
+
 ---
 
 ## Error Handling Strategy
@@ -127,6 +141,7 @@ Use when the caller needs to handle simple failure cases (e.g., "Not Found", "Va
 *   **PROHIBITED**: Do **NOT** define a new `Result` or `Outcome` class/type in the code. Assume one exists in the project's core utilities.
 *   **PROHIBITED**: Do **NOT** use `boolean` (success/fail) or `null` to indicate business errors.
 *   **PROHIBITED**: Do **NOT** rely on exceptions for control flow or expected business rules.
+*   **Bootstrap Exception**: If the core types (`Result<T>`, etc.) do not exist in the project, you are **AUTHORIZED** to create a minimal implementation in the project's shared kernel/utilities following standard Result pattern practices.
 
 **Conceptual Usage**:
 1.  Check `result.IsSuccess` (or equivalent method).
@@ -160,6 +175,8 @@ Inside a boundary (e.g., inside a private method of a Service), you may use Anem
 
 **Constraint**: These internal details MUST NOT leak out of the interface.
 
+**Rule**: Keep internal paradigm consistent within a specifically cohesive module or file.
+
 ### 3. Entity Mutability Strategy
 
 *   **Default: Rich Mutable Model**
~~~~

### `DESIGN_PHILOSOPHY.md`

~~~~diff
@@ -12,7 +12,7 @@ core_value: "Boundary_Stability"
 ## Redefining "Object-Oriented"
 
 *   **The Shell (OOP)**: Handles communication, boundaries, and dependencies (Interfaces, DI). Applies primarily to **Services, Components, and Architectural Boundaries**.
-*   **The Engine (Internal)**: Handles logic and computation (Functional, Procedural, etc.).
+*   **The Core Logic (Internal)**: Handles logic and computation (Functional, Procedural, etc.).
 
 **Scope Clarification**:
 This "Shell" metaphor applies to behavioral components (Services, Repositories).
@@ -47,6 +47,9 @@ rationale: |
 
 1.  **Contract First**: Interfaces define the *capabilities* (what), not the *methods* (how).
 2.  **Dependency Inversion**: High-level policies (Domain) should not depend on low-level details (Infrastructure). Both should depend on abstractions.
+
+    Layer diagrams describe responsibility boundaries, not dependency direction.
+    Dependency direction is always toward abstractions.
 3.  **Testability**: Interfaces allow trivially creating Mocks/Stubs without complex frameworks.
 
 ---
@@ -164,6 +167,7 @@ internal_paradigm:
   rule: "As long as the contract is honored, the internal implementation can be Functional, Procedural, or OOP."
   goal: "Use the best tool for the specific task (e.g., pure functions for logic, state machines for protocols)."
   restriction: "Internal implementation details MUST NOT leak into the public contract."
+  consistency: "Keep internal paradigm consistent within a specifically cohesive module or file."
 ```
 
 ## Design Priority Order
~~~~
