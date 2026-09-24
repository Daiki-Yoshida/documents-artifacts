# Code Design

このsubjectは、**Encapsulation Horizonで選択したsoftware boundaryと責務を、codeとしてどう実現・進化・検証するか**を扱う。

境界をどのscaleで硬化するかは `../encapsulation-horizon/`、repository/filesystem構造は `../workspace-structure/`、開発command/runtimeは `../development-execution/`、破壊操作や復旧は `../development-safety/` が主所有する。

旧 `design-principles` のpackagingをそのまま復活させたsubjectではない。旧repositoryのGit snapshot/commitと、移行後の後続PR・Issueをrecordsとして固定し、現在採用する意味へ再整理している。

## 構成

```text
code-design/
├─ INDEX.md
├─ S001_REALIZATION_MODEL.md
├─ S002_IMPLEMENTATION_FREEDOM_AND_SIDE_EFFECTS.md
├─ S003_INHERITANCE_BOUNDARY.md
├─ S004_STATE_OWNERSHIP_AND_CONSISTENCY.md
├─ S005_CODE_STRUCTURE.md
├─ S006_DEPENDENCY_AND_EXTERNALS.md
├─ S007_DOMAIN_AND_DATA_BOUNDARIES.md
├─ S008_FAILURE_ASYNC_AND_CONTRACTS.md
├─ S009_TESTING_AND_RUNTIME.md
├─ S010_COMPATIBILITY_AND_VERIFICATION.md
├─ S011_PERFORMANCE_SHAPED_INTERACTION.md
├─ S012_DESIGN_PRIORITY.md
└─ S013_HISTORY.md
```

### S001_REALIZATION_MODEL.md
boundary-first / contract-firstのcode realizationモデルを扱う。

### S002_IMPLEMENTATION_FREEDOM_AND_SIDE_EFFECTS.md
boundary内部のparadigm自由とside-effect containmentを扱う。

### S003_INHERITANCE_BOUNDARY.md
inheritanceをcontract-enforcement mechanismとして使う条件を扱う。

### S004_STATE_OWNERSHIP_AND_CONSISTENCY.md
mutable state、cross-boundary business outcome、consistency/failure ownershipを扱う。

### S005_CODE_STRUCTURE.md
feature/module first、Domain/Application/Infrastructure/UI、contract placement、public surface、shared placementを扱う。

### S006_DEPENDENCY_AND_EXTERNALS.md
interface requirement、dependency direction、DI、external dependency containmentを扱う。

### S007_DOMAIN_AND_DATA_BOUNDARIES.md
Rich/Lightweight model、Domain purity、state ownership、DTO/mappingを扱う。

### S008_FAILURE_ASYNC_AND_CONTRACTS.md
expected/system failure、error translation、async/concurrency、code-level contract semanticsを扱う。

### S009_TESTING_AND_RUNTIME.md
unit/integration/contract/E2E、test placement、runtime topology、composition rootを扱う。

### S010_COMPATIBILITY_AND_VERIFICATION.md
consumer/provider双方のcompatibility、contract conformanceとrequested outcome verificationの分離を扱う。

### S011_PERFORMANCE_SHAPED_INTERACTION.md
load-bearing performance requirement、evidence gate、interaction-shape redesignを扱う。

### S012_DESIGN_PRIORITY.md
boundary / stability / locality / side-effect explicitnessを内部eleganceより優先するdesign decision ruleを扱う。

### S013_HISTORY.md
旧design-principlesからのsource recovery、後続訂正、移行履歴を保持する。

## 境界

```text
encapsulation-horizon
  どこをhard boundaryにするか
        ↓
code-design
  そのboundaryをcodeとしてどう実現・進化・検証するか
        ↓
development-execution
  そのcodeをどのruntime/commandでbuild/test/runするか
```

AI/agentが要求をどう調査・実装・検証・報告するかというengineering change processは、このsubjectに含めない。これは `../engineering-operation/` が主所有する。移行経緯は `../../../project/migration/LEGACY_ENGINEERING_OPERATION_GAP_AUDIT.md` を参照する。

## Traceability

基準source snapshots:

- `../../records/2026-01-31-initial-code-design-source/`
- `../../records/2026-01-31-bounded-contracts-refinement-source/`
- `../../records/2026-01-31-dependency-boundary-refinement-source/`
- `../../records/2026-01-31-domain-model-refinement-source/`
- `../../records/2026-06-13-design-principles-reference-snapshot/`
- `../../records/2026-07-02-design-principles-final-source-snapshot/`

後続の採用・訂正:

- `../../records/2026-09-06-design-principles-proposals/RECORD.md`
- `../../records/2026-09-15-design-principles-contract-decision/RECORD.md`
- `../../records/2026-09-15-cross-artifact-consistency-issue/RECORD.md`
- `../../records/2026-09-15-cross-artifact-consistency-pr/RECORD.md`
- `../../records/2026-09-15-performance-redesign-hold/RECORD.md`
- `../../records/2026-09-20-performance-contract-evolution/RECORD.md`

旧artifactそのものではなく、旧repositoryのversioned source stateと後続decision recordから現在の日本語knowledgeを導出する。
