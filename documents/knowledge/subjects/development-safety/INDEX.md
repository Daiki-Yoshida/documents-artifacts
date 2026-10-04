# Development Safety

このsubjectは、**開発操作をどう安全に行い、失敗をどう診断・復旧するか**を扱う。

Work固有resourceのownership/lifecycleは `../work-identity/`、実行環境の具体的materializationは `../development-execution/` が主所有する。 engineering change全体の進行順序・VCS・reportingは `../engineering-operation/` が主所有し、このsubjectはrisk / destructive operation / diagnosis / recoveryを所有する。

## 構成

```text
development-safety/
├─ INDEX.md
├─ S001_SAFETY_PRINCIPLES.md
├─ S002_DESTRUCTIVE_OPERATIONS.md
├─ S003_DIAGNOSTICS_AND_RECOVERY.md
├─ S004_INTEGRATION.md
└─ S005_CONFIRMATION_AND_REREAD.md
```

### S001_SAFETY_PRINCIPLES.md

安全性の優先順位、安全で使いやすい日常経路を扱う。

### S002_DESTRUCTIVE_OPERATIONS.md

通常操作と破壊的操作の境界、scope、明示性を扱う。

### S003_DIAGNOSTICS_AND_RECOVERY.md

状態診断、検証、失敗時の確認順序と復旧を扱う。

### S004_INTEGRATION.md

repository境界を守った統合と、統合後の再検証を扱う。

### S005_CONFIRMATION_AND_REREAD.md

変更riskに応じた確認境界と、環境・構造文書の再読条件を扱う。

## 再編元

旧 `development-environment` のうち、安全性・破壊操作・診断・復旧・確認境界をこのsubjectへ移管した。

## Execution Target selectorとの接続

`DIR=<path>` のようなExecution Target Directory selectorはoperation authorityを意味しない。破壊操作でdirectory selectorがownership / identity / precondition / confirmationを短絡しないための規則は `S002_DESTRUCTIVE_OPERATIONS.md` が扱う。

generic `DIR` semantics自体は `../development-execution/S003_COMMAND_INTERFACE_AND_CI.md` が主所有する。

source: `../../records/2026-10-03-project-root-execution-routing/`


## Decision lineage — safety responsibility split

Current:

- `../../records/2026-09-22-six-subject-cross-audit-fixes/` — destructive operations, diagnostics/recovery, integration safety, and confirmation/reread are owned by this dedicated safety subject rather than the old development-environment umbrella.
- `../../records/2026-10-03-project-component-documentation-boundary/` — later repository-role terminology and ownership alignment is reflected in current safety guidance（当時のrole名はProject Repository、現在はManagement Root Repository）。
- `../../records/2026-10-04-management-root-repository-terminology/` — repository role名をProject RepositoryからManagement Root Repositoryへterminology refinement。semantic responsibilityは継承する。

Historical predecessor:

- the old `development-environment` umbrella combined safety with execution, workspace, Work lifecycle, and resource concerns.
- that predecessor semantic model is preserved in `../development-execution/S005_HISTORY.md` and the original development-environment source records; it is not current safety authority.

No separate safety HISTORY file is required while the reusable predecessor semantics are already preserved and routed without ambiguity.
