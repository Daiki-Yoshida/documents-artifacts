# Work Identity — Worktree Commands

Work Identityとrepository selectorからGit worktreeを安全に作成・診断・削除するpublic semantic contractを扱う。

## 目的

Worktree Materialization Contractは実機検証済みだが、routine callerが毎回、

- path導出
- branch導出
- `--no-checkout`
- sparse適用要否
- sparse pattern
- materialization
- post-condition確認
- recreate時の再適用

を判断・入力する運用は避ける。

public commandの責務は、Work Identityとrepository selectorから必要なGit操作を一意に解決し、安全な最終状態まで持っていくこと。

```text
Work Identity + Repository Selector
              ↓
project-owned command
              ↓
branch/path/materialization policy resolution
              ↓
verified Git worktree
```

---

## Public semantic operations

exact CLI syntaxは各projectが所有するが、意味上は最低限次の3操作を持つ。

```yaml
worktree_create: "required; create or reuse the requested Work Identity repository checkout safely"
worktree_status: "required; inspect resolved identity/path/branch/materialization without mutation"
worktree_remove: "required; remove only the selected Git worktree after safety checks"
```

Makefileをpublic routerとして使うprojectでは、既存命名規則と衝突しない限り次を推奨する。

```text
worktree-create
worktree-status
worktree-remove
```

複雑なGit処理はMakefile本文へ埋めず、`scripts/`等のproject-owned implementationへ委譲する。

---

## Routine caller inputs

単一repository / 複数repositoryで同じ入力形を使う。

```yaml
required:
  WORK: "<work-type>/<work-name>"
  REPO: "<stable project repository selector>"
conditional:
  BASE: "new branch creation時。projectにdocumented default baseがある場合は省略可能"
```

重要:

- `REPO`は単一repositoryでも省略しない。例: `main`。
- callerにworktree filesystem pathを入力させない。
- callerにsparse適用要否を入力させない。
- callerにbranch名を原則入力させない。projectのdeterministic mappingから導出する。
- branchが存在しない場合、現在のHEADを暗黙baseにしない。

単一repo例:

```text
WORK=feat/pathfinding
REPO=main
```

複数repo例:

```text
WORK=feat/user-auth REPO=front
WORK=feat/user-auth REPO=back
```

---

## Repository selector

`REPO` が参照するstable repository identity / role /基準locationは `../workspace-structure/` が所有する。Work Identity側は、そのstatic mappingをWork単位のbranch/path/materializationへ変換する責務を持つ。

`REPO`はWork Root直下のdirectory名とrepository identityを安定して対応させるproject-owned selector。

```text
.worktrees/feat/user-auth/front/
.worktrees/feat/user-auth/back/
```

selectorから最低限次を解決できる必要がある。

```yaml
repository_resolution:
  source_repository: "which Git repository owns this checkout"
  worktree_directory_name: "path component under the Work Root"
  branch_mapping: "how the base Work Identity maps to this repository branch"
  project_repository_role: "whether this repository carries Project-level tracked .worktrees/** state"
```

このmappingのためだけに、現在worktree一覧やDocker state等を複製したmanifestを作らない。
`git worktree list`、Git refs、filesystem、Docker等、それぞれの実システムを状態source of truthとする。

---

## Branch resolution

Work IdentityとREPOからbranchをdeterministically解決する。

単一repoの典型:

```text
WORK=feat/pathfinding
REPO=main
→ branch=feat/pathfinding
```

複数repoではproject conventionに従う。

```text
feat/user-auth/front
feat/user-auth/back
```

または他のdocumented deterministic form。

branch resolution rules:

```yaml
existing_local_branch: "reuse if it is not already assigned to another incompatible writable worktree"
existing_remote_branch: "create/select the appropriate local tracking branch according to project policy"
missing_branch:
  allowed: "only when a documented base ref is resolved"
  base_resolution: "explicit BASE or documented project default"
  forbidden_default: "current HEAD merely because it happens to be checked out"
```

branch creationとworktree materializationは一つのpublic create operation内で扱ってよいが、base selectionは曖昧にしない。

---

## Path resolution

caller inputからpathをdeterministically導出する。

```text
<project-root>/.worktrees/<work-type>/<work-name>/<repository-selector>/
```

例:

```text
WORK=feat/pathfinding REPO=main
→ .worktrees/feat/pathfinding/main/

WORK=fix/session REPO=front
→ .worktrees/fix/session/front/
```

routine callerがabsolute/relative pathを自由入力するinterfaceにしない。

---

## Create preflight

mutation前に最低限確認する。

```yaml
preflight:
  - "Project Root / selected repository resolution succeeds"
  - "Work Identity syntax is valid for the project"
  - "repository-specific branch resolves deterministically"
  - "new branch requires an explicit/documented base"
  - "target path is absent, or is the exact already-registered worktree being requested"
  - "no unrelated filesystem content occupies the target path"
  - "the selected branch is not owned by another incompatible writable worktree"
  - "Project Repository ignore boundary covers the sibling worktree path where required"
  - "supported Git/materialization capability is available when the Materialization Contract applies"
```

fail closed。既存pathを自動削除・上書きして進めない。

---

## Create behavior

createはcallerから見てatomicな意味操作とする。

### Materialization Contractが必要なrepository

selected branch treeがProject-level tracked `.worktrees/**` coordination stateを含む場合:

