# Source record: Subject consistency convergence — 2026-10-03

```yaml
record_type: "multi-source-event record"
record_date: "2026-10-03"
work_identity: "docs/subject-consistency-convergence"
purpose: "8 subject横断監査で発見したWork Identity / Project Root / generic DIR / Artifact v2導入後のcanonical不整合を、修正前の第0情報源として保存する"
immutability_policy: "既存recordを変更せず、このdirectoryを新規追加する"
source_events:
  - "ChatGPT会話内のユーザーメッセージ3件"
  - "GitHub Issue #164 body snapshot"
body_policy:
  chat_user_messages: "無要約・無抜粋・無言い換え"
  github_issue_sources: "GitHub connectorで取得した現存bodyを無加工保存"
```

## Files

- `USER_MESSAGES.md` — 今回の監査・継続・全修正指示に直接関係するユーザー原文
- `ISSUE_164_BODY.md` — Issue #164本文のsnapshot

## Provenance note

Issue #164は、読み取り専用横断監査で得たF1–F13と修正方針を固定するために作成した。
subjectsへの意味変更は、このrecord追加後にIssue #164の決定内容を根拠として行う。

historical records / history subject内の旧layout・旧authority記述は、現行規範と明示的に分離されている限り削除しない。
