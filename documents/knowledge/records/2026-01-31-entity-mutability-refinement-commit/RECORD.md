# Source record: 2026-01-31-entity-mutability-refinement-commit

```yaml
record_type: "verbatim_external_source_snapshot"
source_kind: "Git commit message"
source_repository: "Daiki-Yoshida/design-principles"
source_commit: "1f5637e4fa584183d09d0e9e446af8c915207ba1"
source_url: "https://github.com/Daiki-Yoshida/design-principles/commit/1f5637e4fa584183d09d0e9e446af8c915207ba1"
source_author_date: "2026-01-31T23:11:18Z"
retrieved_date: "2026-09-24"
source_text_status: "GitHub APIで取得したcommit messageのsnapshot"
record_body_policy: "commit message本文は無加工。changed_filesはprovenance metadata。具体的なdiff内容をcommit message以上の意思決定として推測しない"
changed_files:
  - "CODING_STANDARDS.md"
```

## Commit message原文

~~~~text
docs: Refine entity mutability strategy patterns and their descriptions in coding standards.
~~~~

## GitHub API patch snapshot

この節は同commitについてGitHub APIが返したpatchを無加工で保存する。commit stateで何が変更されたかの証拠であり、チャットの提案・承認原文ではない。

### `CODING_STANDARDS.md`

~~~~diff
@@ -179,16 +179,16 @@ Inside a boundary (e.g., inside a private method of a Service), you may use Anem
 
 ### 3. Entity Mutability Strategy
 
-*   **Default: Rich Mutable Model**
+*   **Pattern A: Rich Mutable Model (Standard)**
     *   Methods modify internal state (e.g., `void AddItem(...)`).
-    *   **Reason**: Performance and familiarity for standard business logic.
+    *   **Use Case**: Standard business objects where identity is constant, and state changes are granular updates.
     *   **Invariant**: The object MUST ensure it is always in a valid state after any method call.
 
-*   **Exception: Type-Driven State Transitions (Immutable-ish)**
-    *   Use when a state change fundamentally alters the capabilities of the object.
-    *   **Example**: `UnpaidOrder.Pay()` returns `PaidOrder`.
-    *   **Reason**: Enforces flow correctness at compile time (you can't `Ship` an `UnpaidOrder`).
-    *   **Rule**: If usage of Type-Driven transitions is chosen, it MUST be consistent for that specific entity lifecycle.
+*   **Pattern B: Type-Driven State Transitions (Recommended for Critical Flows)**
+    *   Use when a state change fundamentally alters the capabilities or contract of the object.
+    *   **Example**: `UnpaidOrder.Pay()` returns `PaidOrder` (which has a `Ship()` method, whereas `UnpaidOrder` does not).
+    *   **Reason**: Enforces flow correctness at compile time and aligns with `DESIGN_PHILOSOPHY`.
+    *   **Rule**: If chosen, it MUST be consistent for that specific entity lifecycle.
 
 
 ---
~~~~
