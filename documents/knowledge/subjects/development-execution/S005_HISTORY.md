# 開発実行 — 履歴・旧umbrella

この文書は、旧 `development-environment` umbrellaの責務定義や、現在の複数subjectへ分解される前の誤読防止を歴史的文脈として保持する。

現在は `development-execution` / `workspace-structure` / `development-safety` / `work-identity` がそれぞれ主責務を持つ。

## Original preambles

### DEVELOPMENT_ENVIRONMENT_PHILOSOPHY.md

# 開発環境の基本思想

```yaml
document_type: "development_environment_philosophy_translation"
target_audience: "human_readers"
language: "japanese"
source: "../../artifacts/development-environment-strategy/DEVELOPMENT_ENVIRONMENT_PHILOSOPHY.md"
strategy_version: "1.1.1"
authority: "英語版 artifacts/ が正本。内容に差がある場合は英語版を優先する"
```

### ENVIRONMENT_STANDARDS.md

# 開発環境の実装基準

```yaml
document_type: "environment_standards_translation"
target_audience: "human_readers"
language: "japanese"
source: "../../artifacts/development-environment-strategy/ENVIRONMENT_STANDARDS.md"
strategy_version: "1.1.1"
authority: "英語版 artifacts/ が正本。内容に差がある場合は英語版を優先する"
```

### ENVIRONMENT_WORKFLOW.md

# 開発環境の作業フロー

```yaml
document_type: "environment_workflow_translation"
target_audience: "human_readers"
language: "japanese"
source: "../../artifacts/development-environment-strategy/ENVIRONMENT_WORKFLOW.md"
strategy_version: "1.1.1"
authority: "英語版 artifacts/ が正本。内容に差がある場合は英語版を優先する"
```

---

## この戦略が担当する範囲

```yaml
担当する:
  - "ホストとcontainerの責務"
  - "開発toolの実行方法"
  - "repositoryと任意worktreeの構造"
  - "開発環境に関するトップレベルfolder"
  - "公開commandと開発環境script"
  - "ローカルとCIの実行経路"
  - "環境状態、診断、後片付け、復旧"
担当しない:
  - "application codeの設計"
  - "domain moduleの境界"
  - "documents/ の案内やversion管理"
  - "Issue整理やPull Request承認方針"
  - "release統制やteam権限"
```

---

## よくある誤解

- **Dockerファースト**は、すべての操作をDocker内で行うという意味ではない。
- **ホスト依存を最小化する**とは、全プロジェクト共通の固定許可リストを作ることではない。
- **worktree対応**は、すべてのタスクでworktreeを作るという意味ではない。
- **branchを作ること**と**worktreeを作ること**は別である。
- **Primary Checkout**はdefault branch専用ではなく、単独作業ではtask branchの実装場所として使える。
- **Workspace Repository**は、Git上の親リポジトリや必須submoduleを意味しない。
- **resource分離**は、すべてのcacheを複製する意味ではない。
- **安全性**は、作業を遅くすることではない。

## Sources

- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/development-environment-strategy/DEVELOPMENT_ENVIRONMENT_PHILOSOPHY.md`
- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/development-environment-strategy/ENVIRONMENT_STANDARDS.md`
- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/development-environment-strategy/ENVIRONMENT_WORKFLOW.md`


---

## 2026-09-22 cross-subject alignment

6 subject横断監査で、旧development-environment umbrella由来の責務がdevelopment-executionの現行本文へ残存していたことを確認した。

現行本文から次を除去・委譲した。

- repository / Workspace / Componentの静的構造 → `workspace-structure`
- Work / branch / worktree / resource lifecycle → `work-identity`
- destructive operation / diagnostics / recovery / confirmation → `development-safety`

旧modelではexecution workflow自身がrepository構造、Task Worktree path、task resource identity、安全性まで広く所有していた。この意味は本historyとsource recordへ保持する。

現在のdevelopment-executionは、host/container boundary、Docker-first、runtime materialization、public command surface、local/CI、reproducibilityへ責務を限定する。

Source decision:

- `../../records/2026-09-22-six-subject-cross-audit-fixes/`


---

## 6 subject横断整合前のnormative snapshot

以下は2026-09-22の6 subject横断整合直前、mainに存在したdevelopment-executionの現行本文をそのまま保存したsnapshotである。

このsnapshot内のrepository/worktree/task/safety ownershipは旧development-environment umbrella由来であり、現在の規範ではない。現在の規範はS001〜S004を参照する。


### 旧 S001_EXECUTION_MODEL.md

# 開発実行 — 基本モデル

開発処理をどこで実行し、どの状態から再現し、どの入口から操作するかという実行契約の基本モデルを扱う。

## 開発環境は契約である

開発環境は、各開発者やAIエージェントが手元へ好きにツールを追加して使うだけのものではありません。

開発作業をどこから始め、どこで実行し、どう分離し、どう検証し、最後にどう片付けるかを定めた「契約」として扱います。

```yaml
開発環境の契約:
  構造: "リポジトリ、checkout、worktree、ツール、キャッシュ、生成物をどこへ置くか"
  ツール構成: "ホストへ置くツールと、プロジェクト実行環境へ置くツールの境界"
  公開コマンド: "人、AIエージェント、CIが利用する安定した操作"
  状態管理: "環境を作成、確認、再利用、削除、復旧する方法"
  分離: "プロジェクト、タスク、branch、並列エージェント同士の衝突を防ぐ方法"
  安全性: "通常操作、破壊的操作、事前確認が必要な操作の区別"
