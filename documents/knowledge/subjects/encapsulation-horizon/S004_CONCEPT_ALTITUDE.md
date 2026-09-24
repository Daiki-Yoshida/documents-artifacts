# Encapsulation Horizon — Concept Altitude

概念の意味が属する高度と、YAGNI・最初のconsumer・physical placement・hardening depthの独立性、およびEncapsulation Horizon内外でのYAGNI適用の非対称を扱う。

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

## 6.8. YAGNI across the Horizon — surface breadth と contract completeness

YAGNIはEncapsulation Horizonの全領域へ同じ強さで適用しない。
**Horizon上・外側のcontract completenessには適用を渋り、Horizon内側の投機的な機構には積極的に適用する。**

```yaml
contract_surface_breadth:
  yagni: "strong"
  rule: "現在選択した責務から導出されない将来capability・extension point・公開面を先回りして増やさない"
selected_contract_completeness:
  yagni: "weak"
  rule: "既に選択した責務から導出される意味・保証・制約・failure・resource・determinism・data semanticsを『今は使わない』だけで省略しない"
internal_mechanism:
  yagni: "strong"
  rule: "contractを満たす限り、未観測の将来に備えた内部abstraction・分割・汎用化・最適化を先払いしない"
```

したがって目標は**広いcontract**ではなく、**small surface, strong contract**である。
YAGNIはsurfaceの広さを抑制できるが、いったん選択したsurfaceの意味完全性を削る免罪符にはならない。

### 「あり得る未来」と「現在の責務から導出される意味」を分ける

contractへ含める根拠は「可能性が0ではない」ことではない。
現在選択した責務そのものから意味的に導出できるかを見る。

経路探索を例にすると、到達不能・不正入力・失敗・cancellation・resource上限等は、
採用する具体的API形状とは別として、経路探索という能力のsemanticsを閉じる際に検討すべき意味空間である。
一方、将来GPU clusterへ差し替える、複数algorithmをruntime選択する、といった事項は
現在の責務から必然的に導出されない内部・拡張上の予測であり、YAGNIで落とせる。

```yaml
responsibility_derivable:
  treatment: "contract completenessとして検討し、必要な保証を明示する"
mere_future_possibility:
  treatment: "surfaceへ先取りせず、必要になるまで実装しない"
```

### 証明責任の非対称

内部の新しい機構については「なぜ今それを作るのか」を追加側が説明する。
一方、hardening対象として選択済みのboundaryで既知の保証を省略する場合は、
**「なぜその保証を未定義または弱いまま残して安全なのか」を省略側が説明する。**

この非対称によって、外面へ設計コストを集中させ、その代わり内部では大胆な実装交換を許容する。
これは §7 の「内部の自由は境界面の完全性で買う」と同じ方向を向く。

---

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
- `../../records/2026-09-24-yagni-encapsulation-horizon-decision/RECORD.md`（YAGNI / Horizonの後続判断）
