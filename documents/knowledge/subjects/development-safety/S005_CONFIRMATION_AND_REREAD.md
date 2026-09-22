# 開発安全性 — 確認境界と再読

開発operationのrisk levelと、重大な環境・構造変更時に関連knowledgeを読み直す条件を扱う。

## Development Operation Safety Level

このlevelは**実際に行う開発operationの破壊性・host/data影響**を扱う。

code contract変更の `CONTRACT_L0..L3` やdocumentation構造変更の `DOC_L0..L3` とは別軸である。

```yaml
SAFETY_L0_observe:
  例: ["help", "status", "diagnostics", "non-mutating version check"]
  対応: "そのまま実行"

SAFETY_L1_safe_local:
  例: ["non-destructive target", "diagnostic script", "reversible local runtime materialization"]
  対応: "実行して報告"

SAFETY_L2_structural:
  例: ["repository root移動", "worktree path contract変更", "standard command rename", "CI ref policy変更"]
  対応: "依頼から明確に必要な場合に実行し、明示報告"

SAFETY_L3_destructive_or_host:
  例: ["dirty worktree破棄", "branch / persistent volume削除", "DB破棄", "host-wide cleanup", "host runtime追加削除", "history rewrite"]
  対応: "破壊効果が明示的に要求されていない限り実施しない"
```

無害に見えるcommand名の裏へ破壊的effectを隠してlevelを下げない。

## 再読条件

```yaml
must_re_read:
  - "このstrategyを使うprojectへ初めて触れる"
  - "Workspace / Component構造を変更する"
  - "worktree contractを追加・再設計する"
  - "host / container boundaryを変更する"
  - "destructive operationを追加する"

should_re_read:
  - "runtime resource naming / isolationを変える"
  - "public command structureを変える"
  - "local / CI execution pathを変える"
  - "external Workspace/tool ref policyを変える"

no_re_read_needed:
  - "確立済みcommandの日常利用"
  - "確立済みWork Identity contractに従うroutine repository-specific worktree作成"
  - "command contractを変えない小さな内部script修正"
```

## Sources

- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/development-environment-strategy/ENVIRONMENT_WORKFLOW.md`
- `../../records/2026-09-22-six-subject-cross-audit-fixes/`
