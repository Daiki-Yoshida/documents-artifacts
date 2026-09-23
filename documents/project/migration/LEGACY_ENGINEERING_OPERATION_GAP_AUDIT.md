# Engineering Operation — 旧AI_WORKFLOWの意味差分監査（第1巡）

```yaml
document_type: "repository_local_semantic_gap_audit"
authority: "derived_analysis_not_normative"
audit_date: "2026-09-24"
baseline_legacy_commit: "e760eb38841650d60739750953c8342b639ce6f0"
legacy_file: "artifacts/design-principles/AI_WORKFLOW.md"
legacy_h2_sections: 8
semantic_migration_complete: false
candidate_subject: "engineering-operation"
```

## 位置付け

旧 `AI_WORKFLOW.md` は、software designそのものだけでなく、要求理解・事前scan・確認境界・実装・検証・version-control・報告・brownfieldという**engineering changeの進め方**を1本のFLOWとして扱っていた。

現行6 subjectのうち、`development-execution` はcommand/runtime、`development-safety` はoperation risk、`work-identity` はWork lifecycleを主語にしており、このFLOW全体の単一ownerではない。

この監査は旧8 H2を現在の責務へ分解し、第0情報源が確認できる部分と旧artifactにしか残らない部分を区別する。

## 根拠

