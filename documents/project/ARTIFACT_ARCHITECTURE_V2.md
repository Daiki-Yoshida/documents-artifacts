# Artifact Architecture v2 — Initial Design

```yaml
document_type: "repository_local_artifact_architecture"
status: "candidate_reviewed"
authority: "derived_from_documents/knowledge/system/ARTIFACT_MODEL.md"
base_main_commit: "31d60ab2145860e717f52334aed5796df9e19741"
date: "2026-09-24"
```

## Goal

`artifacts/` を様々なtarget projectへそのまま配布し、各projectのAIが共通知識を必要なときだけ低token costで取得できる構造へ置き換える。

legacyの3 module:

```text
design-principles/
documentation-strategy/
development-environment-strategy/
```

は新構造の分割根拠にしない。

## Packaging Decision

**install unitを1つ、reading unitを複数**とする。

全artifactをtarget projectへ配置してよい。
AIは小さい `INDEX.md` からtaskに必要なfileだけ読む。

```yaml
distribution:
  default: "whole pack"
context_loading:
  default: "selective routing"
optimization_target: "few filesではなくsmall relevant context"
```

disk上のfile数そのものはtoken costではない。
そのためfile countに低い上限を設けず、context co-occurrenceを基準に分割する。

AI-facing runtime本文は簡潔な英語をdefaultとし、canonical knowledgeの日本語本文を二言語併記しない。language変換はauthorityを変えず、normative strength / condition / exceptionを保持する。

## Candidate layout

```text
artifacts/
├─ INDEX.md
│
├─ design/
│  ├─ INDEX.md
│  ├─ BOUNDARY_HORIZON.md
│  ├─ CONTRACTS.md
│  ├─ RESPONSIBILITY.md
│  ├─ CONCEPT_ALTITUDE.md
│  └─ STATE_AND_CONSISTENCY.md
│
├─ implementation/
│  ├─ INDEX.md
│  ├─ CODE_STRUCTURE.md
│  ├─ DEPENDENCIES.md
│  ├─ DOMAIN_AND_DATA.md
│  ├─ FAILURE_AND_ASYNC.md
│  ├─ TESTING.md
│  ├─ COMPATIBILITY.md
│  └─ PERFORMANCE.md
│
├─ operation/
│  ├─ INDEX.md
│  ├─ CHANGE_LIFECYCLE.md
│  ├─ SCOPE_AND_AUTHORITY.md
│  ├─ PRE_IMPLEMENTATION_SCAN.md
│  ├─ VERIFICATION_AND_DONE.md
│  ├─ VERSION_CONTROL_AND_REPORTING.md
│  └─ BROWNFIELD.md
│
├─ documentation/
│  ├─ INDEX.md
│  ├─ PRINCIPLES_AND_ROUTING.md
│  ├─ WORKFLOW_AND_MAINTENANCE.md
│  └─ FORMAT_AND_GIT.md
│
├─ project/
│  ├─ INDEX.md
│  ├─ WORKSPACE.md
│  ├─ WORK_IDENTITY.md
│  ├─ WORK_LIFECYCLE.md
│  └─ WORKTREES.md
│
├─ execution/
│  ├─ INDEX.md
│  ├─ EXECUTION_MODEL.md
│  ├─ HOST_AND_CONTAINER.md
│  ├─ COMMANDS_AND_CI.md
│  └─ ADOPTION_AND_MIGRATION.md
│
└─ safety/
   ├─ INDEX.md
   ├─ SAFETY_PRINCIPLES.md
   ├─ DESTRUCTIVE_OPERATIONS.md
   ├─ DIAGNOSTICS_AND_RECOVERY.md
   └─ INTEGRATION_AND_CONFIRMATION.md
```

これはsubject構造の複製ではない。

- `design/` はencapsulation-horizonとcode-designの設計判断をtask consumption単位で再構成する。
- `implementation/` はcode-designの実装判断を、同時に読む頻度で分ける。
- `operation/` はengineering-operationのchange lifecycleをtask phaseで分ける。
- `project/` はworkspace-structureとwork-identityをproject/work利用文脈で統合する。
- specializedなworktree detailは通常taskから分離する。

## File split rule

artifactの分割基準はsemantic ownershipではなく**context co-occurrence**。

例:

- Encapsulation Horizonとhardening/YAGNIは同じboundary判断で同時に必要になりやすい → `BOUNDARY_HORIZON.md`
- contract completenessはAPI/contract判断として単独需要が高い → `CONTRACTS.md`
- testingとperformanceは同じcode-design ownerでも同時に必要とは限らない → 別file
- Work Identityとworktree implementationは通常taskで必要度が異なる → 別file

fileを分けた結果、ほぼ毎回双方を読むなら再統合を検討する。

## Root INDEX responsibilities

