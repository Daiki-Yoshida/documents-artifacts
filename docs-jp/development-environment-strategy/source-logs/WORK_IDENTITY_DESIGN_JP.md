# Work Identity 設計原本

```yaml
document_type: "source_rationale_log"
target_audience: "human_readers"
language: "japanese"
authority: "non_canonical_source_log"
status: "design_approved_pending_artifactization"
future_owner: "artifacts/development-environment-strategy/"
```

> この文書は、Work Identity という新しい開発環境概念を artifact 化する前の設計原本です。
> 現在有効な規範を直接変更するものではありません。
> 情報・背景・判断理由を圧縮せず保存し、後続工程で AI 向け artifact へ再構成するために使用します。

---

## 1. 目的

開発作業の管理単位を、ツール固有の識別子や個々の実行回数ではなく、**「何を実現するための開発作業なのか」**という意味のある単位へ統一する。

その単位を **Work Identity** と呼ぶ。

Work Identity は単なる命名規則ではなく、次の三つをまとめる境界である。

```yaml
work_identity:
  meaning: "何を実現するための開発作業か"
  owns:
    - "ownership"
    - "resource identity"
    - "lifecycle"
```

目標は、Git、worktree、Docker、テスト状態、ログ、生成物、作業ドキュメントなどを、同じ開発目的から追跡できる状態にすることである。

---

## 2. なぜ Work Identity が必要か

開発中には複数の識別子が自然に発生する。

- Git branch
- Git worktree
- Docker Compose project
- container / network / volume
- test database / fixture
- logs
- temporary output
- working documents
- individual test or command executions

これらが独立した命名・ライフサイクルを持つと、同じ開発目的に属する状態であっても関連性が失われる。

望ましい関係は次である。

```text
User Goal
   ↓
Work Identity
   ├─ Git branch / worktree
   ├─ runtime state
   ├─ test state
   ├─ logs / outputs
   └─ Work Documents
```

Work Identity は、これらを意味的に束ねる上位概念である。

---

## 3. Work Identity を確定するタイミング

Work Identity は、アイデア相談や設計議論を始めた瞬間には作らない。

次の順序を基本とする。

```text
ユーザーが目標を提示
        ↓
人間 / AI で調査・設計・協議
        ↓
実装する内容が具体化
        ↓
Work Identity を明示的に確定
        ↓
実装開始
```

### 確定ルール

- Work Identity は **実装作業へ移る直前**に確定する。
- AI は Work Identity の候補を提案してよい。
- 実装開始前に、ユーザーがその Work Identity を明示的に確認する。
- まだ目的が曖昧な調査・相談段階では、Work Identity の生成を急がない。

これにより、Work Identity は会話や実行の都合ではなく、実際の開発目標から導出される。

---

## 4. 命名モデル

基本的な意味表現は次とする。

```text
<work-type>/<work-name>
```

例:

```text
feat/pathfinding
fix/login-timeout
refactor/payment-boundary
```

### work-type

`feat`、`fix`、`refactor` など、作業の種類を表す。

Git を利用する場合、この種別は branch prefix と意味的に一致させることを基本とする。

ただし、具体的な branch naming convention は各プロジェクトが所有する。

### work-name

作業の対象・責務・目標が人間に理解できる固有名を使用する。

ランダム値や単なる実行回数ではなく、**何を変更しているかが分かる名前**を優先する。

---

## 5. Git との関係

Work Identity は Git に依存しない。

```text
Work Identity
    │
    ├─ Git available
    │    └─ branch / worktree で表現・追跡
    │
    └─ Git unavailable / not applicable
         └─ Work Identity 自体で lifecycle を管理
```

Git は推奨される主要な追跡手段であり、通常のソフトウェア開発では branch を利用することが望ましい。

ただし概念の依存方向は次である。

```text
Work Identity
    ↓
Git representation
```

Git branch が Work Identity を定義するのではない。

---

## 6. Project Root と `.worktrees/`

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

## 7. 単一 repository と複数 repository を同一形状にする

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

## 8. Base Work Identity と repository 派生 identity

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

## 9. Work Documents

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

## 10. Project Documents と Work Documents

両者は意味が異なる。

### Project Documents

```text
<project-root>/documents/
```

現在確定しているプロジェクト状態を表す canonical knowledge。

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

## 11. Work Documents の Git 所有権

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

## 12. main の役割

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

