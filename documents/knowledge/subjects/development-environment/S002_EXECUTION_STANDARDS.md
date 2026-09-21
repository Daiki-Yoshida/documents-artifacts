# 開発環境 — 実行基準

host依存境界、Docker-first、公開command、local/CI parityなど、日常の実行面を成立させる基準を扱う。

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
- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/development-environment-strategy/ENVIRONMENT_WORKFLOW.md`
- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/development-environment-strategy/WORKSPACE_STRUCTURE.md`