root `INDEX.md` は小さなrouterとする。

含める:

- authority / project-local ruleとの関係
- task → directory / file routing
- 「全部読むな」というprogressive disclosure rule
- cross-cuttingな最小global guard

含めない:

- leaf rule本文の長い要約
- history
- source provenance
- 全fileの詳細目次

## Directory INDEX responsibilities

各directoryの `INDEX.md` は、その領域へrouteされた後の二段目router。

例:

```yaml
implementation:
  dependency_or_DI: "DEPENDENCIES.md"
  DTO_mapping_domain: "DOMAIN_AND_DATA.md"
  failure_async: "FAILURE_AND_ASYNC.md"
  tests: "TESTING.md"
  public_contract_evolution: "COMPATIBILITY.md"
  performance_changes_interaction: "PERFORMANCE.md"
```

INDEX本文をknowledge要約へ膨らませない。

## Initial task routing

```yaml
normal_code_change:
  read:
    - "operation/CHANGE_LIFECYCLE.md"
  then:
    - "implementation/INDEX.md"
  add_design_when:
    - "new boundary"
    - "public contract"
    - "responsibility split"
    - "state ownership changes"

new_api_or_architecture:
  read:
    - "design/INDEX.md"
    - "operation/CHANGE_LIFECYCLE.md"
    - "implementation/INDEX.md"

dependency_or_DI:
  read:
    - "implementation/DEPENDENCIES.md"

domain_DTO_mapping:
  read:
    - "implementation/DOMAIN_AND_DATA.md"

failure_or_async:
  read:
    - "implementation/FAILURE_AND_ASYNC.md"

testing:
  read:
    - "implementation/TESTING.md"

public_contract_change:
  read:
    - "design/CONTRACTS.md"
    - "implementation/COMPATIBILITY.md"

performance_redesign:
  read:
    - "implementation/PERFORMANCE.md"
    - "design/CONTRACTS.md when interaction shape changes"

documentation_change:
  read:
    - "documentation/INDEX.md"
    - "operation/CHANGE_LIFECYCLE.md when part of an engineering change"

project_or_repository_structure:
  read:
    - "project/WORKSPACE.md"

work_identity:
  read:
    - "project/WORK_IDENTITY.md"
    - "project/WORK_LIFECYCLE.md when lifecycle/resources matter"

worktree:
  read:
    - "project/WORKTREES.md"
    - "safety/DESTRUCTIVE_OPERATIONS.md when removing/resetting"

docker_container_environment:
  read:
    - "execution/INDEX.md"

cleanup_delete_reset_recovery:
  read:
    - "safety/INDEX.md"
```

## Context budget targets

token数はmodel/tokenizerで変動するためhard contractではなくrouting reviewの初期targetとする。

```yaml
root_INDEX:
  target: "roughly <= 1,000 tokens"

directory_INDEX:
  target: "roughly <= 600 tokens"

leaf:
  preferred: "roughly 700–2,500 tokens"
  soft_review_trigger: "roughly > 3,000 tokens"

normal_task:
  expected: "root INDEX + 1 router or direct leaf + 1–3 relevant leaves"
  preferred_total: "roughly <= 6,000–8,000 tokens"
```

短さのためにcondition / exception / normative strengthを削らない。
大きい場合はまずrouting分割を検討する。

## Projection rules

```yaml
preserve:
  - "normative strength"
  - "preconditions"
  - "exceptions"
  - "negative guards"
  - "ownership / routing boundaries"
  - "decision rules needed by an agent"

remove_or_compress:
  - "history"
  - "source provenance detail"
  - "migration state"
  - "repeated rationale"
  - "obsolete alternatives"

never:
  - "legacy artifact wordingをcurrent authorityとして復活"
  - "token削減のためにconditionを落とす"
  - "subject間のownership conflictをartifact側で新しく作る"
  - "directory INDEXへleaf本文を大量複製"
```

## Maintenance traceability

artifact本文へsource bookkeepingを大量に埋め込まない。

repository-local projection mapで、artifact leafがどのsubject sectionを入力としているか追跡する。

## Distribution script impact

現行 `artifacts.sh --modules` はlegacy 3 module前提なので、新pack確定時に変更する。

初期方向:

```text
./artifacts.sh --target <project>
  -> documents/artifacts/ をwhole-pack atomic sync
```

legacy module selectionは廃止候補。
remove / symlink safety / atomic replacement / non-interactive execution等の安全性は維持する。

## Next implementation step

1. candidate layoutのroot / directory routerを作る。
2. subject → artifact leaf projection mapを作る。
3. leaf本文をcurrent subjectsからprojectionする。
4. representative taskでroutingとcontext量をレビューする。
5. legacy14 artifactとのsemantic regression auditを行う。
6. 問題なければ `artifacts/` とdistribution toolingを置換する。
