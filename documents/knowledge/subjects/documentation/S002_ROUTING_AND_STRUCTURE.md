# ドキュメント — ルーティングと構造

情報を削るのではなく責務ごとに配置し、INDEX・cross reference・file role・progressive disclosureによって必要情報へ到達させる考え方を扱う。

Project Root上の `documents/` の存在・top-level placementは `../workspace-structure/` が主所有する。この文書はその内部構造を扱う。

## 切り詰めよりルーティング

```yaml
principle: "情報量を削るのではなく、必要な情報へ到達しやすくする"
mechanisms:
  index_file: "documentation treeへのrouting entry"
  cross_references: "関連authorityへ接続する"
  responsibility_split: "fileごとに主責務を明確にする"
  progressive_disclosure: "入口 → 概要 → 詳細"
```

1 file = 1 information を強制しない。fileの主語や責務が繰り返し変わる場合に分割を検討する。

## 2. ファイル役割

Project DocumentationにINDEXを置く場合、その主目的は**routing**である。

```yaml
index_role:
  - "主要documentとそのpurpose"
  - "task / concernから読むべきdocumentへのrouting"
  - "必要なcross reference"
not_required:
  - "documentごとのSemantic Version registry"
  - "last_updated_commit registry"
  - "全fileを必ず一行ずつ列挙する完全inventory"
```

inventoryを持つ場合も、routingの役に立つ範囲へ限定し、registry自体を別の状態source of truthにしない。

## Agent entry

`AGENTS.md`、`CLAUDE.md` 等を使う場合はproject固有の入口として利用できる。

原則:

- projectが実際に使用する入口だけ用意する。
- 詳細knowledgeを複製せず、Project Documentationへroutingする。
- agent固有の差異がなければ、同じ情報を各entryへ大量複製しない。

## 7. ディレクトリ分割ガイド

`documents/project/`、`documents/reference/`、`documents/<topic>/` は有効な構成例だが必須templateではない。

```yaml
project_level:
  meaning: "project全体の現在状態・目的・制約・設計"
reference:
  meaning: "必要時に参照する仕様・schema・標準・用語"
topic_directory:
  meaning: "独立して理解・保守する価値のあるまとまったknowledge"
```

directoryを増やす判断はfile数だけではなく、責務の独立性・routing改善・ownership境界で行う。

## 3. 相互参照とルーティング戦略

- 相対pathを基本とする。
- authorityを持たないdocumentは、必要な文脈を短く再述した上で主所有documentへlinkしてよい。
- linkだけでは読解不能になる場合、意味の完全性を優先する。
- rename / move時は参照元を同時に更新する。

## 8. 階層プロジェクト

repository / projectの静的関係は `../workspace-structure/` が所有する。

documentation側では、各componentが独立したdocumentation lifecycleを必要とする場合にだけ独自のdocumentation entryを持たせる。親子関係だけを理由に各childへ固定の `documents/` treeを強制しない。

親level documentationはcomponentの高levelな責務・接続を説明できるが、component内部のauthorityを重複所有しない。

## Work Documentsとの接続

進行中Workの設計・調査・検証は `../work-identity/S003_WORK_DOCUMENTS.md` が所有する。

Work完了時に恒久knowledgeへ昇格する情報は、Project Documentationの既存authorityへreconcileする。配置先の判断はこのsubjectのrouting / structure規則に従う。

## Sources

- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/documentation-strategy/DOCUMENTATION_PHILOSOPHY_JP.md`
- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/documentation-strategy/DOCUMENT_WORKFLOW_JP.md`
- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/documentation-strategy/FILE_AND_STRUCTURE_JP.md`
- `../../records/2026-09-22-six-subject-cross-audit-fixes/`
