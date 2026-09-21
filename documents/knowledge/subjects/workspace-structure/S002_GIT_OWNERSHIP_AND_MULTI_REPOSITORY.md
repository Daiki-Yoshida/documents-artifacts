# Workspace構造 — Git所有境界と複数Repository

Project Repository / Component Repository間のGit所有境界、複数repository構成、stable repository identity、Work Identityとの接続を扱う。

## Git所有境界

### Project Repository

Project Repositoryは、project-level coordination stateを所有する。

`.worktrees/` 全体を一律ignoreしてはならない。

Work Identityの現行モデルでは、少なくとも次を区別する。

```text
.worktrees/<work-type>/<work-name>/documents/
    → Project Repositoryがtracked fileとして所有

.worktrees/<work-type>/<work-name>/<repository>/
    → participating repositoryのGit worktree
    → Project Repositoryの通常fileとしては所有しない
```

したがってignore / materialization policyは、

> **Work Documentsをtrackしつつ、repository-specific worktree pathを通常fileとして扱わない**

という境界を満たす必要がある。

具体的な `.gitignore` patternやnested worktree materialization contractは `../work-identity/` が所有する。

Project Repository側で通常ignoreする代表例:

- 独立Git履歴を持つComponent Repositoryのcheckout
- Work Identity配下のrepository-specific worktree path
- local secret
- build / export生成物
- runtime cache
- 共有しないeditor / OS file

embedded repositoryをignoreするだけでなく、そのpathが独立repositoryであることをproject文書へ明示する。

### Component Repository

Component Repository自身が次を所有する。

- product source / test
- component固有Git履歴
- component cache / build output / generated file
- component固有tool state

Project RepositoryがComponent Repository内部の通常fileや生成物を誤って所有しないようにする。

## 複数repository

一つのProject / Workspace Repositoryで複数Component Repositoryを調整できる。

必要な性質:

```yaml
repository_identity:
  - "各repositoryにproject内で安定したidentityがある"
  - "各repositoryの基準checkout locationを安定して解決できる"
  - "project repositoryかcomponent repositoryかを識別できる"

operation_scope:
  - "project全体操作でなければ対象repositoryを明示できる"
  - "component横断操作は独立した明示operationとして扱う"

ownership:
  - "各repositoryのGit履歴所有者が明確"
  - "Project RepositoryがComponent Repositoryのsource/historyを重複所有しない"
```

無関係なrepositoryを同じfolderへ置くだけのためにWorkspace Repositoryを作らない。

共有tool、project-level coordination、cross-component orchestrationなど、実際の調整責務がある場合に利用する。

## Stable repository identity と REPO selector

Workspace Structureは、projectに参加するrepositoryの**静的identity・role・基準location**を所有する。

Work Identityは、その情報をWork単位の `REPO` selectorとして利用する。

関係:

```text
workspace-structure
  stable repository identity / role / location
        ↓
work-identity
  REPO selector
        ↓
Work Root内のrepository-specific worktree
```

例:

```text
Project Repository
  selector: main

Component Repository
  selector: front

Component Repository
  selector: back
```

これは独自registry fileを必須化する意味ではない。

実際のrepository / Git / filesystemを状態のsource of truthとし、projectがdeterministicに解決できるstable selectorを持てばよい。

`REPO` からWork branchやWork Root内pathをどう導出するかは `../work-identity/S006_WORKTREE_COMMANDS.md` が所有する。

## Primary Checkoutとの関係

各repositoryにstableな基準checkoutを持たせる場合、そのcheckoutはrepository identity / root resolutionの基準として利用できる。

ただし、

- Primary CheckoutでWorkを実装するか
- Work専用worktreeを作るか
- どのbranchをcheckoutするか

はWorkspace Structureの責務ではない。

Work単位の判断は `../work-identity/` またはproject固有policyが所有する。

## Workspace toolへの依存

Component Repositoryが別Workspace / Project Repository内のtoolへ依存する場合、使用versionを明示する。

```yaml
moving_ref:
  意味: "document化されたbranchまたは現在のworkspace checkoutを使う"
  特徴: "更新は簡単だが、過去再現性は弱い"

fixed_ref:
  意味: "tagまたはcommitを使う"
  特徴: "再現性は高いが、更新作業が必要"
```

CIやrelease検証が、指定されていないworkspace最新版へ偶然依存してはいけない。

## Sources

- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/development-environment-strategy/DEVELOPMENT_ENVIRONMENT_PHILOSOPHY.md`
- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/development-environment-strategy/WORKSPACE_STRUCTURE.md`
- `../../records/2026-09-22-workspace-work-identity-alignment/`
