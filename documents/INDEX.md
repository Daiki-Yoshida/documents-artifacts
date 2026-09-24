# Documents Index

このrepository内のfile化された情報では、`knowledge/` を常に最優先の情報源とする。

## Routing

```yaml
第1情報源:
  target: "knowledge/INDEX.md"

repository更新フロー:
  target: "project/KNOWLEDGE_UPDATE_WORKFLOW.md"

repository構造:
  target: "project/REPOSITORY_STRUCTURE.md"

第2情報源:
  target: "../artifacts/"
  note: "AI向け派生情報。疑義があればknowledgeへ戻る"

legacy_source_logs:
  target: "../docs-jp/"
  note: "旧来の人間向け説明・実験/source log。2026-09-21時点はknowledge/recordsへ原文snapshot済みで、現在のauthorityではない"
```

## 優先順位

```text
documents/knowledge/
  ↓
repository-local derived documents
  ↓
artifacts/
  ↓
target-project copies
```

`documents/project/` はこのrepositoryの運用説明であり、knowledgeと意味が衝突した場合はknowledgeを優先してproject文書側を修正する。