```

内部のDocker構成やスクリプトは変更されても構いません。ただし、日常的に使うビルド、テスト、診断、削除の入口は、意味が明確で安定している必要があります。

---

## 制御面と実行面

```yaml
ホストの制御面:
  役割: "Git、Docker、コマンド振り分け、認証、遠隔接続を管理する"
  原則: "明示的な例外がない限り、プロジェクト固有runtimeやpackage環境を置かない"
コンテナの実行面:
  役割: "言語runtime、package manager、build、test、プロジェクト固有CLIを持つ"
  原則: "リポジトリ管理された定義から、実行環境を再現できるようにする"
```

ホストは原則としてプロジェクトの実行環境そのものではなく、それを制御する場所です。

---

## 再現性

あるリポジトリ状態を取得したとき、その開発環境の動作を再現できるだけの情報が、リポジトリ側に存在する必要があります。

```yaml
必要な性質:
  - "重要なtool versionまたは許容範囲が管理されている"
  - "依存関係のlockファイルを尊重する"
  - "文書化されていないホスト状態へ依存しない"
  - "可能な限りローカルとCIが同じプロジェクト管理コマンドを使う"
  - "外部Workspace Repositoryへの依存version選択を明示する"
```

再現性とは、更新を禁止することではありません。変更が意図的で、追跡できることです。

## Sources

- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/development-environment-strategy/DEVELOPMENT_ENVIRONMENT_PHILOSOPHY.md`


### 旧 S002_HOST_AND_CONTAINER.md

# 開発実行 — ホストとコンテナ

ホスト側の制御責務とコンテナ側の実行責務、Docker-first、resource materialization、mount・cache・network・secretの実装基準を扱う。Work単位のownershipは `../work-identity/` が主所有する。

## 1. ホスト依存の境界

ツールを固定リストだけで判断せず、役割で分類します。

```yaml
ホスト側の基本役割:
  - "DockerとCompose"
  - "Gitなどのソース管理"
  - "Makeやshellなどのコマンド入口"
  - "SSH・tmux などの認証と遠隔接続"
コンテナ側の基本役割:
  - "言語runtime"
  - "package manager"
  - "compilerとbuild toolchain"
  - "test runtime"
  - "DB・migration CLI"
  - "project固有のcloud・deploy CLI"
```

- リポジトリ管理されたコンテナ実行が現実的なら、project runtimeをホストへ要求しない。
- エージェントがcontainer commandを面倒に感じたという理由だけで、host packageを追加しない。
- host例外を設ける場合は、container化が不適切な理由とversion差異の管理方法を明記する。
- 対話的desktop toolはhostに置けるが、buildやCLIは可能な限りcontainer側へ置く。
- 日常操作でsudoなどの昇格権限を前提にしない。

---

## 2. Docker基準

### Dockerファースト

- build、test、lint、format、migration、project固有CLIは、repository管理のDocker定義から実行する。
- DockerfileやComposeは個人メモではなく、version管理された開発環境定義である。
- 事前作成されたhost network、global package、手動containerへ隠れて依存しない。
- 重要なruntimeやtoolはversionを固定または管理し、重要箇所で `latest` を使わない。
- container内でもlockファイルを尊重する。

### resourceの識別

すべてのresourceは、どのprojectが所有するか分かる必要があります。task固有の分離を行う場合だけ、taskやworktreeの識別子も含めます。

```yaml
必須:
  - "workspaceまたはproject名"
  - "resourceの役割"
必要な場合だけ追加:
  - "environment"
  - "component"
  - "taskまたはworktree"
性質:
  - "決定的"
  - "人が読める"
  - "host内で衝突しにくい"
  - "診断と限定cleanupに使える"
```

