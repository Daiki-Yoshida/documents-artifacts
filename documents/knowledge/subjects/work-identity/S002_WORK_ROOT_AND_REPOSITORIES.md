# Work Identity — Work Root and Repositories

Work Identityのfilesystem表現、単一/複数repositoryの統一形状、repository派生identity、Git worktreeの物理配置とProject-level `.worktrees/` の境界を扱う。
> Project Repository / Project Root / Component Repositoryの**静的な定義と配置**は `../workspace-structure/` が主所有する。ここでは、それらが1つのWorkへ参加するときのWork Root内構造と関係だけを扱う。


## Project Root と `.worktrees/`

`.worktrees/` を単なる Git worktree 格納ディレクトリとして扱わない。

現行モデルでは、**Project Repository が所有する Work Identity Workspace** として扱う。

基本形:

```text
<project-root>/
├─ documents/
└─ .worktrees/
   └─ <work-type>/
      └─ <work-name>/
         ├─ documents/
         └─ <repository>/
```

ここで、

```text
.worktrees/<work-type>/<work-name>/
```

が Work Identity の物理的な **Work Root** となる。

Project Root は、`.worktrees/` が配置されている最上位の Project Repository のルートである。

---

---

## 単一 repository と複数 repository を同一形状にする

この設計では、単一 repository と複数 repository で異なるディレクトリモデルを導入しない。

理由:

1. プロジェクト構成の変更に強くする。
2. 単一 / 複数 repository 専用の管理フローを別々に説明しない。
3. AI がプロジェクト形態によって判断を分岐する必要を減らす。
4. artifact のコンテキスト量と例外規則を抑える。

### 単一 repository

```text
.worktrees/
└─ feat/
   └─ pathfinding/
      ├─ documents/
      └─ project/
```

`project/` は、そのprojectでProject Repositoryを指すstable repository selectorの例である。selector名はproject-localであり、Git branch名を意味しない。

### 複数 repository

```text
.worktrees/
└─ feat/
   └─ hogehoge/
      ├─ documents/
      ├─ front/
      └─ back/
```

`front/`、`back/` がそれぞれの Component Repository の Git worktree である。

構造上は同じであり、Work Identity Root の直下に、

- Work Documents
- 参加 repository の worktree

を並べる。

---

---

## Base Work Identity と repository 派生 identity

複数 repository が一つの開発目標に参加する場合、まず Work 全体の Base Work Identity を持つ。

例:

```text
Base Work Identity:
feat/hogehoge
```

そこから repository ごとの派生 identity を持たせる。

例:

```text
feat-hogehoge-front
feat-hogehoge-back
```

重要なのは、各 repository の branch / runtime identity が Base Work Identity との対応を deterministic に追跡できることである。

branch 名の具体的な構文はプロジェクト規約に委ねる。

例えば次のいずれも設計上は許容できる。

```text
feat/hogehoge/front
feat/hogehoge/back
```

```text
feat-hogehoge-front
feat-hogehoge-back
```

ただし、一つのプロジェクト内では意味関係が一貫していなければならない。

---

---

## Git worktree との物理互換性

Git worktree は次へ配置する。

```text
.worktrees/<work-type>/<work-name>/<repository>/
```

例:

```text
.worktrees/feat/hogehoge/front/
.worktrees/feat/hogehoge/back/
```

単一 repository:

```text
.worktrees/feat/pathfinding/project/
```

この構造により、

```text
Work
  ↓
participating repository
```

という順序を filesystem 上でも表現する。

---

---

## Work RootとAgent Session Rootを分離する

Work Rootは、Work Identityに属するWork Documentsとparticipating repository worktreeを束ねる**物理的な作業領域**である。

ただしWork Rootは、Project全体を理解するためのAI development session entry rootではない。

Projectに属するdevelopment workでは、

```text
Agent Session Root
  = Project Root

Work Root
  = .worktrees/<work-type>/<work-name>/
```

を区別する。

AIはProject RootからProject Documentation、project policy、public command interface、repository ownership / selector、Work Identity rule等を解決し、その後にWork Root内のparticipating repository worktreeへ操作をroutingする。

```text
Project Root
  ↓ project context / routing
Work Identity / Work Root
  ↓ participating repository
repository-specific worktree
```

したがって、

```text
.worktrees/<work-type>/<work-name>/
.worktrees/<work-type>/<work-name>/<repository>/
```

をProject全体のAI session entry rootとして扱わない。

Project Repository自身のlinked worktreeがWork Root配下にある場合も同じであり、そのworktreeはimplementation targetであってProject Rootの代替ではない。

個々のbuild/test/install等でsubprocess working directoryをrepository-specific worktreeへ変えることは、この規範と矛盾しない。Project Rootからpublic commandを利用して別directoryへexecutionをroutingするgeneric contractは `../development-execution/S003_COMMAND_INTERFACE_AND_CI.md` が所有する。

## tracked Work Documents と nested worktree の技術課題

Project Repository が、

```text
.worktrees/<work-type>/<work-name>/documents/
```

をProject baseline branchでtrackすると、そのcoordination stateを取り込んだProject RepositoryのWork worktreeで、Project-level `.worktrees/` が再帰的にmaterializeされる可能性がある。

望ましい filesystem state は次である。

### Primary / Project Checkout

```text
project-root/
├─ documents/
├─ .worktrees/        # tracked Work Documents を materialize
└─ ...
```

### Work Identity 内の Git worktree

```text
.worktrees/feat/pathfinding/project/
├─ documents/
├─ src/
└─ ...
# Project-level .worktrees/ はここへ再帰展開しない
```

この問題は概念モデルを変更して回避せず、Project Repositoryのlinked Work worktreeへworktree-local materialization policyを適用して解決する。

現行の検証済みcontractは `S005_WORKTREE_MATERIALIZATION.md`、public create/status/remove semanticsは `S006_WORKTREE_COMMANDS.md` が所有する。具体的には、Project-level coordination stateを所有するrepositoryへ必要なsparse exclusionをworktree-localに適用し、nested filesystemへProject-level `.worktrees/` をmaterializeしない。

この技術詳細はWork Identityの概念そのものとは分離する。

---

---

## `.work/` を別途導入しない

Work Root がすでに、

```text
.worktrees/<work-type>/<work-name>/
```

として存在するため、別の、

```text
.work/<work-type>/<work-name>/
```

は基本モデルとして導入しない。

Work Identity 固有の filesystem state は、必要に応じて Work Root 配下へ配置する。

ただし、Docker volume など外部システムが所有すべき状態まで filesystem 上へ無理に集約しない。

---

## Sources

- `../../records/2026-10-03-subject-consistency-convergence/`

- `../../records/2026-10-03-project-root-execution-routing/`

- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/development-environment-strategy/source-logs/WORK_IDENTITY_DESIGN_JP.md`
