# History

## 旧design-principlesとの関係

旧 `design-principles` はWHY / HOW / WHERE / FLOWの複数文書へ設計knowledgeを分けていた。

現行ではそのfile splitをsubject authorityとして復活させず、主語で分離した。

```text
encapsulation-horizon
  boundaryをどこでhardeningするか

code-design
  選択済みboundaryをcodeとしてどう実現するか

engineering-operation（候補）
  engineering changeをどう調査・実行・検証・報告するか
```

## Source recovery

2026-09-24の移行監査で、旧repositoryから次をrecordsへ無加工snapshotとして保存した。

- 2026-01-31 initial code-design state
- Bounded Contracts / testing / error等のrefinement state
- dependency direction / DI refinement state
- domain model refinement state
- 2026-06-13非配布reference
- 2026-07-02最後の実質的design-principles state
- PROJECT_STRUCTURE初出、Encapsulation Horizon反映、review guard等のcommit message

これにより、旧第2情報源artifactだけでなく、**versioned repository stateそのもの**からcode-designを再構成できる範囲が広がった。

## 2026-01-31系の設計規範

初期sourceではinterface / layer / DI / error / testing / composition / fail-fast等が導入された。

後続refinementでは:

- interface keywordとcontract meaningを分離
- language idiomを優先
- Domain/Application/Infrastructureのdependency ruleを明確化
- Entity/VOのDI constraint
- Result bootstrap
- testing scope / black-box / contract verification
- Rich/Lightweight model
- type-driven state transition

などが段階的に調整された。

現行subjectは最終的なsnapshotと後続decisionを優先し、初期版の古い強い表現をそのまま復活させない。

## 2026-06〜07の構造化

PROJECT_STRUCTURE追加によりpublic surface、shared placement、runtime topology、test placementが独立して整理された。

review反映ではone public surfaceのaudience exception、module四義、confirmation severity等が追加された。

2026-07-02 snapshotを、旧repository側の最後の実質的baselineとして扱う。

## 移行後の訂正

### 2026-09-15

- contract conformanceとrequested outcome verificationを分離。
- Concept Generalityのone-sentence testをneutrality signalへ限定。
- compatibilityをconsumer/provider双方で評価。
- state ownership / coordination responsibilityを明確化。
- performance-shaped contract提案はいったん保留。
- raw Infrastructure exception leakageやContract Testの過剰一般化をcross-artifact auditで修正。

### 2026-09-20

load-bearing performance requirementとevidenceがある場合のみinteraction shape redesignを許容する方針を反映。

## 現在canonicalへ移行した範囲

- code realization / internal freedom / side-effect containment
- inheritance boundary
- state ownership / consistency
- feature/module firstとlayer responsibility
- contract placement / module public surface / shared placement
- interface requirement / dependency direction / DI
- external dependency containment
- Rich/Lightweight Domain Model / Domain purity
- DTO / mapping ownership
- expected failure / system failure / boundary translation
- async / cancellation / thread-safety contract
- test strategy / placement / runtime topology / composition root
- compatibility / verification
- performance-shaped interaction
- design priority

## 旧表現をそのまま採用していない例

- 「additiveならcompatible」→ consumer/provider双方のcompatibilityへ修正
- 「Contract Test IS correctness」→ contract conformanceとrequested outcomeを分離
- performanceでAPIを変える一般論 → load-bearing requirement + evidence gateを必須化
- interface everywhere → actual boundaryで価値がある場合に限定
- Rich Domain Modelを常時default → subdomain complexityでRich/Lightweightを選択

## Engineering Operationへ残すもの

commit/push authority、reporting、task scope、brownfield作業規律、approach question等はcode-designではない。

これらは `documents/project/migration/LEGACY_ENGINEERING_OPERATION_GAP_AUDIT.md` で別途追跡する。


## Sources

主要な旧repository state / reference:

- `../../records/2026-01-31-initial-code-design-source/`
- `../../records/2026-01-31-bounded-contracts-refinement-source/`
- `../../records/2026-01-31-dependency-boundary-refinement-source/`
- `../../records/2026-01-31-domain-model-refinement-source/`
- `../../records/2026-06-13-design-principles-reference-snapshot/`
- `../../records/2026-07-02-design-principles-final-source-snapshot/`

導入・refinementのGit source event:

- `../../records/2026-01-31-design-principles-foundation-commit/RECORD.md`
- `../../records/2026-01-31-code-standards-refinement-commit/RECORD.md`
- `../../records/2026-01-31-dependency-boundary-refinement-commit/RECORD.md`
- `../../records/2026-01-31-domain-modeling-refinement-commit/RECORD.md`
- `../../records/2026-06-13-external-boundary-refinement-commit/RECORD.md`
- `../../records/2026-06-13-module-mapping-testing-refinement-commit/RECORD.md`
- `../../records/2026-06-21-project-structure-origin-commit/RECORD.md`
- `../../records/2026-06-22-design-review-guard-commit/RECORD.md`

移行後の訂正・評価:

- `../../records/2026-09-06-design-principles-proposals/RECORD.md`
- `../../records/2026-09-15-design-principles-contract-decision/RECORD.md`
- `../../records/2026-09-15-cross-artifact-consistency-issue/RECORD.md`
- `../../records/2026-09-15-cross-artifact-consistency-pr/RECORD.md`
- `../../records/2026-09-15-performance-redesign-hold/RECORD.md`
- `../../records/2026-09-20-performance-contract-evolution/RECORD.md`

移行監査:

- `../../../project/migration/LEGACY_CODE_DESIGN_GAP_AUDIT.md`
- `../../../project/migration/LEGACY_DESIGN_PHILOSOPHY_GAP_AUDIT.md`
- `../../../project/migration/LEGACY_DESIGN_SUBJECT_OWNERSHIP.md`
- `../../../project/migration/LEGACY_ENGINEERING_OPERATION_GAP_AUDIT.md`
