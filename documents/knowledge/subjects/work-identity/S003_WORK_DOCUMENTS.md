# Work Identity — Work Documents

Work Documents、Project Documentationとの関係、Git所有権、Primary/mainの役割、完了時reconciliation、履歴管理を扱う。Project Documentation内部のrouting / file role / maintenanceは `../documentation/` が主所有する。

## Work Documents

```text
.worktrees/<work-type>/<work-name>/documents/
```

を **Work Documents** と呼ぶ。

これは「一時ドキュメント」ではない。

Work Documents は、その Work Identity について現在進行している、

- 設計
- 調査
- 判断
- 仮説
- 検証
- 移行計画
- 実装に必要な作業固有コンテキスト

を記録する正式な作業ドキュメント領域である。

例:

```text
.worktrees/
└─ feat/
   └─ pathfinding/
      └─ documents/
         ├─ DESIGN.md
         ├─ INVESTIGATION.md
         └─ VERIFICATION.md
```

ファイル名や必須ファイルの固定は、この設計原本では行わない。

目的は、Work 固有の必要情報を失わず保存できる場所を提供することである。

---

---

## Project Documentation と Work Documents

両者は意味が異なる。

### Project Documentation

```text
<project-root>/documents/
```

現在確定しているプロジェクト状態を表す canonical knowledge。内部のdirectory / file role / routingは `../documentation/` が所有する。

### Work Documents

```text
<project-root>/.worktrees/<work-identity>/documents/
```

現在進行している変更についての knowledge。

例えば、

```text
documents/architecture/pathfinding.md
```

が現行仕様を表し、

```text
.worktrees/feat/new-pathfinding/documents/DESIGN.md
```

が次の仕様変更についての設計を表す状態を許容する。

この二層構造により、

```text
現在確定している状態
+
現在何を変えようとしているか
```

を同じ Project Repository から把握できる。

---

---

## Work Documents の Git 所有権

Work Documents は Git 管理する。

所有者は、`.worktrees/` が配置されている Project Root を所有する **最上位の Project Repository** とする。

つまり、

```text
.worktrees/<work-type>/<work-name>/documents/
```

は Project Repository の tracked files であり、原則として main に存在する。

一方、その兄弟ディレクトリである、

```text
.worktrees/<work-type>/<work-name>/<repository>/
```

は、それぞれ参加 repository の Git worktree であり、親 Project Repository の通常ファイルとしては管理しない。

---

---

## main の役割

main は、完成済みコードだけを示す場所ではなく、**プロジェクトの現在状態を把握する基準面**として扱う。

実装途中のソースコードは各作業 branch に隔離する。

一方、Work Documents は main から確認できるようにする。

例:

```text
.worktrees/
├─ feat/
│  ├─ pathfinding/
│  │  └─ documents/
│  └─ admin-dashboard/
│     └─ documents/
└─ fix/
   └─ login-timeout/
      └─ documents/
```

これにより main を見るだけで、

- 現在の canonical Project Documentation
- 現在進行中の Work Identity
- 各 Work が何を目的としているか
- 設計・調査・検証の状態

を間接的に把握できる。

これは人間だけでなく、AI がプロジェクト状況を理解する入口としても利用できる。

---

---

## Work Documents の完了時 reconciliation

Work Documents は、Work 完了後にそのまま Project Documentation へ全コピーしない。

Work 完了時には **reconciliation** を行う。

```text
Work Documents
      ↓
review / reconcile
      ├─ 今後も正本として必要
      │      ↓
      │   Project Documentation へ統合
      │
      └─ 作業中だけ必要
             ↓
          破棄
```

Project Documentation へ昇格する候補:

- 確定した設計
- 今後も必要な運用知識
- 恒久的な制約
- 将来の開発者 / AI が必要とする判断結果

原則として残さない候補:

- 途中の仮説
- 採用されなかった案
- raw benchmark output
- 一時的な検証ログ
- 完了後に意味を持たない作業メモ

Work Documents 自体の過去は Git history から確認できるため、独自 archive を作らない。

---

---

## Git history を履歴機構として使用する

Work Documents の履歴、変更過程、削除済みWorkの確認には Git を使用する。

独自の、

- archive directory
- history database
- generated manifest
- parallel version-history system

を Work Identity のために導入しない。

Work 完了後に Work Root が削除されても、tracked Work Documents の過去は Git history に残る。

---

## Sources

- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/development-environment-strategy/source-logs/WORK_IDENTITY_DESIGN_JP.md`
