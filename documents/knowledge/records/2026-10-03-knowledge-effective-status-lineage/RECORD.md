# Source record: Knowledge effective status / Decision Lineage — 2026-10-03

```yaml
record_type: "multi-source decision record"
record_date: "2026-10-03"
work_identity: "docs/knowledge-effective-status-lineage"
purpose: "records→subjects→artifacts間でsource completeness / semantic completeness / current-effective projectionを分離し、subjectsがsemantic knowledgeを捨てずeffective statusを明示するKnowledge System contractの採用"
immutability_policy: "既存recordを変更せず、このdirectoryを新規追加する"
source_events:
  - "ChatGPT会話内のユーザーメッセージ"
  - "GitHub Issue #171 body"
  - "GitHub Issue #171 design comments"
decision_lineage:
  event: "adoption"
  scope: "knowledge promotion / subject effective-status model"
  adopts:
    - "GitHub Issue #171 final design proposal"
  corrects:
    - "Issue #171初期案: subjectsをcurrent effective viewだけとしてsuperseded semantic knowledgeを除外してよい、という方向"
```

## Adopted principle

```text
records
  = source completeness

subjects
  = semantic completeness + effective-status resolution

artifacts
  = current-effective runtime projection
```

subjectsはsemantic knowledgeを「obsoleteだから」という理由で削除しない。

current / superseded / rejected / unresolvedを明示し、substantial non-current semantic modelsはHISTORY等の明示的non-current areaへ整理する。

recordはimmutable eventを表し、可変な `current` statusをrecord自身へ固定しない。

## Files

- `USER_MESSAGES.md` — 設計変更・採用・実装開始に関するユーザー原文
- `ISSUE_171_BODY.md` — 実装承認後のIssue #171 body snapshot
- `ISSUE_171_DECISION_COMMENTS.md` — 方針修正・推奨設計・最終設計proposalのIssue comments
