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

このsectionは、projectが **Work Identity worktree lifecycle capabilityを採用する場合** のpublic semantic surfaceを定める。Work Identityが存在するだけで、全project / 全Workへworktreeを要求しない。

capabilityを採用したprojectでは、exact CLI syntaxは各projectが所有するが、意味上は最低限次の3操作を持つ。

```yaml
worktree_create: "required when capability is adopted; create or reuse the requested Work Identity repository checkout safely"
worktree_status: "required when capability is adopted; inspect resolved identity/path/branch/materialization without mutation"
worktree_remove: "required when capability is adopted; remove only the selected Git worktree after safety checks"
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

このcapabilityを採用するProjectで対象directoryが可変の場合、Make-based public interfaceは**generic `DIR=<directory-path>`を優先する**。Worktree操作では、パスを**検証対象のlocator**として受け取り、内部でWork IdentityとRepository Selectorを解決する。

~~~bash
make DIR=.worktrees/feat/pathfinding/project/ worktree-create
make DIR=.worktrees/feat/pathfinding/project/ worktree-status
make DIR=.worktrees/feat/pathfinding/project/ worktree-remove

make DIR=.worktrees/feat/user-auth/front/ worktree-status
make DIR=.worktrees/feat/user-auth/back/ worktree-status
~~~

Public command名・supportするpath形状はProjectが明示する。`WORK + REPO`を公開入力に使う従来interfaceは互換・Project固有の選択として残せるが、**汎用規約で必須としない**。

内部identityのconceptual inputは次のとおり。

~~~yaml
WORK: "<work-type>/<work-name>"
REPO: "<stable project repository selector>"
BASE: "missing Work branchの開始refにdocumented defaultがない場合のみ必要"
~~~

Project-owned resolverは`DIR`とcanonical Work Root/repository mappingを照合し、確定したWork Identityおよびstable REPOを返す。単一repository Projectでも**内部**Repo Selectorは明示的に解決する。`DIR`の指定やfilesystem pathの存在そのものはWork確定・操作権限を意味しない。

Callerにはsparse-checkout適用要否やbranch名を原則指定させず、branchのstart refを偶然のcurrent HEADから推定しない。

単一RepositoryのWorktreeを操作するcommandにWork Rootのみを指定しても、複数参加Repositoryから対象を一意に決定できなければfailする。Work全体に対するoperationを別途Projectが明示的に定義した場合のみ、その範囲の解決を行う。

## Repository selector

`REPO` が参照するstable repository identity / role /基準locationは `../workspace-structure/` が所有する。Work Identity側は、そのstatic mappingをWork単位のbranch/path/materializationへ変換する責務を持つ。

`REPO`はWork Root直下のdirectory名とrepository identityを安定して対応させるproject-owned selector。**Git branch名ではない。** selectorが `main` という文字列であっても、それはrepository identityであり、baseline branchが `main` であることを意味しない。

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
  management_root_repository_role: "whether this repository owns / can receive Project-level tracked .worktrees/** coordination state"
```

このmappingのためだけに、現在worktree一覧やDocker state等を複製したmanifestを作らない。
`git worktree list`、Git refs、filesystem、Docker等、それぞれの実システムを状態source of truthとする。

---

## Branch resolution

Work IdentityとREPOからbranchをdeterministically解決する。

単一repoの典型:

```text
WORK=feat/pathfinding
REPO=project
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

## Path resolution / generic `DIR`との境界

Work-specific Repository worktreeのcanonical path:

~~~text
<project-root>/.worktrees/<work-type>/<work-name>/<repository-selector>/
~~~

公開`DIR`はパスを表すだけ。worktree create/status/removeを選んだoperationが、Project Root基準で解決したパスを**正規配置の候補**として扱い、Work Identity + REPO + branch/path/materializationをdeterministically解決する。

~~~text
DIR=.worktrees/feat/pathfinding/project/
  → validated WORK=feat/pathfinding
  → validated REPO=project
  → project-owned branch/base/path resolution
  → create/status/remove with existing safety gates
~~~

これはcallerに任意のGit worktree配置先を指定させるAPIではない。対象はProject-ownedの正規pathへ完全一致し、pathの字句解釈だけでGit ownershipや許可を決めない。

- relative `DIR`はProject Root基準。末尾slashの無害な差は同じtargetとして正規化する。shell fragmentとして評価しない。
- 存在するpath/親のrealpath、symlink、境界外参照、unexpected content、stable repository mappingを照合する。absolute/outside-Project-Rootの扱いは明示的なProject authorityに従う。
- **create**は最終target directoryが存在しなくてもよい。その場合も存在する祖先、想定のcanonical shape、Git repository/branch ownership、衝突・予期せぬ内容をpreflightする。
- **status**は未作成の正規pathも非変更で診断し、registered/not registeredを正確に報告する。既存登録がある場合のみ、その登録path・branch・owner・clean/dirty等を照合する。
- **remove**は既存の登録済みGit worktreeだけを対象にし、期待path、branch、owner、clean/dirty等をpreflightする。
- Work Identityの確認と操作の権限は独立したgateであり、`DIR`を渡せることでは成立しない。

Worktree lifecycleのactual semanticsは下記contractを維持する。generic `DIR` conventionの主所有は`../development-execution/S003_COMMAND_INTERFACE_AND_CI.md`に置く。

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
  - "Management Root Repository ignore boundary covers the sibling worktree path where required"
  - "supported Git/materialization capability is available when the Materialization Contract applies"
```