- 現在の canonical Project Documents
- 現在進行中の Work Identity
- 各 Work が何を目的としているか
- 設計・調査・検証の状態

を間接的に把握できる。

これは人間だけでなく、AI がプロジェクト状況を理解する入口としても利用できる。

---

## 13. Work Documents の完了時 reconciliation

Work Documents は、Work 完了後にそのまま Project Documents へ全コピーしない。

Work 完了時には **reconciliation** を行う。

```text
Work Documents
      ↓
review / reconcile
      ├─ 今後も正本として必要
      │      ↓
      │   Project Documents へ統合
      │
      └─ 作業中だけ必要
             ↓
          破棄
```

Project Documents へ昇格する候補:

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

## 14. Work lifecycle

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

## 15. Resource scope

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

## 16. Resource Identity の伝播

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

## 17. Git worktree との物理互換性

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

## 18. tracked Work Documents と nested worktree の技術課題

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

## 19. `.work/` を別途導入しない

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

## 20. Git history を履歴機構として使用する

Work Documents の履歴、変更過程、削除済みWorkの確認には Git を使用する。

独自の、

- archive directory
- history database
- generated manifest
- parallel version-history system

を Work Identity のために導入しない。

Work 完了後に Work Root が削除されても、tracked Work Documents の過去は Git history に残る。

---

## 21. 設計上の非目標

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

## 22. 既存 development-environment-strategy との関係

現在の artifact にある次の思想は維持する。

- host / data safety を最優先する
- Docker-first execution
- worktree は必要な場合だけ使用する
- shared cache / image を安全なら再利用する
- parallel writer は mutable state を分離する
- cleanup は deterministic / scoped にする
- destructive purge と通常cleanupを分離する
- Gitが履歴を所有する
- 単なる識別子の存在を理由に追加resourceを作らない

変更される中心概念は、従来複数箇所に分散していた作業単位・branch・worktree・runtime ownership を **Work Identity** へ統合することである。

artifact 化では、既存思想を壊さず、この共通軸を各文書の所有範囲へ分配する。

---

## 23. artifact 化時の予定責務

このsource logをそのままartifactへコピーしない。

AIの認識・ルーティング・トークン効率を考慮し、既存文書のOwnershipへ再配置する。

想定:

```yaml
DEVELOPMENT_ENVIRONMENT_PHILOSOPHY.md:
  future_content:
    - "Work Identity の WHY"
    - "Goal -> Work Identity -> environment ownership という基本モデル"
    - "Git は Work Identity の表現手段であり定義元ではない"
    - "Work Identity確定タイミングの原則"

WORKSPACE_STRUCTURE.md:
  future_content:
    - ".worktrees/<type>/<name>/ を Work Root とする構造"
    - "単一 / 複数 repository の統一形状"
    - "Work Documents と repository worktree の配置"
    - "Base Work Identity と repository派生identity"
    - "Project Root / ownership boundary"

ENVIRONMENT_STANDARDS.md:
  future_content:
    - "Work-scoped resource identity"
    - "Project / Work / Run scope"
    - "resource reuse / creation rules"
    - "Git / filesystem safe normalization"

ENVIRONMENT_WORKFLOW.md:
  future_content:
    - "Work Identity確認からcompletionまでのlifecycle"
    - "Work Documents creation / update / reconciliation"
    - "branch / worktree / runtime preparation"
    - "multi-repository completion semantics"
    - "cleanup / retained state"

INDEX.md:
  future_content:
    - "Work Identity routing"
    - "Work Root / Work Documentsへの入口"
```

この分割は artifact 化工程で再レビューする。

---

## 24. artifact 化前に検証すべき事項

概念設計は確定しているが、少なくとも次は実装・artifact化前に技術検証する。

1. Project Repository が `.worktrees/**/documents/**` をtrackしながら、兄弟repository worktreeを安全にignoreできるGit設定。
2. 同一Project Repositoryのnested worktree内で、Project-level `.worktrees/` を再materializeしない方法。
3. sparse checkout を採用する場合、通常のbuild/test/editor操作への副作用。
4. `.worktrees/<type>/<name>/<repository>/` へのGit worktree生成・削除・pruneの安全な手順。
5. Work Documentsの削除とProject Documentsへのreconciliationを、Git履歴を壊さず行えること。

これらの結果によって実装手段は変わり得るが、Work Identity、Work Root、Work Documents、Project Repository ownershipという概念モデルは維持する。
