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
