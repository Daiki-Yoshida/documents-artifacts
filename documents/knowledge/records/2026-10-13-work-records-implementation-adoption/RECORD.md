# Record — Work Records protocol adoption and implementation authorization

```yaml
record_format: 1
record_kind: bundle
recorded_date: "2026-10-13"
scope: "Issue #204の長時間稼働記録・Work完了フローに関する後続設計判断と、Work Identityを明示した実装開始承認"
```

## Source inventory

| Payload | Source / locator | Coverage | Fidelity |
|---|---|---|---|
| `ISSUE_COMMENT_6143925024.md` | [Issue #204 comment 6143925024](https://github.com/Daiki-Yoshida/documents-artifacts/issues/204#issuecomment-6143925024) | 2026-10-13に記録されたユーザー訂正・設計了承の選定eventを含む、このcomment本文全体 | GitHub connectorから取得したcomment bodyを無加工で保存。埋め込まれたChat user messagesは元コメント記載の手動転記でありAPIとのbyte equalityは未検証 |
| `ISSUE_COMMENT_6144512278.md` | [Issue #204 comment 6144512278](https://github.com/Daiki-Yoshida/documents-artifacts/issues/204#issuecomment-6144512278) | Work Identity `feat/work-records-protocol` と実装範囲・前提を提示したcomment本文全体 | GitHub connectorから取得したcomment bodyを無加工で保存 |
| `USER_APPROVAL.md` | このChatGPT会話のユーザーによる直前の実装開始承認（個別message URLは取得できない） | 明示的なWork Identity確認に続くユーザー返信1件の全文。会話全体は含まない | 会話表示から手動転記。API byte identityは未検証。保存用外枠を追加した |

## Relation and effective scope

本Bundleは採用済みの方針・実装開始権限に関する第0情報源を保存する。以前の記録 `../2026-10-13-work-records-proposal/` （PR #205）を上書きしない。ユーザー了承は共通開発記録の設計方針、Work Identity、許可された実装とPR作成を対象とする。Project所有の具体的な命令や権限は引き続き有効であり、規約反映後のtarget project自動同期、外部CI実行、無断mergeを許可した記録ではない。

Work Records Protocolの意味とcurrent statusは関連するsubjectが所有する。このBundleの保存形状はeventの採否やcurrent/supersededを意味しない。後続の実装・独立レビュー・受け入れ結果は新しいsource eventとして扱う。
