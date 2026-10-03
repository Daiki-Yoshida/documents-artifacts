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

Component_Repository:
  意味: "productまたは独立versionを持つcomponentと、そのGit履歴を所有するrepository"

Primary_Checkout:
  意味: "repository rootやproject-level helperを安定して解決するための基準checkout"
  非責務:
    - "Workごとにどのbranchを使うか決める"
    - "Workごとにworktreeを作るか決める"
```

### 日本語でのrole名

current normativeの説明では、次を使用できる。

```yaml
Project_Repository:
  日本語: "プロジェクト管理リポジトリ"
  短縮: "管理リポジトリ（文脈上Project roleであることが明確な場合）"

Component_Repository:
  日本語: "コンポーネントリポジトリ"
```

「親リポジトリ / 子リポジトリ」はcurrent role名として使用しない。

### 単一repository

Project全体が1repositoryで成立する場合、そのrepositoryがProject Repositoryとなる。

```text
Project Repository
= product repository
= Project Rootを所有するrepository
```

この場合も、Work単位の構造は `work-identity` が所有する。

### 複数repository

複数repository Projectでは、Project Repositoryがproject-level coordinationを所有し、1つ以上のComponent Repositoryが参加できる。

```text
Project Repository
  = project-level coordination / Project Root ownership

Component Repository
  = projectに参加する独立repository
```

Project RepositoryとComponent Repositoryは別のGit履歴を持ってよく、Git submoduleである必要はない。

### Workspace Repositoryという旧用語

旧modelで `Workspace Repository` と呼んでいた「複数repositoryを調整するrepository」は、現行modelでは **Project Repository** の責務に包含する。

`Workspace Repository` をProject Repository / Component Repositoryと並ぶ第三のcurrent roleとして要求しない。旧source・history・既存project固有用語の説明で必要な場合だけcompatibility / historical termとして扱う。

## Repository構造

### Project Repository

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

複数repository構成でも、Project RootはProject Repositoryの基準working tree rootである。Component Repository checkoutがその配下に配置されてもProject Rootは移動しない。

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

## Project Repositoryの開発入口責務

Project Repositoryはproject-level coordination stateのGit ownershipを持つだけでなく、**人・AIがproject全体の開発contextへ入る基準面**でもある。

日本語で役割を説明するときは、`Project Repository` を **プロジェクト管理リポジトリ**、文脈上明確な場合は **管理リポジトリ** と表現できる。ただし「管理」は単なるadministrative repositoryを意味しない。Project Repositoryは少なくとも次をproject-levelに束ねる。

- Project Documentation
- agent entrypointやdocumentation routing
- project policy
- Makefile / public command wrapper / project-level scripts
- repository/component間のcoordination
- Work Identityが利用するproject-level coordination state

「親repository / 子repository」という表現は、Git ownershipや依存方向を誤解させやすいため、Project Repository / Component Repositoryの役割名で区別する。

### Project RootはAI development sessionのentry surface

Projectに属するdevelopment workでは、AI development sessionは **Project Rootから開始する**。

Project Rootは単なるpath resolutionの基準ではなく、次を取得するdevelopment entry surfaceである。

- Project Documentation
- `AGENTS.md` 等のagent-facing entrypoint
- `documents/INDEX.md` 等のdocumentation router
- managed artifactへのproject-owned entry hook
- project-level architecture / policy
- public command interface
- repository ownership / stable selector
- Work Identity / verification / integrationのproject-local rule

Work Root、Component Repository checkout、repository-specific worktreeに実装対象が存在しても、それらをProject全体のAI session entry rootとして扱わない。

典型的な解決順序は次になる。

```text
Project Root
  ↓ project context / policy / documentation / routing
Work Identity
  ↓ participating repositories
repository checkout / worktree
  ↓ actual implementation / verification target
```

これは「すべてのsubprocessをProject Rootのworking directoryで実行する」という意味ではない。実際のcommand target / subprocess working directoryの選択は `../development-execution/` が所有し、Work Rootとrepository-specific worktreeの意味は `../work-identity/` が所有する。

### Project Repository自身のworktree

Project Repository自身が1つのWorkへ参加し、Project Root配下の `.worktrees/<work-type>/<work-name>/<repository>/` にProject Repositoryのlinked worktreeが存在する場合も、そのlinked worktreeは実装対象であってAI development sessionのentry rootではない。

AIはProject Rootからproject contextを取得したうえで、対象worktreeへ操作をroutingする。

### standalone Component Repository

Component Repositoryであるrepositoryが、上位Projectから切り離された独立projectとして意図的に開発される場合、そのdevelopment contextではそのrepository自身がProject Repositoryになり得る。

したがって規範は「Component RepositoryではAIを起動してはならない」ではなく、**そのWorkが属するProjectのProject RootからAI development sessionを開始する**ことである。

上位Projectに属するWorkなのに、Component Repository checkoutだけをproject全体のrootとして扱ってproject-level assetsを無視することを避ける。

## Primary Checkoutの境界

Primary Checkoutはstatic repository resolutionのための概念として扱う。

用途:

- repository rootを安定して解決する
- project-level helperの安全な実行起点を提供する
- fetch / status / integration等の基準面にできる

ただし、あるWorkでPrimary Checkoutを使うかrepository-specific worktreeを使うかはWorkspace Structureでは決めない。

その判断はWork Identity / project policyが所有する。

## Sources

- `../../records/2026-10-03-project-component-documentation-boundary/`

- `../../records/2026-10-03-project-root-execution-routing/`

- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/development-environment-strategy/DEVELOPMENT_ENVIRONMENT_PHILOSOPHY.md`
- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/development-environment-strategy/WORKSPACE_STRUCTURE.md`
- `../../records/2026-09-22-workspace-work-identity-alignment/`
- `../../records/2026-09-22-six-subject-cross-audit-fixes/`
