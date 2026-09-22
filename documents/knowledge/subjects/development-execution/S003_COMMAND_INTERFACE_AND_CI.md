# 開発実行 — 公開コマンドとCI

人・AI・CIが利用するgeneric public command interface、operation semantics、local/CIの実行経路を扱う。

## Operation semantics

commandは生tool syntaxではなく、project内で安定した**目的**を公開する。

- 実行前に対象scopeと主要effectを判断できる名前にする。
- destructive effectを通常operationの名前へ隠さない。
- failureを隠さずnon-zero statusと診断可能なoutputを返す。
- command interfaceの安全境界は `../development-safety/` と整合させる。

## Public command surface

```yaml
typical_layers:
  Makefile: "discoverable operation name / help / parameter / simple delegation"
  wrapper: "共通routingや環境準備が必要な場合の任意入口"
  scripts: "複雑な分岐、検証、orchestration、provider固有処理"
```

- Makefileへ複雑なshell implementationを埋め込みすぎない。
- parameterは意味ごとに明示し、万能raw argsへ寄せすぎない。
- help/status/validate等、日常利用者が操作を発見できる入口を持つ。
- final validationの標準operationを定義できる。

## Domain-specific command contract

このsubjectはgeneric command surfaceを所有する。

Work Identity固有の、

```text
worktree-create
worktree-status
worktree-remove
```

等のsemantic contract、`WORK + REPO` input、branch/path resolutionは `../work-identity/S006_WORKTREE_COMMANDS.md` が主所有する。

関係:

```text
development-execution
  generic public command / implementation routing
        ↓
work-identity
  Work-specific semantic operation
```

Work Identity operationもproject public command surfaceへ公開できるが、意味契約をexecution側で複製しない。

## Local and CI

- CI workflowへbuild/test logic本体を再実装せずproject-owned operationを呼ぶ。
- provisioning差があっても最終的なbuild/test/validate pathを共有する。
- provider固有setupはCI edgeへ置く。
- 外部Workspace/tool dependencyを使う場合はref/versionを明示する。
- 未指定の最新版へ偶然依存しない。

## Sources

- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/development-environment-strategy/DEVELOPMENT_ENVIRONMENT_PHILOSOPHY.md`
- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/development-environment-strategy/ENVIRONMENT_STANDARDS.md`
- `../../records/2026-09-22-six-subject-cross-audit-fixes/`
