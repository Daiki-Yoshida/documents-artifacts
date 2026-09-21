# Work Identity — Work Root and Repositories

Work Identityのfilesystem表現、単一/複数repositoryの統一形状、repository派生identity、Git worktreeの物理配置とProject-level `.worktrees/` の境界を扱う。

## Project Root と `.worktrees/`

`.worktrees/` を単なる Git worktree 格納ディレクトリとして扱わない。

今後は、**Project Repository が所有する Work Identity Workspace** として扱う。

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
      └─ main/
```

`main/` がそのプロジェクト本体 repository の Git worktree である。

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
.worktrees/feat/pathfinding/main/
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

## tracked Work Documents と nested worktree の技術課題

Project Repository が、

```text
.worktrees/<work-identity>/documents/
```

を main で track すると、同じ Project Repository の feature worktree がその commit を取り込んだ際に、Project-level `.worktrees/` が feature worktree 内へ再帰的に materialize される可能性がある。

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
.worktrees/feat/pathfinding/main/
├─ documents/
├─ src/
└─ ...
# Project-level .worktrees/ はここへ再帰展開しない
```

この問題は概念モデルを変更して回避せず、Git の materialization 設定で解決する方向とする。

候補:

- worktree ごとの sparse checkout
- 同等の checkout exclusion mechanism

ただし、**具体的な実装方式は artifact 化前または実装時に実機検証する**。

この技術詳細は、Work Identity の概念そのものとは分離する。

---

---

## `.work/` を別途導入しない

Work Root がすでに、

```text
.worktrees/<work-type>/<work-name>/
```

として存在するため、別の、

```text
.work/<work-identity>/
```

は基本モデルとして導入しない。

Work Identity 固有の filesystem state は、必要に応じて Work Root 配下へ配置する。

ただし、Docker volume など外部システムが所有すべき状態まで filesystem 上へ無理に集約しない。

---

## Sources

- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/development-environment-strategy/source-logs/WORK_IDENTITY_DESIGN_JP.md`