- `web`、`api`、`database` のように役割しか分からない名前を避ける。
- 安定した識別子があるなら無意味な乱数名を避ける。
- task固有のCompose project名は、並列または明示的に隔離したcheckoutを同時実行する場合だけ使用する。
- container、network、可変volume、log、temporary outputへ同じ識別体系を伝播する。

### resourceの作成と再利用

- task、branch、worktreeの識別子があること自体は、別のimage、container、network、volumeを作る理由にならない。
- build入力が同じなら、projectまたはcomponent単位のimageと安全に共有できるcacheを再利用する。
- 並列実行、可変状態の分離、設定差異、または明示的なproject規則により共有が危険・不正確になる場合だけ、runtime resourceを分ける。
- checkout、branch、task、worktreeが変わったという理由だけでimageをrebuild・retagしない。imageのbuild入力または必要toolchainが変わった場合に行う。
- 実際の分離要件を満たすために必要な、最小限のresourceだけを分ける。

### file所有権とmount

- containerがhostへ作成したfileは、host userが編集・削除できるようにする。
- bind mountした生成物にはUID/GID mappingなどを使う。
- permission問題を理由にcontainer全体をroot実行へしない。
- projectが意図的に所有する場合を除き、generated fileをsource directoryへ混在させない。
- cacheとbuild outputはGit管理から除外する。

### cacheとvolume

- 安全に再利用できる依存cacheは共有してよい。
- 複数checkoutの結果へ影響する可変状態は分離する。
- volume名から所有者と削除範囲を判断できるようにする。
- Task Worktree削除時に、他taskが使う共有cacheを黙って削除しない。

### portとnetwork

- 並列checkoutが同じ固定host portを奪い合わないようにする。
- host公開が不要ならcontainer内部networkを使う。
- host portが必要な場合は、隔離taskごとに明示的に割り当てる。
- cleanupは選択したprojectまたはtaskのnetworkだけを対象にする。

### secret

- secretをimageへ焼き込まず、repositoryへcommitしない。
- sampleと実値を分ける。
- command出力、log、診断、CI traceへsecretを表示しない。
- build-timeとruntimeのsecretは、それぞれに適した方法で渡す。
- 通常のbuildやtestでAIエージェントがsecret実値を読む必要をなくす。

## Sources

- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/development-environment-strategy/ENVIRONMENT_STANDARDS.md`


### 旧 S003_COMMAND_INTERFACE_AND_CI.md

# 開発実行 — 公開コマンドとCI

人・AI・CIが利用する公開command、操作意味、local/CIの実行経路を扱う。

## 操作内容を明確にする

コマンド名も開発環境契約の一部です。

```yaml
原則: "実行前に、操作対象と起こることを判断できなければならない"
必要なこと:
  - "曖昧な操作には対象範囲を付ける"
  - "通常の後片付けと、データを捨てる強制削除を分ける"
  - "生のツール構文ではなく、安定した目的を公開する"
  - "失敗を隠さず、次に確認すべきことが分かる出力を残す"
```

プロジェクト内で意味が一つに定まるなら、短いコマンド名でも構いません。

---

## 3. 公開コマンド

projectは、日常操作を見つけやすい公開command interfaceを持ちます。

```yaml
推奨構成:
  Makefile: "公開操作名、help、parameter、単純な依存関係"
  wrapper: "checkout選択や環境準備を共通化する任意のCLI入口"
  scripts: "複雑な分岐、検証、orchestration、cleanup、provider固有処理"
