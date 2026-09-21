# Encapsulation Horizon — Operational Guards

誤読防止、moduleの四義、confirmation levelなど、原理を運用するときのguardを扱う。

## 13. 運用ガード（誤読防止・module 解決・確認段階）

### 13.1 誤読防止リスト（Common Misreadings to Prevent）

```yaml
misreadings:
  - "『公開面を既定で硬化』＝ interface を全部作る、ではない（地平線より内側は既定で柔軟）"
  - "AND が出た ＝ 常に分割、ではない（従属ステップは保持。§8）"
  - "Domain purity ＝ Date/Color/Text を Domain に置くな、ではない（出自で判定。概念なら可）"
  - "one public surface ＝ 巨大ファサード一つ、ではない（audience 別の named/governed 面は可）"
  - "UseCase は技術に触れるな、ではない（調停は可・*所有*は不可）"
  - "契約ドキュメント ＝ どこにでも冗長コメント、ではない（load-bearing な意味だけ）"
  - "module ＝ フォルダ、ではない（四義を解決せよ。§13.2）"
  - "Result ＝ 例外を投げるな、ではない（期待される業務失敗が Result。システム障害は throw 可）"
  - "内部の柔軟 ＝ 内部は雑でよい、ではない（外面が全漏洩チャネルを閉じている前提。§7）"
  - "public contract ＝ メソッド署名だけ、ではない（Semantics+Constraints+副作用+失敗+資源+決定性+データ）"
  - "YAGNI／module より下は柔軟 ＝ 汎用概念を feature 専用に作ってよい、ではない（YAGNI は機構と置き場所を縛る。意味の中立性は縛らない。§6.7）"
```

### 13.2 module の四義（操作前に解決）

```yaml
module_resolution:
  semantic_module: "責務 / 機能 / 機能領域"
  code_module: "package / namespace / folder / assembly / crate"
  deployment_module: "実行体：app / service / worker / frontend"
  hardening_horizon: "今 安定契約境界として扱っている単位"
ask_first: "このタスクの『module』は semantic か physical か deployable か、今の硬化地平線か？"
```

### 13.3 確認段階（severity）の根拠

二値の確認ゲートは過剰ブロックになる。L0–L3 で AI の自律性と安全性を両立させる（運用表は `artifacts/AI_WORKFLOW.md` → Contract Confirmation Gate）。

```yaml
levels:
  L0_internal: "private/refactor/test/doc → 進行"
  L1_local_contract: "module-local interface / 内部 port / 非公開 DTO → 進行＋報告"
  L2_public_additive: "新公開メソッド / optional フィールド / 要求機能に要る endpoint → タスクに明確に含意されれば進行＋明示報告"
  L3_breaking_or_side_effect: "破壊的変更 / 公開 semantics 変更 / 破壊的操作 / 新規外部副作用 / 永続データ移行 → 事前確認必須"
```

## Sources

- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/design-principles/source-logs/ENCAPSULATION_HORIZON_ORIGINAL_NOTES_JP.md`
