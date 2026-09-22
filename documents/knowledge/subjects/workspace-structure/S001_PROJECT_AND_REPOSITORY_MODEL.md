# Workspace構造 — ProjectとRepository

project全体の**静的なrepository/filesystem構造**を扱う。

1つのWorkに属するWork Root、Work Documents、repository-specific worktree、branch/worktree lifecycleは `../work-identity/` が所有する。Project Documentation内部のrouting / file role / maintenanceは `../documentation/` が所有する。

## 基本用語

```yaml
Project_Repository:
  意味: "Project全体のcoordination stateを所有する最上位repository"
  主な責務:
    - "Project DocumentationのGit ownership"
    - "Project-level .worktrees/ coordination namespace"
    - "Work DocumentsのGit ownership"
    - "project-level helperを安定して実行する基準面"

Project_Root:
  意味: "Project Repositoryの基準working tree root"
  用途:
    - "project-level path解決"
    - "documents/ と .worktrees/ の所有境界"
    - "repository selector解決の起点"

Workspace_Repository:
  意味: "複数repository projectで、開発tool・workspace調整・project-level coordinationを所有するrepository"
  関係: "複数repositoryを調整するWorkspace Repositoryが存在する場合、そのrepositoryがProject Repositoryを兼ねる"

Component_Repository:
  意味: "productまたは独立versionを持つcomponentと、そのGit履歴を所有するrepository"

Primary_Checkout:
  意味: "repository rootやproject-level helperを安定して解決するための基準checkout"
  非責務:
    - "Workごとにどのbranchを使うか決める"
    - "Workごとにworktreeを作るか決める"
```

### 単一repository

Project全体が1repositoryで成立する場合、そのrepositoryがProject Repositoryとなる。

```text
Project Repository
= product repository
= Project Rootを所有するrepository
```

この場合も、Work単位の構造は `work-identity` が所有する。

### 複数repository

複数repositoryをまとめるWorkspace Repositoryが存在する場合、

```text
Workspace Repository
= Project Repository

Component Repository
= projectに参加する独立repository
```

を基本とする。

Workspace RepositoryとComponent Repositoryは別のGit履歴を持ってよく、Git submoduleである必要はない。

## Repository構造

### Project / Workspace Repository

project全体のcoordination責務を持つ。

典型的には次のartifactを**Git/filesystem上で所有・配置**できる。ここでのownershipは静的配置・Git ownershipを意味し、各artifactのbehavior contractまでこのsubjectが所有するという意味ではない。

```yaml
静的所有:
  - "Project Documentation"
  - "Docker / Compose等のproject-level environment definition"
  - "Makefileやpublic command wrapper"
  - "project-level scripts"
  - "repository/component間の調整"
  - "Work Identityが利用するProject-level .worktrees/ coordination namespace"
通常は担当しない:
  - "独立Component Repositoryのproduct history"
  - "独立Component Repositoryのsource code"
```

`documents/` のtop-level placement / Git ownershipはこのsubjectの静的構造に含まれるが、その内部routing・file role・maintenance contractは `../documentation/` が主所有する。Docker / Compose、Makefile / public command、runtime scriptの実行意味は `../development-execution/` が主所有する。

### Component Repository

product/component固有のsourceとGit履歴を所有する。

```yaml
担当:
  - "product source code"
  - "product test"
  - "component固有CI / release file"
  - "componentのGit履歴"
```

Project Repository配下にcheckoutを置けるが、Project Repositoryの通常fileとして管理しない。

## Project Rootとtop-level構造

Project RootはProject Repositoryの基準working tree rootである。

複数repository構成でWorkspace RepositoryがProject Repositoryなら、Workspace RootとProject Rootは同じ場所を指す。

典型形:

```text
<project-root>/
├─ Makefile
├─ <public-wrapper>
├─ compose.yml
├─ docker/
├─ scripts/
├─ documents/
├─ <component-a>/        # independent repository checkout when applicable
├─ <component-b>/        # independent repository checkout when applicable
└─ .worktrees/           # Work Identity-owned coordination namespace
```

重要:

- `.worktrees/` の**内部構造はこのsubjectで定義しない**。
- Work Rootのpath、Work Documents、repository-specific worktree配置は `../work-identity/` が所有する。
- `.worktrees/` が存在すること自体はworktree作成を要求しない。
- `documents/` 内部構造は `../documentation/` が所有する。
- application内部moduleの配置はこのsubjectの責務ではない。

## Primary Checkoutの境界

Primary Checkoutはstatic repository resolutionのための概念として扱う。

用途:

- repository rootを安定して解決する
- project-level helperの安全な実行起点を提供する
- fetch / status / integration等の基準面にできる

ただし、あるWorkでPrimary Checkoutを使うかrepository-specific worktreeを使うかはWorkspace Structureでは決めない。

その判断はWork Identity / project policyが所有する。

## Sources

- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/development-environment-strategy/DEVELOPMENT_ENVIRONMENT_PHILOSOPHY.md`
- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/development-environment-strategy/WORKSPACE_STRUCTURE.md`
- `../../records/2026-09-22-workspace-work-identity-alignment/`
- `../../records/2026-09-22-six-subject-cross-audit-fixes/`
