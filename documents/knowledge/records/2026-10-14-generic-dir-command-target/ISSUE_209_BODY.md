## 背景・問題提起

Issue #148（Project Root / public command / generic `DIR`）で、AI development sessionをProject Rootに維持し、Project-owned public commandへ実行対象をパスで渡す設計を導入した。現行の主なauthorityは次のとおり。

- `documents/knowledge/subjects/development-execution/S003_COMMAND_INTERFACE_AND_CI.md`
- `documents/knowledge/subjects/work-identity/S006_WORKTREE_COMMANDS.md`
- `artifacts/execution/COMMANDS_AND_CI.md`
- `artifacts/project/WORKTREES.md`

しかし、現在の `DIR` 説明は「既存のexecution target directoryを選ぶ」用途に寄り、Worktree lifecycleには `WORK + REPO`、既存のDocker Work-runtime behavior fixtureにも `WORK=` を使う公開操作がある。これらを読んだAIが、日常の公開コマンドにもWork Identity専用の引数を優先して設計する余地がある。

ユーザー報告では、Artifactを参照したあるプロジェクトで `make WORK=feat/hogehoge docker-up` のような公開インターフェイスが実装された。一方、ユーザーが想定していたのは **`make DIR=.worktrees/feat/hogehoge/ docker-up`** というパス指定だった。この外部プロジェクトの実装原因や使用Artifactの版は未調査であり、Artifactが直接の原因だったとは確定しない。

## ユーザーが明確化した設計意図

**`DIR` は単にディレクトリパスを受け取る、汎用の指定対象パラメータである。** `DIR` 自体にはWork Identity、Repository Identity、Docker Runtime Identity等の意味を持たせない。

**そのディレクトリパスを何の指定として扱うかは、呼び出されたpublic commandの契約が決める。** 例えば:

```bash
# 指定ディレクトリを基準として該当するDocker環境を起動
make DIR=.worktrees/feat/hogehoge/ docker-up

# 指定ディレクトリをテスト対象にする
make DIR=.worktrees/feat/hogehoge/game test

# 指定ディレクトリをlint対象にする
make DIR=components/web lint

# 指定ディレクトリを基準に必要なものを作成する操作
make DIR=components/api generate
```

`docker-up` がWork単位の操作なら、**コマンド側が与えられたパスを検証し、その構造や既存のProject情報から対象Work/Runtimeを解決してよい**。呼出側に毎回 `WORK=`、`REPO=` 等の別表現への変換を要求したいわけではない。識別子は操作内部の意味解決に必要なら使う。

汎用の `DIR` を統一的に利用すること自体が目的である。Project Rootからの実在パスを利用者が辿り、ファイルパス補完（Tab補完等）を活用しやすくする、という人間の操作性も重要な動機。実際に利用するshell/Make補完の挙動は別途検証する。これは単なる変数名の変更提案ではない。

## 検討したい規範と境界

1. **Generic selector:** `DIR` はProject Root基準で解決するディレクトリパス。共通のWork/Repo/Runtime意味を付与しない。受け取ったパスの存在要件・基準・用途はコマンドが明示する。
2. **Command-owned semantics:** public commandはパスをその操作の指定対象として解釈する。既存Workに対する操作、Repository操作、作成先指定など、意味は各commandのcontractが定義する。したがって「すべての `DIR` は既存checkoutへのbuild/test対象に限る」という制約を汎用モデルにしない。
3. **Internal resolution:** 例えば `docker-up` は検証済みのWork RootパスからWork Identityを特定し、必要なDocker/Compose対象・名前空間・mount先等を一貫して解決できる。ただし `DIR` そのものをWork Identityへ再定義したり、パス文字列を無検証で権限や識別の証拠に使ったりしない。
4. **Lifecycle consistency and safety:** `up/status/config/verify/down/cleanup` は同一入力から同じResource Identityを解決すること。Work以外のscopeへの誤適用・shared resourceの削除・既定Runtimeへのfallbackを防ぐ。存在しない `DIR` の扱いは既存対象操作と作成系操作で区別する。symlink/canonical path、所有境界・権限・破壊的操作の確認規約は維持する。
5. **Worktree APIとの関係:** 現行 `WORK + REPO (+ BASE)` によるworktree create/status/remove contractは存在する。これを単に `DIR` で置換すると宣言する前に、その位置づけ（identity入力を要求する操作の境界、project-specificな高位API、`DIR`からの安全な解決可能性）を検討し、公開コマンドの汎用パス指定思想との整合を判断する。
6. **Project-local specialization:** 特定Project独自の高位selectorを排除する目的ではない。ただし汎用 `DIR` の意味を、固定の `/main` / `/android` 補完やWork Identityに暗黙変換する規約として再定義しない。コマンド固有の内部導出は別の責務として説明する。
7. **Public interface:** Project Root上のMakefile/wrapper等が人・AI・CIの安定した窓口であり、各コマンドが標準的な対象指定パラメータを持つことの価値を明確化する。単に内部実装の短縮記法ではない。

