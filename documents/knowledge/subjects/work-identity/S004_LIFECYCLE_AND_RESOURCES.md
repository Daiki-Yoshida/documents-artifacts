# Work Identity — Lifecycle and Resources

Work lifecycle、Project/Work/Run resource scope、Resource Identityの伝播、Work Identityの非目標を扱う。

## Work lifecycle

基本ライフサイクル:

```text
Goal established
       ↓
Design / discussion
       ↓
Work Identity confirmed
       ↓
Work Documents created on Project main
       ↓
branch / checkout / optional worktree prepared
       ↓
required work-scoped runtime created
       ↓
implementation
       ↓
verification
       ↓
integration
       ↓
Work Documents reconciled into Project Documents
       ↓
work-scoped resources reconciled / cleaned
       ↓
Work Identity completed
```

### Work 完了と branch merge は同義ではない

特に複数 repository では、一つの branch merge は Component Work の完了を示すだけで、Work 全体の完了とは限らない。

例:

```text
feat/hogehoge
├─ front      merged
├─ back       active
└─ documents  active
```

この場合、Base Work Identity はまだ active である。

Work 全体の完了判定では、参加 repository の状態と Work Documents の reconciliation を含めて判断する。

---

---

## Resource scope

Work Identity を導入しても、すべてのリソースを Work ごとに複製してはならない。

状態は少なくとも次の scope に分ける。

### Project-scoped

プロジェクト全体で安全に共有でき、Work より長寿命なもの。

例:

- shared image
- immutable dependency cache
- SDK / tool cache
- safely reusable read-only state

### Work-scoped

Work Identity の ownership / lifecycle に属するもの。

例:

- branch
- optional worktree
- mutable runtime
- isolated database / test state
- host port allocation when isolation is required
- logs
- Work Documents
- generated work outputs

### Run-scoped

一回の実行だけに属する短命状態。

例:

- individual test process
- temporary file
- one command execution output

ただし、Run-scoped resource も ownership 上は Work Identity 配下にある。

```text
feat/pathfinding
├─ verification run A
├─ verification run B
└─ verification run C
```

実行回数ごとに新しい Work Identity を作らない。

---

---

## Resource Identity の伝播

Work 固有の分離が必要な場合、同じ Work Identity を各 subsystem へ deterministic に伝播させる。

概念例:

```yaml
resource_identity:
  project: "project slug"
  component: "repository/component when relevant"
  work: "work identity"
  role: "resource role"
```

対象例:

- Compose project / container namespace
- mutable volume
- network
- host port allocation
- test database
- log path
- generated output path

ただし、Work Identity が存在するだけでは専用リソース生成の理由にならない。

既存の shared resource が安全に再利用可能なら共有する。

---

---

## 設計上の非目標

Work Identity は次を目的としない。

- すべてのWorkにGit worktreeを強制すること
- WorkごとにDocker imageを作ること
- Workごとに全volume/network/cacheを複製すること
- 実行回数をWorkとして管理すること
- 独自の状態管理DBを作ること
- Project DocumentsをWork Documentsへ置き換えること
- Gitを使用できない環境を禁止すること

Work Identity は **意味・ownership・lifecycleを揃えるための共通軸** であり、不要な分離状態を増やす仕組みではない。

---

## Sources

- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/development-environment-strategy/source-logs/WORK_IDENTITY_DESIGN_JP.md`
