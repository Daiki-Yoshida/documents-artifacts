# Documentation

このsubjectは、project documentationを正確に保存・構造化・ルーティング・保守するためのknowledgeを管理する。

このrepo自身の第1情報源管理である `documents/knowledge/` の仕組みは `../../system/` が所有し、このsubjectより優先する。

## 用語

```yaml
Project_Documentation:
  意味: "Project Root配下の documentation 全体。典型的には <project-root>/documents/ を指す"
project_level_document:
  意味: "Project Documentation内でproject全体の状態・制約・設計を扱うdocument role"
Work_Documents:
  意味: "1つのWorkに属する進行中knowledge。配置・lifecycleは work-identity が主所有する"
```

Project Root上の `documents/` というtop-level placementは `../workspace-structure/`、Work Documentsは `../work-identity/` が主所有する。このsubjectはProject Documentation内部のrouting・structure・maintenanceを所有する。

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

情報正確性、routing-first、authorityと重複、audience・local conventionなどの基本原則を扱う。

### S002_ROUTING_AND_STRUCTURE.md

INDEX、cross reference、file role、directory分割、階層projectなど、情報へ到達するための構造を扱う。

### S003_WORKFLOW.md

新規project、brownfield、継続的更新、Work Documentsからのreconciliationを扱う。

### S004_MAINTENANCE_AND_REVIEW.md

削除、再読、documentation固有の変更確認境界など、継続保守を扱う。

### S005_FORMAT_AND_GIT.md

Gitを履歴機構として使う方針、commit message、Markdown/YAML等のformatを扱う。

### S006_HISTORY.md

旧固定directory / audience分離、厳密な1情報1文書規則、document version / commit registryなど、現在のknowledge-first設計と競合する旧モデルを保持する。

## Traceability

主要source record:

```text
../../records/2026-09-21-docs-jp-snapshot/
└─ files/docs-jp/documentation-strategy/
   ├─ DOCUMENTATION_PHILOSOPHY_JP.md
   ├─ DOCUMENT_WORKFLOW_JP.md
   └─ FILE_AND_STRUCTURE_JP.md
```

旧モデルに含まれる情報は削除せず `S006_HISTORY.md` とsource recordへ保持する。

## 再編監査

```yaml
source_documents: 3
source_h2_sections: 30
missing: 0
duplicated: 0
all_sections_exactly_once: true
source_preambles_preserved_once: 3
```
