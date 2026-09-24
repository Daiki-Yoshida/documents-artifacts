# Source record: 2026-09-20-work-identity-artifactization-pr

```yaml
record_type: "verbatim_external_source_snapshot"
source_kind: "GitHub PR body"
source_url: "https://github.com/Daiki-Yoshida/documents-artifacts/pull/19"
source_created_at: "2026-09-20T21:11:12Z"
source_updated_at: "2026-09-20T21:11:22Z"
source_merged_at: "2026-09-20T21:11:22Z"
merge_commit_sha: "2ea61cb369e16dd013b644fb898e25085e6e32f9"
retrieved_date: "2026-09-24"
source_text_status: "GitHub APIで取得した現存PR本文のsnapshot。作成当時から無編集かは未検証"
record_body_policy: "PR本文は無加工。中央repository移行後にlegacy artifactへ追加された後続knowledgeの実装説明として扱う"
```

## 取得本文（原文）

~~~~text
## 概要

`WORK_IDENTITY_DESIGN_JP.md` の設計原本を、既存artifactのOwnershipへ分解して正本化します。

### development-environment-strategy 1.2.0
- Work Identity を semantic ownership/lifecycle boundary として導入
- Git/branch/worktree を Work Identity の表現手段として整理
- Project / Work / Run resource scope を追加
- `.worktrees/<work-type>/<work-name>/` を Work Root として定義
- 単一repo / 複数repoを同一Work Root形状に統一
- Work Documents の配置・Project RepositoryによるGit所有を定義
- repository派生identityとmulti-repo completion semanticsを定義
- Work Documents reconciliation / cleanupをWork lifecycleへ統合
- 旧 task identity / TASK_ID / Task Worktree 文脈をWork Identityへ置換
- nested Project Repository worktreeで `.worktrees/` を再帰materializeしない不変条件を明記

### documentation-strategy 2.5.0
- canonical Project Documents と active Work Documents を分離
- Work Documentsは `documents/INDEX.md` のversion registry対象外
- Work Documents自体にはsemantic version / last_updated_commitを要求しない
- active Work中の作成・更新・完了時reconciliationを追加
- durable knowledgeだけをcanonical `documents/` へ昇格し、Git historyを履歴として利用

### design-principles
- 変更なし。Work Identityはコード設計責務ではないため、artifact間の独立性を維持

### source log
- Work Identity設計原本を `artifactized_reference` へ更新

## 監査
- 変更artifact内に `TASK_ID` / `task identity` / `Task Worktree` / `task branch` の旧identity表現なし
- Markdown fenced code blockの開閉整合を確認
- development-environment-strategy: 1.2.0で統一
- documentation-strategy: 2.5.0で統一
- `artifacts.sh` / 配布機構 / design-principles は変更なし
~~~~
