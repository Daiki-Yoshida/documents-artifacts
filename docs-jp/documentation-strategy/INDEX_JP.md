# ドキュメント戦略 - 日本語案内

```yaml
document_type: "human_companion_index"
target_audience: "human_readers"
language: "japanese"
source: "../../artifacts/documentation-strategy/INDEX.md"
canonical_strategy_version: "2.4.0"
authority: "non_canonical"
```

このディレクトリは、人が `documentation-strategy` の背景や過去の日本語訳を確認するための補助領域です。

**現在有効な規範の唯一の正本は `../../artifacts/documentation-strategy/` です。**
この日本語領域に差分・古い表現・古いバージョンがある場合は、必ず英語正本を優先してください。

## 現在の要点

現行の documentation-strategy 2.4.0 は、次の方針を取ります。

- 優先順位は **accuracy > routing > token efficiency**。
- `documents/` はAI向けのルートですが、`documents/artifacts/` は project-owned documentation ではなく **distributor-managed guidance** です。
- `documents/artifacts/` の内容は、対象プロジェクト側の通常ドキュメントとして編集・version registry管理せず、所有する配布機構で同期・削除します。
- glossary は必須ではなく、曖昧さ・反復・言語差など、正確性に寄与するときだけ導入します。
- ディレクトリ分割は固定の「三の法則」ではありません。ファイル数は兆候の一つにすぎず、責務・権限境界・独立して読む必要性を基準に判断します。
- project-owned document の履歴・対応状態は Git と文書version/hash規約で記録します。artifact配布物のversioningはその仕組みに混ぜません。

詳細・正確なルール・Ownership Map・Quick Task Routing は、正本の
`../../artifacts/documentation-strategy/INDEX.md`
から参照してください。

## このディレクトリ内の旧詳細文書

以下の詳細な日本語文書は、documentation-strategy 2.1.0 時点を中心とした**情報源ログ / 旧訳**として保持しています。

- `DOCUMENTATION_PHILOSOPHY_JP.md`
- `FILE_AND_STRUCTURE_JP.md`
- `DOCUMENT_WORKFLOW_JP.md`

これらは現在の規範ではありません。特に旧版の directory splitting、scope、versioning、`documents/artifacts/` の扱いを、現行正本へ逆輸入しないでください。

日本語側を逐次完全同期するのではなく、現行規範は英語正本へ一本化し、日本語の旧詳細資料は設計判断の背景を確認するために保存する方針です。
