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
