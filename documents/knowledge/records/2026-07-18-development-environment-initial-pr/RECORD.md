# Source record: 2026-07-18-development-environment-initial-pr

```yaml
record_type: "verbatim_external_source_snapshot"
source_kind: "GitHub PR body"
source_url: "https://github.com/Daiki-Yoshida/development-environment-strategy/pull/1"
source_created_at: "2026-07-18T20:21:09Z"
source_updated_at: "2026-07-18T20:26:45Z"
retrieved_date: "2026-09-24"
source_text_status: "GitHub APIで取得した現存PR本文のsnapshot。作成当時から無編集かは未検証"
record_body_policy: "PR本文は無加工。会話の原文そのものとは限らない"
```

## 取得本文（原文）

~~~~text
## 概要

`development-environment-strategy` の初版を追加します。

## Exported artifacts

- `artifacts/INDEX.md`
- `artifacts/DEVELOPMENT_ENVIRONMENT_PHILOSOPHY.md`
- `artifacts/ENVIRONMENT_STANDARDS.md`
- `artifacts/WORKSPACE_STRUCTURE.md`
- `artifacts/ENVIRONMENT_WORKFLOW.md`

`INDEX + WHY + HOW + WHERE + FLOW` の5ファイル構成に限定し、タスク別ルーティングとSingle Source of Truthを明示しています。

## 主な内容

- ホストを制御面、コンテナを実行面とするDockerファースト方針
- Makefile・共通wrapper・`scripts/` の責務分担
- 対象と副作用が分かるコマンド命名
- Workspace Repository / Component Repository / Primary Checkout / Task Worktree の語彙
- `.worktrees/<component>/<task>/` を用いた並列AIエージェント開発
- worktreeごとのDocker・ネットワーク・mutable state分離
- 通常削除と強制破棄の分離
- ローカルとCIの共通実行経路
- 初期導入、Brownfield移行、検証、統合、cleanup、復旧フロー
- 開発環境変更のL0〜L3 Confirmation Gate

## Repository maintenance

- `AGENTS.md`
- `documents/INDEX.md`
- `documents/project/REPOSITORY_STRUCTURE.md`
- `copy-environment-docs.sh`
- READMEと`.gitignore`の整理

## 確認

- `main...feat/initial-artifacts`: 11ファイル、branchはmainより13コミットahead / 0 behind
- exported artifactは意図どおり5ファイル
- `documents/` と `artifacts/` の所有範囲を分離
- リポジトリ固有名・Godot固有コマンドを汎用artifactへ含めていない
- 文書リンク、ファイル名、コピー対象の一致を確認

コード実行を必要とする変更はありません。
~~~~
