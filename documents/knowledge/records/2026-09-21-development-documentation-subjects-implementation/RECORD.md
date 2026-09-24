# Source record: 2026-09-21-development-documentation-subjects-implementation

```yaml
record_type: "verbatim_external_source_snapshot"
source_kind: "GitHub PR body"
source_url: "https://github.com/Daiki-Yoshida/documents-artifacts/pull/26"
source_created_at: "2026-09-21T16:05:45Z"
source_updated_at: "2026-09-21T16:15:12Z"
retrieved_date: "2026-09-24"
source_text_status: "GitHub APIで取得した現存PR本文のsnapshot。作成当時から無編集かは未検証"
record_body_policy: "PR本文は無加工。直前のAI提案原文ではなく、後続の実装説明としてのみ参照する"
```

## 取得本文（原文）

~~~~text
## 概要

`documents/knowledge/subjects/` に次の2subjectを追加します。

- `development-environment/`
- `documentation/`

## Development Environment

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

- docs-jp snapshot 4文書を責務単位へ再配置
- H2 sections: 36 / 36 exactly once
- source preambles: 4 / 4 preserved once
- Work Identity以前のTask Worktree / Primary Checkout固有モデルは `S006_HISTORY.md` へ分離
- 現行worktree知識は `work-identity` subjectへroute

## Documentation

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

- docs-jp snapshot 3文書を責務単位へ再配置
- H2 sections: 30 / 30 exactly once
- source preambles: 3 / 3 preserved once
- 旧 `docs-jp/` / `artifacts/` authority、厳密な1情報1文書、version/commit registry等は `S006_HISTORY.md` へ分離
- このrepository自身のknowledge管理は `knowledge/system/` を優先

## 検証

- 新規subject本文は全file `SNNN_*.md` naming ruleに適合
- source section missing: 0
- source section duplicate: 0
- 変更範囲は `documents/knowledge/` のみ
- ユーザー指示もrecordsへ原文保存
~~~~
