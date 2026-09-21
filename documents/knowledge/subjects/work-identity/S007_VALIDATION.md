# Work Identity — Reference Validation

Worktree command contractのreference implementation検証、fresh-clone test、post-reviewで発見した問題、修正と再検証、実証範囲を扱う。

## 対象

Repository:

```text
Daiki-Yoshida/test-git-track
```

Work Identity:

```text
feat/worktree-command-reference
```

Reference implementation:

```text
Makefile
scripts/worktree-manager.sh
```

Public interface:

```bash
make worktree-create WORK=feat/example REPO=main [BASE=origin/main]
make worktree-status WORK=feat/example REPO=main
make worktree-remove WORK=feat/example REPO=main
```

このrepositoryはsingle-repository検証だが、public inputは将来multi-repositoryへ拡張しても変わらないよう、

```text
WORK + REPO
```

を維持した。

---

## 実装したcontract

### create

- WORK / REPO validation
- deterministic branch/path resolution
- exact valid existing worktreeはidempotent no-op success
- branch ownership conflictを拒否
- unrelated target path contentを拒否
- missing branchはexplicit BASEまたはdocumented default baseから作成
- REPO=mainではWorktree Materialization Contractを適用
- postcondition verification
- partial failure時は今回作成したstateだけをnon-force rollback

### status

non-mutatingで以下を表示:

- Work Identity
- repository selector
- repository root
- branch
- worktree path
- registered state
- branch owner
- dirty state
- sparse/materialization state
- nested Project-level `.worktrees/` presence
- Work Documents tracking/materialization state

### remove

- WORK + REPOから対象を解決
- dirty worktreeを拒否
- normal non-force removal
- branchは削除しない
- Work Documentsは削除しない
- Work Root全体は削除しない
- sibling worktreeは触らない

---

## Primary checkout invocation boundary

参照実装はProject Repository Primary checkoutからのみproject-level helperを実行可能とした。

理由:

linked worktree内部から相対的にproject rootを求めるだけでは、そのlinked checkout自身をProject Rootとして誤認する可能性がある。

参照実装では、

```text
git rev-parse --absolute-git-dir
git rev-parse --git-common-dir
```

を比較し、linked worktreeからの呼び出しをfail-closedにした。

実機検証:

nested worktree内から、

```bash
make worktree-status WORK=feat/something REPO=main
```

を実行すると、

```text
ERROR: run this project-level worktree command from the Project Repository Primary checkout, not from a linked worktree
```

で停止。

nested checkoutを新たなProject Rootとして扱わず、nested `.worktrees/` も生成しなかった。

generic contractでは「必ずPrimary checkoutからしか呼べない」と普遍化する必要はないが、

> project-level helperはProject Rootをstable/explicitに解決しなければならず、linked worktreeを偶然Project Rootとして推定してはならない

というinvariantを保持する。

Primary checkout限定は、そのinvariantを満たす安全で単純なproject policyの一例。

---

## Fresh-clone validation

初回検証で以下すべてPASS:

| Case | Result |
|---|---|
| shell syntax / help | PASS |
| status before create | PASS |
| missing branch create | PASS |
| worktree-local sparse materialization | PASS |
| status after create | PASS |
| idempotent create | PASS |
| dirty remove refusal | PASS |
| unrelated path conflict | PASS |
| invalid base | PASS |
| branch ownership conflict | PASS |
| linked-worktree invocation guard | PASS |
| clean remove | PASS |
| recreate | PASS |
| Primary Work Documents | PASS |
| input validation | PASS |

Materialization:

```text
--no-checkout
↓
worktree-local sparse policy
↓
reset --hard HEAD
```

によりnested Project-level `.worktrees/` はmaterializeしなかった。

---

## Post-verification reviewで発見した問題

初回参照実装ではmissing Work branchを、

```bash
git branch <work-branch> origin/main
```

で作成していた。

Git 2.43.0では `branch.autoSetupMerge` の影響により、新しいWork branchへ、

```text
upstream = origin/main
```

が設定された。

例:

```text
branch.feat/worktree-command-smoke.remote=origin
branch.feat/worktree-command-smoke.merge=refs/heads/main
```

これはbase refを「開始commit」として使いたいだけなのに、後続のplain `git pull` semanticsまでmain追従へ変える。

初回検証ではharmless caveatとして記録されたが、post-reviewで参照contract上のsemantic defectと判断した。

---

## 修正

Commit:

```text
d6ae75b1608fdbc1185f411b02d3513f41eae1b1
fix: avoid tracking base branch for new Work branches
```

missing branch creation:

```bash
git branch --no-track <work-branch> <base>
```

へ変更。

一方、same-name remote Work branchが既に存在する場合は、

```bash
git branch --track <work-branch> origin/<work-branch>
```

を維持。

意味:

```text
base ref
  = new branch starting point

upstream
  = later synchronization target

these are separate decisions
```

---

## Focused revalidation

fresh cloneで修正後を再検証。

Test Work:

```text
feat/worktree-command-upstream-retest
```

結果:

- syntax PASS
- create PASS
- branch start commit = origin/main
- `branch.<work>.remote` unset
- `branch.<work>.merge` unset
- `%(upstream:short)` empty
- Materialization Contract PASS
- status PASS
- idempotent create PASS
- remove PASS
- recreate PASS
- recreate後もupstream unset
- Primary Work Documents PASS

結論:

> missing Work branchのbase refとupstreamは明確に分離する必要がある。

---

## その他の観測

### worktree removal後のbranch

normal removeではbranchは残る。これはcontractどおり。

### recreate

worktree-local sparse stateはremoveで消えるため、recreate時にMaterialization Contractを再適用してPASS。

### duplicate registry

live state判定は `git worktree list --porcelain`、Git refs、filesystemから行い、独自worktree registryは作成しなかった。

### Git config inspection

Git 2.43.0環境では複数keyを一つの `git config --get-regexp` alternationで確認する手法に観測上の癖があった。
artifactでは特定のdiagnostic one-linerを規範化せず、必要状態を診断可能であることだけを要求する。

---

## 検証範囲

実証済み:

```yaml
repository_topology: "single repository"
repo_selector: "main"
materialization_case: "Project Repository itself as linked worktree"
git: "2.43.0"
os: "WSL2/Linux"
```

未実証:

- 実際の複数repository mapping
- independent Component Repositoryのnormal materialization path
- macOS / Windows native Git
- older/newer Git versions全域

したがって、multi-repository command shape自体は設計contractとして維持するが、この参照実装検証だけを根拠にmulti-repository implementationまで実証済みとは扱わない。

---

## 最終評価

```yaml
public_worktree_contract: "validated for REPO=main"
work_plus_repo_input: "validated"
idempotent_create: "validated"
conflict_guards: "validated"
materialization_contract: "validated"
primary_checkout_guard: "validated"
dirty_remove_refusal: "validated"
remove_recreate: "validated"
base_ref_as_start_point: "validated"
base_ref_not_automatic_upstream: "validated after review fix"
same_name_remote_tracking: "implementation policy retained; not the base-ref case"
multi_repo_implementation: "not yet validated"
distribute_reference_shell_as_artifact: false
artifact_action: "record branch/upstream separation and stable Project Root resolution"
```

## Sources

- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/development-environment-strategy/source-logs/WORK_IDENTITY_WORKTREE_REFERENCE_VALIDATION_JP.md`
