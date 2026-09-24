# Source record: 2026-07-01-brownfield-policy-commit

```yaml
record_type: "verbatim_external_source_snapshot"
source_kind: "Git commit message"
source_repository: "Daiki-Yoshida/design-principles"
source_commit: "5048cc21e89b903c2d2c40f2f76bbc897838d698"
source_url: "https://github.com/Daiki-Yoshida/design-principles/commit/5048cc21e89b903c2d2c40f2f76bbc897838d698"
source_author_date: "2026-07-01T20:19:48Z"
retrieved_date: "2026-09-24"
source_text_status: "GitHub APIで取得したcommit messageのsnapshot"
record_body_policy: "commit message本文は無加工。changed_filesはprovenance metadataでありcommit message原文ではない"
changed_files:
  - "artifacts/AI_WORKFLOW.md"
  - "artifacts/CODING_STANDARDS.md"
  - "artifacts/INDEX.md"
```

## Commit message原文

~~~~text
artifacts のドキュメントを更新: AI ワークフローにブラウンフィールドポリシーを追加し、INDEX に関連情報を追記。CODING STANDARDS でのライブラリ使用に関するガイドラインを明確化。
~~~~

## GitHub API patch snapshot

この節は同commitについてGitHub APIが返したpatchを無加工で保存する。commit stateで何が導入・変更されたかの証拠であり、元チャットの提案・承認原文ではない。

### `artifacts/AI_WORKFLOW.md`

~~~~diff
@@ -37,7 +37,9 @@ process_flow:
     *   **focus**: The "Contract" is the Class State invariant & public Behavior.
 
 ### Pre-Implementation Scan
-Before drafting contracts, run these checks (criteria are owned elsewhere — link, don't re-derive):
+Before drafting contracts, run these checks (criteria are owned elsewhere — link, don't re-derive).
+
+**Proportionality**: scale the scan to the blast radius. For L0-scope edits (typo, comment/doc fix, test-only change, private helper behind a stable shell) the scan collapses to a quick sanity check — do NOT produce a full boundary analysis for a one-line fix. Run it in FULL whenever a contract, module boundary, external dependency, or persistent data is touched.
 1.  **Module Shell & Horizon**: What module is this? What is its outer contract, and who calls it? What can change internally without affecting callers? What must NOT leak out? First **resolve which "module"** you mean (semantic responsibility / code package / deployable / current hardening-horizon). Work **macro → micro, hardening the public SURFACE by default** (not 'interface everywhere'); the interior **below the module** is flexible by default (the initial horizon — a prior, not a floor). Is the responsibility **stable** enough to harden now, or still emerging (then keep it soft)? Is the seam **cheap**? Split only when the responsibility fractures (the 'AND' test). In an **immature domain do NOT descend below the module**: harden the outer API + stable module seams only, keep sub-module flexible. (See `DESIGN_PHILOSOPHY.md` → Module Shell vs Internal Implementation + Encapsulation Horizon.)
 2.  **Responsibility**: One-sentence job? Judged by reason-to-change & caller-visible capability? Mixing Functional/Technical/Orchestration? Becoming a *god service*? Using DTOs as Domain models? UI/Infra logic flowing inward? (See `DESIGN_PHILOSOPHY.md` → Responsibility-Driven Design + Anti-Patterns.)
 3.  **Dependency Spread**: Introduce/spread an external dependency? Local, or will many modules depend on it? Does it touch Domain/Core language? Wrap with port/adapter/anti-corruption? Acceptable because it stays in UI/Infrastructure? (See `CODING_STANDARDS.md` → External Dependency Boundary Policy.)
@@ -94,7 +96,7 @@ Concrete operating rules applied to every task.
 ```yaml
 reporting:
   thinking_and_interim: "english"
-  final_report: "japanese"
+  final_report: "the user's language — reply in the language the user writes in"
   content: "state what changed, why, and any impact on a public contract"
 testing:
   when: "Run tests after implementation, before declaring done."
@@ -110,6 +112,21 @@ clarification:
 
 ---
 
+## Brownfield Policy (existing code that violates these standards)
+
+Target projects contain legacy code. These standards govern the code you **write**; they are NOT a mandate to rewrite what you find.
+
+```yaml
+brownfield_policy:
+  new_code: "Code you add or modify follows these standards, even inside a non-conforming area."
+  local_convention: "Explicit target-project conventions (project instructions, lint config, house style) OUTRANK these artifacts where they conflict; report the conflict once, then follow the local rule."
+  on_violation_found: "Do NOT silently 'fix' surrounding violations. Note them in the report; leave the code as-is unless the task requires touching it."
+  fixing_is_a_change: "Cleaning up an existing violation is its own change — classify it through the Contract Confirmation Gate (internal refactor = L0/L1; anything touching a published contract = L2/L3)."
+  scope_guard: "Never let a violation hunt expand the task. Opportunistic refactors of unrelated code need explicit user approval."
+```
+
+---
+
 ## Special Instructions
 
 ### Handling "How to Approach" Questions
~~~~

### `artifacts/INDEX.md`

~~~~diff
@@ -26,6 +26,7 @@ On first contact, read 1 → 2 → 3 → 4. For a specific task, jump via the Ow
 ```yaml
 split_by: "the question each doc answers — WHY (philosophy) / HOW (standards) / WHERE (structure) / FLOW (workflow); INDEX routes."
 one_owner: "each concept lives in exactly ONE doc — see Ownership Map; link, never duplicate."
+restatement_cap: "when a doc needs a concept it does not own, restate AT MOST one sentence + a link to the owner; on any apparent conflict between docs, the OWNING doc's wording is authoritative."
 why_vs_how: "a topic may split as principle (why) vs normative rule (how/where), joined by 'single source of truth' pointers."
 not_split_by: ["audience", "language", "feature/domain"]   # all docs are AI-facing, English, language-agnostic
 ```
@@ -109,6 +110,8 @@ AI_WORKFLOW.md:
     - "Per-task process: analysis -> contract -> risk gate -> implementation -> verification"
     - "Contract Confirmation Gate (severity levels L0–L3)"
     - "Pre-implementation scan (module-sense resolution / module shell & horizon / responsibility / dependency spread / mapping / accuracy-vs-speed)"
+    - "Scan proportionality (scale analysis effort to blast radius)"
+    - "Brownfield policy (existing violations, local-convention precedence)"
     - "Operational discipline (reporting language, test timing, commit rules)"
 ```
 
@@ -132,5 +135,6 @@ AI_WORKFLOW.md:
 "where do test files go":                  "PROJECT_STRUCTURE.md (Test File Placement) + CODING_STANDARDS.md (Testing Strategy)"
 "mapping / DTO conversion":               "CODING_STANDARDS.md (Mapping & Conversion Policy)"
 "is a value Domain or UI?":               "CODING_STANDARDS.md (Domain Purity Rules)"
+"existing code violates these standards":  "AI_WORKFLOW.md (Brownfield Policy)"
 "how should I approach this?":            "AI_WORKFLOW.md (Special Instructions)"
 ```
~~~~
