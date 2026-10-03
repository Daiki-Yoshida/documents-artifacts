# Source record: Project / Component documentation boundary — 2026-10-03

```yaml
record_type: "multi-source-event record"
record_date: "2026-10-03"
work_identity: "docs/project-component-documentation-boundary"
purpose: "旧parent/child repository・hierarchical project modelをhistoryへ退避し、Project Repository / Component Repository責務モデルへDocumentation ownershipを収束する設計判断の第0情報源保存"
immutability_policy: "既存recordを変更せず、このdirectoryを新規追加する"
source_events:
  - "ChatGPT会話内のユーザーメッセージ2件"
  - "GitHub Issue #167 body snapshot"
body_policy:
  chat_user_messages: "無要約・無抜粋・無言い換え"
  github_issue_sources: "GitHub connectorで取得した現存bodyを無加工保存"
```

## Files

- `USER_MESSAGES.md` — 今回の概念整理・実装開始指示に直接関係するユーザー原文
- `ISSUE_167_BODY.md` — Issue #167本文のsnapshot

## Decision boundary

Current normative terminology:

```text
Project Repository / プロジェクト管理リポジトリ / 管理リポジトリ
Component Repository / コンポーネントリポジトリ
```

Old parent/child repository / hierarchical project management terminology is preserved as history, not current repository-role authority.
