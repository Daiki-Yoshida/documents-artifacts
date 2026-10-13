# Record — Work Records proposal and Issue #204

```yaml
record_format: 1
record_kind: bundle
recorded_date: "2026-10-13"
scope: "2026-10-13のWork Records Protocolに関するChatGPT設計相談・元のWork Documents意図の訂正・Issue #204起案時点のsource event群"
source_issue: "https://github.com/Daiki-Yoshida/documents-artifacts/issues/204"
```

## Source inventory

| Payload | Source / locator | Coverage | Fidelity |
|---|---|---|---|
| `USER_MESSAGES.md` | このChatGPT会話のユーザー発言。永続的な個別message locator未取得 | 初期問題提起、Work終了後archive提案、Work Documents原意の訂正、Issue化と記録の指示という選定した4メッセージの本文。会話全体ではない | 画面上で利用できる本文からの手動転記。要約・言い換えは意図しないが、原文API exportとのbyte-for-byte一致、空白/改行の完全一致は未検証。本文外側のevent見出しとfenceは新設 |
| `DESIGN_CONTEXT.md` | このChatGPT会話における最後のユーザー指示の直前のassistant返信。個別message locator未取得 | ユーザーの「かなりよさそう」を理解するため、直前のassistant返信1件を選定して本文を収録。その他のassistant返信、ツール出力、会話全体は収録していない | 画面上の返信内容をMarkdown/DILを含めて手動転記。要約を目的としないが、原文API exportとのbyte-for-byte一致とレンダリングによる変化は未検証 |
| `ISSUE_204_BODY.md` | GitHub Issue #204: https://github.com/Daiki-Yoshida/documents-artifacts/issues/204 | Issue作成直後に取得したIssue本文全体（コメントと後日編集は対象外） | GitHub connectorが返したIssue `body` 文字列を無加工で保存 |

## Record boundary and relation

このBundleはIssue #204起案時の**範囲を確定したsource event集合**であり、このtopicに関する全Chat/全Issue履歴ではない。Chat側は選定したuser eventの順序を保持し、短い最終指示が参照する直前のassistant提案を別payloadで保存する。Issue本文は後続の独立したsource eventであり、Chatの原文に置き換えない。

保存対象の意味として、ユーザーはリポジトリの開発過程を失わないためのWork Recordsを提案し、Work中はWork Documents、完了後は通常参照しないProject-owned archiveへの移管を支持した。また、**元のWork DocumentsはProject Documentationへのreconciliation後に不要部分を削除し、Git履歴で追える**という初期設計意図を明示した。

ただし、Issue化・source保存の指示はWork Records Protocolの最終仕様確定や実装開始・mergeの包括承認ではない。発火条件、必要な記録粒度、archive移管の具体契約、既存subjectの改定はIssue #204で今後解決する。

`record_kind: bundle`は保存形状であり、内容のcurrent/superseded等の評価ではない。後続の設計決定、実装結果、レビューは新たなsource eventとして別recordに記録し、このBundleに追記しない（原文転記誤りの訂正は除く）。

## Authority

これは第0情報源の保存であり、正本への昇格ではない。現行のRecord Modelは `../../system/RECORD_MODEL.md`、Work Documentsの現在規約は `../../subjects/work-identity/S003_WORK_DOCUMENTS.md` が所有する。`subjects/` と `artifacts/` はこの取り込みによって変更しない。
