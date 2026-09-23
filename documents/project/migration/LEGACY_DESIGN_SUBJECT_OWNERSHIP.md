# Subject Ownership Decision — Legacy Design Knowledge

~~~~yaml
document_type: "repository_local_subject_design_decision"
authority: "derived_architecture_decision_not_normative_subject_content"
decision_date: "2026-09-24"
status: "subject boundary decision; content migration still gated by source provenance"
~~~~

## 結論

旧 design-principles の残存知識は、現在の6 subjectへ無理に押し込まない。

現行の責務モデルと比較すると、少なくとも次の2つの独立した知識対象候補が存在する。

~~~~text
encapsulation-horizon
  「どの責務・scaleを硬いboundaryとして扱うか」
          ↓ boundary chosen

code-design
  「選んだboundaryの内外を、codeとしてどう構造化・実装・検証するか」

engineering-operation
  「1つのengineering changeを、どう調査・変更・検証・報告するか」
~~~~

code-design / engineering-operation は候補subject名であり、この文書だけで正式subjectを新設したことにはしない。旧module名 design-principles をそのままsubjectへ復活させる案は採らない。

## 取得できた旧Git履歴による補強

旧 `Daiki-Yoshida/design-principles` のGit commit messageも第0情報源snapshotとして保存した。

- [PROJECT_STRUCTURE追加commit](../../knowledge/records/2026-06-21-project-structure-origin-commit/RECORD.md): `PROJECT_STRUCTURE.md` を「モジュール公開面・共有カーネル・runtime topology・test placementを扱うWHERE」として新設し、`CODING_STANDARDS.md` をHOW、`DESIGN_PHILOSOPHY.md` をWHY、`AI_WORKFLOW.md` をFLOWとして分けた当時の設計意図を確認できる。
- [review運用版commit](../../knowledge/records/2026-06-22-design-review-guard-commit/RECORD.md): audience別public surface例外、Contract Confirmation Gate、module四義等をレビュー反映したことを確認できる。
- [brownfield policy commit](../../knowledge/records/2026-07-01-brownfield-policy-commit/RECORD.md): AI workflowへbrownfield policyを追加したことをcommit messageから確認できる。
- [2026-07-02 design docs update](../../knowledge/records/2026-07-02-design-doc-update-commit/RECORD.md): commit message自体は詳細を持たないため、変更内容の採用理由をこのmessageだけから推論しない。

これらは旧artifactのすべての規範の元sourceではないが、少なくとも**code structureとAI workflowが当時から別の問いとして分割されていた**ことの直接的なGit履歴証拠になる。

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

## 2. Code Design候補の主語

候補 code-design は次の一文で独立して説明できる。

> 選択済みのsoftware boundaryと責務を、依存方向・型・port・adapter・失敗・非同期・変換・testを含むcode structureへ落とし込む方法を扱う。

| 知識 | code-design候補の責務 | 既存subjectとの接続 |
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
- AI/agentが変更作業をどう進めるかという横断process → engineering-operation候補

## 3. Engineering Operation候補の主語

旧AI workflow 8 H2の具体的なsource / gap監査は [LEGACY_ENGINEERING_OPERATION_GAP_AUDIT.md](LEGACY_ENGINEERING_OPERATION_GAP_AUDIT.md) に分離した。

旧 AI_WORKFLOW.md には、user intent / required outcome、pre-implementation scan、contract confirmation、implementation、requirement verification、commit / push、brownfield、approach question、reportingなど、code-designを超える知識が存在する。

候補 engineering-operation は次の一文で独立して説明できる。

> 要求を受けたengineering changeを、authority・scope・設計・実装・検証・version-control・報告までどの順序と確認境界で進めるかを扱う。

既存subjectとの境界:

- development-execution: commandをどのruntime/environmentで実行するか
- development-safety: destructive/risky operationをどう安全に実行するか
- work-identity: 1つのWorkのidentity・resource・lifecycle
- engineering-operation候補: 1つの変更要求をどう判断・実施・verify・reportするか

したがって旧 ENGINEERING_OPERATING_MODEL.md のような横断資料をdevelopment-executionへ丸ごと統合しない。

## 4. Performance / Contract Evolution / Testingの境界

Performance:
- caller-visible guarantee / boundary completeness → Encapsulation Horizon
- batch / stream / pagination / async等のinteraction shape設計 → code-design候補
- benchmarkの実行環境・CI entrypoint → development-execution

Contract Evolution:
- hardening boundaryのseverity / confirmation level → Encapsulation Horizon
- API/interface/wireの具体的compatibility mechanism → code-design候補
- destructive migrationのoperation risk → development-safety

Testing:
- boundaryを独立test可能か → Encapsulation Horizonのsplit/hardening判断材料
- unit / integration / contract / E2Eの目的、fake、suite、placement → code-design候補
- CIでどのcommandから実行するか → development-execution
- destructive integration testの安全性 → development-safety

## 5. 新subjectを今すぐ正式作成しない理由

責務境界は独立しているが、subject本文へ移す情報のprovenanceはまだ不均一である。DI・layering・mapping・async・shared kernel・test placementの多くは、現在取得できている第0情報源より旧第2情報源artifactの方が詳細である。

旧artifact本文だけを根拠に現在の正式規範として再採用すると、knowledge-firstの情報源モデルを逆転させる。

順序:

1. この文書でsubject ownership boundaryを固定する。
2. 旧artifact各規範について、第0情報源または後続の明示的採用sourceを探す。
3. sourceを確認できた規範から、新subjectまたは既存subjectへ日本語で整理する。
4. sourceが失われた規範はhistorical derived rule / adoption unverifiedとして監査側に残す。
5. 十分なsource-backed本文が揃った時点でcode-designを正式subjectとして作成する。
6. engineering-operationはAI_WORKFLOW / cross-cutting recordsの監査を別に完了してから新設判断する。

## 6. 今回確定すること / 確定しないこと

確定:
- Encapsulation Horizonへ具体的code architectureを大量統合しない。
- code structure / dependency / translation / failure / async / testingには独立したsubject責務が成立する。
- AI実装workflow / reporting / VCS権限はcode-designとは別の知識対象として扱う。
- 現在の6 subjectの既存責務を広げてlegacy内容を吸収する方法は採らない。
- design-principlesという旧packaging名そのものを新subject authorityにしない。

未確定:
- 正式subject名を最終的にcode-designとするか。
- code-design内部のfile分割。
- legacy artifactにしか残らない規範を現在も採用するか。
- engineering-operationを正式subject化するか。
- 旧artifactへの再projection方法。
