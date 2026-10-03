# Workspace Structure

このsubjectは、**project全体の静的なrepository/filesystem構造、Project Repository / Project Root、Git所有境界、stable repository identity**を扱う。

Work Root、Work Documents、repository-specific worktreeなど1つのWorkに属する動的構造は `../work-identity/` が主所有する。

## 構成

```text
workspace-structure/
├─ INDEX.md
├─ S001_PROJECT_AND_REPOSITORY_MODEL.md
├─ S002_GIT_OWNERSHIP_AND_MULTI_REPOSITORY.md
└─ S003_HISTORY.md
```

### S001_PROJECT_AND_REPOSITORY_MODEL.md

Project Repository / Project Root、Component Repository、単一/複数repository、top-level filesystem構造、Primary Checkoutの静的役割を扱う。旧Workspace Repository用語はhistory / compatibility contextへ退避する。

### S002_GIT_OWNERSHIP_AND_MULTI_REPOSITORY.md

Git所有境界、Work Documentsとrepository worktreeのownership境界、複数repository、stable repository identityとWork Identityの `REPO` selector接続を扱う。

### S003_HISTORY.md

旧artifact間の責務境界など、現在のsubject構造以前の歴史的情報を保持する。

## Work Identityとの接続

```text
workspace-structure
  Project / repositoryの静的構造
        ↓
work-identity
  Work単位の動的構造
```

`.worktrees/` の内部path、Work Root、Work Documents、repository-specific worktree、Work単位のbranch/resource lifecycleは `../work-identity/` が主所有する。

## 再編元

旧 `development-environment` のうち、project全体の静的repository/filesystem構造を所有していた情報をこのsubjectへ移管した。

## Work Identity共存監査

`workspace-structure` と `work-identity` の責務境界を再確認し、次を現行contractとして揃えた。

```yaml
workspace_structure_owns:
  - "Project Repository / Project Root"
  - "Component Repository"
  - "stable repository identity / role / base location"
  - "project-level Git ownership boundary"

work_identity_owns:
  - "Work Identity / Work Root / Work Documents"
  - ".worktrees/ 内部のWork単位構造"
  - "repository-specific worktree"
  - "Work単位のbranch / resource / lifecycle"
  - "REPO selectorからWork branch/pathへのmapping"
```

修正済み:

- 旧 `.worktrees/<component>/<task-identity>/` layoutを現行本文から除外
- `.worktrees/` 全体ignoreを撤回
- Work Documents trackingとrepository-specific worktree ignoreを分離
- 旧Task Worktree定義をhistoryへ移動
- Project Repository / Component Repositoryをcurrent roleとして明文化し、Workspace Repositoryを旧/compatibility用語へ整理
- stable repository identityとWork Identityの `REPO` selectorを接続

旧定義は `S003_HISTORY.md` に保存している。

## AI development entryとの接続

Project Repository / Project RootをAI development sessionの入口として扱うstatic contractは `S001_PROJECT_AND_REPOSITORY_MODEL.md` が主所有する。

Component RepositoryのGit ownershipとProject-level development context ownershipを分離する規則は `S002_GIT_OWNERSHIP_AND_MULTI_REPOSITORY.md` を参照する。

実際のcommand target / `DIR` selectionは `../development-execution/S003_COMMAND_INTERFACE_AND_CI.md`、Work Rootとrepository-specific worktreeの動的意味は `../work-identity/` が主所有する。

source: `../../records/2026-10-03-project-root-execution-routing/`

## Project / Component repository terminology

current normativeでは `Project Repository` / `Component Repository` を責務roleとして使用する。parent/child repository hierarchyと旧Workspace Repository peer-role modelはcurrent authorityにしない。判断根拠は `../../records/2026-10-03-project-component-documentation-boundary/` を参照する。

## Decision lineage — repository role model

Current:

- `../../records/2026-10-03-project-component-documentation-boundary/` — Project Repository / Component Repositoryをcurrent repository roleとする責務model

Superseded:

- `../../records/2026-09-21-docs-jp-snapshot/` — Workspace Repositoryを独立current roleとして扱う旧model。semantic knowledgeは `S003_HISTORY.md` に保持する

parent / child repository hierarchyと旧Workspace Repository peer-role modelはcurrent authorityではないが、subjectsからsemantic historyを削除しない。
