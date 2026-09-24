# 日本語ドキュメント（legacy）

> **現在の正本は [documents/knowledge/](../documents/knowledge/INDEX.md) です。**
> `docs-jp/` は旧来の補助説明・source log・実験経緯を参照するためのlegacy領域であり、現在のnormative authorityではありません。`artifacts/` は第1情報源からprojectionされたArtifact v2のAI runtime guidanceです。

## 保存状態

2026-09-21時点の `docs-jp/` 全16ファイルは、次の原文snapshotに保存されています。

- [Snapshot manifest](../documents/knowledge/records/2026-09-21-docs-jp-snapshot/MANIFEST.md)

manifestに記録された旧commitの16ファイルとsnapshotのGit blob SHAが一致することを確認済みです。旧文書内部の「artifactsが正本」という記述は、**当時の歴史的方針**として記録されたものであり、現在の参照順位には適用しません。

## このdirectoryの利用

- 日本語の旧補助説明・設計根拠・実験結果の原文を確認するために参照できます。
- 特定の提言が現在も採用されているかは、後続recordと `documents/knowledge/subjects/` を確認します。
- source logの旧表現や旧authorityを、現在の結論として扱いません。
- 有用な未移行情報を発見した場合は、[Knowledge Update Workflow](../documents/project/KNOWLEDGE_UPDATE_WORKFLOW.md) に従って根拠を確認し、必要ならrecords・subjectsへ反映します。
- `docs-jp/` の本文は `artifacts.sh` の配布対象ではありません。

```text
docs-jp/
├─ design-principles/
├─ documentation-strategy/
└─ development-environment-strategy/
```

第0→第1→第2情報源の順序は [Knowledge Model](../documents/knowledge/system/KNOWLEDGE_MODEL.md) を参照してください。
