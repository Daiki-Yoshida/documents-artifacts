# Development Environment

このsubjectは、開発環境を安全・再現可能・診断可能な契約として扱うためのknowledgeを管理する。

Work Identity固有のWork Root、Work Documents、worktree materialization、worktree command contractは `../work-identity/INDEX.md` が所有する。

## 構成

```text
development-environment/
├─ INDEX.md
├─ S001_PRINCIPLES.md
├─ S002_EXECUTION_STANDARDS.md
├─ S003_SAFETY_AND_LIFECYCLE.md
├─ S004_ADOPTION_AND_MIGRATION.md
├─ S005_WORKSPACE_AND_REPOSITORIES.md
└─ S006_HISTORY.md
```

### S001_PRINCIPLES.md

開発環境を契約として扱う考え方、優先順位、host/container責務、再現性、安全性と使いやすさの関係を扱う。

### S002_EXECUTION_STANDARDS.md

host依存境界、Docker-first、公開command、local/CI parityなど、実行面の基準を扱う。

### S003_SAFETY_AND_LIFECYCLE.md

破壊的操作、診断、統合、cleanup、復旧、確認レベル、再読条件を扱う。

### S004_ADOPTION_AND_MIGRATION.md

新規projectへの導入とbrownfieldへの段階的導入を扱う。

### S005_WORKSPACE_AND_REPOSITORIES.md

Workspace Repository / Component Repository、top-level構造、Git管理境界、複数component、workspace tool dependencyを扱う。

### S006_HISTORY.md

Work Identity導入以前のTask Worktree / Primary Checkoutモデル、旧artifact境界など、現在の知識と混ぜると誤読しやすい歴史的情報を保持する。

## Traceability

主要source record:

```text
../../records/2026-09-21-docs-jp-snapshot/
└─ files/docs-jp/development-environment-strategy/
   ├─ DEVELOPMENT_ENVIRONMENT_PHILOSOPHY.md
   ├─ ENVIRONMENT_STANDARDS.md
   ├─ ENVIRONMENT_WORKFLOW.md
   └─ WORKSPACE_STRUCTURE.md
```

このsubjectは上記recordを責務単位へ再配置している。旧Task Worktree固有の内容は削除せず `S006_HISTORY.md` へ分離している。

## 再編監査

```yaml
source_documents: 4
source_h2_sections: 36
missing: 0
duplicated: 0
all_sections_exactly_once: true
source_preambles_preserved_once: 4
```

旧Task Worktree / Primary Checkout固有のsectionは削除せず `S006_HISTORY.md` に保持している。
