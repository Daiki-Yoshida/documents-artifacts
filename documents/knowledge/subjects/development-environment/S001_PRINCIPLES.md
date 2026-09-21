# 開発環境 — 基本原則

開発環境を単なるtool集合ではなく、安全性・再現性・責務境界を持つ契約として扱うための基本原則をまとめる。旧Task Worktree固有の記述は履歴側へ分離している。

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

## 優先順位

```yaml
優先順位:
  1: "ホストとデータの安全性"
  2: "再現性"
  3: "リポジトリとリソースの分離"
  4: "複数AIエージェントの並列運用"
  5: "操作内容と副作用の明確さ"
  6: "診断と復旧のしやすさ"
  7: "ローカルとCIの実行経路の一致"
  8: "開発効率"
```

安全性を理由に、日常作業を不必要に面倒にしてはいけません。安全な操作を最も短く、使いやすい経路にします。

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

---

## 安全性と使いやすさの両立

```yaml
原則: "安全な操作を最も簡単な操作にする"
方針:
  - "日常操作は初期状態で非破壊的"
  - "破壊的操作は名前と対象範囲を明確にする"
  - "診断コマンドを見つけやすくする"
  - "最終検証の標準経路を一つ定義する"
  - "後片付けは選択したprojectまたはtaskのresourceだけを対象にする"
```

安全性は、何度も手作業を要求するのではなく、コマンド設計とresource識別へ組み込みます。

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

## Sources

- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/development-environment-strategy/DEVELOPMENT_ENVIRONMENT_PHILOSOPHY.md`
- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/development-environment-strategy/ENVIRONMENT_STANDARDS.md`
- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/development-environment-strategy/ENVIRONMENT_WORKFLOW.md`
- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/development-environment-strategy/WORKSPACE_STRUCTURE.md`
