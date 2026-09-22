# 開発実行 — 基本モデル

開発処理をどこで実行し、どの状態から再現し、どの入口から操作するかという実行契約の基本モデルを扱う。

## 開発環境は契約である

開発環境は、各開発者やAIエージェントが手元へ好きにツールを追加して使うだけのものではありません。

開発作業をどの実行環境で、どの公開入口から実行し、どう再現・検証するかを定めた「契約」として扱います。

Project/repositoryの静的配置は `../workspace-structure/`、Work単位のidentity・ownership・lifecycleは `../work-identity/`、破壊操作・診断・復旧の安全境界は `../development-safety/` が主所有し、このsubjectはそれらを入力として利用します。

```yaml
開発環境の契約:
  静的構造との接続: "Project Root / repository identity等はworkspace-structureから解決する"
  ツール構成: "ホストへ置くツールと、プロジェクト実行環境へ置くツールの境界"
  公開コマンド: "人、AIエージェント、CIが利用する安定した操作"
  runtime管理: "実行環境を作成、確認、再利用し、必要なresourceへmaterializeする方法"
  Workとの接続: "必要な分離scope / resource identityはwork-identityから受け取りruntimeへ反映する"
  安全性との接続: "destructive effect / confirmation boundaryはdevelopment-safetyへ委譲する"
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
