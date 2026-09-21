# 開発環境 — 履歴・旧モデル

この文書は、Work Identity導入以前のTask Worktree / Primary Checkoutモデル、旧artifact境界、当時の誤読防止など、現在のsubject本文へそのまま混ぜると誤読しやすい歴史的情報を保持する。

ここにある内容は削除対象ではない。**当時どのようなモデル・判断で運用されていたかを保存する記録**として扱う。現在のworktree / Work Root / Work Documentsに関する知識は `../work-identity/INDEX.md` を優先する。

## Original preambles

### DEVELOPMENT_ENVIRONMENT_PHILOSOPHY.md

# 開発環境の基本思想

```yaml
document_type: "development_environment_philosophy_translation"
target_audience: "human_readers"
language: "japanese"
source: "../../artifacts/development-environment-strategy/DEVELOPMENT_ENVIRONMENT_PHILOSOPHY.md"
strategy_version: "1.1.1"
authority: "英語版 artifacts/ が正本。内容に差がある場合は英語版を優先する"
```

### ENVIRONMENT_STANDARDS.md

# 開発環境の実装基準

```yaml
document_type: "environment_standards_translation"
target_audience: "human_readers"
language: "japanese"
source: "../../artifacts/development-environment-strategy/ENVIRONMENT_STANDARDS.md"
strategy_version: "1.1.1"
authority: "英語版 artifacts/ が正本。内容に差がある場合は英語版を優先する"
```

### ENVIRONMENT_WORKFLOW.md

# 開発環境の作業フロー

```yaml
document_type: "environment_workflow_translation"
target_audience: "human_readers"
language: "japanese"
source: "../../artifacts/development-environment-strategy/ENVIRONMENT_WORKFLOW.md"
strategy_version: "1.1.1"
authority: "英語版 artifacts/ が正本。内容に差がある場合は英語版を優先する"
```

### WORKSPACE_STRUCTURE.md

# ワークスペース構造

```yaml
document_type: "workspace_structure_translation"
target_audience: "human_readers"
language: "japanese"
source: "../../artifacts/development-environment-strategy/WORKSPACE_STRUCTURE.md"
strategy_version: "1.1.1"
authority: "英語版 artifacts/ が正本。内容に差がある場合は英語版を優先する"
```

---

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

## よくある誤解

- **Dockerファースト**は、すべての操作をDocker内で行うという意味ではない。
- **ホスト依存を最小化する**とは、全プロジェクト共通の固定許可リストを作ることではない。
- **worktree対応**は、すべてのタスクでworktreeを作るという意味ではない。
- **branchを作ること**と**worktreeを作ること**は別である。
- **Primary Checkout**はdefault branch専用ではなく、単独作業ではtask branchの実装場所として使える。
- **Workspace Repository**は、Git上の親リポジトリや必須submoduleを意味しない。
- **resource分離**は、すべてのcacheを複製する意味ではない。
- **安全性**は、作業を遅くすることではない。

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

---

## 10. 他artifactとの境界

```yaml
development_environment_strategy:
  担当: "repository、checkout、worktree配置と開発環境top-level directory"
design_principles:
  担当: "application module、public code surface、依存方向、test architecture"
documentation_strategy:
  担当: "documents/ 内部構造、案内、保守"
```

## Sources

- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/development-environment-strategy/DEVELOPMENT_ENVIRONMENT_PHILOSOPHY.md`
- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/development-environment-strategy/ENVIRONMENT_STANDARDS.md`
- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/development-environment-strategy/ENVIRONMENT_WORKFLOW.md`
- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/development-environment-strategy/WORKSPACE_STRUCTURE.md`
