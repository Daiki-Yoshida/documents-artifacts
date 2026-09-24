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
  - "strong contract ＝ 将来あり得るcapabilityを全部surfaceへ追加する、ではない（small surface, strong contract。§6.8 / §7）"
  - "YAGNI ＝ contract completenessを高コストだから省略してよい、ではない（creation costだけでは選択済みcontractを弱める十分な理由にならない。§6.5 / §6.8）"
  - "Horizon内側は柔軟 ＝ 内部も将来向けに汎用化しておく、ではない（contractを満たす限り内部の投機的機構にはYAGNIを強く適用する。§6.8）"
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
  意味: "module-local interface / internal port / non-public DTO。参加者全員を要求scope内で所有できる局所的な変更は、局所のblast radiusで評価する"
  対応: "進行して報告。公開outer contractに影響が出る場合は公開契約として再分類"

CONTRACT_L2_compatible_public_evolution:
  意味: "既存caller / consumerとprovider / implementerの双方が従来の保証のまま成立する、互換性を確認済みの公開contract進化"
  確認: "契約媒体に応じて、該当するsource / binary / wire / schema / persisted-dataの互換性だけを確認する。追加形状(additive)は互換性の証明ではない"
  対応: "依頼に明確に含意され、参加者双方と以前の保証の互換性が確認できる場合に進行し明示報告"

CONTRACT_L3_breaking:
  意味: "公開contractの既存参加者に必須変更を要求する変更（必須interface memberの追加を含む）、公開semantics / 既存保証の破壊、永続data contract migration、新規外部副作用"
  対応: "明示的要求なしに実施しない。署名上は追加でも、既存implementer / fakeを壊すならL2へ分類しない"
```

実際のoperationがdata削除・host変更等を伴う場合は、contract levelとは別に `../development-safety/S005_CONFIRMATION_AND_REREAD.md` を評価する。

### 後続判断による互換性の明確化（2026-09-15）

旧sourceの「追加はL2」の例示に対して、中央PR #10は**追加形状と後方互換性を区別**する規則を採用した。既存callerが変わらなくても必須interface member追加によって既存implementerやfakeが壊れる場合は、L2の互換変更ではない。L2は既存参加者の両側が従来保証のまま成立すると確認できる公開進化に限定し、公開破壊はL3で扱う。変更媒体に応じた互換性dimensionを評価し、変更のblast radiusが局所で完結する場合はL1で評価できる。

旧例示の原文はrecords snapshotに保持する。追加要素それ自体を安全性の根拠にしない。

## Sources

- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/design-principles/source-logs/ENCAPSULATION_HORIZON_ORIGINAL_NOTES_JP.md`
- `../../records/2026-09-22-six-subject-cross-audit-fixes/`
- `../../records/2026-09-06-design-principles-proposals/RECORD.md`（提案）
- `../../records/2026-09-15-design-principles-contract-decision/RECORD.md`（修正採用）
- `../../records/2026-09-15-design-principles-proposal-status/RECORD.md`（移行結果）
- `../../records/2026-09-24-yagni-encapsulation-horizon-decision/RECORD.md`
