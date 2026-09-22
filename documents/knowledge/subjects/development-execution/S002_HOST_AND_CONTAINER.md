# 開発実行 — ホストとコンテナ

host側の制御責務とcontainer側の実行責務、Docker-first、runtime resource materialization、mount・cache・network・secretの実装基準を扱う。

Work / resource scopeそのものは `../work-identity/` が主所有する。ここでは、そこで決まったscope / identityをruntime resourceへどうmaterializeするかを扱う。

## Host boundary

```yaml
host_control_plane:
  examples:
    - "Docker / Compose"
    - "Git等のsource control"
    - "Make / shell等のcommand entry"
    - "SSH / tmux等の認証・remote control"

container_execution_plane:
  examples:
    - "language runtime"
    - "package manager"
    - "compiler / build toolchain"
    - "test runtime"
    - "DB / migration CLI"
    - "project固有cloud / deploy CLI"
```

- container executionが現実的ならproject runtimeをhostへ要求しない。
- convenienceだけを理由にhost packageを増やさない。
- host例外は理由とversion差異の扱いを明示する。
- 日常operationでsudo等の昇格権限を前提にしない。

## Docker-first

- build / test / lint / format / migration / project固有CLIはrepository管理されたruntime definitionから実行する。
- Dockerfile / Composeはversion管理されたexecution definitionとして扱う。
- pre-created host network、global package、manual containerへ隠れて依存しない。
- 重要runtime/toolで無管理の `latest` に依存しない。
- container内でもlock fileを尊重する。

## Runtime resource identity

resourceの**意味上のscope / ownership / Work Identity**は `../work-identity/S004_LIFECYCLE_AND_RESOURCES.md` が所有する。

execution側は、それを各runtime systemへdeterministically materializeする。

```yaml
materialized_identity:
  project: "workspace-structure / project policyから取得"
  repository_or_component: "必要な場合"
  work: "Work-scoped resourceの場合のみWork Identityから取得"
  role: "container / network / volume / database / log等"
```

Work Identityやbranchが存在するだけでは専用resourceを作らない。分離要件があるときだけ必要最小限をmaterializeする。

## Creation / reuse

- build入力が同じならimageや安全なimmutable cacheを再利用できる。
- mutable stateが並列Work間で影響する場合は分離する。
- checkout / branch / worktreeが変わっただけでimageをrebuild/retagしない。
- project / Work / Run scopeの選択はWork Identity contractへ従う。

## File ownership / mount

- containerがhostへ生成するfileはhost userが管理可能にする。
- bind mount生成物には適切なUID/GID mapping等を使う。
- permission問題を理由にcontainer全体をroot実行へしない。
- generated outputをsourceへ混在させる場合はprojectが意図的に所有すること。
- cache / build outputは通常Git管理しない。

## Cache / volume / network / port

- safely reusable cacheは共有できる。
- 結果へ影響するmutable stateは必要なscopeで分離する。
- resource名からownership / cleanup scopeを追えるようにする。
- shared cacheを1 Workのcleanupで削除しない。
- host公開不要ならcontainer internal networkを使う。
- 並列runtimeが必要な場合はhost port衝突を避ける。

cleanupの破壊性・確認境界は `../development-safety/` が所有する。

## Secret

- secretをimageへ焼き込まない。
- repositoryへcommitしない。
- sampleと実値を分離する。
- command output / log / diagnostics / CI traceへ表示しない。
- build-time / runtimeで適切なsecret mechanismを使う。
- routine build/testでAIがsecret実値を読む必要をなくす。

## Sources

- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/development-environment-strategy/ENVIRONMENT_STANDARDS.md`
- `../../records/2026-09-22-six-subject-cross-audit-fixes/`
