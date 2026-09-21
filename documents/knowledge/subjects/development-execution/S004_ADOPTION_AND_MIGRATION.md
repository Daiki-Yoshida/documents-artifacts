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
