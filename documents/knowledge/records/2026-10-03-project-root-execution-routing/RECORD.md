# Source record: Project Root / execution routing — 2026-10-03

```yaml
record_type: "multi-source-event record"
record_date: "2026-10-03"
work_identity: "feat/project-root-execution-routing"
purpose: "Project RootをAI development sessionの入口とし、Project Repository側のpublic command interfaceからgeneric DIR selectorでexecution targetを指定する設計議論の第0情報源保存"
immutability_policy: "既存recordを変更せず、このdirectoryを新規追加する"
source_events:
  - "ChatGPT会話内のユーザーメッセージ5件"
  - "GitHub Issue #148 body snapshot"
  - "GitHub Issue #148 comment #5958273589 snapshot"
  - "GitHub Issue #148 comment #5958401218 snapshot"
body_policy:
  chat_user_messages: "無要約・無抜粋・無言い換え"
  github_issue_sources: "GitHub connectorで取得した現存bodyを無加工保存"
```

## Files

- `USER_MESSAGES.md` — 今回の設計判断に直接関係するユーザー原文
- `ISSUE_148_BODY.md` — Issue #148本文のsnapshot
- `ISSUE_148_COMMENT_5958273589.md` — DIR/public command設計コメントのsnapshot
- `ISSUE_148_COMMENT_5958401218.md` — 実装前ブラッシュアップコメントのsnapshot

## Provenance note

ユーザーの短い採用・進行判断だけから承認対象を推測復元しないため、対応するAI設計内容はIssue #148の本文・コメントを別source eventとして同じrecord directoryへ保存する。

このrecord追加時点では、既存の `documents/knowledge/subjects/`、`artifacts/`、既存 `records/` 本文は変更しない。
