# Documentation

このsubjectは、project documentationを正確に保存・構造化・ルーティング・保守するためのknowledgeを管理する。

このrepo自身の第1情報源管理である `documents/knowledge/` の仕組みは `../../system/` が所有し、このsubjectより優先する。

## 構成

```text
documentation/
├─ INDEX.md
├─ S001_PRINCIPLES.md
├─ S002_ROUTING_AND_STRUCTURE.md
├─ S003_WORKFLOW.md
├─ S004_MAINTENANCE_AND_REVIEW.md
├─ S005_FORMAT_AND_GIT.md
└─ S006_HISTORY.md
```

### S001_PRINCIPLES.md

情報正確性、AI向けdocumentation、汎用性などの基本原則を扱う。

### S002_ROUTING_AND_STRUCTURE.md

INDEX、cross reference、file role、directory分割、階層projectなど、情報へ到達するための構造を扱う。

### S003_WORKFLOW.md

新規project、brownfield、継続的更新という主要workflowを扱う。

### S004_MAINTENANCE_AND_REVIEW.md

削除、再読、構造変更時の確認境界など、継続保守を扱う。

### S005_FORMAT_AND_GIT.md

Gitによる履歴、commit message、Markdown/YAML等のformatを扱う。

### S006_HISTORY.md

旧 `docs-jp/` / `artifacts/` 配置、厳密な1情報1文書規則、document version / commit registryなど、現在のknowledge-first設計と競合しうる旧モデルを保持する。

## Traceability

主要source record:

```text
../../records/2026-09-21-docs-jp-snapshot/
└─ files/docs-jp/documentation-strategy/
   ├─ DOCUMENTATION_PHILOSOPHY_JP.md
   ├─ DOCUMENT_WORKFLOW_JP.md
   └─ FILE_AND_STRUCTURE_JP.md
```

旧モデルに含まれる情報は削除せず `S006_HISTORY.md` へ分離している。
