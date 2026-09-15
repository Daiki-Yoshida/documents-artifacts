# 開発環境の実装基準

```yaml
document_type: "environment_standards_translation"
target_audience: "human_readers"
language: "japanese"
source: "../artifacts/ENVIRONMENT_STANDARDS.md"
strategy_version: "1.1.1"
authority: "英語版 artifacts/ が正本。内容に差がある場合は英語版を優先する"
```

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

## 4. Git操作の安全性

- default branchは安定させ、通常の変更はtask branchで行う。
- **task branchを使うことは、Task Worktreeを作ることを意味しない。**
- 書き込み作業が一つだけで追加隔離が不要なら、現在割り当てられたcheckoutを使う。
- Task Worktreeは、並列書き込み、安定した別checkout、明示的な隔離要求がある場合だけ作る。
- `.worktrees/` やworktree commandが存在するという理由だけで作らない。
- 一つの書き込み可能checkoutを同時に所有する書き込みエージェントは一つとする。
- 変更前に、対象repositoryとcheckoutを確認する。worktree利用時はworktreeも確認する。
- 宣言されたworkspace外のrepositoryを操作しない。
- 通常のworktree削除はdirty worktreeを拒否する。
- 可能なら、未push・未保存commitも削除前に確認する。
- `--force` は明示的な破壊commandだけで使う。
- worktree cleanupとbranch削除は別の判断とする。
- stale metadataのpruneを、実directory削除の許可として扱わない。
- push、force-push、branch削除、history書き換えは明示操作とする。

## 5. 破壊的操作

```yaml
通常操作:
  性質: "source変更と永続dataを保持する"
破壊的操作:
  性質: "source変更、commit、volume、DB、cache、remote状態を失う可能性がある"
  必須:
    - "明示的な名前"
    - "狭い対象範囲"
    - "事前条件確認"
    - "削除内容の報告"
```

- global Docker pruneのようなhost全体操作を通常project lifecycleへ入れない。
- cleanup対象は決定的なproject/task識別子で限定する。
- DB reset、volume削除、worktree強制削除、remote deploy破棄を曖昧な `clean` にまとめない。

## 6. 診断と検証

project環境は、次に相当する操作を提供します。

```yaml
案内: "利用可能な操作と必要parameterを表示"
診断: "tool version、選択repository・checkout、container、port、mount、よくある設定不良を表示"
状態: "変更せず、現在のproject/task resourceを表示"
検証: "完了判定用の標準gateを実行"
```

- 診断でsecretを表示しない。
- 選択checkoutを表示し、Task Worktree利用時だけworktreeとcontainer namespaceも表示する。
- 実装中は狭い検証から始め、完了前に最終gateを実行する。
- 最終gateが失敗・未実行なら完了と報告しない。

## 7. ローカルとCI

- CIのworkflow YAMLへbuild/test本体を再実装せず、project管理commandを呼ぶ。
- provisioningが異なっても、最終的には同じ検証scriptへ合流させる。
- provider固有準備はCI edgeに置き、project動作はrepository管理commandへ置く。
- CIで別Workspace Repositoryを利用する場合は、使用refを明示する。
- 未指定の外部workspace最新版へ偶然依存しない。
