# Source record: 2026-09-21-development-subject-split-implementation

```yaml
record_type: "verbatim_external_source_snapshot"
source_kind: "GitHub PR body"
source_url: "https://github.com/Daiki-Yoshida/documents-artifacts/pull/27"
source_created_at: "2026-09-21T19:08:20Z"
source_updated_at: "2026-09-21T23:39:05Z"
retrieved_date: "2026-09-24"
source_text_status: "GitHub APIで取得した現存PR本文のsnapshot。作成当時から無編集かは未検証"
record_body_policy: "PR本文は無加工。直前のAI提案原文ではなく、後続の実装説明としてのみ参照する"
```

## 取得本文（原文）

~~~~text
## 概要

umbrella化していた `subjects/development-environment/` を廃止し、責務別subjectへ分解します。

```text
subjects/
├─ workspace-structure/
├─ development-execution/
├─ development-safety/
└─ work-identity/   # 既存。前身Task Worktreeモデルをhistoryへ統合
```

## 新しい責務境界

- `workspace-structure`: project全体の静的repository/filesystem構造、Git ownership、multi-repository
- `development-execution`: host/container、Docker-first、公開command、local/CI、reproducibility、導入/移行
- `development-safety`: destructive operation、diagnostics、recovery、integration、confirmation boundary
- `work-identity`: Workの意味・ownership・lifecycle・resource identity・worktree。既存主責務を維持

## Work Identityへの統合

Work Identity導入以前のTask Worktree / Primary Checkout / task resource identity等の9 sectionを、
`work-identity/S008_HISTORY.md` へ前身モデルとして移管しました。

## Subject model

`system/SUBJECT_MODEL.md` にsubject粒度の規則を追加。

- subjectは単なるカテゴリ/umbrellaではない
- 名前を主語に独立した概念・責務・制約・lifecycleを説明できる単位
- ownership衝突や異なる判断軸のごった煮が発生したら分解
- `development-environment` は今後、人間向け総称としては使えるがsubject authorityは持たない

## 情報保存監査

- source documents: 4
- source H2 sections: 36
- 36 / 36 exactly once
- missing: 0
- duplicated: 0
- source preambles: 4 / 4 preserved once
- residual legacy `Task Worktree` terminology in current normative safety files: 0
- `subjects/development-environment/`: removed
- subject本文の `SNNN_*.md` naming: PASS
- non-knowledge changes: 0

## 記録

今回のユーザー判断は `records/2026-09-22-development-environment-subject-split/` に原文保存しています。
## Workspace Structure / Work Identity 共存修正

追加監査で、旧development-environment由来のWorkspace本文にWork Identity導入前の定義がnormativeに残っていたため修正。

### 修正した矛盾

- 旧 `.worktrees/<component>/<task-identity>/` と現行 `.worktrees/<work-type>/<work-name>/<repository>/` の衝突
- `.worktrees/` 全体ignoreと、Work DocumentsをProject Repositoryがtrackする現行contractの衝突
- Task Worktreeを現行基本概念として扱う記述と、Work Identity側のhistorical扱いの衝突

### 接続contract

- `workspace-structure`: Project Repository / Project Root / Workspace Repository / Component Repository / stable repository identity / project-level Git ownership
- `work-identity`: Work Identity / Work Root / Work Documents / `.worktrees/` 内部構造 / repository-specific worktree / Work lifecycle / REPO mapping

### 保存

修正前のWorkspace Structure本文は `workspace-structure/S003_HISTORY.md` に原文保持。

### 再監査

- old forbidden normative terms / layouts: 0
- source H2 sections: 36 / 36 exactly once
- missing: 0
- duplicate: 0
- source preambles: 4 / 4 preserved once
~~~~
