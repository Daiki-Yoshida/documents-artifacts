# Source record: 2026-09-20-worktree-command-contract-pr

```yaml
record_type: "verbatim_external_source_snapshot"
source_kind: "GitHub PR body"
source_url: "https://github.com/Daiki-Yoshida/documents-artifacts/pull/21"
source_created_at: "2026-09-20T22:51:25Z"
source_updated_at: "2026-09-20T22:51:34Z"
source_merged_at: "2026-09-20T22:51:34Z"
merge_commit_sha: "d53b76ad4c0f004b1233ca30542944eae1d3baae"
retrieved_date: "2026-09-24"
source_text_status: "GitHub APIで取得した現存PR本文のsnapshot。作成当時から無編集かは未検証"
record_body_policy: "PR本文は無加工。中央repository移行後にlegacy artifactへ追加された後続knowledgeの実装説明として扱う"
```

## 取得本文（原文）

~~~~text
## 概要

Worktree Materialization Contractをroutine運用へ落とすため、Work Identity Git worktreeのpublic command contractを追加します。

### source/rationale log
- `WORK_IDENTITY_WORKTREE_COMMAND_CONTRACT_JP.md` を追加
- `WORK + REPO` を単一/multi repo共通のroutine identity inputとして定義
- path/branch/materialization判断をproject-owned helperへ集約
- idempotency / fail-closed / partial-failure rollback / remove境界を記録

### development-environment-strategy 1.4.0
- worktree-create / worktree-status / worktree-remove相当のsemantic operationsを定義
- 単一repoでもREPO selectorを必須化しpublic contractを統一
- routine callerからpath / sparse判断 / branch名を除外
- branchが無い場合はexplicit BASEまたはdocumented default baseを要求し、偶然のcurrent HEADを使わない
- REPO selectorからrepository root / Work Root child / branch / repository roleをdeterministicに解決
- create preflight / idempotent existing success / postconditions / non-destructive rollbackを定義
- removeはselected worktreeだけを対象としbranch / Work Documents / Work Root / siblingを削除しない
- live worktree stateはGit自身をsource of truthとし、duplicate registryを作らない

### docs-jp
- INDEXを1.4.0へ同期
- 旧Task/TASK_ID表現を除去
- Work Identity / Materialization / public command contractの人間向け入口を更新

### 非変更
- Work Identity / Work Root layout自体は変更なし
- documentation-strategy / design-principles / artifacts.sh は変更なし
~~~~
