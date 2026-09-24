# Source record: 2026-08-02-task-resource-ownership-pr

```yaml
record_type: "verbatim_external_source_snapshot"
source_kind: "GitHub PR body"
source_url: "https://github.com/Daiki-Yoshida/development-environment-strategy/pull/2"
source_created_at: "2026-08-02T17:35:24Z"
source_updated_at: "2026-08-02T17:42:02Z"
retrieved_date: "2026-09-24"
source_text_status: "GitHub APIで取得した現存PR本文のsnapshot。作成当時から無編集かは未検証"
record_body_policy: "PR本文は無加工。会話の原文そのものとは限らない"
```

## 取得本文（原文）

~~~~text
## 変更内容

- `artifacts/ENVIRONMENT_WORKFLOW.md` の既存Cleanup節を補強
- task-scoped resourceを、タスク終了時に「削除済み」または「理由を伴って意図的に保持」のどちらかへ確定する規則を追加
- worktreeを作らなかった場合にも、作成したcontainer・network・volume等のtask-scoped runtime resourceを確認するよう明記
- 所有者や理由が不明な残存resourceを完了状態として扱わないことを明記
- `docs-jp/ENVIRONMENT_WORKFLOW.md` を同じ意味で同期

## 背景

問題はworktreeの利用そのものではなく、worktreeごとに作成されたfolder・Git metadata・container・network・volume等が、タスク終了後も判断されないまま残ることです。

既存のworktree選択基準や通常cleanup / destructive purgeの区別を維持しつつ、作成したtask-scoped resourceのライフサイクルを閉じる最小差分にしています。

## 影響

- 新しいArtifactや専用schemaは追加しません
- shared resourceやpersistent dataをtask cleanupで削除する規則にはしていません
- destructive operationの確認レベルは変更していません
- `strategy_version` は、既存方針の明確化として据え置いています

## 確認

- `main` との差分: 2 files changed
- 英語正本と日本語版の意味を同期
- 文書のみの変更で、実行コードやCIへの変更なし
~~~~