fail closed。既存pathを自動削除・上書きして進めない。

---

## Create behavior

createはcallerから見てatomicな意味操作とする。

### Materialization Contractが必要なrepository

stable repository roleとしてProject-level tracked `.worktrees/**` coordination stateを**所有する、または将来受け取るManagement Root Repository**にはMaterialization Contractを適用する。

selected branch treeへ現在 `.worktrees/**` が存在するかは診断材料にはなるが、適用要否をその瞬間のtree内容だけで決めない。first Workや古いbase branchでも、Management Root Repository roleがcoordination namespaceを所有するなら将来のbaseline growthに備えて同じcontractを適用する。

適用sequence:

```bash
git worktree add --no-checkout <resolved-path> <resolved-branch>

git -C <resolved-path> \
  sparse-checkout set --no-cone '/*' '!/.worktrees/'

git -C <resolved-path> \
  reset --hard HEAD
```

### 独立Component Repository

Project-level coordination namespaceを所有しない独立Component Repositoryでは、同じsparse exclusionを無条件適用しない。
helperはstable repository roleを主基準として適用要否を解決し、branch tree inspectionは補助診断として利用できる。

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

`worktree-status DIR=<canonical-worktree-path>` はnon-mutating。Public syntaxが異なるProjectでも、同じWork/Repository identityを内部で解決して検証する。

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
  - "Work Documents path and Management Root Repository tracking visibility where relevant"
```

Git状態は`git worktree list`等から読み、custom registryを真実源にしない。

---

## Remove contract

`worktree-remove DIR=<canonical-worktree-path>` は検証済みのWork/Repository identityに対応するGit worktreeだけを対象にする。

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

これらの実行可否・確認境界は `../development-safety/S002_DESTRUCTIVE_OPERATIONS.md` / `S005_CONFIRMATION_AND_REREAD.md` が主所有する。この文書は対象Work / repository / branch / pathの解決と通常remove semanticsだけを所有する。

---

## Stable Repository Identityと公開入力

Worktree lifecycleには、単一/multi-repositoryを問わず、**内部semantic inputとして**stable Repository Selectorが必要である。それによりGit ownership、branch resolution、worktree materializationを一貫して決定できる。

~~~text
public DIR=<canonical-worktree-path>
         ↓ Project-owned path validation
internal WORK + REPO (+ BASE)
         ↓ deterministic mapping + Git preflight
selected worktree
~~~

利用者が実在するdirectoryを指定できる場合、Work名とRepository Selectorを繰り返し手入力する必要はない。公開入力形式が違うProjectでも、内部で同じsemantic identityと安全なpostconditionに到達することを求める。

## 最終設計

~~~yaml
recommended_variable_target_public_input: "DIR=<directory-path>"
dir_semantics: "path locator only; operation decides target kind and existence"
canonical_worktree_locator: ".worktrees/<work-type>/<work-name>/<repository-selector>/"
internal_identity: "validated directory -> Work Identity + stable REPO"
internal_repo_required_even_single_repo: true
alternative_public_interface: "project-local WORK + REPO is allowed, not generically mandatory"
sparse_decision_from_caller: false
branch_name_input_by_default: false
branch_mapping: "project-owned deterministic policy"
missing_branch_base: "explicit BASE or documented project default; never accidental current HEAD"
state_source_of_truth: "Git/filesystem/runtime systems themselves; no duplicate worktree registry"
create: "planned canonical target may be absent; idempotent, fail-closed, atomic semantic operation"
status: "non-mutating diagnosis"
remove: "normal selected registered worktree removal only; branch/Work Documents/Work Root remain separate"
~~~

## Sources

- `../../records/2026-10-14-generic-dir-implementation-adoption/` — 実装への進行とWork Identity選定委任
- `../../records/2026-10-14-generic-dir-command-target/` — 汎用DIR指定の訂正意図

- `../../records/2026-10-03-subject-consistency-convergence/`

- `../../records/2026-10-03-project-root-execution-routing/`

- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/development-environment-strategy/source-logs/WORK_IDENTITY_WORKTREE_COMMAND_CONTRACT_JP.md`
