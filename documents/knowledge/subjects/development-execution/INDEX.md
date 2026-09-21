# Development Execution

このsubjectは、**開発処理をどこで・どの実行環境で・どの公開入口から実行するか**を扱う。

Project/repositoryの静的配置は `../workspace-structure/`、Work単位のownership/lifecycleは `../work-identity/`、破壊操作や診断・復旧の安全境界は `../development-safety/` が主所有する。

## 構成

```text
development-execution/
├─ INDEX.md
├─ S001_EXECUTION_MODEL.md
├─ S002_HOST_AND_CONTAINER.md
├─ S003_COMMAND_INTERFACE_AND_CI.md
├─ S004_ADOPTION_AND_MIGRATION.md
└─ S005_HISTORY.md
```

### S001_EXECUTION_MODEL.md

実行環境を契約として扱う基本モデル、制御面と実行面、再現性を扱う。

### S002_HOST_AND_CONTAINER.md

host/container責務、Docker-first、resource materialization、mount/cache/network/secret等の実装基準を扱う。

### S003_COMMAND_INTERFACE_AND_CI.md

公開command、操作の意味、local/CIの実行経路を扱う。

### S004_ADOPTION_AND_MIGRATION.md

新規projectとbrownfieldへの導入・移行を扱う。

### S005_HISTORY.md

旧development-environment umbrellaの責務定義・authority・誤読防止を歴史として保持する。

## 境界

```text
workspace-structure
  Project全体の静的構造

work-identity
  1つのWorkの意味・ownership・lifecycle

development-execution
  実際の開発処理をどう実行するか

development-safety
  その操作をどう安全に行い、診断・復旧するか
```

## 再編監査

旧development-environment全体の再編監査は、workspace-structure / development-execution / development-safety / work-identityを横断して実施した。

```yaml
source_documents: 4
source_h2_sections: 36
missing: 0
duplicated: 0
all_sections_exactly_once: true
source_preambles_preserved_once: 4
```
