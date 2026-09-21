# Encapsulation Horizon — Concept Altitude

概念の意味が属する高度と、YAGNI・最初のconsumer・physical placement・hardening depthの独立性を扱う。

## 6.7. 概念の高度 — YAGNI は「機構」を縛るのであって「意味」を縛らない

§6.5 の「module より下は既定で柔軟」「予期的分割は YAGNI 違反」には既知の誤読がある。
**「最初の消費者しかいない概念は、その消費者専用に作ってよい」という誤読**である。

例：RPG で「階段」をダンジョン機能が最初に必要とした。エージェントは YAGNI を理由に
`DungeonStairs`（ダンジョン型に依存し、契約も無い）として実装した。だが「階段」の責務は
「作動時にアクターを接続された場所間で移動させる」であり、この一文に「ダンジョン」は現れない。
つまり**概念の意味の高度は feature より上**にあり、ダンジョンは最初の消費者にすぎない。

```yaml
principle: "概念はその意味の高度に置く。最初の呼び出し側は消費者であって所有者ではない。"
test: "その単位の責務を一文で述べる。文に feature 名が不要なら、概念は feature より汎用。"
yagni_bounds: "YAGNI が禁じるのは投機的な機構（使われない interface・余分な継ぎ目・早すぎる共有モジュール抽出）。概念の意味を消費者で汚染しないことは機構ではなく、YAGNI の適用対象外。"
apply:
  neutral_model: "概念は『それが何であるか』で命名・型付けする。契約・型は消費 feature の型に依存しない。"
  feature_policy: "feature 固有の差分は、概念の契約の実装・合成・パラメータとして feature 側が所有する。"
  placement_may_wait: "中立な概念が物理的に最初の消費者 module 内に居るのは可（Rule of Two/Three までは共有先へ抽出しない）。YAGNI が縛るのは置き場所と機構の量であって、意味の中立性ではない。"
asymmetry: "作成時に中立を保つのはほぼ無料（命名＋feature 型を import しないだけ）。後から汚染を除くのは高い（参照と semantics が拡散済み）。§6.5 の訂正コスト非対称と同型。"
independent_axes: "概念の高度（意味がどの層に属するか）と硬化深度（どこまで契約を強制するか, §6.5）は独立の軸。中立にモデル化しても地平線は下がらず、機構も増えない。"
```

---

## Sources

- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/design-principles/source-logs/ENCAPSULATION_HORIZON_ORIGINAL_NOTES_JP.md`
