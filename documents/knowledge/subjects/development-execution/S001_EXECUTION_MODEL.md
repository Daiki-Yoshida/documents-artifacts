# 開発実行 — 基本モデル

開発処理を**どこで・どの実行環境で・どの公開入口から**実行し、どう再現するかというexecution contractを扱う。

## Execution contract

```yaml
development_execution_owns:
  host_container_boundary: "どのtool/runtimeをhostとcontainerのどちらで実行するか"
  runtime_definition: "Docker / Compose等で実行環境を再現する"
  public_command_surface: "人・AI・CIが使う安定した実行入口"
  materialization: "mount / cache / network / secret等をruntimeへどう具現化するか"
  local_ci_path: "localとCIを同じproject-owned operationへ収束させる"
  reproducibility: "repository stateから実行環境を再現できる条件"

delegated:
  repository_filesystem_structure: "../workspace-structure/"
  work_identity_resource_lifecycle: "../work-identity/"
  destructive_operation_diagnostics_recovery: "../development-safety/"
```

executionはこれらのsubjectが決めたidentity・structure・safety boundaryを利用するが、独自に再定義しない。

## 制御面と実行面

```yaml
host_control_plane:
  role: "Git、Docker、command routing、認証、遠隔接続等の制御面"
  principle: "明示的な例外がない限り、project固有runtime/package環境を増やさない"

container_execution_plane:
  role: "language runtime、package manager、build、test、project固有CLI"
  principle: "repository管理された定義から再現する"
```

内部Docker構成やscriptは変更可能だが、公開operationの意味は安定させる。

## Reproducibility

あるrepository stateを取得したとき、必要なexecution environmentを再現できる情報がproject側に存在する。

- 重要tool versionまたは許容範囲を管理する。
- dependency lockを尊重する。
- 文書化されていないhost stateへ隠れて依存しない。
- localとCIは可能な限り同じproject-owned command/scriptを使う。
- 外部tool / Workspace dependencyを使う場合はref/version選択を明示する。

再現性は更新禁止ではない。変更が意図的で追跡可能であることを要求する。

## Sources

- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/development-environment-strategy/DEVELOPMENT_ENVIRONMENT_PHILOSOPHY.md`
- `../../records/2026-09-22-six-subject-cross-audit-fixes/`
