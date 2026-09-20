# Work Identity Git Materialization 実験記録

```yaml
document_type: "source_rationale_log"
target_audience: "human_readers"
language: "japanese"
authority: "non_canonical_experiment_record"
status: "artifactization_source"
related_design: "WORK_IDENTITY_DESIGN_JP.md"
test_repository: "Daiki-Yoshida/test-git-track"
tested_environment:
  os: "Linux on WSL2"
  git: "2.43.0"
```

> Work Identity / Work Root 設計のうち、Project Repository が Work Documents を追跡しながら、
> 同じ `.worktrees/` 配下に Git worktree を安全に配置できるかを実機検証した記録。
> 検証条件・失敗経路・採用手順・制約を artifact より詳細に保存する。
> 現在有効な規範は `artifacts/development-environment-strategy/` が所有する。

## 1. 検証対象

Work Identity:

```text
feat/materialization-test
```

対象形状:

```text
<project-root>/
└─ .worktrees/
   └─ feat/
      └─ materialization-test/
         ├─ documents/   # Project Repository が main で追跡する Work Documents
         └─ main/        # 同じ repository の Git worktree
```

必要な不変条件:

- Primary checkoutでは `.worktrees/feat/materialization-test/documents/` が materialize され tracked である。
- Nested worktreeでは通常repository contentが materialize される。
- Nested worktree内部へ Project-level `.worktrees/` が再帰 materialize されない。

禁止状態:

```text
.worktrees/feat/materialization-test/main/
└─ .worktrees/
   └─ feat/
      └─ materialization-test/
         └─ documents/
```

## 2. 検証repositoryと証拠

Repository:

```text
Daiki-Yoshida/test-git-track
```

準備commit:

```text
ee44a0086fdf29261352774e44ccab4de1c85852
chore: prepare Work Identity Git materialization test (#1)
```

検証branch:

```text
feat/materialization-test
```

結果記録:

```text
26ef36b35e3d11665330741085b7e1ef705ebdaf
.worktrees/feat/materialization-test/documents/RESULT.md

b99c350084df58995e4093876c0aa28e0043063e
.worktrees/feat/materialization-test/documents/NO_CHECKOUT_RESULT.md
```

## 3. Tracking ownership と materialization は別問題

検証 `.gitignore`:

```gitignore
.worktrees/*/*/*
!.worktrees/*/*/documents/
!.worktrees/*/*/documents/**
```

意味:

```text
.worktrees/<type>/<name>/documents/
    → Project Repository が追跡

.worktrees/<type>/<name>/<repository>/
    → sibling Git worktreeなので親repositoryの通常ファイルとして無視
```

このignore境界は成功したが、`.gitignore` は tracked paths のcheckoutを抑制しない。

したがって、

```text
Git tracking ownership
```

と、

```text
worktree filesystem materialization
```

は別の契約として扱う必要がある。

# 実験1 — plain worktree add

## 4. Baseline

fresh cloneから次を実行:

```bash
git worktree add \
  .worktrees/feat/materialization-test/main \
  feat/materialization-test
```

結果: **FAIL**

nested worktree内へtracked Project-level `.worktrees/` が再帰materializeした。

```text
main/
├─ .git
├─ .gitignore
├─ README.md
├─ documents/
├─ scripts/
├─ test.test
└─ .worktrees/
   └─ feat/
      └─ materialization-test/
         └─ documents/
            └─ TEST_PLAN.md
```

結論:

> raw `git worktree add` は Work Root 配下の標準作成手順として不十分。

## 5. worktree-local sparse checkout

候補:

```bash
git config extensions.worktreeConfig true

git -C .worktrees/feat/materialization-test/main \
  sparse-checkout set --no-cone '/*' '!/.worktrees/'
```

結果: **PASS**

Nested:
- 通常repository filesはmaterialize
- Project-level `.worktrees/` はfilesystemから除外
- tracked `.worktrees/**` はnested indexでskip-worktree

Primary:
- Work Documentsはmaterializeしたまま
- Primary自体はsparseにならない
- nested worktree filesystemは親repositoryのstatus noiseにならない

