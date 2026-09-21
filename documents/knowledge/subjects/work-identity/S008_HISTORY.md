# Work Identity — Historical Context

この文書は、現在のsubject構造へ再整理する際に、旧source logのauthority表現、旧artifactへの反映計画、当時の未検証事項などを失わないための履歴領域である。

ここにある内容は「現在も旧artifact構造を採用する」という意味ではない。作成当時に何が想定・計画されていたかを保持する。

## 旧source log metadata / preamble

### Work Identity design

# Work Identity 設計原本

```yaml
document_type: "source_rationale_log"
target_audience: "human_readers"
language: "japanese"
authority: "non_canonical_source_log"
status: "artifactized_reference"
future_owner: "artifacts/development-environment-strategy/"
```

> この文書は、Work Identity を artifact 化する際の設計原本として作成された source/rationale log です。
> 現在の規範は `artifacts/` 側であり、この文書は背景・判断理由・圧縮前の文脈を保持する参照資料です。

---

### Git materialization experiment

# Work Identity Git Materialization 実験記録

```yaml
document_type: "source_rationale_log"
target_audience: "human_readers"
language: "japanese"
authority: "non_canonical_experiment_record"
status: "artifactized_reference"
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

### Worktree command contract

# Work Identity Worktree Command Contract 設計原本

```yaml
document_type: "source_rationale_log"
target_audience: "human_readers"
language: "japanese"
authority: "non_canonical_source_log"
status: "artifactized_reference"
related_design: "WORK_IDENTITY_DESIGN_JP.md"
related_experiment: "WORK_IDENTITY_GIT_MATERIALIZATION_EXPERIMENT_JP.md"
```

> Work Identity配下のGit worktree作成・診断・削除を、人間やAIが低レベルGit手順を直接組み立てずに扱えるようにするためのcommand contract設計原本。
> 実際のGit状態のsource of truthはGit自身であり、このcommandは新しい状態registryを作らない。

### Reference validation

# Work Identity Worktree Reference Implementation 検証記録

```yaml
document_type: "source_rationale_log"
target_audience: "human_readers"
language: "japanese"
authority: "non_canonical_experiment_record"
status: "artifactized_reference"
related_contract: "WORK_IDENTITY_WORKTREE_COMMAND_CONTRACT_JP.md"
test_repository: "Daiki-Yoshida/test-git-track"
reference_merge_commit: "d584d3f110f8cc230b59af6c9f06860bd3e0b6fb"
tested_environment:
  os: "Linux on WSL2"
  git: "2.43.0"
  make: "GNU Make 4.3"
  bash: "5.2.21"
```

> Worktree public command contractを、project-owned参照実装として実装し、fresh cloneから実機検証した記録。
> 実装Shell/Makefile自体はartifact配布対象ではない。
> 正本artifactには、実装から得られた再利用可能なcontract/invariantだけを反映する。

---

## 既存 development-environment-strategy との関係

現在の artifact にある次の思想は維持する。

- host / data safety を最優先する
- Docker-first execution
- worktree は必要な場合だけ使用する
- shared cache / image を安全なら再利用する
- parallel writer は mutable state を分離する
- cleanup は deterministic / scoped にする
- destructive purge と通常cleanupを分離する
- Gitが履歴を所有する
- 単なる識別子の存在を理由に追加resourceを作らない

変更される中心概念は、従来複数箇所に分散していた作業単位・branch・worktree・runtime ownership を **Work Identity** へ統合することである。

artifact 化では、既存思想を壊さず、この共通軸を各文書の所有範囲へ分配する。

---

---

## artifact 化時の予定責務

このsource logをそのままartifactへコピーしない。

AIの認識・ルーティング・トークン効率を考慮し、既存文書のOwnershipへ再配置する。

想定:

```yaml
DEVELOPMENT_ENVIRONMENT_PHILOSOPHY.md:
  future_content:
    - "Work Identity の WHY"
    - "Goal -> Work Identity -> environment ownership という基本モデル"
    - "Git は Work Identity の表現手段であり定義元ではない"
    - "Work Identity確定タイミングの原則"

WORKSPACE_STRUCTURE.md:
  future_content:
    - ".worktrees/<type>/<name>/ を Work Root とする構造"
    - "単一 / 複数 repository の統一形状"
    - "Work Documents と repository worktree の配置"
    - "Base Work Identity と repository派生identity"
    - "Project Root / ownership boundary"

ENVIRONMENT_STANDARDS.md:
  future_content:
    - "Work-scoped resource identity"
    - "Project / Work / Run scope"
    - "resource reuse / creation rules"
    - "Git / filesystem safe normalization"

ENVIRONMENT_WORKFLOW.md:
  future_content:
    - "Work Identity確認からcompletionまでのlifecycle"
    - "Work Documents creation / update / reconciliation"
    - "branch / worktree / runtime preparation"
    - "multi-repository completion semantics"
    - "cleanup / retained state"

