# Subject Ownership Decision — Legacy Design Knowledge

~~~~yaml
document_type: "repository_local_subject_design_decision"
authority: "derived_architecture_decision_not_normative_subject_content"
decision_date: "2026-09-24"
status: "code-design and engineering-operation formalized from recovered source"
~~~~

## 結論

旧 design-principles の残存知識を既存subjectへ無理に押し込まず、source-backedな範囲から新しい責務へ整理する。

責務監査と旧repository source recoveryにより、`code-design` と `engineering-operation` をそれぞれ独立subjectとして正式化した。

~~~~text
encapsulation-horizon
  「どの責務・scaleを硬いboundaryとして扱うか」
          ↓ boundary chosen

code-design
  「選んだboundaryの内外を、codeとしてどう構造化・実装・検証するか」

engineering-operation
  「1つのengineering changeを、どう調査・変更・検証・報告するか」
~~~~

`code-design` は `documents/knowledge/subjects/code-design/`、`engineering-operation` は `documents/knowledge/subjects/engineering-operation/` として正式化済み。旧module名 `design-principles` をそのままsubject authorityへ復活させない。

## 取得できた旧Git履歴による補強

旧 `Daiki-Yoshida/design-principles` のGit commit messageも第0情報源snapshotとして保存した。

- [PROJECT_STRUCTURE追加commit](../../knowledge/records/2026-06-21-project-structure-origin-commit/RECORD.md): `PROJECT_STRUCTURE.md` を「モジュール公開面・共有カーネル・runtime topology・test placementを扱うWHERE」として新設し、`CODING_STANDARDS.md` をHOW、`DESIGN_PHILOSOPHY.md` をWHY、`AI_WORKFLOW.md` をFLOWとして分けた当時の設計意図を確認できる。
- [review運用版commit](../../knowledge/records/2026-06-22-design-review-guard-commit/RECORD.md): audience別public surface例外、Contract Confirmation Gate、module四義等をレビュー反映したことを確認できる。
- [brownfield policy commit](../../knowledge/records/2026-07-01-brownfield-policy-commit/RECORD.md): AI workflowへbrownfield policyを追加したことをcommit messageから確認できる。
- [2026-07-02 design docs update](../../knowledge/records/2026-07-02-design-doc-update-commit/RECORD.md): commit message自体は詳細を持たないため、変更内容の採用理由をこのmessageだけから推論しない。

これらは旧artifactのすべての規範の元sourceではないが、少なくとも**code structureとAI workflowが当時から別の問いとして分割されていた**ことの直接的なGit履歴証拠になる。

旧DESIGN_PHILOSOPHY 18 H2の具体的な移行状況は [LEGACY_DESIGN_PHILOSOPHY_GAP_AUDIT.md](LEGACY_DESIGN_PHILOSOPHY_GAP_AUDIT.md) で監査する。

## 1. Encapsulation Horizonとの境界

encapsulation-horizon の現在の主語は「境界面をどのscaleで硬化し、どこから内部自由を許容するか」である。

引き続きEncapsulation Horizonが所有するもの:

- responsibility / caller coherenceとhardening horizon
- stability / seam cost / maturityによるhardening判断
- Concept Altitudeとsemantic identity
- boundary contractの完全性
- inner horizonへのgraduation
- contract変更のblast radius / confirmation level

一方、boundaryを選択した後のDomain / Application / Infrastructure / UI、port / adapter、DI、external dependency containment、DTO / mapping、error、async、shared kernel、runtime topology、test strategy / placementは同じ問いではない。

これらをEncapsulation Horizonへ追加すると「boundaryをどこに置くか」と「そのboundaryの周辺をどう実装するか」が混在し、SUBJECT_MODELの分割兆候に該当する。

## 2. Code Design（正式subject）

`code-design` は次の一文を主語として正式subject化した。

> 選択済みのsoftware boundaryと責務を、依存方向・型・port・adapter・失敗・非同期・変換・testを含むcode structureへ落とし込む方法を扱う。

