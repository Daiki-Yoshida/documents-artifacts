# Encapsulation Horizon — Concept Altitude

概念の意味が属する高度と、YAGNI・最初のconsumer・physical placement・hardening depthの独立性を扱う。

## 6.7. 概念の高度 — YAGNI は「機構」を縛るのであって「意味」を縛らない

§6.5 の「module より下は既定で柔軟」「予期的分割は YAGNI 違反」には既知の誤読がある。
**「最初の消費者しかいない概念は、その消費者専用に作ってよい」という誤読**である。

例：RPG で「階段」をダンジョン機能が最初に必要とした。エージェントは YAGNI を理由に
`DungeonStairs`（ダンジョン型に依存し、契約も無い）として実装した。だが「階段」の責務は
「作動時にアクターを接続された場所間で移動させる」であり、この一文に「ダンジョン」は現れない。
これは「階段」という**名称・モデルを最初の消費者であるダンジョンに不要に結び付けない**根拠になる。ただし、この一文だけでは別のfeatureの「階段」と不変条件や失敗時の意味まで一致することは証明できない。

```yaml
principle: "概念はその意味の高度に置く。最初の呼び出し側は消費者であって所有者ではない。"
test: "責務を一文で述べ、feature 名が不要かを調べる。これはconsumer-neutralな命名・型付けの手掛かりであり、複数のconsumerが同一の汎用契約を共有できる証明ではない。"
yagni_bounds: "YAGNI が禁じるのは投機的な機構（使われない interface・余分な継ぎ目・早すぎる共有モジュール抽出）。概念の意味を消費者で汚染しないことは機構ではなく、YAGNI の適用対象外。"
apply:
  neutral_model: "概念は『それが何であるか』で命名・型付けする。契約・型は消費 feature の型に依存しない。"
  feature_policy: "feature 固有の差分は、概念の契約の実装・合成・パラメータとして feature 側が所有する。"
  placement_may_wait: "中立な概念が物理的に最初の消費者 module 内に居るのは可（Rule of Two/Three までは共有先へ抽出しない）。YAGNI が縛るのは置き場所と機構の量であって、意味の中立性ではない。"
semantic_identity: "共有契約に昇格する前に、候補概念の不変条件・成功/失敗の事後条件・失敗の意味・lifecycle/状態遷移・変更理由が一致する範囲を確認する。"
uncertainty: "同一性の証拠が不足する場合、意味中立な名称・型付けのまま局所に保持し、広いshared abstractionを宣言しない。"
asymmetry: "作成時に中立を保つのはほぼ無料（命名＋feature 型を import しないだけ）。後から汚染を除くのは高い（参照と semantics が拡散済み）。§6.5 の訂正コスト非対称と同型。"
independent_axes: "概念の高度（意味がどの層に属するか）と硬化深度（どこまで契約を強制するか, §6.5）は独立の軸。中立にモデル化しても地平線は下がらず、機構も増えない。"
```

### 後続の採用判断との接続（2026-09-15）

当初の原文は、一文の責務説明を概念の高度を見つける判断材料として用いた。その後の旧design-principles Issue #1では、異なる概念でも抽象化した一文にまとめられる問題が提起された。中央PR #10は、そのテストを**中立性を示すsignal**に限定し、意味の同一性を不変条件・事前/事後条件・失敗時の意味・lifecycle・変更理由で確認する修正を採用した。

- **中立な命名と型**: 最初のfeature名や型に不要に従属させない。
- **汎用契約の共有**: 複数consumerで同じ意味が成立すると確認できる場合に限る。
- **物理的な共有先への移動**: 意味が中立であっても別の判断であり、需要と安定性が確認できるまで局所配置を維持できる。

この補足は旧原文自体を修正するものではない。旧sourceはrecordsに保存し、現在の採用判断を別sourceで追跡する。

---

## Sources

- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/design-principles/source-logs/ENCAPSULATION_HORIZON_ORIGINAL_NOTES_JP.md`
- `../../records/2026-09-06-design-principles-proposals/RECORD.md`（提案時点）
- `../../records/2026-09-15-design-principles-contract-decision/RECORD.md`（修正採用）
- `../../records/2026-09-15-design-principles-proposal-status/RECORD.md`（後続の移行結果報告）
