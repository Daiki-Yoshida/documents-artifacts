# Code Design

このsubjectは、**Encapsulation Horizonで選択したsoftware boundaryと責務を、codeとしてどう実現・進化・検証するか**を扱う。

境界をどのscaleで硬化するかは `../encapsulation-horizon/` が主所有する。repository/filesystem構造は `../workspace-structure/`、開発command/runtimeは `../development-execution/`、破壊操作や復旧は `../development-safety/` が主所有する。

旧 `design-principles` の全規範を復活させたsubjectではない。第0情報源または後続の明示的採用を追跡できる知識だけを初期本文へ移している。

## 構成

```text
code-design/
├─ INDEX.md
├─ S001_REALIZATION_MODEL.md
├─ S002_IMPLEMENTATION_FREEDOM_AND_SIDE_EFFECTS.md
├─ S003_INHERITANCE_BOUNDARY.md
├─ S004_STATE_OWNERSHIP_AND_CONSISTENCY.md
├─ S005_COMPATIBILITY_AND_VERIFICATION.md
├─ S006_PERFORMANCE_SHAPED_INTERACTION.md
├─ S007_DESIGN_PRIORITY.md
└─ S008_HISTORY.md
```

### S001_REALIZATION_MODEL.md

boundary-first / contract-firstの設計観を、code realization側から扱う。classやinterface自体を目的にせず、選択済みboundaryの外面を安定させ、内部を交換可能に保つ。

### S002_IMPLEMENTATION_FREEDOM_AND_SIDE_EFFECTS.md

boundary内部のparadigm自由と、state / I/O / time / external systemsなどのside effect containmentを扱う。

### S003_INHERITANCE_BOUNDARY.md

inheritanceをcode reuseの既定手段ではなく、behavior / lifecycle / framework assumptionを強く拘束するcontract-enforcement mechanismとして扱う。

### S004_STATE_OWNERSHIP_AND_CONSISTENCY.md

mutable stateのowner、複数state ownerをまたぐbusiness outcomeのcoordination / failure ownership、atomicityが使えないtopologyでのconsistency strategyを扱う。

### S005_COMPATIBILITY_AND_VERIFICATION.md

公開contractの互換性をconsumer / provider双方から評価すること、contract conformanceとrequested outcomeのverificationを分離することを扱う。change levelそのものはEncapsulation Horizonを参照する。

### S006_PERFORMANCE_SHAPED_INTERACTION.md

load-bearing performance requirementがcode interaction shapeへ影響する条件、内部最適化優先、evidence gate、compatibility接続を扱う。

### S007_DESIGN_PRIORITY.md

design decisionの優先順位と、内部の美しさをboundary / external stability / locality / side-effect explicitnessより上位に置かない原則を扱う。

### S008_HISTORY.md

旧 `design-principles` からの復元範囲、未移行のlegacy規範、初期subject化の制約を保持する。

## 境界

```text
encapsulation-horizon
  どこを硬いboundaryとして扱うか
        ↓ boundary chosen

code-design
  そのboundaryをcodeとしてどう実現・進化・検証するか
```

次は現時点ではこのsubjectのcanonical規範へ昇格していない。

- Domain / Application / Infrastructure / UIの詳細layer rule
- constructor DI / Service Locator禁止等の具体DI policy
- DTO / Mapper / Converter / Adapterの詳細placement rule
- Result/Eitherの標準type選択、error translationの全詳細
- async / cancellation / thread-safetyの具体policy
- shared-kernel tier / test placementの具体rule

これらは旧artifactでは詳細だが、第0情報源・採用状態の回収が未完了である。監査は `documents/project/migration/LEGACY_CODE_DESIGN_GAP_AUDIT.md` を参照する。

## Traceability

主要source:

- `../../records/2026-06-13-design-principles-reference-snapshot/`
- `../../records/2026-09-06-design-principles-proposals/RECORD.md`
- `../../records/2026-09-15-design-principles-contract-decision/RECORD.md`
- `../../records/2026-09-15-performance-redesign-hold/RECORD.md`
- `../../records/2026-09-15-cross-artifact-consistency-issue/RECORD.md`
- `../../records/2026-09-15-cross-artifact-consistency-pr/RECORD.md`
- `../../records/2026-09-20-performance-contract-evolution/RECORD.md`
