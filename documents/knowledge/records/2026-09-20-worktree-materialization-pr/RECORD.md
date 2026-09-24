# Source record: 2026-09-20-worktree-materialization-pr

```yaml
record_type: "verbatim_external_source_snapshot"
source_kind: "GitHub PR body"
source_url: "https://github.com/Daiki-Yoshida/documents-artifacts/pull/20"
source_created_at: "2026-09-20T22:45:27Z"
source_updated_at: "2026-09-20T22:45:42Z"
source_merged_at: "2026-09-20T22:45:42Z"
merge_commit_sha: "349615bdb541c852bd6a0b7287cbb0998cf34133"
retrieved_date: "2026-09-24"
source_text_status: "GitHub APIで取得した現存PR本文のsnapshot。作成当時から無編集かは未検証"
record_body_policy: "PR本文は無加工。中央repository移行後にlegacy artifactへ追加された後続knowledgeの実装説明として扱う"
```

## 取得本文（原文）

~~~~text
## 概要

`Daiki-Yoshida/test-git-track` で行った2段階のGit実機検証を source/rationale log として保存し、その結果を `development-environment-strategy` へ圧縮して反映します。

### 実験記録
- plain `git worktree add` で tracked Project-level `.worktrees/` が再帰materializeするbaselineを記録
- worktree-local non-cone sparse checkoutで解消できることを記録
- `--no-checkout -> sparse-checkout set -> reset --hard HEAD` により一時的な再帰materializationも防げることを記録
- merge/rebase/switch/Work Document追加/remove/prune/recreate回帰を記録
- Git 2.43.0 / WSL2 という検証境界を保持

### development-environment-strategy 1.3.0
- Worktree Materialization Contractを定義
- tracking ownership と filesystem materialization を分離
- applicable repositoryに対するworktree-local non-cone sparse exclusionを規範化
- Work Root worktree creationをproject-owned atomic operationとして定義
- raw `git worktree add` をtracked Project-level `.worktrees/**` がある場合の標準手順から除外
- recreation時のsparse再適用を明記
- supported Git versionでworktree-local sparse checkoutを検証する責務を追加

### 過剰一般化の防止
- sparse exclusionは、選択repositoryのbranch treeがProject-level tracked `.worktrees/**` を含む場合に適用
- 独立Component Repositoryの無関係なtracked `.worktrees/` を無条件に隠さない
- project-owned helperが適用判断を所有し、routine callerには低レベル分岐を見せない

### 非変更
- Work Root layout自体は変更なし
- documentation-strategy / design-principles / artifacts.sh は変更なし
~~~~
