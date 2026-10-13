# Record — Issue #189 record intake regulation adoption

```yaml
record_format: 1
record_kind: bundle
recorded_date: "2026-10-13"
scope: "Issue #189 の新規record intake: B案（bounded source-event bundle）の選択と実装指示"
source_issue: "https://github.com/Daiki-Yoshida/documents-artifacts/issues/189"
```

## Source inventory

| Payload | Source / locator | Coverage | Fidelity |
|---|---|---|---|
| `ISSUE_189_BODY.md` | GitHub Issue #189: https://github.com/Daiki-Yoshida/documents-artifacts/issues/189 | 2026-10-13取り込み時点のIssue本文全体。後続コメントや会話履歴は含まない | GitHubから取得した本文を無加工保存 |
| `USER_MESSAGES.md` | このChatGPT会話のユーザー発言（永続的な個別message locatorは未取得） | 設計相談開始、B案選択、実装指示の3件を選定して全文収録。会話全体ではない | 各収録メッセージの本文は無要約・無言い換え。event見出し・fenceは追加した外枠 |
| `DESIGN_CONTEXT.md` | このChatGPT会話の先行assistant返信（個別message locator未取得） | B案の詳細提案について選択した返信1件の全文。会話全体は含まない | 会話表示からMarkdown/DILを含む本文を転記。再構成要約ではない。APIエクスポートとのbyte-for-byte一致は未検証 |

## Relation

このBundleは、Issue #189の既存方針から具体的な保存条件を選択した時点の採用判断と着手指示を収録する。Decision Lineage上の採否の対象を `ISSUE_189_BODY.md` と `DESIGN_CONTEXT.md` に関連付け、出典ごとの忠実性の差を区別する。

`record_kind: bundle` は保存形状を表すもので、採用・承認等の判断種別とは独立する。今後の実装報告・レビュー・完了判断は新しいsource eventとして別recordに追加してよい。これらの記録を理由に本Bundleの元の発言を改変しない。

## Scope

これはhistorical sourceの保存であり、現行record形式の正本は `../../system/RECORD_MODEL.md`、運用導線は `../../../project/KNOWLEDGE_UPDATE_WORKFLOW.md` が所有する。既存recordsの一括変更は行わない。
