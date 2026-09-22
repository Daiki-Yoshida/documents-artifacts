# Encapsulation Horizon — Operational Guards

誤読防止、moduleの四義、contract変更のconfirmation levelなど、原理を運用するときのguardを扱う。

## 13. 運用ガード（誤読防止・module 解決・確認段階）

### 13.1 誤読防止リスト（Common Misreadings to Prevent）

```yaml
misreadings:
  - "『公開面を既定で硬化』＝ interface を全部作る、ではない（地平線より内側は既定で柔軟）"
  - "AND が出た ＝ 常に分割、ではない（従属ステップは保持。§8）"
  - "Domain purity ＝ Date/Color/Text を Domain に置くな、ではない（出自で判定。概念なら可）"
  - "one public surface ＝ 巨大ファサード一つ、ではない（audience 別の named/governed 面は可）"
  - "UseCase は技術に触れるな、ではない（調停は可・所有は不可）"
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
  deployment_module: "実行体: app / service / worker / frontend"
  hardening_horizon: "今 安定contract boundaryとして扱っている単位"
ask_first: "このタスクのmoduleは semantic / physical / deployable / hardening horizon のどれか"
```

### 13.3 Contract Change Level

このlevelは**code / API / architecture contract変更のseverity**を扱う。

documentation構造変更の `DOC_L0..DOC_L3`、development operation riskの `SAFETY_L0..SAFETY_L3` とは別軸である。

```yaml
CONTRACT_L0_internal:
  意味: "private refactor / test / internal implementation"
  対応: "進行"

CONTRACT_L1_local:
  意味: "module-local interface / internal port / non-public DTO"
  対応: "進行して報告"

CONTRACT_L2_public_additive:
  意味: "new public method / optional field / required additive endpoint"
  対応: "依頼に明確に含意される場合に進行し明示報告"

CONTRACT_L3_breaking:
  意味: "public semantics破壊、breaking contract変更、永続data contract migration、新規外部副作用"
  対応: "明示的要求なしに実施しない"
```

実際のoperationがdata削除・host変更等を伴う場合は、contract levelとは別に `../development-safety/S005_CONFIRMATION_AND_REREAD.md` を評価する。

## Sources

- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/design-principles/source-logs/ENCAPSULATION_HORIZON_ORIGINAL_NOTES_JP.md`
- `../../records/2026-09-22-six-subject-cross-audit-fixes/`
