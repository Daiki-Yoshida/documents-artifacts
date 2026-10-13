## Issue #204 — 実装前レビュー・着手計画（2026-10-13）

ユーザーより「実装に進もうか」と明示されたため、実装対象と現行 `main` の制約を照合した。本コメントは**実装計画の記録**であり、Work Identity確定前のbranch/worktree/source変更は行わない。

### Work Identity 提案と開始ゲート

- **提案:** `feat/work-records-protocol`
- **目的:** AI/ツール/オーケストレーションに依存しない軽量なWork Recordsの保存・完了移管規約を、canonical subjects → Artifact v2へ実装する
- **Work Identityの明示的なユーザー確認:** PENDING（既存の `artifacts/project/WORK_IDENTITY.md` とsource `work-identity/S001_IDENTITY_MODEL.md` に従う）
- **操作範囲:** User確認後、専用branchの作成、該当records/subjects/artifacts/testsへの限定変更、利用可能なローカル検証、独立レビュー用PR。main直接commitや無断mergeは行わない

### 対応関係

1. **Source保存:** 初期sourceを収録した[PR #205](https://github.com/Daiki-Yoshida/documents-artifacts/pull/205)は現時点でOpen。初期recordは保持し、後続ユーザー判断/Issueコメントを新規の独立したsource eventとしてrecordsへ追加する。PR #205のmerge状況を確認し、必要に応じてstacked branch/PRで取り込む。
2. **正本:** `subjects/work-identity/S003_WORK_DOCUMENTS.md` が進行中Recordのownership、保存先、完了後Archiveを所有。`S004_LIFECYCLE_AND_RESOURCES.md` が完了ゲートと移管/cleanup順序を所有。
3. **正本:** `subjects/documentation/S003_WORKFLOW.md` が現行Project Documentationへのreconciliationと、Work Recordsという履歴資料に限ったarchive exception・routingを所有。`subjects/engineering-operation/S006_VERSION_CONTROL_AND_REPORTING.md` が記録タイミング・結果と証拠の区別・Gitへのcommit/push authorityを所有。
4. **Artifact:** `project/WORK_IDENTITY.md`、`project/WORK_LIFECYCLE.md`、`documentation/WORKFLOW_AND_MAINTENANCE.md`、`operation/VERSION_CONTROL_AND_REPORTING.md` を中心にpurpose-directed projection。rootは必要なrouting変更のみ。単なる説明のために旧案を広げない。
5. **検証:** `bash tests/test-knowledge-integrity.sh`、`bash tests/test-artifacts.sh`、`bash tests/test-agent-harness.sh` を実行可能な許可済み環境で確認し、さらにWork Recordsに限ったarchive移管と失敗時保全をfocusedなfixture/testで検証する。実行不能・未検証はPASSと表現しない。

### 既存回帰テストとの関係

既存`documentation-maintenance-reconciliation`のfixtureはWork Recordsを持たず、「Work Documents全体をjust-in-caseでarchiveしない」ことを評価する。今回追加するのは**Records限定の意図的なアーカイブ**であり、既存の正本reconciliationと非Recordsのcleanup原則を維持する。歴史的なraw results/evaluationsを後から書き換えない。

### 意図した最小運用

- Work進行中: 意味のある区切りで自由Markdownへ軽量checkpoint。コマンド全件・Chat全文の収録や定期的な監視/commitは不要。
- 保存と公開: file write、Git commit、push、Project baseline publicationは別段階。自動的なVCS権限拡大はない。
- Work完了時: integration/outcome確認 → durable knowledgeを正本へreconcile → Record締め → `documents/archive/works/<work-type>/<work-name>/`へ移管・検証 → Work Documents/Work resourcesの安全な整理。
- Archive: 通常のAI実行では読まない、現在仕様を上書きしない履歴資料。既存dest衝突や移管失敗時は元Recordsを保全し、Work完了を保留する。
- 非目標: 役割固有の開発オーケストレーション、外部runner/CIの追加、プロジェクト固有の監視プログラム、別バージョンDB/台帳。

**現状態:** 読み取り調査とこの実装準備コメントのみ。Work Identity明示確認待ち。