# Source record: 2026-01-31-domain-modeling-refinement-commit

```yaml
record_type: "verbatim_external_source_snapshot"
source_kind: "Git commit message"
source_repository: "Daiki-Yoshida/design-principles"
source_commit: "fe40cf2b50d151b9760fcd0d466b8fd9d5dfbdc6"
source_url: "https://github.com/Daiki-Yoshida/design-principles/commit/fe40cf2b50d151b9760fcd0d466b8fd9d5dfbdc6"
source_author_date: "2026-01-31T23:29:29Z"
retrieved_date: "2026-09-24"
source_text_status: "GitHub APIで取得したcommit messageのsnapshot"
record_body_policy: "commit message本文は無加工。changed_filesはprovenance metadata。具体的なdiff内容をcommit message以上の意思決定として推測しない"
changed_files:
  - "CODING_STANDARDS.md"
  - "DESIGN_PHILOSOPHY.md"
```

## Commit message原文

~~~~text
feat: Update domain modeling strategy in coding standards and design philosophy, clarifying usage of Rich and Lightweight models based on domain complexity.
~~~~

## GitHub API patch snapshot

この節は同commitについてGitHub APIが返したpatchを無加工で保存する。commit stateで何が変更されたかの証拠であり、チャットの提案・承認原文ではない。

### `CODING_STANDARDS.md`

~~~~diff
@@ -159,17 +159,27 @@ Use when the system cannot recover gracefully (e.g., "Database Down", "Out of Me
 
 **Principle**: The public contract is strict. The internal implementation is flexible.
 
-### 1. Rich Domain Model (Recommended for Complex Logic)
-Entities contain both state and behavior. Best for enforcing invariants.
+### 1. Domain Modeling Strategy
+Choose the sophistication of the model based on the complexity of the subdomain.
+
+#### A. Rich Domain Model (Complex Logic)
+**Use when**: The specific domain entity has complex invariants, state transitions, or business rules.
+*   Entities contain both state and behavior.
+*   Enforce invariants strictly within the entity.
 
 ```csharp
+// Rich Model: Enforces rules (e.g., distinct items, max quantity)
 public class Order {
     public List<LineItem> Items { get; private set; }
-    // Enforces strict invariant
     public void AddItem(Product product, int quantity) { ... }
 }
 ```
 
+#### B. Anemic/Lightweight Model (Simple Logic)
+**Use when**: The entity is primarily a data holder, or the logic is purely CRUD.
+*   Entities are simple data carriers (Properties/Fields).
+*   **Goal**: Simplify maintenance for simple data. Do not force behavior if none exists.
+
 ### 2. Internal Flexibility (Allowed)
 Inside a boundary (e.g., inside a private method of a Service), you may use Anemic Models, Functional Pipelines, or raw data structures if it simplifies the implementation.
 
~~~~

### `DESIGN_PHILOSOPHY.md`

~~~~diff
@@ -16,7 +16,11 @@ core_value: "Boundary_Stability"
 
 **Scope Clarification**:
 This "Shell" metaphor applies to behavioral components (Services, Repositories).
-**Domain Entities** should still follow the **Rich Domain Model** (see `CODING_STANDARDS.md`), encapsulating state and business invariants strictly, but they are not "architectural shells" in the dependency injection sense.
+**Domain Entities** should follow the **Rich Domain Model** *when the domain logic is complex* (see `CODING_STANDARDS.md`), encapsulating state and business invariants strictly.
+*   **Complex Domain**: Use Rich Model. Enforce invariants internally.
+*   **Simple Domain**: Use Lightweight/Anemic Model. Do not force complexity where none exists.
+
+They are not "architectural shells" in the dependency injection sense.
 
 AI should interpret OOP strictly as:
 *   **Message-based interaction**
~~~~