INDEX.md:
  future_content:
    - "Work Identity routing"
    - "Work Root / Work Documentsへの入口"
```

この分割は artifact 化工程で再レビューする。

---

---

## artifact 化前に検証すべき事項

概念設計は確定しているが、少なくとも次は実装・artifact化前に技術検証する。

1. Project Repository が `.worktrees/**/documents/**` をtrackしながら、兄弟repository worktreeを安全にignoreできるGit設定。
2. 同一Project Repositoryのnested worktree内で、Project-level `.worktrees/` を再materializeしない方法。
3. sparse checkout を採用する場合、通常のbuild/test/editor操作への副作用。
4. `.worktrees/<type>/<name>/<repository>/` へのGit worktree生成・削除・pruneの安全な手順。
5. Work Documentsの削除とProject Documentsへのreconciliationを、Git履歴を壊さず行えること。

これらの結果によって実装手段は変わり得るが、Work Identity、Work Root、Work Documents、Project Repository ownershipという概念モデルは維持する。

---

## artifact反映対象

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

---

## artifact反映方針

```yaml
ENVIRONMENT_STANDARDS.md:
  - "public worktree-create/status/remove semantic contract"
  - "required inputs and deterministic resolution"
  - "idempotency, fail-closed, no custom state registry"
WORKSPACE_STRUCTURE.md:
  - "REPO selector maps to Work Root child directory/repository"
  - "path/branch derivation relationship"
ENVIRONMENT_WORKFLOW.md:
  - "create preflight -> create -> postcondition -> rollback"
  - "remove lifecycle boundary"
  - "routine caller does not execute low-level Git sequence"
INDEX.md:
  - "routing for worktree command contract"
```

---

## artifactへ反映する知見

### ENVIRONMENT_STANDARDS.md

- base refとupstreamは別contract
- missing Work branchをbaseから作るだけならbase branchを自動upstreamにしない
- same-name remote Work branchのtrackingは明示的policyとして別扱い
- project-level helperはProject Rootをstable/explicitに解決し、linked worktreeを偶然Project Rootとして扱わない

### ENVIRONMENT_WORKFLOW.md

- missing branch作成時にbase resolution後、upstream policyも明示的に決める
- Primary checkout限定、または同等に安全なexplicit Project Root resolutionを要求
- create postconditionにbranch/upstream semanticsを含める場合はproject policyに従う

## Sources

- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/development-environment-strategy/source-logs/WORK_IDENTITY_DESIGN_JP.md`
- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/development-environment-strategy/source-logs/WORK_IDENTITY_GIT_MATERIALIZATION_EXPERIMENT_JP.md`
- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/development-environment-strategy/source-logs/WORK_IDENTITY_WORKTREE_COMMAND_CONTRACT_JP.md`
- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/development-environment-strategy/source-logs/WORK_IDENTITY_WORKTREE_REFERENCE_VALIDATION_JP.md`

---

## Work Identity導入前のTask Worktreeモデル

以下は、Work Identity導入以前のdevelopment-environment文書で、task / checkout / worktree / resource identityを扱っていた前身モデルである。

現在のWork Identity、Work Root、Work Documents、worktree command contractより前の設計として保存する。現在の規範としてそのまま適用しない。

## checkoutの選び方

worktreeは、すべてのタスクで必ず作るものではありません。

```yaml
通常:
  条件: "書き込み作業が一つで、別checkoutやruntime分離が不要"
  対応: "現在またはPrimary Checkoutでtask branchを使う"
Task_Worktreeを作る条件:
  - "同じComponent Repositoryで複数の書き込み作業を並列実行する"
  - "別branchを安定したパスで維持する必要がある"
  - "ユーザーまたはプロジェクト規則が明示的に要求する"
  - "独立して破棄できるcheckoutと可変runtime状態が必要"
作らない条件:
  - "書き込み作業が一つだけ"
  - "現在のcheckoutでtask branchを安全に使える"
  - "理由が .worktrees/ やworktreeコマンドの存在だけ"
```

AIエージェントは、安全性と分離条件を満たす中で最も単純な方式を選びます。不要なworktreeは、管理状態、後片付け、誤ったcheckout選択を増やすだけです。

---

## 複数AIエージェントの分離

複数の書き込み作業を並列実行する場合、branchだけを分けても不十分です。

```yaml
並列タスクごとに分離するもの:
  - "branch"
  - "作業ディレクトリ"
  - "container名前空間"
  - "networkとhost port"
  - "共有すると結果へ影響する可変volume"
  - "logと生成物"
原則: "一つの書き込み可能checkoutを同時に所有する書き込みエージェントは一つ"
```

Task Worktreeを使う場合、task、branch、worktree、container、logを共通の安定識別子から追跡できるようにします。

安全に共有できる読み取り専用cacheは共有して構いません。

---

## 4. Git操作の安全性

- default branchは安定させ、通常の変更はtask branchで行う。
- **task branchを使うことは、Task Worktreeを作ることを意味しない。**
- 書き込み作業が一つだけで追加隔離が不要なら、現在割り当てられたcheckoutを使う。
- Task Worktreeは、並列書き込み、安定した別checkout、明示的な隔離要求がある場合だけ作る。
- `.worktrees/` やworktree commandが存在するという理由だけで作らない。
- 一つの書き込み可能checkoutを同時に所有する書き込みエージェントは一つとする。
- 変更前に、対象repositoryとcheckoutを確認する。worktree利用時はworktreeも確認する。
- 宣言されたworkspace外のrepositoryを操作しない。
- 通常のworktree削除はdirty worktreeを拒否する。
- 可能なら、未push・未保存commitも削除前に確認する。
- `--force` は明示的な破壊commandだけで使う。
- worktree cleanupとbranch削除は別の判断とする。
- stale metadataのpruneを、実directory削除の許可として扱わない。
- push、force-push、branch削除、history書き換えは明示操作とする。

---

## 3. checkout選択と任意Task Worktree

### checkout方式を選ぶ

編集前に、最も単純で安全な方式を選びます。

```yaml
現在またはPrimary_Checkout:
  使用条件:
    - "Component Repositoryで書き込み作業が一つだけ"
    - "そのcheckoutでtask branchを安全に使える"
    - "別branchを安定したpathで維持する必要がない"
    - "独立した可変runtime状態が不要"
  対応: "割り当て済みcheckoutを使い、worktreeを作らない"
Task_Worktree:
  使用条件:
    - "複数の書き込みtaskまたはAIエージェントを並列実行する"
    - "別branchを安定したpathで維持する必要がある"
    - "ユーザーまたはproject規則が明示的に要求する"
    - "独立して破棄できるcheckoutとruntime状態が必要"
  対応: "Task Worktreeを作成し、すべての操作で明示選択する"
```

`.worktrees/`、worktree helper、TASK_IDの存在だけでは、worktreeを作る理由になりません。

### 選択checkoutを準備する

どちらの方式でも、次を確認します。

- Component Repository
- taskとtask branch
- 選択checkoutが正しいrepositoryに属すること
- project規則に従ったref同期
- その書き込み可能checkoutを所有する書き込みエージェントが一つだけであること

Primary Checkoutを使う場合は、project規則に従ってtask branchへ切り替えるか作成します。保護されたdefault branch上で直接実装しません。

### 必要な場合だけTask Worktreeを作る

作成前に、次を確認します。

- 実際に並列または隔離条件が存在する。
- Primary Checkoutが意図したrepositoryである。
- branch名とpathが衝突しない。

作成後は、branch、絶対またはworkspace相対path、runtime識別子を報告します。

```yaml
worktree割り当て:
  worktree: "一つの書き込みエージェント"
  branch: "そのworktreeでcheckoutしたbranch"
  可変runtime: "task識別子で分離"
  command対象: "すべての操作で明示選択"
```

### 実装と検証

1. 最も狭い関連検証から始める。
2. host toolを直接呼ばず、project管理commandを使う。
3. 選択checkoutのlogと状態から失敗を診断する。
4. 他の書き込み可能checkoutへ触れない。
5. 完了報告前に最終HEADで標準最終検証を実行する。

### 変更を保存する

統合、checkout切替、worktree削除の前に、次を行います。

- working treeを確認する。
- project規則に従って意図した変更をcommitへ保存する。
- untracked generated fileを確認する。
- 必要ならremoteなどへの保存条件を確認する。

---

## 5. 後片付け

task専用resourceを作成した場合、task終了時にその最終状態を判断する責任が生じます。

```yaml
完了状態:
  削除済み: "不要になったresourceを、通常の限定cleanupで削除した"
  意図的に保持: "具体的な後続作業のために必要であり、resourceと保持理由を報告した"
原則: "所有者や理由が不明な残存resourceを、完了状態として認めない"
```

共有resourceや永続dataは、taskが利用したという理由だけでtask cleanupの対象にしません。破壊的な削除は、後述のpurge規則に従います。

### worktreeを作らなかった場合

現在またはPrimary Checkoutを使ったtaskでは、次のようにします。

- worktree cleanupを実行しない。
- task branchをproject規則に従って保存する。
- 実際に作成したtask専用runtime resourceをすべて確認する。
- 不要なresourceは削除し、意図的に保持するresourceは対象と理由を報告する。
- project workflowが要求する場合だけ、期待branchへcheckoutを戻す。

### 通常のworktree削除

Task Worktreeを作った場合だけ、通常削除で次を行います。

1. 対象worktreeを決定的に解決する。
2. 正しいComponent Repositoryに属することを確認する。
3. 未commit変更があれば拒否する。
4. 未保存commitがある場合は警告または拒否する。
5. task専用runtime resourceを停止・削除する。
6. forceなしでGit worktreeを削除する。
7. 必要な場合だけstale metadataをpruneする。
8. branchなど残るものを報告する。
9. 意図的に保持するtask専用resourceと、その理由を報告する。

### 破壊的purge

purgeは未保存作業や永続dataを失う可能性があります。通常削除とは別の明示操作とし、対象範囲を報告します。

branch削除、worktree強制削除、DB削除、共有cache削除を一つの曖昧なcleanupへまとめません。

すべてのtask専用resourceが削除済み、または理由を伴って意図的に保持されている場合だけ、後片付け完了とします。想定外の残存resourceは無視せず報告します。

---

## 2. Primary Checkout

各Component Repositoryには、workspace内に一つのPrimary Checkoutを置きます。

```yaml
用途:
  - "project規則が許す場合の、単独AIエージェントによるtask branch実装"
  - "fetchと同期"
  - "必要な場合のworktree作成"
  - "統合と最終確認"
  - "対話toolが必要とする安定したcomponent path"
default_branchの扱い: "実装前にtask branchへ切り替え、default branch上で直接実装しない"
```

Primary Checkoutを常にdefault branchへ固定する必要はありません。書き込み作業が一つだけで別checkoutが不要なら、通常のfeature実装場所として使用できます。

ただし、無関係なlocal変更を混在させず、安定したpathを保ちます。

---

## 3. checkoutの選択

安全性を満たす中で、最も単純なcheckout方式を選びます。

```yaml
現在またはPrimary_Checkoutを使う条件:
  - "Component Repositoryで書き込み作業が一つだけ"
  - "そのcheckoutでtask branchを安全に使える"
  - "別branchを安定したpathで維持する必要がない"
  - "独立した可変runtime状態が不要"
Task_Worktreeを作る条件:
  - "同じComponent Repositoryで複数の書き込み作業を並列実行する"
  - "別branchを安定したpathで維持する必要がある"
  - "ユーザーまたはproject規則が明示的に要求する"
  - "独立して破棄できるcheckoutとruntime状態が必要"
理由として不十分:
  - ".worktrees/ が存在する"
  - "worktree commandが用意されている"
  - "taskにTASK_IDがある"
```

Task Worktreeは分離が必要な場合の道具です。通常の単独作業で毎回行う儀式ではありません。

---

## 4. Task Worktree

上記の選択条件に該当した場合だけ、Workspace Repositoryの `.worktrees/` 以下へ作成します。

```yaml
標準形: ".worktrees/<component>/<task-identity>/"
所有: "一つのtask、一つのbranch、一つの書き込みエージェント"
lifecycle: "隔離作業のために作成し、統合または中止後に削除する一時checkout"
Git管理: "Workspace Repository側ではignoreする"
```

componentが一つだけなら、flatな `.worktrees/<component>-<task>/` 形式も許容できます。複数componentがある場合は入れ子形式を推奨します。

`.worktrees/` は空のままでも構いません。directoryの存在は、worktree作成の指示ではありません。

### 名前

Task Worktree名から次を識別できるようにします。

- Component Repository
- taskまたは管理番号
- 必要なら短いbranch名

既に安定したTASK_IDがあるなら利用できますが、TASK_IDがあるという理由だけでworktreeを作りません。

### 不変条件

- worktreeのbranchはComponent Repositoryに属する。
- 一つのbranchを複数の書き込みworktreeへ割り当てない。
- 選択worktree pathをbuild、test、format、log、生成物へ伝える。
- 並列worktreeには別々の可変runtime状態を与える。
- worktree削除時にbranchを自動削除しない。branch削除は別操作とする。

---

## 8. resource識別の伝播

Task Worktreeまたはtask固有runtimeで隔離する場合は、同じ論理task識別子を環境全体へ伝えます。

```yaml
隔離時に伝える対象:
  - "branchまたはtask metadata"
  - "worktree path"
  - "Compose project・container namespace"
  - "可変volumeとhost port"
  - "log"
  - "一時・生成output path"
```

単一checkoutと共通runtimeを意図的に使う場合、不要なtask専用namespaceを作りません。

## Predecessor sources

- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/development-environment-strategy/DEVELOPMENT_ENVIRONMENT_PHILOSOPHY.md`
- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/development-environment-strategy/ENVIRONMENT_STANDARDS.md`
- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/development-environment-strategy/ENVIRONMENT_WORKFLOW.md`
- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/development-environment-strategy/WORKSPACE_STRUCTURE.md`