- [review運用版commit](../../knowledge/records/2026-06-22-design-review-guard-commit/RECORD.md): Contract Confirmation GateをL0-L3化し、pre-scanでmodule四義を解決する変更をcommit messageで確認。
- [brownfield policy commit](../../knowledge/records/2026-07-01-brownfield-policy-commit/RECORD.md): AI workflowへbrownfield policyを追加したことをcommit messageで確認。
- [旧design-principles Issue #1](../../knowledge/records/2026-09-06-design-principles-proposals/RECORD.md): contract conformanceと要求達成、semantic identity、compatibility、state ownership、performanceの改善提案。
- [中央PR #10](../../knowledge/records/2026-09-15-design-principles-contract-decision/RECORD.md): 上記のうち1/2/3/5を修正採用。
- [performance後続PR #17](../../knowledge/records/2026-09-20-performance-contract-evolution/RECORD.md): load-bearing performance requirementの後続実装。
- baseline旧artifact: 当時の最終的な第2情報源本文を示すが、第0情報源そのものではない。

## 1. 8 H2の差分

| 旧節 | 旧artifactで扱う内容 | 現行subjectとの関係 | source / 評価状態 |
|---|---|---|---|
| Core Thinking Process | user intent / required outcome → contract → risk gate → implementation → verification | 全体FLOWのownerなし。Encapsulation Horizonはcontract/boundary判断だけを所有 | baseline L。DP1/DP2はoutcomeとcontractの分離を後続で補強 |
| Step 1: Define Boundaries & Contracts | component type、pre-implementation scan、proportionality、module/horizon、responsibility、semantic identity、state ownership、dependency spread、mapping、performance、compatibility、L0-L3 confirmation | boundary/horizonはencapsulation-horizon、mapping等はcode-design候補、作業順序と確認はengineering-operation候補 | 41f commit、DP1/DP2、DP5で一部source-backed。全scan項目の原提案は未取得 |
| Step 2: Implementation | shell/core logic、constructor injection、内部paradigm、contract遵守 | 実装構造はcode-design候補。FLOWとして「設計後に実装」はengineering-operation候補 | 詳細は主にbaseline L。第0情報源不足 |
| Step 3: Verification | contract conformanceとrequirement satisfactionを別に確認、narrowest meaningful path、boundary check、performance verification | test strategyの具体はcode-design候補。作業完了判定はengineering-operation候補 | DP1提案1→DP2で修正採用。performanceはDP5 |
| Operational Discipline | reporting language/content、test before done、commit/pushしない、default branchでbranch作成、clarification | engineering-operation候補。documentationのGit規則やdevelopment-safetyとは別 | 大半はbaseline Lのみ。commit/push等の元チャットsource未取得 |
| Brownfield Policy | new/modified codeはstandardsに従う、project-local rule優先、周辺違反を勝手に直さない、scope expansion禁止 | engineering-operation候補。development-executionのbrownfield environment adoptionとは別 | 5048 commit messageでpolicy追加は確認。詳細条文の第0情報源は未取得 |
| Special Instructions | 「どう進める？」では即codeせずapproach比較・trade-off・推奨 | engineering-operation候補。ただしagent interaction guidanceとして独立性要検討 | baseline Lのみ。元source未取得 |
| Worked Example | stairs例でproportionality→scan→contract→implementation→requirement verificationを接続 | reusable ruleではなく、複数ownerのルールを使う説明exampleとして扱う候補 | baseline L。example自体をnormative sourceにしない |

## 2. 現行subjectへ吸収しない理由

### development-executionではない

`development-execution` の主語は「開発処理をどこで・どの実行環境で・どの公開入口から実行するか」。

旧AI workflowのuser intent、design scan、contract確認、requirement satisfaction、brownfield scope、reportingは、Docker/host/command/CIの実行environmentを変更しても同じ意味で残る。したがってexecution environmentとは独立した知識である。

### development-safetyではない

`development-safety` は破壊操作、diagnostics、recovery、integration、operation riskを所有する。

旧AI workflowのL3にはdestructive operationも含まれるが、workflow全体をsafetyへ寄せると、通常の設計・実装・verification・reportingまで安全性subjectが所有することになる。safetyはrisk部分の主ownerとして参照する。

### work-identityではない

Work Identityは一つのWorkのidentity / Work Root / resource / lifecycleを扱う。engineering change processはWork Rootの有無に依存せず成立する。

## 3. Engineering Operation候補の責務

候補subjectの主語:

> **要求を受けたengineering changeを、どのauthority・scope・判断順序・verification・version-control・reportingで完了させるか。**

候補として整理できる内部責務:

1. authority / local convention / user intent
2. task outcomeとscope
3. proportional pre-implementation scan
4. design/contract確認へのrouting
5. implementation中のscope discipline
6. verificationとdone判定
7. brownfield behavior
8. version-control authority
9. reporting
10. approach question等のagent interaction

ただし、この一覧は**構造候補**であって、旧artifactの全条文を現在採用したものではない。

## 4. source-backedで現在使える知識

### Contract conformanceと要求達成を分離する

DP1は、誤った要求理解からcontract・実装・testが自己整合しても、user-visible outcomeを満たさない問題を提起した。DP2はformal acceptance criteriaを常時必須にはせず、contract conformanceとは別に、必要なobservable outcomeをnarrowest meaningful pathで確認する形へ修正採用した。

したがって「contract test PASSだけでtask完了としない」という判断はsource-backedである。

### Confirmation levelはchange impactで分類する

41f commit messageはContract Confirmation GateをL0-L3 severityへ変更したことを確認できる。その後DP2がadditiveとcompatibilityを分離しているため、現行の具体的contract levelは `encapsulation-horizon/S008_OPERATIONAL_GUARDS.md` を主ownerとして参照する。

engineering-operation候補がlevel定義そのものを複製せず、「作業中に該当ownerへrouteする」形が適切。

### Brownfield policyが独立FLOWへ追加された

5048 commit messageはbrownfield policyをAI workflowへ追加したことを直接確認できる。ただし「project-local rule優先」「周辺違反を直さない」等の全詳細をcommit message単独で証明できないため、詳細条文のcurrent adoptionは保留する。

## 5. source不足

次はbaseline artifactに存在するが、今回の第0情報源では詳細採用を十分に証明できない。

- `thinking_and_interim: english` 等のreporting language
- userが求めるまでcommit/pushしないというversion-control authority
- default branchならbranch作成
- intent/contract不明時のSTOP/clarification
- test実行前にdoneを宣言しない、というOperational Disciplineの全文
- brownfield policyの全細則
- approach questionの3-step手順
- Worked Example固有の手順

これらをcanonical subjectへ移すには、元チャット等を取得するか、現在の新しい第0情報源として改めて採用判断を記録する必要がある。

## 6. 次のgate

1. 現行ユーザー運用として維持したいengineering-operation規則を、過去の元sourceまたは新しい明示判断から確定する。
2. source-backedな規則が十分になった時点で、`engineering-operation` という正式subject名・内部file構造を決める。
3. Encapsulation Horizon / Code Design / Development Safety等が所有するルールは局所再述＋参照に留め、別specを作らない。
4. 旧 `AI_WORKFLOW.md` は第2情報源のhistorical projectionとして扱い、そこにあるという理由だけで全規範を復活させない。
