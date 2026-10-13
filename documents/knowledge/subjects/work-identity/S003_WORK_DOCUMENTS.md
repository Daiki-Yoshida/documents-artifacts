# Work Identity — Work Documents

Work Documentsと軽量なWork Records、Project Documentationとの関係、Git所有権、Project baseline branchへのvisibility/publication、完了時のreconciliation・履歴移管を扱う。Project Documentation内部のrouting / file role / maintenanceは `../documentation/` が主所有する。

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

## Work Records — 進行中の開発記録

Work Recordsは、Workに属する**開発過程の軽量なジャーナル**である。長時間にわたる作業で、Chat/CLIの一時的なcontextにしか残らない重要な判断・発見・失敗・検証結果を失わず、後続の作業主体が必要に応じて調べられるようにする。

標準の配置:

```text
<project-root>/.worktrees/<work-type>/<work-name>/documents/records/
```

Work RecordsはManagement Root RepositoryがGitで所有するWork Documentsの一部であり、Component Repositoryごとに別々の正本を作らない。Work Identityは記録の帰属を示し、記録主体・ツール・実行環境を限定しない。Work Identity確定前の探索的な議論は必要に応じてIssueやProject Documentationへ記録し、記録のためだけにWork Identityを生成しない。

### 軽量な記録単位と内容

- 一連の作業、セッション、または意味のある作業区切りを1つのMarkdownファイルとして記録できる。同じファイルに複数の判断・問題・結果を含めてよく、細かな操作単位に分割する必要はない。
- 主な内容は「何をしたか」「重要な判断と理由」「意味のある問題・解決」「検証済みの結果・残課題」。Work Identity、日時、記録主体、Issue/PR/commit等の証拠は判明する範囲で示す。固定スキーマや固定長は要求しない。
- 実測事実・推測・他者からの報告を区別し、重要な失敗と判断変更の経緯を維持する。原文会話の全量、全コマンド出力、厳密なprovenance表は要求しない。非公開情報を無条件で転載しない。
- 同じWorkに複数の作業主体が参加する場合、変更が衝突しない記録ファイルを選ぶ。全主体共通の連番発番・役割名を必須とせず、既存ファイルへの同時上書きを避ける。

### 長時間作業のチェックポイント

重要な判断、調査結果、問題解決、検証、引継ぎ、中断など**意味のある区切り**で、適切なRecordを更新する。明確な区切りが長く来ない場合にも、その時点の進捗と未解決事項を短く保存する。時間固定の自動監視・全操作の実況・チェックポイントごとのcommitを共通規約として求めない。

Work Recordsのファイル更新、Git commit、remote push、Project baselineへのpublicationは**別々の行為**である。管理ルート側で保存できても、未commit/未公開ならその状態を区別する。具体的なVCS authorityは`../engineering-operation/S006_VERSION_CONTROL_AND_REPORTING.md`が所有する。

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
<project-root>/.worktrees/<work-type>/<work-name>/documents/
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

を同じ Management Root Repository から把握できる。

---

---

## Work Documents の Git 所有権

Work Documents は Git 管理する。

所有者は、`.worktrees/` が配置されている Project Root を所有する **最上位の Management Root Repository** とする。

つまり、

```text
.worktrees/<work-type>/<work-name>/documents/
```

はManagement Root Repositoryが所有するtracked filesであり、**Project baseline branchから現在のactive Workとして確認できる状態**を目標とする。Project baseline branchはprojectが定義するstable coordination/documentation branchであり、名前をliteral `main` に固定しない。

一方、その兄弟ディレクトリである、

```text
.worktrees/<work-type>/<work-name>/<repository>/
```

は、それぞれ参加 repository の Git worktree であり、親 Management Root Repository の通常ファイルとしては管理しない。

---

---

## Project baseline branch の役割

Project baseline branchは、完成済みコードだけを示す場所ではなく、**プロジェクトの現在のcoordination / documentation stateを把握する基準面**として扱う。多くのprojectでは `main` がこのroleを担うが、branch名はproject-localである。

実装途中のソースコードは各Work branchへ隔離する。一方、Work DocumentsはProject baselineからactive Workとして確認できることを目標とする。

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

これによりProject baselineを確認することで、

- 現在の canonical Project Documentation
- 現在進行中の Work Identity
- 各 Work が何を目的としているか
- 設計・調査・検証の状態

を間接的に把握できる。

これは人間だけでなく、AIがProject状況を理解する入口としても利用できる。

### Baseline publicationとVCS authority

Work Identityは、Work DocumentsがProject baselineから確認可能になるというlifecycle上の目標を所有する。ただし、その状態を成立させるためのcommit / push / merge authorityを自動付与しない。

- project-local workflowがcoordination/documentation commitを明示的に許可する場合は、そのworkflowに従う。
- baseline publicationのauthorityがまだ無い場合、未公開なのに「baselineへ反映済み」と扱わない。
- その場合は、許可されたManagement Root Repository working state等へWork contextを保持し、baseline publicationがpendingであることをreportする。

commit / push / default-branch guard等のauthorityは `../engineering-operation/S006_VERSION_CONTROL_AND_REPORTING.md` が主所有する。

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

Work Documentsのうち、現行知識として必要な部分はProject Documentationへ統合し、不要な作業用文書は整理する。過去の版の追跡は引き続きGit historyが担う。**Work Recordsの歴史的記録は、完了後の専用Archiveへ移管する**。移管・cleanupの完了条件は `S004_LIFECYCLE_AND_RESOURCES.md` が所有する。

---

---

## Work Recordsの歴史的ArchiveとGit history

Work完了後、Work Recordsを次の**Project所有の非日常参照領域**へ移管する。

```text
<project-root>/documents/archive/works/<work-type>/<work-name>/records/
```

Archiveは、そのWorkに何が起きたかを後から調査するための資料であり、現在有効なProject Documentationの意味的authorityではない。通常のAI作業では全Archiveを読み込まず、必要なときにWork Identityと軽量な入口から参照する。詳細なArchive routingは `../documentation/S002_ROUTING_AND_STRUCTURE.md` が扱う。

Archiveの対象は**Work Records**であり、DESIGN・INVESTIGATION等のWork Documents全体の無差別なコピーではない。確定した設計・制約等は既存のProject Documentationへreconcileする。作業文書の旧版やArchiveの変更履歴はGitで管理し、独立した履歴DB、追加のversion registry、generated manifestは設けない。

移管では、既存のArchiveを無条件で上書きしない。保存・参照・Git所有境界が確認できない場合は元のWork Recordsを保持する。Workの最終完了とwork-scoped resourceのcleanupは `S004_LIFECYCLE_AND_RESOURCES.md` の条件に従う。

---

## Sources

- `../../records/2026-10-13-work-records-proposal/` — 初期提案と元のWork Documents意図（PR #205）
- `../../records/2026-10-13-work-records-implementation-adoption/` — 軽量化・長時間稼働・Archive移管と実装開始の後続判断

- `../../records/2026-10-03-subject-consistency-convergence/`

- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/development-environment-strategy/source-logs/WORK_IDENTITY_DESIGN_JP.md`