```bash
git worktree add --no-checkout <resolved-path> <resolved-branch>

git -C <resolved-path> \
  sparse-checkout set --no-cone '/*' '!/.worktrees/'

git -C <resolved-path> \
  reset --hard HEAD
```

### 独立Component Repository

Project-level tracked `.worktrees/**` を持たないrepositoryでは、同じsparse exclusionを無条件適用しない。
helperがproject role / branch treeから適用要否を解決する。

routine callerにはこの差を見せない。

---

## Create postconditions

成功を返す前に検証する。

```yaml
common:
  - "registered Git worktree path equals resolved path"
  - "selected branch equals resolved Work branch"
  - "one writable checkout ownership invariant holds"
project_checkout:
  - "Work Documents remain materialized/tracked"
  - "sibling worktree path does not appear as ordinary untracked project content"
materialization_contract_case:
  - "ordinary repository content is materialized"
  - "nested Project-level .worktrees/ is absent"
  - "worktree-local sparse state is active"
```

postconditionが成立しないcreateを成功扱いしない。

---

## Idempotency

同じ `WORK + REPO` でcreateを再実行したとき:

```yaml
exact_existing_valid_worktree: "no-op success; report existing resolved state"
existing_but_invalid_or_conflicting_state: "fail with diagnosis; do not repair destructively by default"
target_path_unrelated_content: "fail"
branch_checked_out_elsewhere: "fail or report existing owner according to project policy; do not steal it"
```

routine createをforce-repair commandにしない。

---

## Partial-failure rollback

createの途中で失敗した場合、helper自身が今回作成した状態だけを対象にrollbackしてよい。

例:

```text
worktree add --no-checkout succeeded
↓
sparse setup failed
↓
newly-created clean worktreeをnormal removalでrollback
```

ただし:

- 既存worktreeを削除しない。
- `--force`を通常rollbackで使わない。
- rollback自体に失敗した場合は残存path/Git metadataを明示して終了する。
- branch deletionはrollbackに含めない。新規branchを作成した場合も、削除は明示的policyがない限り別判断とする。

---

## Status contract

`worktree-status WORK=... REPO=...` はnon-mutating。

最低限表示:

```yaml
status_fields:
  - "Work Identity"
  - "repository selector and resolved repository root"
  - "resolved branch"
  - "resolved worktree path"
  - "registered/not registered"
  - "current branch/HEAD when present"
  - "clean/dirty state"
  - "whether Materialization Contract applies"
  - "sparse/materialization state when applicable"
  - "whether nested Project-level .worktrees/ is absent/present"
  - "Work Documents path and Project Repository tracking visibility where relevant"
```

Git状態は`git worktree list`等から読み、custom registryを真実源にしない。

---

## Remove contract

`worktree-remove WORK=... REPO=...` は選択されたGit worktreeだけを対象にする。

preconditions:

```yaml
remove_preflight:
  - "resolved path is a registered worktree of the expected repository"
  - "resolved identity/branch match expectation"
  - "worktree has no uncommitted changes"
  - "commits are preserved according to project policy"
```

behavior:

- normal `git worktree remove`; forceしない。
- 必要ならstale metadataを限定的にprune。
- branchを削除しない。
- Work Documentsを削除しない。
- Work Root全体を削除しない。
- 他repositoryのsibling worktreeを削除しない。

Work全体のcompletion / Work Documents reconciliation / Work Root removalは上位Work lifecycleの責務。

---

## Command/output semantics

成功時はmachine/human双方が追えるよう、最低限resolved stateを返す。

```yaml
success_output:
  work: "resolved Work Identity"
  repository: "repository selector"
  branch: "resolved branch"
  path: "resolved worktree path"
  action: "created | existing | removed | status"
  materialization: "normal | worktree-local-sparse"
```

失敗時はnon-zero exit。secretを出力しない。

---

## Confirmation boundary

通常のcreate/status/removeは、既にWork Identityが確認され、requested effectが明確なら追加確認を要求しない。

ただし次は別のexplicit/destructive operation:

- dirty worktreeのforce removal
- branch deletion
- unpreserved commitの破棄
- Work Root全体のpurge
- shared runtime/cache削除

---

## なぜREPOを単一repoでも必須にするか

単一repoだけ特別扱いしてREPOを省略すると、projectが後からmulti-repo化したときにpublic contractが変わる。

またAIは、

```text
single repoなら引数1つ
multi repoなら引数2つ
```

という判断を持つ必要が生じる。

常に、

```text
WORK + REPO
```

をpublic identity inputとすることで、filesystem shapeとcommand shapeの両方を単一/multi repoで統一する。

---

## 最終設計

```yaml
routine_identity_input: ["WORK", "REPO"]
path_input_from_caller: false
sparse_decision_from_caller: false
branch_name_input_by_default: false
branch_mapping: "project-owned deterministic policy"
missing_branch_base: "explicit BASE or documented project default; never accidental current HEAD"
state_source_of_truth: "Git/filesystem/runtime systems themselves; no duplicate worktree registry"
create: "idempotent, fail-closed, atomic semantic operation"
status: "non-mutating diagnosis"
remove: "normal selected-worktree removal only; branch/Work Documents/Work Root remain separate"
single_multi_repo_command_shape: "uniform WORK + REPO"
```

## Sources

- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/development-environment-strategy/source-logs/WORK_IDENTITY_WORKTREE_COMMAND_CONTRACT_JP.md`
