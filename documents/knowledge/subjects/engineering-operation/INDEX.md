# Engineering Operation

このsubjectは、**要求されたengineering changeを、authority・scope・設計routing・実装・verification・version-control・reportingのどの順序と確認境界で完了させるか**を扱う。

codeの構造・DI・failure・testing strategyそのものは `../code-design/`、boundary hardeningとcontract change levelは `../encapsulation-horizon/`、command/runtimeは `../development-execution/`、破壊操作の安全性は `../development-safety/`、Work identity / resource lifecycleは `../work-identity/` が主所有する。

## 構成

```text
engineering-operation/
├─ INDEX.md
├─ S001_CHANGE_LIFECYCLE.md
├─ S002_AUTHORITY_SCOPE_AND_CLARIFICATION.md
├─ S003_PRE_IMPLEMENTATION_SCAN.md
├─ S004_CONFIRMATION_AND_ROUTING.md
├─ S005_VERIFICATION_AND_DONE.md
├─ S006_VERSION_CONTROL_AND_REPORTING.md
├─ S007_BROWNFIELD_AND_APPROACH.md
└─ S008_HISTORY.md
```

### S001_CHANGE_LIFECYCLE.md
要求理解からverificationまでのengineering change lifecycleを扱う。

### S002_AUTHORITY_SCOPE_AND_CLARIFICATION.md
user intent、project-local rule、scope、曖昧さがある場合の停止・確認を扱う。

### S003_PRE_IMPLEMENTATION_SCAN.md
変更前に必要なscanとproportionality、他subjectへのroutingを扱う。

### S004_CONFIRMATION_AND_ROUTING.md
contract / document / operation risk等を、それぞれのownerが持つconfirmation modelへrouteする。

### S005_VERIFICATION_AND_DONE.md
contract conformanceとrequested outcomeを分け、done宣言までのverification disciplineを扱う。

### S006_VERSION_CONTROL_AND_REPORTING.md
commit / push authority、default branch guard、reportingを扱う。

### S007_BROWNFIELD_AND_APPROACH.md
brownfield scope disciplineと「どう進めるか」というapproach questionへの対応を扱う。

### S008_HISTORY.md
旧AI_WORKFLOWからのsource recoveryと、code-design / execution / safety等への責務分割履歴を保持する。

## 境界

```text
engineering-operation
  changeをどう判断・進行・検証・報告するか
       ├─ design question       -> encapsulation-horizon / code-design
       ├─ command/runtime       -> development-execution
       ├─ destructive risk      -> development-safety
       ├─ Work lifecycle        -> work-identity
       └─ project documentation -> documentation
```

このsubjectは各domainの規範を複製せず、engineering change中に**いつ・どのownerへ判断をrouteするか**を所有する。

## Traceability

主要source:

- `../../records/2026-01-31-initial-code-design-source/files/AI_WORKFLOW.md`
- `../../records/2026-06-13-operational-discipline-commit/RECORD.md`
- `../../records/2026-07-01-brownfield-policy-commit/RECORD.md`
- `../../records/2026-07-02-design-principles-final-source-snapshot/files/AI_WORKFLOW.md`
- `../../records/2026-09-06-design-principles-proposals/RECORD.md`
- `../../records/2026-09-15-design-principles-contract-decision/RECORD.md`

旧 `design-principles` のFLOW packagingをそのまま復活させるのではなく、現在のsubject responsibilityへ再整理する。
