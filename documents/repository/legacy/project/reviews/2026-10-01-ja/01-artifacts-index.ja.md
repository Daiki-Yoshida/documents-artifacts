# 監査用参考訳（非正本）

原文: `artifacts/INDEX.md`、コミット `93b0fab575f28698e61ae56202004eeab75d6861`、[固定版の原文](https://github.com/Daiki-Yoshida/documents-artifacts/blob/93b0fab575f28698e61ae56202004eeab75d6861/artifacts/INDEX.md)

GPT-6-Luna（high）による翻訳

# AIエンジニアリングガイダンス

このディレクトリには、リポジトリの正本となる知識から導出された、再利用可能なエンジニアリングガイダンスが含まれます。

## 必要最小限を読む

既定では、すべてのファイルを読まないでください。まずここから始め、タスクを特定してから、関連するルーターまたは個別ガイダンスファイルだけを開いてください。

プロジェクト固有の指示、アーキテクチャ、コマンド、制約は、この再利用可能なガイダンスを意図的に特化させている場合、そちらを優先してください。これらの成果物からプロジェクト固有の事実を作り出さないでください。

このディレクトリは、管理対象の派生スナップショットです。プロジェクト固有のルールや恒久的な修正を作るために、インストール済みの成果物コピーを編集しないでください。ローカルの上書きはプロジェクト所有の指示やドキュメントに記載し、再利用可能なガイダンスは正本のソースで修正して再配布してください。

## タスク別の参照先

| タスク | 読むファイル |
|---|---|
| 通常のコード変更／リファクタリング | `operation/CHANGE_LIFECYCLE.md` → `implementation/INDEX.md` |
| 新しいAPI／境界／アーキテクチャ | `design/INDEX.md` + `operation/CHANGE_LIFECYCLE.md` + 関連する実装ガイダンス |
| 依存関係／DI | `implementation/DEPENDENCIES.md` |
| ドメインモデル／DTO／マッピング | `implementation/DOMAIN_AND_DATA.md` |
| 障害／非同期処理／並行性 | `implementation/FAILURE_AND_ASYNC.md` |
| テスト | `implementation/TESTING.md` |
| 公開契約の変更 | `design/CONTRACTS.md` + `implementation/COMPATIBILITY.md` |
| パフォーマンスを主因とする再設計 | `implementation/PERFORMANCE.md`。相互作用の形が変わる場合は `design/CONTRACTS.md` も参照 |
| ドキュメント | `documentation/INDEX.md`。ドキュメントがエンジニアリング変更の一部である場合は `operation/CHANGE_LIFECYCLE.md` も参照 |
| プロジェクト／リポジトリの構造 | `project/WORKSPACE.md` |
| Work Identity（作業の識別情報）／ライフサイクル | `project/WORK_IDENTITY.md`。必要に応じて `project/WORK_LIFECYCLE.md` も参照 |
| worktree の操作 | `project/WORKTREES.md`。破壊的操作には安全ガイダンスを追加 |
| リポジトリの統合／マージ／リベース | `safety/INTEGRATION_AND_CONFIRMATION.md` → `operation/VERIFICATION_AND_DONE.md` |
| スコープ／権限／確認、アプローチのみの場合／既存コードベースへの着手、コミット／プッシュ／報告の判断 | `operation/INDEX.md` |
| Docker／ビルド／テスト／CI環境 | `execution/INDEX.md` |
| 削除／クリーンアップ／リセット／復旧 | `safety/INDEX.md` |

## 全体に適用する原則

公開境界は明確かつ限定的に保ち、内部は柔軟にしてください。YAGNIを適用して、選択済みの契約を完成させるのが高コストだからという理由で弱めるのではなく、推測に基づく公開面や内部機構を避けてください。