```

### Makefile

- targetは生のcommand列ではなく、安定した目的を表す。
- 複雑なshell処理は `scripts/` などへ分離する。
- help targetで操作、parameter、破壊的効果を説明する。
- 構造化parameterには専用変数を使い、quoteが曖昧になる万能引数を避ける。
- ローカルとCIは、可能な限り同じtargetまたはscriptを呼ぶ。

### target名

対象や副作用が曖昧になる場合は `<scope>-<action>` を使います。

- すべてへ機械的にprefixを付ける必要はない。
- `help`、`check`、`test`、`validate` はproject内の意味が一つなら短いままでよい。
- `up`、`down`、`reset`、`clean`、`deploy`、`logs` は通常scopeを必要とする。
- 互換aliasを残す場合でも、正規targetを明記する。

### 操作の意味

- command文書には対象、見える効果、破壊範囲を書く。
- 非破壊commandを同じ名前のまま破壊的処理へ変えない。
- stop、container削除、volume削除、完全purgeを分ける。
- 最終検証の標準commandを一つ定義する。
- 部分検証は実装中や診断用であり、最終gateの代替ではない。
- 失敗時はnon-zeroで終了し、診断可能な出力を残す。

---

## 7. ローカルとCI

- CIのworkflow YAMLへbuild/test本体を再実装せず、project管理commandを呼ぶ。
- provisioningが異なっても、最終的には同じ検証scriptへ合流させる。
- provider固有準備はCI edgeに置き、project動作はrepository管理commandへ置く。
- CIで別Workspace Repositoryを利用する場合は、使用refを明示する。
- 未指定の外部workspace最新版へ偶然依存しない。

## Sources

- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/development-environment-strategy/DEVELOPMENT_ENVIRONMENT_PHILOSOPHY.md`
- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/development-environment-strategy/ENVIRONMENT_STANDARDS.md`


### 旧 S004_ADOPTION_AND_MIGRATION.md

# 開発実行 — 導入と移行

新規projectへの実行環境導入と、既存projectへ安全に段階導入するbrownfield workflowを扱う。

## 1. 新規プロジェクトへの導入

### 手順1: リポジトリ構造を決める

```yaml
単一repository: "product codeと開発環境toolを同じrepositoryで管理する"
WorkspaceとComponent: "Workspace Repositoryが一つ以上の独立Component Repositoryを管理する"
```

別履歴、安定したcomponent root、共有tool、並列エージェント調整など、実際の必要性がある場合だけ後者を選びます。

### 手順2: ホスト境界を決める

- host制御面へ置くtoolを列挙する。
- project runtime、package manager、build、test、project固有CLIは原則containerへ置く。
- host例外とversion差異の管理方法を記録する。
- 通常commandが昇格権限を要求しないようにする。

### 手順3: 公開commandを作る

- 通常はMakefileを公開command入口にする。
- checkout選択や環境準備が複雑なら共通wrapperを追加する。
- 複雑な処理は `scripts/` などへ分離する。
- help、状態確認、診断、部分検証、最終検証、限定cleanupを用意する。
- 通常操作と破壊的操作を分ける。

### 手順4: resource識別を決める

次を安定した名前で識別します。

- workspaceまたはproject
- component
- resourceの役割
- task固有隔離を使う場合だけtaskまたはworktree

並列taskには、衝突しない可変resourceとhost portを割り当てます。

### 手順5: repositoryと任意worktreeのpathを決める

- 各Component RepositoryのPrimary Checkoutを決める。
- 独立Component RepositoryのpathをWorkspace Repository側でignoreする。
- worktree対応を採用する場合だけ `.worktrees/` を定義してignoreする。
- 必要時に使うworktree命名規則を決める。
- command内部を書き換えず、現在checkoutまたは明示worktreeを対象にできるようにする。
- worktree対応の確認だけを目的に、bootstrap時にTask Worktreeを作らない。

### 手順6: bootstrapを検証する

clean clone相当の状態から、次を確認します。

- 環境を作成できる。
- versionと選択pathを表示できる。
- 最小checkが通る。
- 最終検証が通る。
- 検証で作成したresourceだけを削除できる。

文書化されていないhost前提があれば報告します。

---

## 2. 既存プロジェクトへの導入

開発環境改善を理由に、無関係なrepository構造やcodeを全面改修してはいけません。

### 現状調査

```yaml
host依存: "runtime、package manager、SDK、CLI"
入口command: "文書化・未文書化のbuild、test、deploy"
container状態: "image、Compose、名前、port、volume、permission"
Git構造: "repository root、embedded repository、branch、任意worktree"
CI: "local scriptとの重複や差異"
破壊経路: "cleanup、reset、force削除、data削除"
```

### 移行順序

1. 現在の動作を覆う安定した公開commandを作る。
2. project固有処理を管理されたcontainerへ移す。
3. resource識別と所有権を整える。
4. 診断と最終検証を追加する。
5. 並列開発または明示的隔離が必要な場合だけworktree対応を追加する。
6. CIをproject管理commandへ合わせる。

一度に一つの開発環境境界だけを変更し、動作を維持します。

### 既存環境の保護

- project固有規則とgeneric strategyが衝突した場合はproject規則を優先し、衝突を報告する。
- repository移動や環境状態削除を黙って行わない。
- 依頼に必要でないWorkspace・Component分割を導入しない。
- 現在checkoutで単独作業を安全に行える場合、Task Worktreeを導入しない。
- scope外の違反は報告し、ついでに全面修正しない。

## Sources

- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/development-environment-strategy/ENVIRONMENT_WORKFLOW.md`