## 現行規約での曖昧さと修正候補（未着手）

- `S003_COMMAND_INTERFACE_AND_CI.md` / `artifacts/execution/COMMANDS_AND_CI.md`: 「Execution Target Directory」へ限定した説明を、**汎用ディレクトリパス指定 + コマンド固有の意味解決**として明確化する。
- `S006_WORKTREE_COMMANDS.md` / `artifacts/project/WORKTREES.md`: `WORK + REPO` を公開インターフェイスとして要求する範囲と `DIR` の関係を監査する。安全なmaterialization・identity解決の契約は弱めない。
- `work-identity` / `development-execution` / `development-safety` の責務境界、特にWork-scoped Docker resource identityの伝播との整合を確認する。
- 現行 `tests/repositories/work-runtime-lifecycle/` にある `make work-up WORK=...` を歴史的な具体例として確認し、必要なら `DIR` 入力から対象を解決する正/負の検証ケースを設計する。旧fixtureを根拠なく破壊・書き換えない。

## 進め方・完了条件（案）

1. **原文保存:** この議論の選定したユーザーメッセージ、参照先のassistant提案、起票時点のIssue本文を、現行 `RECORD_MODEL.md` のbounded Bundleとして新規 `documents/knowledge/records/` に保存する（Coverage/Fidelityとevent境界を明示、既存recordは変更しない）。
2. **既存契約の独立レビュー:** `DIR` の原意（Issue #148と当時のsource record）、Worktree lifecycle、Work Runtime、公開コマンドの責務を突き合わせて、必要な変更と維持すべき境界を特定する。
3. **設計収束:** 利用者が指定するパスの意味、各コマンドの解釈と検証、内部Work Identity導出、存在しないpathの扱い、入力補完上の利点、Worktree操作の境界を具体例で整理する。
4. **必要なら規約改定:** 確認された判断を `records → subjects → artifacts` の順で更新し、routing/authority重複を点検する。
5. **動作検証:** 一つ以上の汎用操作とWork-scoped Docker操作を使い、同一 `DIR` から期待どおり対象を解決し、status/down/cleanupまで一致することを検証。既存の安全条件、Project Root entry、Repository ownershipが維持されることも確認する。
6. **報告:** 変更・非変更の採否理由、対象Projectへの適用要否、未検証点を区別して記録する。

## 関連

- 先行設計: #148 / #151
- 2026-10-03原文: `documents/knowledge/records/2026-10-03-project-root-execution-routing/`
- Generic DIR: `artifacts/execution/COMMANDS_AND_CI.md`
- Worktree lifecycle: `artifacts/project/WORKTREES.md`
- Docker runtime behavior fixture: `tests/repositories/work-runtime-lifecycle/`

## 今回の依頼と権限境界

今回の明示依頼は **Issueの作成と、新規Recordへの原文保存**。本Issueの起票は、subject/Artifact改定、既存テストの変更、target ProjectのMakefile変更、Work Identityの確定、PR merge、GitHub Actionsや外部有料サービスの利用を承認するものではない。実装Workの開始と採用仕様は後続の判断で確定する。