確認されたworktree-local状態:

```text
<repo>/.git/worktrees/main/config.worktree
  core.sparseCheckout=true
  core.sparseCheckoutCone=false

<repo>/.git/worktrees/main/info/sparse-checkout
  /*
  !/.worktrees/
```

## 6. non-coneを採用する理由

必要なsemanticsは、

```text
repositoryの通常tracked contentをすべてmaterialize
ただし Project-level .worktrees/ だけ除外
```

である。

cone modeで既知directoryだけをincludeすると、将来追加されたtop-level directoryがnested worktreeから静かに欠落する可能性がある。

そのため、

```bash
sparse-checkout set --no-cone '/*' '!/.worktrees/'
```

を採用候補とした。

## 7. 回帰試験

以下を確認しPASS:

- `git status`
- `git fetch`
- branch switch
- main merge
- rebase
- mainでtracked Work Documentを追加した後のmerge
- normal `git worktree remove`
- `git worktree prune`
- 同一pathへのrecreate

重要ケース:

```text
ec31fa764e9ab7782e96d322ff7e2a200c0a6c38
docs: add Work Document on main for merge regression test
```

をfeature側へ、

```text
9e4f6f1c310a340ef92e4f418cf7f10f1125d3a3
merge: integrate latest main (new Work Doc) into feat/materialization-test
```

で取り込んだ。

新しいWork DocumentはGit tree/indexには入るが、nested filesystemでは `.worktrees/` はmaterializeしなかった。

## 8. 実験1の残課題

worktreeをremoveすると `.git/worktrees/<id>/` とともに、
- `config.worktree`
- `info/sparse-checkout`

も削除される。

よってrecreate時にsparse policyは再適用が必要。

またplain `git worktree add` では、sparse適用前に一度だけ禁止状態がmaterializeする。

この一時的なinvariant違反をなくすため、`--no-checkout` を追加検証した。

# 実験2 — --no-checkout

## 9. 候補手順

```bash
git worktree add --no-checkout \
  .worktrees/<work-type>/<work-name>/<repository> \
  <work-branch>

git -C .worktrees/<work-type>/<work-name>/<repository> \
  sparse-checkout set --no-cone '/*' '!/.worktrees/'

git -C .worktrees/<work-type>/<work-name>/<repository> \
  reset --hard HEAD
```

## 10. Materialization timeline

Git 2.43.0 / WSL2で確認。

### A. `worktree add --no-checkout` 直後
nested contentsは `.git` のみ。nested `.worktrees/` は存在しない。

### B. `sparse-checkout set` 直後
引き続き `.git` のみ。nested `.worktrees/` は存在しない。

### C. `reset --hard HEAD` 後
通常repository filesが初めてmaterialize:

```text
.gitignore
README.md
documents/
scripts/
test.test
```

Project-level `.worktrees/` は存在しない。

結論:

> `--no-checkout → sparse policy → reset` により、Project-level `.worktrees/` をnested filesystemへ一度もmaterializeさせず作成できる。

## 11. sparse-checkout self configuration

実験2では事前に、

```bash
git config extensions.worktreeConfig true
```

を実行しなかった。

Git 2.43.0ではnested worktreeで `git sparse-checkout set` を実行すると、

common config:

```text
extensions.worktreeConfig=true
```

nested worktree config:

```text
core.sparseCheckout=true
core.sparseCheckoutCone=false
```

が自動設定され、Primary checkoutはsparse化されなかった。

artifactではGit 2.43.0を普遍的必須versionにはせず、

> projectがサポートするGit versionで worktree-local sparse checkout が正しく機能すること

をcompatibility条件とする。

古い/未検証versionをサポートする場合はbootstrap/doctorで検証する。

## 12. 実験2 回帰試験

PASS:
- nested `git status`
- `git fetch`
- temporary branch switch
- mainで新規Work Document追加
- feature branchへのmain merge
- normal worktree remove
- prune
- same-path recreate
- recreate後のA/B/C timeline

