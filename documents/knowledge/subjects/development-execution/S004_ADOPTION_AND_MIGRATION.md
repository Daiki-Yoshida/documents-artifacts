# 開発実行 — 導入と移行

新規projectへのexecution contract導入と、既存projectへ安全に段階導入するbrownfield workflowを扱う。

repository構造を新しく設計するworkflowではない。静的構造は `../workspace-structure/`、Work/worktree/resource lifecycleは `../work-identity/`、破壊操作は `../development-safety/` が所有する。

## 1. 新規プロジェクトへの導入

### 1. Static structureを確認する

`../workspace-structure/` またはproject固有規則から次を解決する。

- Project Root / Project Repository
- participating repository identity
- project-level helperを置く基準面

execution導入の都合だけでsingle/multi-repository構成を変更しない。

### 2. Host / container boundary

- host control-plane toolを決める。
- project runtime / package manager / build / test / project-specific CLIを原則container側へ置く。
- host例外とversion差異の扱いを記録する。
- routine operationが昇格権限を要求しないようにする。

### 3. Public operations

- discoverableなpublic command surfaceを用意する。
- 複雑なimplementationはscript等へdelegationする。
- help / status / partial check / final validation等を必要に応じて用意する。
- destructive operationとの境界は `../development-safety/` に従う。

### 4. Runtime materialization

Project / Work / Run resource scopeは `../work-identity/S004_LIFECYCLE_AND_RESOURCES.md` を利用する。

execution側では、そのidentityをcontainer / network / volume / port / log等へ必要な範囲だけmaterializeする。

Work-specific separationが不要ならshared resourceを安全に再利用する。

### 5. Worktree support

worktree path・branch mapping・create/remove semanticsをexecution側で定義しない。

必要なprojectは `../work-identity/S005_WORKTREE_MATERIALIZATION.md` と `../work-identity/S006_WORKTREE_COMMANDS.md` に従い、generic public command surfaceから呼び出す。

### 6. Bootstrap validation

clean clone相当のstateから:

- environmentを作成できる。
- tool/runtime versionを確認できる。
- public operationが対象を正しく解決する。
- minimal / final validationが実行できる。
- 作成したruntime resourceをscope通りに扱える。

undocumented host prerequisiteがあれば報告する。

## 2. 既存プロジェクトへの導入

現状を先に観察する。

```yaml
audit:
  host_dependencies: "runtime / SDK / CLI"
  public_operations: "build / test / deploy / diagnostics"
  runtime: "Docker / Compose / port / volume / permission"
  ci: "local pathとの重複・差異"
  safety_edges: "cleanup / reset / destructive operation"
```

Git/repository/worktreeの静的・Work固有状態は対応subjectへroutingし、execution migrationの名目で全面再設計しない。

推奨順序:

1. 現在の動作を覆うpublic operationを安定させる。
2. project-specific runtimeをmanaged execution environmentへ移す。
3. runtime materializationをProject/Work/Run scopeへ接続する。
4. status / diagnostics / final validationを整える。
5. 必要な場合だけWork Identityのworktree operationを公開surfaceへ接続する。
6. CIをproject-owned operationへ合わせる。

一度に変更するexecution boundaryを絞り、behaviorを維持する。

## Brownfield guards

- explicit local conventionがgeneric strategyと競合する場合はlocal ruleを優先し、差異を報告する。
- repository移動やWorkspace/Component再編をexecution改善へ便乗させない。
- destructive cleanupをmigrationへ隠さない。
- scope外の問題は記録・報告し、無関係な全面修正へ拡大しない。

## Sources

- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/development-environment-strategy/ENVIRONMENT_WORKFLOW.md`
- `../../records/2026-09-22-six-subject-cross-audit-fixes/`