| 知識 | code-designの責務 / 今後の拡張領域 | 既存subjectとの接続 |
|---|---|---|
| module public surface | code-level visibility / export / deep-import prevention | hardening対象そのものはencapsulation-horizon |
| layer responsibilities | Domain / Application / Infrastructure / UIの依存とownership | repositoryの物理配置を扱うworkspace-structureとは別 |
| dependency direction / DI | dependencyの提供方法とcomposition | Docker/host実行を扱うdevelopment-executionとは別 |
| external dependency | vendor typeのcontainment・port/adapter | boundary必要性はencapsulation-horizonと接続 |
| domain model | business rule / model sophistication / mutability | Concept Altitudeの意味所有と接続 |
| mapping | DTO / Domain / ViewModel / DB modelのtranslation ownership | documentationの情報routingとは別 |
| failure contracts | Result / exception / boundary translation | contract completenessのfailure channelを具体化 |
| async / concurrency | signature / cancellation / thread-safety / mutable state | contract completenessのresource/determinismを具体化 |
| shared kernel | cross-cutting codeの依存階層 | workspaceのrepository topologyとは別 |
| runtime topology | application codeのruntime seam / composition root | development-executionの開発tool runtimeとは別 |
| test strategy / placement | contract conformanceと要求達成の検証、test ownership | development-safetyの操作検証とは別 |

code-designが所有しないもの:

- boundaryを硬化すべきscaleそのもの → encapsulation-horizon
- project/repository/worktreeのfilesystem/Git配置 → workspace-structure / work-identity
- Docker / host / CI command execution → development-execution
- destructive operation / recovery → development-safety
- project documentation → documentation
- AI/agentが変更作業をどう進めるかという横断process → engineering-operation

## 3. Engineering Operation（正式subject）

旧AI workflow 8 H2の具体的なsource / gap監査は [LEGACY_ENGINEERING_OPERATION_GAP_AUDIT.md](LEGACY_ENGINEERING_OPERATION_GAP_AUDIT.md) に分離した。

旧 AI_WORKFLOW.md には、user intent / required outcome、pre-implementation scan、contract confirmation、implementation、requirement verification、commit / push、brownfield、approach question、reportingなど、code-designを超える知識が存在する。

engineering-operation は次の一文を主語として正式subject化した。

> 要求を受けたengineering changeを、authority・scope・設計・実装・検証・version-control・報告までどの順序と確認境界で進めるかを扱う。

既存subjectとの境界:

- development-execution: commandをどのruntime/environmentで実行するか
- development-safety: destructive/risky operationをどう安全に実行するか
- work-identity: 1つのWorkのidentity・resource・lifecycle
- engineering-operation: 1つの変更要求をどう判断・実施・verify・reportするか

したがって旧 ENGINEERING_OPERATING_MODEL.md のような横断資料をdevelopment-executionへ丸ごと統合しない。

## 4. Performance / Contract Evolution / Testingの境界

Performance:
- caller-visible guarantee / boundary completeness → Encapsulation Horizon
- batch / stream / pagination / async等のinteraction shape設計 → code-design
- benchmarkの実行環境・CI entrypoint → development-execution

Contract Evolution:
- hardening boundaryのseverity / confirmation level → Encapsulation Horizon
- API/interface/wireの具体的compatibility mechanism → code-design
- destructive migrationのoperation risk → development-safety

Testing:
- boundaryを独立test可能か → Encapsulation Horizonのsplit/hardening判断材料
- unit / integration / contract / E2Eの目的、fake、suite、placement → code-design
- CIでどのcommandから実行するか → development-execution
- destructive integration testの安全性 → development-safety

## 5. Code Design / Engineering Operation正式化の根拠

Code Designは旧reference原本、versioned repository snapshot、後続Issue / PR decisionからbounded unit、layer/dependency、state、failure、testing、compatibility、performance等を追跡できるため正式化した。

Engineering Operationは、当初不足していたsourceを追加回収した。

- 2026-01-31 initial AI_WORKFLOW: change processとapproach question
- 2026-06-13 Operational Discipline commit patch: reporting、test-before-done、commit/push authority、default branch guard、clarification
- 2026-07-01 Brownfield Policy commit patch: local convention、surrounding violation、scope guard
- 2026-09-06 proposal + 2026-09-15 adopted decision: contract conformanceとrequested outcomeの分離

このため、Engineering Operationも責務境界だけでなくsource-backedなnormative coreが成立した。

## 6. 今回確定すること / 確定しないこと

確定:
- Encapsulation Horizonへ具体的code architectureを大量統合しない。
- code structure / state / compatibility / verification / performanceには独立したsubject責務が成立し、`code-design` として正式化した。
- AI実装workflow / reporting / VCS権限はcode-designとは別の `engineering-operation` が主所有する。
- 既存subjectの責務を広げてlegacy内容を吸収する方法は採らない。
- design-principlesという旧packaging名そのものを新subject authorityにしない。

未確定:
- code-designへ未回収legacy detailをどこまで追加採用するか。
- legacy artifactにしか残らない規範を現在も採用するか。
- 旧artifactへの再projection方法。