main regression commit:

```text
f78bcebb1290473293ae2c5030af13fc0397cb50
docs: add Work Document on main for no-checkout regression test
```

feature merge:

```text
7599c43670cef78e47fff8b98ff776b8ceae4e49
merge: integrate main (NO_CHECKOUT_REGRESSION doc) into feat/materialization-test
```

mainで増えたWork Documentsをbranchへ取り込んでもnested filesystemに `.worktrees/` はmaterializeしなかった。

# 採用判断

## 13. Work Root layout

**変更不要。**

実証済み:

```text
.worktrees/<work-type>/<work-name>/
├─ documents/
└─ <repository>/
```

- Work DocumentsをProject Repository mainでtrack可能
- 同一repositoryを含むGit worktreeを兄弟配置可能
- single/multi repositoryの統一形状を維持可能

## 14. Worktree Materialization Contract

Nested repository worktreeは、Project-level `.worktrees/` をfilesystemへmaterializeしてはならない。

標準作成候補:

```bash
git worktree add --no-checkout <worktree-path> <work-branch>

git -C <worktree-path> \
  sparse-checkout set --no-cone '/*' '!/.worktrees/'

git -C <worktree-path> \
  reset --hard HEAD
```

この3操作は人間が毎回個別入力する低レベル手順ではなく、

> **Work Identity Git worktree creation operation**

としてproject-owned wrapper/scriptにまとめるべきである。

理由:
- transientなrecursive materializationも起こさない
- sparse適用漏れを防ぐ
- recreate時にも同じcontractを保証
- 人間/AIの判断と手順数を減らす

## 15. Creation invariants

作成完了時:

Primary checkout:
- Work Documents materialized
- Work Documents tracked by Project Repository
- sibling repository worktree pathは親repositoryで通常ファイルとしてignore

Nested worktree:
- intended Work branch
- ordinary repository content materialized
- Project-level `.worktrees/` absent
- worktree-local sparse configuration active

## 16. Recreation invariant

worktree-local sparse stateはworktree removalとともに消える。

したがって、再作成でも必ず、

```text
--no-checkout
↓
worktree-local sparse policy
↓
materialize
```

を再実行する。

## 17. Version / compatibility boundary

実機確認:

```text
Git 2.43.0
Linux / WSL2
```

generic artifactは特定OS/Git 2.43.0に固定しない。

代わりに、Work Root materialization contractを使うprojectは、

> サポート対象Git versionでworktree-local sparse checkoutが成立すること

を保証する。

未検証/古いGitを正式サポートする場合はbootstrap/doctorで検証する。

## 18. artifact反映対象

`WORKSPACE_STRUCTURE.md`:
- recursive materialization invariantを実装済みcontractへ昇格
- tracking ownershipとmaterializationの区別
- non-cone `/*` + `!/.worktrees/`
- creation/recreationごとのworktree-local sparse policy

`ENVIRONMENT_WORKFLOW.md`:
- worktree creationをatomic project-owned operationとして扱う
- `--no-checkout → sparse-checkout set → reset --hard HEAD`
- create後のPrimary/Nested invariant check
- recreateでも同じprocedure
- raw `git worktree add` を標準Work Root作成手順にしない

`ENVIRONMENT_STANDARDS.md`:
- supported Git versionでworktree-local sparse checkoutを保証
- low-level multi-step setupをproject-owned helperでencapsulate
- diagnosticsでmaterialization状態を確認可能にする

## 19. 最終結果

```yaml
work_root_layout: "validated"
work_documents_on_main: "validated"
nested_same_repo_worktree: "validated"
gitignore_ownership_boundary: "validated"
plain_worktree_add: "fails recursive-materialization invariant"
worktree_local_sparse_checkout: "validated on Git 2.43.0"
zero_transient_recursive_materialization: "validated with --no-checkout"
merge_rebase_switch_regression: "validated"
main_work_document_growth: "validated"
remove_prune_recreate: "validated"
layout_redesign_required: false
artifact_action: "encode Worktree Materialization Contract and atomic creation operation"
```
