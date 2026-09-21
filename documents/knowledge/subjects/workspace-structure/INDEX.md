# Workspace Structure

このsubjectは、**project全体のrepository/filesystem構造とGit所有境界**を扱う。

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

Workspace Repository / Component Repository、単一repository、top-level filesystem構造を扱う。

### S002_GIT_OWNERSHIP_AND_MULTI_REPOSITORY.md

Git所有境界、複数component、外部workspace tool dependencyを扱う。

### S003_HISTORY.md

旧artifact間の責務境界など、現在のsubject構造以前の歴史的情報を保持する。
