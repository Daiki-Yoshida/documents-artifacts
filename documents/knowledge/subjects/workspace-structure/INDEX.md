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

Project Repository / Project Root、Workspace Repository / Component Repository、単一/複数repository、top-level filesystem構造、Primary Checkoutの静的役割を扱う。

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
