# Source record: 2026-06-13-operational-discipline-commit

```yaml
record_type: "verbatim_external_source_snapshot"
source_kind: "Git commit message + GitHub API patch"
source_repository: "Daiki-Yoshida/design-principles"
source_commit: "b92af5490f33b6600039692069e87fa5cb4edd53"
source_url: "https://github.com/Daiki-Yoshida/design-principles/commit/b92af5490f33b6600039692069e87fa5cb4edd53"
source_author_date: "2026-06-13T07:32:28Z"
retrieved_date: "2026-09-24"
source_text_status: "GitHub APIで取得したcommit messageとpatchのsnapshot"
record_body_policy: "commit messageとpatchは無加工。commit stateの証拠であり、元チャットの提案・承認原文とは区別する"
```

## Commit message原文

~~~~text
indexを配置
~~~~

## GitHub API patch snapshot

この節は同commitについてGitHub APIが返したpatchを無加工で保存する。commit stateで何が導入・変更されたかの証拠であり、元チャットの提案・承認原文ではない。

### `artifacts/AI_WORKFLOW.md`

~~~~diff
@@ -73,6 +73,29 @@ process_flow:
 
 ---
 
+## Operational Discipline
+
+Concrete operating rules applied to every task.
+
+```yaml
+reporting:
+  thinking_and_interim: "english"
+  final_report: "japanese"
+  content: "state what changed, why, and any impact on a public contract"
+testing:
+  when: "Run tests after implementation, before declaring done."
+  gate: "Contract Tests MUST pass before reporting completion. If tests fail, report the failure with output; never claim done."
+  scope: "Run the narrowest relevant suite first; widen it if a contract boundary was touched."
+version_control:
+  commit: "Do NOT commit or push unless the user asks."
+  branch: "If on the default branch, create a branch before committing."
+  confirmation: "After changes and the final report, ask the user whether to commit."
+clarification:
+  rule: "If intent or the contract is unclear, STOP and ask before implementing."
+```
+
+---
+
 ## Special Instructions
 
 ### Handling "How to Approach" Questions
~~~~

### `artifacts/INDEX.md`

~~~~diff
@@ -0,0 +1,79 @@
+# AI Agent Guidance - Index
+
+```yaml
+document_type: "index"
+target_audience: "ai_agents"
+optimization: "token_efficiency"
+language: "english"
+role: "entry point for the exported design guidance set"
+```
+
+This is the entry point for the exported guidance. Read it first.
+
+## Read Order
+
+```yaml
+1_philosophy: "DESIGN_PHILOSOPHY.md"   # WHY:  core values, Bounded Contracts, design priorities
+2_standards:  "CODING_STANDARDS.md"    # HOW:  interfaces, layering, DI, errors, models, tests
+3_workflow:   "AI_WORKFLOW.md"         # FLOW: per-task operating procedure & discipline
+```
+
+On first contact, read 1 → 2 → 3. For a specific task, jump via the Ownership Map below.
+
+## Foundational Lens
+
+These artifacts assume a **Contract-Oriented, boundary-driven** paradigm.
+
+```yaml
+contract: "Signature + Semantics + Constraints"
+interpret_through: ["boundaries", "contracts", "responsibilities", "side-effect containment"]
+do_not_optimize_for: ["class count", "inheritance depth", "paradigm purity"]
+core_idea: "OOP is the Shell, not the Core Logic. The contract is the design; implementation is replaceable."
+```
+
+## Ownership Map (Single Source of Truth)
+
+Each concept has exactly ONE authoritative document. Do not duplicate; link instead.
+
+```yaml
+DESIGN_PHILOSOPHY.md:
+  owns:
+    - "Bounded Contracts: definition & rationale"
+    - "Design priority order"
+    - "Shell vs Core Logic"
+    - "Responsibility-driven design (SRP)"
+    - "Composition over inheritance"
+    - "Fail-fast & side-effect / environment protection policy"
+    - "Type-Driven State Design: the principle (the WHY)"
+
+CODING_STANDARDS.md:
+  owns:
+    - "Interface design & naming"
+    - "Layering & contract placement"
+    - "Dependency Injection rules"
+    - "Error handling (Result vs Panic)"
+    - "Error boundary translation"
+    - "Concurrency & async contracts"
+    - "Contract evolution & versioning"
+    - "Domain modeling (Rich vs Anemic)"
+    - "Entity mutability & Type-Driven State: the normative pattern (the HOW)"
+    - "Testing strategy & contract tests"
+
+AI_WORKFLOW.md:
+  owns:
+    - "Per-task process: analysis -> contract -> risk gate -> implementation -> verification"
+    - "Contract Confirmation Gate"
+    - "Operational discipline (reporting language, test timing, commit rules)"
+```
+
+## Quick Task Routing
+
+```yaml
+"defining a new service/repository":      "AI_WORKFLOW.md (Step 1) + CODING_STANDARDS.md (Interface Design)"
+"placing a contract in a layer":          "CODING_STANDARDS.md (Architectural Boundaries)"
+"handling failures":                      "CODING_STANDARDS.md (Error Handling + Boundary Translation)"
+"async / threading decision":             "CODING_STANDARDS.md (Concurrency & Async Contracts)"
+"changing an existing public contract":   "CODING_STANDARDS.md (Contract Evolution) + AI_WORKFLOW.md (Confirmation Gate)"
+"modeling a domain entity":               "CODING_STANDARDS.md (Domain Modeling) + DESIGN_PHILOSOPHY.md (Shell vs Core Logic)"
+"how should I approach this?":            "AI_WORKFLOW.md (Special Instructions)"
+```
~~~~
