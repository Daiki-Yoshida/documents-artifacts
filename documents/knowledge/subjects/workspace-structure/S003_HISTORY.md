# Workspace構造 — 履歴

旧development-environment artifact群の中で、workspace/repository構造の責務境界を説明していた歴史的情報を保持する。

現在はWorkspace構造そのものをこのsubjectが所有し、Work Root / Work Documents / repository-specific worktreeは `../work-identity/` が所有する。

## Original preamble

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

- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/development-environment-strategy/WORKSPACE_STRUCTURE.md`

---

## Work Identityとの境界整理前のWorkspace Structure subject

以下は、Work Identityとの責務衝突を修正する直前の `workspace-structure` 本文を、そのまま履歴として保存したもの。

旧本文には、Task Worktreeを現行基本用語として扱う定義、旧 `.worktrees/<component>/<task-identity>/` path、`.worktrees/` 全体をignoreする規則などが含まれる。

これらは現在の規範ではない。現在の規範は `S001_PROJECT_AND_REPOSITORY_MODEL.md`、`S002_GIT_OWNERSHIP_AND_MULTI_REPOSITORY.md`、および `../work-identity/` を参照する。

### 旧 S001_PROJECT_AND_REPOSITORY_MODEL.md

# Workspace構造 — ProjectとRepository

project全体の静的なrepository/filesystem構造を扱う。1つのWorkの動的構造は `../work-identity/` が所有する。

## ワークスペース構造の基本用語

```yaml
Workspace_Repository:
  意味: "開発ツール、ワークスペース調整、環境文書、必要に応じたworktree管理を所有するリポジトリ"
Component_Repository:
  意味: "プロダクトコードと、そのGit履歴を所有する独立リポジトリ"
Primary_Checkout:
  意味: "Component Repositoryの基準checkout。単独作業ではtask branchの実装場所として使ってよい"
Task_Worktree:
  意味: "並列書き込みまたは明示的な隔離が必要な場合だけ追加する一時checkout"
```

Workspace RepositoryとComponent Repositoryは、完全に別のGit履歴を持っていて構いません。これはワークスペース上の関係であり、Git submoduleであることを意味しません。

すべてのプロジェクトを複数リポジトリへ分ける必要もありません。実際の調整・分離需要がないなら、一つのリポジトリで十分です。

---

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

---

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

## Sources

- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/development-environment-strategy/DEVELOPMENT_ENVIRONMENT_PHILOSOPHY.md`
- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/development-environment-strategy/WORKSPACE_STRUCTURE.md`


### 旧 S002_GIT_OWNERSHIP_AND_MULTI_REPOSITORY.md

# Workspace構造 — Git所有境界と複数Repository

Workspace Repository / Component Repository間のGit所有境界、複数component、workspace tool dependencyを扱う。

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

---

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

---

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

## Sources

- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/development-environment-strategy/DEVELOPMENT_ENVIRONMENT_PHILOSOPHY.md`
- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/development-environment-strategy/WORKSPACE_STRUCTURE.md`


## Alignment decision source

- `../../records/2026-09-22-workspace-work-identity-alignment/`

