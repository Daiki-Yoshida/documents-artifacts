# ワークスペース構造

```yaml
document_type: "workspace_structure_translation"
target_audience: "human_readers"
language: "japanese"
source: "../artifacts/WORKSPACE_STRUCTURE.md"
strategy_version: "1.1.1"
authority: "英語版 artifacts/ が正本。内容に差がある場合は英語版を優先する"
```

## 1. リポジトリ構造

### Workspace Repository

開発環境の制御面を所有するリポジトリです。

```yaml
担当:
  - "DockerとCompose定義"
  - "Makefileと公開command wrapper"
  - "開発環境script"
  - "AIエージェント向け環境context"
  - "必要な場合のworktree作成・削除操作"
  - "複数componentの調整"
通常は担当しない:
  - "componentのproduct履歴"
  - "componentのsource code"
```

### Component Repository

productまたは独立versionを持つcomponentを所有するリポジトリです。

```yaml
担当:
  - "product source code"
  - "product test"
  - "component固有のCIとrelease file"
  - "componentのGit履歴"
関係: "Workspace Repository内に置けるが、Workspace側でGit管理しなくてよい"
```

WorkspaceとComponentは別のGit履歴を持てます。実際にsubmoduleでないなら、この関係をGit submoduleと呼びません。

### 単一リポジトリ

Workspace Repositoryを分けることは必須ではありません。

開発toolとproduct codeが同じlifecycleを持ち、別履歴や並列調整が不要なら、一つのrepository rootで同じ原則を適用します。

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

## 5. 推奨トップレベル構成

```text
<workspace>/
├─ Makefile
├─ <public-wrapper>
├─ compose.yml
├─ docker/
├─ scripts/
├─ documents/
├─ <component-a>/
├─ <component-b>/
└─ .worktrees/              # 任意。空でもよい
   ├─ <component-a>/
   │  └─ <task-identity>/
   └─ <component-b>/
      └─ <task-identity>/
```

filenameは技術ごとに変えて構いません。重要なのは責務です。

```yaml
Makefile: "見つけやすい公開操作名と委譲"
public_wrapper: "任意の共通CLI入口とcheckout選択"
compose: "container構造とruntime定義"
docker: "Dockerfileとcontainer支援file"
scripts: "開発環境操作の実装"
documents: "AI向けproject文書。documentation-strategyが管理"
component_paths: "独立Component RepositoryのPrimary Checkout"
worktrees: "必要な場合だけ作る一時Task Worktree"
```

この構造でapplication内部のmodule配置を決めてはいけません。code内部構造は `design-principles` が担当します。

## 6. Git管理境界

### Workspace Repository側でignoreするもの

- 独立Git履歴を持つComponent Repositoryのcheckout
- worktree対応がある場合の `.worktrees/`
- local secret
- build・export生成物
- runtime cache
- 共有しないeditor・OS file

embedded repositoryをignoreするだけでなく、そのpathが独立repositoryであることをAGENTSやproject文書へ書きます。

### Component Repository側

product cache、build output、generated file、tool固有状態はComponent Repository自身のignore規則で管理します。

Workspace RepositoryがComponent内の生成物を誤って所有しないようにします。

## 7. 複数component

一つのWorkspace Repositoryで複数Component Repositoryを管理できます。

```yaml
要件:
  - "各componentに安定したPrimary Checkout pathがある"
  - "workspace全体操作でない場合は対象componentを明示する"
  - "worktree利用時はcomponent別にnamespaceを分ける"
  - "衝突可能性があるresource名へcomponentを含める"
  - "component横断検証は独立した明示操作にする"
```

無関係なrepositoryを同じfolderへ置くだけのためにWorkspace Repositoryを作ってはいけません。共有toolや実際の調整責務が必要です。

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

## 9. Workspace toolへの依存

Component Repositoryが別Workspace Repository内のtoolへ依存する場合、使用versionを明示します。

```yaml
moving_ref:
  意味: "document化されたbranchまたは現在のworkspace checkoutを使う"
  特徴: "更新は簡単だが、過去再現性は弱い"
fixed_ref:
  意味: "tagまたはcommitを使う"
  特徴: "再現性は高いが、更新作業が必要"
```

CIやrelease検証が、指定されていないworkspace最新版へ偶然依存してはいけません。

## 10. 他artifactとの境界

```yaml
development_environment_strategy:
  担当: "repository、checkout、worktree配置と開発環境top-level directory"
design_principles:
  担当: "application module、public code surface、依存方向、test architecture"
documentation_strategy:
  担当: "documents/ 内部構造、案内、保守"
```
