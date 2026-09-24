# Artifact Architecture v2 — Initial Design

```yaml
document_type: "repository_local_artifact_architecture"
status: "initial_design"
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

初期案では**install unitを1つ、reading unitを複数**とする。

```text
target project
└─ documents/
   └─ artifacts/
      ├─ INDEX.md
      ├─ DESIGN.md
      ├─ IMPLEMENTATION.md
      ├─ CHANGE_WORKFLOW.md
      ├─ DOCUMENTATION.md
      ├─ PROJECT_WORK.md
      ├─ WORKTREES.md
      ├─ EXECUTION.md
      └─ SAFETY.md
```

全fileをtargetへ配置してよい。
AIは `INDEX.md` からtaskに必要なfileだけ読む。

## Why one install unit

disk上にfileが存在すること自体はcontext tokenを消費しない。

選択installを主戦略にすると、projectごとにknowledge setが異なり、後から「必要なartifactがそもそも入っていない」状態を生みやすい。

そのため初期案では:

```yaml
distribution:
  default: "whole pack"
context_loading:
  default: "selective through INDEX routing"
```

とする。

将来、明確に別用途のpackが成立した場合のみ複数install unitを再検討する。

## File responsibilities

### INDEX.md

常に最初に読む小さいrouter。

所有するもの:

- packの読み方
- project-local ruleとの関係
- task → artifact routing table
- 最小限のglobal guard

本文規範を大量に複製しない。

### DESIGN.md

主なsource subjects:

- `encapsulation-horizon`
- `code-design` のdesign priority / boundary-level部分

扱うもの:

- boundary / responsibility
- Encapsulation Horizon
- small surface / strong contract
- YAGNI across the Horizon
- contract completeness
- concept altitude
- state / consistencyの設計判断
- compatibility / performanceでinteraction shapeを変える条件

### IMPLEMENTATION.md

主なsource:

- `code-design`

扱うもの:

- feature/module-first code structure
- layer responsibility
- dependency / DI
- external dependency containment
- domain / DTO / mapping
- failure / async
- testing
- runtime / composition root
- implementation freedom

DESIGNとの重複はdecision ruleの短い接続だけにする。

### CHANGE_WORKFLOW.md

主なsource:

- `engineering-operation`
- 他subjectへのrouting rule

扱うもの:

- intent / required outcome
- scope / authority
- pre-implementation scan
- confirmation routing
- implementation → verification → done
- VCS / reporting
- brownfield

domain-specific ruleを複製せず、必要なartifactへrouteする。

### DOCUMENTATION.md

主なsource:

- `documentation`
- `work-identity` のWork Documents接続

扱うもの:

- Project Documentation
- routing-first structure
- documentation workflow
- maintenance / review
- Work Documentsからdurable docsへのreconciliation

### PROJECT_WORK.md

主なsource:

- `workspace-structure`
- `work-identity` のidentity / root / lifecycle / resources

扱うもの:

- Project Root / repository ownership
- stable repository identity
- Work Identity
- Work Root
- Work Documents ownership
- Work lifecycle
- resource identity / completion reconciliation

worktree-specific implementation detailは `WORKTREES.md` へrouteする。

### WORKTREES.md

主なsource:

- `work-identity` のworktree materialization / commands / validation
- destructive operation時は `development-safety`

通常のcode taskでは読まないspecialized artifact。

扱うもの:

- worktree materialization contract
- create / status / remove semantics
- preflight / postcondition / idempotency / rollback
- project/work/repository identityとの対応

### EXECUTION.md

主なsource:

- `development-execution`

扱うもの:

- execution model
- host / container responsibility
- Docker-first等のenvironment ownership
- public command interface
- local / CI parity
- environment adoption / migration

### SAFETY.md

主なsource:

- `development-safety`
- `work-identity` / `development-execution` から必要なrisk接続

扱うもの:

- destructive operation
- scope confirmation
- diagnostics
- recovery
- integration safety
- reread / confirmation level

## Initial routing table

```yaml
implement_or_refactor:
  read: ["CHANGE_WORKFLOW.md", "IMPLEMENTATION.md"]
  add_if_boundary_changes: ["DESIGN.md"]

new_api_or_architecture:
  read: ["CHANGE_WORKFLOW.md", "DESIGN.md", "IMPLEMENTATION.md"]

bug_fix:
  read: ["CHANGE_WORKFLOW.md"]
  add: ["IMPLEMENTATION.md when code structure/contract is relevant"]

documentation_change:
  read: ["CHANGE_WORKFLOW.md", "DOCUMENTATION.md"]

repository_or_project_structure:
  read: ["PROJECT_WORK.md"]

work_identity_or_worktree:
  read: ["PROJECT_WORK.md", "WORKTREES.md"]
  add_if_destructive: ["SAFETY.md"]

docker_build_test_ci_environment:
  read: ["EXECUTION.md"]
  add: ["CHANGE_WORKFLOW.md for engineering change lifecycle"]
  add_if_destructive: ["SAFETY.md"]

cleanup_delete_reset_recovery:
  read: ["SAFETY.md"]
  add: ["PROJECT_WORK.md or EXECUTION.md according to owned resource"]
```

## Context budget targets

token数はmodel/tokenizerで変動するためhard contractではなく運用上の初期targetとする。

```yaml
INDEX:
  target: "roughly <= 1,200 tokens"

primary_artifact:
  target: "roughly 1,500–3,500 tokens"

specialized_artifact:
  target: "roughly 1,000–3,000 tokens"

normal_task_read_path:
  target: "INDEX + 1–2 primary files"
  preferred_total: "roughly <= 8,000 tokens"

split_review_trigger:
  - "single file repeatedly exceeds ~4,000 tokens"
  - "many tasks read less than half of the file"
  - "specialized detail dominates common rules"
```

数値目標よりrouting qualityを優先する。

## Projection rules

artifact生成・編集時は各ruleについて最低限次を確認する。

```yaml
preserve:
  - "normative strength"
  - "preconditions"
  - "exceptions"
  - "negative guards"
  - "ownership / routing boundaries"

remove_or_compress:
  - "history"
  - "source provenance detail"
  - "migration state"
  - "repeated rationale"
  - "obsolete alternatives"

never:
  - "legacy artifact wordingを現在authorityとしてそのまま復活"
  - "token削減のためにconditionを落とす"
  - "subject間のownership conflictをartifact側で新しく作る"
```

## Maintenance traceability

artifact file内へ大量のsource pathを埋め込まない。

repository側でprojection mappingを保持し、artifactのAI-facing本文をsource bookkeepingで膨らませない。

この文書を初期mappingとして利用し、実artifact完成時にfile / section単位のprojection mapへ詳細化する。

## Distribution script impact

現行 `artifacts.sh --modules` はlegacy 3 module前提なので、新pack確定時に変更する。

初期方向:

```text
./artifacts.sh --target <project>
  -> documents/artifacts/ をwhole-pack sync

legacy module selection
  -> 廃止候補
```

remove / symlink safety / atomic replacement / non-interactive execution等の安全性は維持する。

## Next implementation step

1. このarchitectureに沿って新artifact 8 leaf + INDEXをcandidateとして作る。
2. 各fileについてsubject → artifact projection mapを作る。
3. 通常taskのroutingをtoken量と意味欠落の両面でレビューする。
4. legacy 14 artifactとのsemantic regression auditを行う。
5. 問題なければ `artifacts/` を置換し、`artifacts.sh` / tests / READMEを新packへ更新する。
