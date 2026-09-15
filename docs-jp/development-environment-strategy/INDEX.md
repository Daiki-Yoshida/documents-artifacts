# 開発環境戦略 — 日本語版インデックス

```yaml
document_type: "index_translation"
target_audience: "human_readers"
language: "japanese"
source: "../artifacts/INDEX.md"
strategy_version: "1.1.1"
authority: "英語版 artifacts/ が正本。内容に差がある場合は英語版を優先する"
```

このフォルダは、AIエージェント向けの正本である `artifacts/` を、人が理解しやすい日本語にしたものです。

最初にこのファイルを読み、目的に必要な文書だけを参照してください。

## 読む順番

```yaml
1_思想: "DEVELOPMENT_ENVIRONMENT_PHILOSOPHY.md" # なぜ: 安全性、再現性、分離、checkout選択
2_基準: "ENVIRONMENT_STANDARDS.md"             # どうする: ホスト、Docker、コマンド、Git、CI
3_構造: "WORKSPACE_STRUCTURE.md"               # どこに置く: リポジトリ、checkout、任意のworktree
4_流れ: "ENVIRONMENT_WORKFLOW.md"               # どう進める: 導入、checkout選択、検証、削除、復旧
```

初めて全体を把握する場合は1から4まで順番に読みます。特定の作業だけなら、目的に合う文書だけを参照します。

## 基本となる考え方

```yaml
中心思想: "開発環境は、構造・ツール・操作・状態管理・分離・安全性をまとめた契約である"
優先順位: "ホストとデータの安全性 > 再現性 > 分離 > 並列運用 > 操作の明確さ > 診断と復旧 > ローカルとCIの一致 > 効率"
基本形: "ホストは制御面、コンテナはプロジェクト実行面"
checkoutの初期選択: "書き込み作業が一つなら現在のcheckoutを使い、並列または明示的な隔離が必要な場合だけTask Worktreeを作る"
```

## worktree選択の絶対ルール

```yaml
原則: "worktree対応は利用可能な機能であり、すべてのタスクで必須の手順ではない"
通常:
  条件: "同じComponent Repositoryで書き込み作業が一つだけ"
  対応: "現在またはPrimary Checkoutでtask branchを使用する"
worktreeを作る条件:
  - "同じComponent Repositoryで複数の書き込み作業やAIエージェントを並列実行する"
  - "別branchを安定したパスでcheckoutしたまま維持する必要がある"
  - "ユーザーまたはプロジェクト規則が明示的にworktreeを要求する"
  - "独立して破棄できるcheckoutと可変runtime状態が必要"
理由にならないもの:
  - ".worktrees/ が存在する"
  - "worktree作成コマンドが用意されている"
  - "TASK_IDがある"
```

**branchを作ることと、worktreeを作ることは別です。** 通常の変更はtask branchで行いますが、単独作業なら同じcheckoutでbranchを切り替えれば十分です。

このルールは、詳細文書の表現が通常作業にもworktreeを要求しているように読める場合、その表現より優先します。

## 文書ごとの役割

```yaml
DEVELOPMENT_ENVIRONMENT_PHILOSOPHY.md:
  担当:
    - "開発環境を契約として扱う理由"
    - "ホスト制御面とコンテナ実行面"
    - "checkout選択の考え方"
    - "Workspace、Component、Primary Checkout、Task Worktreeの用語"
    - "並列エージェントを分離する理由"

ENVIRONMENT_STANDARDS.md:
  担当:
    - "ホスト依存の境界"
    - "Dockerリソースの命名と分離"
    - "Makefile、公開コマンド、scriptsの責務"
    - "Git操作の安全性"
    - "破壊的操作、診断、最終検証、CIとの一致"

WORKSPACE_STRUCTURE.md:
  担当:
    - "Workspace RepositoryとComponent Repositoryの配置"
    - "Primary Checkoutと任意のTask Worktreeの配置"
    - "checkout選択条件"
    - ".worktrees/ の構造と命名"
    - "トップレベルフォルダとGit管理境界"

ENVIRONMENT_WORKFLOW.md:
  担当:
    - "新規導入と既存環境への導入"
    - "checkout方式の選択"
    - "必要な場合だけ行うTask Worktree作成"
    - "実装、検証、統合、後片付け、復旧"
    - "変更前の確認レベル"
```

## 他のartifactとの境界

```yaml
design_principles:
  担当: "コード設計、モジュール契約、実装、テスト戦略"
documentation_strategy:
  担当: "documents/ の構造、案内、バージョン、保守"
development_environment_strategy:
  担当: "ワークスペース構造、開発ツール、実行経路、任意のGit worktree、環境状態"
```

複数領域にまたがる作業では、それぞれのartifactを担当範囲にだけ適用します。
