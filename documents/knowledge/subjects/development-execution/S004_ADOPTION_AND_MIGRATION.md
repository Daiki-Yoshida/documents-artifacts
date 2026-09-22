# 開発実行 — 導入と移行

新規projectへの実行環境導入と、既存projectへ安全に段階導入するbrownfield workflowを扱う。

## 1. 新規プロジェクトへの導入

### 手順1: リポジトリ構造を確認する

```yaml
authority: "../workspace-structure/"
resolve:
  - "Project Root / Project Repository"
  - "Workspace Repository / Component Repository when applicable"
  - "stable repository identity / base location"
```

execution導入の都合だけでsingle/multi-repository構成やrepository rootを変更しません。

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

### 手順4: resource identityをruntimeへ接続する

Project / Work / RunのscopeとResource Identityは `../work-identity/S004_LIFECYCLE_AND_RESOURCES.md` から解決します。

execution側ではproject / repository / Work / resource roleをcontainer・network・volume・port等へdeterministically反映し、分離が必要な場合だけ衝突しない可変resourceとhost portを割り当てます。

### 手順5: 必要なWork Identity operationを公開commandへ接続する

- worktree path・branch mapping・create/remove semanticsをexecution側で再定義しない。
- 必要なprojectは `../work-identity/S005_WORKTREE_MATERIALIZATION.md` と `../work-identity/S006_WORKTREE_COMMANDS.md` に従う。
- Work Identity固有operationをMakefile / wrapper等のgeneric public command surfaceへ接続してよい。
- worktree対応確認だけを目的に、bootstrap時に不要なWork-scoped worktreeを作らない。

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

開発環境改善を理由に、無関係なrepository構造やcodeを全面改修してはいけません。repository/worktree構造のauthorityは `../workspace-structure/` / `../work-identity/`、破壊操作の安全境界は `../development-safety/` にあります。

### 現状調査

```yaml
host依存: "runtime、package manager、SDK、CLI"
入口command: "文書化・未文書化のbuild、test、deploy"
container状態: "image、Compose、名前、port、volume、permission"
Git構造: "repository root / repository identity / branch / worktreeの現状（変更判断はworkspace-structure / work-identityへ委譲）"
CI: "local scriptとの重複や差異"
破壊経路: "cleanup、reset、force削除、data削除"
```

### 移行順序

1. 現在の動作を覆う安定した公開commandを作る。
2. project固有処理を管理されたcontainerへ移す。
3. runtime resource materializationをProject / Work / Run scopeへ接続する。
4. 診断と最終検証を追加する。
5. 並列開発または明示的隔離が必要な場合だけWork Identityのworktree operationをpublic surfaceへ接続する。
6. CIをproject管理commandへ合わせる。

一度に一つの開発環境境界だけを変更し、動作を維持します。

### 既存環境の保護

- project固有規則とgeneric strategyが衝突した場合はproject規則を優先し、衝突を報告する。
- repository移動や環境状態削除を黙って行わない。
- 依頼に必要でないWorkspace・Component分割を導入しない。
- 現在checkoutで単独作業を安全に行える場合、不要なWork-scoped worktreeを導入しない。
- scope外の違反は報告し、ついでに全面修正しない。

## Sources

- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/development-environment-strategy/ENVIRONMENT_WORKFLOW.md`
