# Documentation Strategy — legacy baseline 37 H2の意味差分監査

```yaml
document_type: "repository_local_semantic_gap_audit"
authority: "derived_analysis_not_normative"
audit_date: "2026-09-24"
legacy_source_snapshot: "../../knowledge/records/2026-07-09-documentation-strategy-final-source-snapshot/"
legacy_files: 4
independent_repository_h2_sections: 34
central_legacy_baseline_h2_sections: 37
semantic_migration_complete: "owner/history classification complete; exhaustive line-by-line parity not claimed"
```

## 結論

旧独立 `documentation-strategy` repositoryの最終実質stateは4ファイル・34 H2。その後、中央repositoryへ統合されたlegacy artifactへ3 H2が追加され、監査baseline `e760eb38841650d60739750953c8342b639ce6f0` では **37 H2** になっている。現在は **37 / 37を現行knowledgeへ分類できる**。

ただし分類は「同じH2 titleが存在する」という意味ではない。現在のdocumentation subjectでは、旧modelのうち後続判断で維持するものをS001〜S005へ整理し、現在採用しないものをS006_HISTORYへ明示的に分離している。

重要な後続変更:

- mandatory `docs-jp/` audience splitを現行規範にしない。
- documentごとのSemantic Version / `last_updated_commit` registryを要求しない。
- INDEXをversion registryとして扱わない。
- 厳密な「1情報 = 1文書」ではなく、主authority + routing / referenceを優先する。
- `documents/project/` / `documents/reference/` 等を絶対構造として強制せず、project固有routingを許容する。

このため、旧H2がS006_HISTORYにあることはmigration漏れではなく、後続decisionにより**非採用または置換された旧modelの保存**である。

## Source integrity

最終実質状態は旧 `Daiki-Yoshida/documentation-strategy` commit
`c53be461410e315f55c5aeee2cd972d3b471acdf`。

[final source snapshot](../../knowledge/records/2026-07-09-documentation-strategy-final-source-snapshot/MANIFEST.md) の4ファイルは、旧repositoryの同commitにあるGit blob SHAと **4 / 4一致**を確認した。

中央統合後はPR #16でManaged Artifact ownershipが追加され、PR #19でWork Documents semanticsが追加された。最終legacy baselineで増えた3 H2は、旧repository snapshotを改変して保存したものではなく、後続source eventとして別に評価する。

## 1. DOCUMENTATION_PHILOSOPHY.md — 10 / 10（旧repo 9 + 中央追加1）

| 旧H2 | 現在の扱い | 現行owner |
|---|---|---|
| Core Principle: Information Accuracy First | 現行。情報量削減より意味の正確性を優先 | documentation/S001 |
| Scope: What This Strategy Governs | 現行。Project Documentationの責務境界 | documentation/S001 |
| Work Documents: Active-Work Knowledge | 中央PR #19で追加。active Work側のidentity/lifecycleはwork-identityが主所有し、Project Documentationへ残すdurable knowledgeのreconciliationはdocumentation/S003が所有 | work-identity/S003/S004 + documentation/S003 |
| AI-Facing by Default | **旧model**。audienceだけを理由に固定top-levelを強制しない | documentation/S006_HISTORY |
| Routing Over Truncation | 現行。情報を切り捨てずroutingで必要範囲を読む | documentation/S002 |
| Git as a Recording Tool | 現行。Git historyを記録機構として利用 | documentation/S005 |
| Single Source of Truth | **旧表現を置換**。厳密な1情報=1文書はhistory。現在は主authorityと参照関係を優先 | documentation/S006_HISTORY + system traceability |
| Universality | 現行。固定templateではなくprojectへ適応 | documentation/S001 |
| Relationship to design-principles | **旧artifact packagingの関係**としてhistory。現在はsubject routingで分離 | documentation/S006_HISTORY |
| Common Misreadings | 旧model固有の誤読guardをhistoryとして保持。現行規範の解釈はS001〜S005自身で決まる | documentation/S006_HISTORY |

## 2. DOCUMENT_WORKFLOW.md — 12 / 12（旧repo 10 + 中央追加2）

| 旧H2 | 現在の扱い | 現行owner |
|---|---|---|
| Use Cases | routing heading。新規 / brownfield / ongoingへ再編 | documentation/S003 |
| New Project Setup | 現行 | documentation/S003 |
| Existing Project Adoption (Brownfield) | 現行 | documentation/S003 |
| Ongoing Document Updates | 現行 | documentation/S003 |
| Staleness Handling | **旧version registry依存model**としてhistory | documentation/S006_HISTORY |
| Managed Artifact Handling | 中央PR #16で追加。installed guidanceはproject-owned文書として直接保守せず、canonical source / distribution mechanismから更新・削除する | documentation/S003 |
| Work Documents | 中央PR #19で追加。active lifecycleはwork-identity、durable Project Documentationへのreconciliationはdocumentation | work-identity/S003/S004 + documentation/S003 |
| Version Bumping Workflow | **非採用**。document Semantic Version / commit-hash二段階更新を現行必須にしない | documentation/S006_HISTORY |
| Document Creation Decision Tree | **旧固定directory/audience model**としてhistory。現在はrouting responsibilityをS002が所有 | documentation/S006_HISTORY |
| Document Deletion Workflow | 現行 | documentation/S004 |
| Re-read Triggers | 現行 | documentation/S004 |
| Confirmation Gate | 現行。document model変更等の確認境界 | documentation/S004 |

## 3. FILE_AND_STRUCTURE.md — 11 / 11

| 旧H2 | 現在の扱い | 現行owner |
|---|---|---|
| 1. Top-Level Directory Layout | **旧固定layout**としてhistory。Project Rootの物理ownershipはworkspace-structure、document内部routingはdocumentation | documentation/S006_HISTORY + workspace-structure |
| 2. File Roles | 現行。役割とroutingをprojectへ適応可能な形で保持 | documentation/S002 |
| 3. Cross-Reference and Routing Strategy | 現行 | documentation/S002 |
| 4. Document Versioning System | **非採用**。Git history中心へ置換 | documentation/S006_HISTORY |
| 5. Git Commit Message Conventions | 現行範囲をS005へ整理 | documentation/S005 |
| 6. File Format Standards | 現行 | documentation/S005 |
| 7. Directory Splitting Guide | 現行。concern / routingで分割 | documentation/S002 |
| 8. Hierarchical Projects | 現行。固定shapeではなくhierarchyを表現可能にする | documentation/S002 |
| 9. Document Deletion Rules | 現行 | documentation/S004 |
| 10. Multi-Developer INDEX.md Conflict Mitigation | **旧central version registry由来**としてhistory | documentation/S006_HISTORY |
| How These Interlock | 旧INDEX/version registry/top-level layoutの統合説明としてhistory。個別の現行責務へ分解済み | documentation/S006_HISTORY |

## 4. INDEX.md — 4 / 4

| 旧H2 | 現在の扱い |
|---|---|
| Read Order | 旧4-file packagingのrouting。現在はdocumentation/INDEX.mdとsubject file routingへ置換 |
| Foundational Lens | Accuracy / Routing / Git等の要約であり、現在はS001〜S005がauthority |
| Ownership Map (Single Source of Truth) | 旧WHY/HOW/FLOW file ownership map。現在のsubject内部責務へ再編 |
| Quick Task Routing | 旧artifact file名へのrouting。現在のdocumentation INDEXへ置換 |

旧INDEXは独立した追加規範ではなく、旧packagingの入口として扱う。

## 5. 現行subjectのcoverage

active normative owner:

- [S001_PRINCIPLES.md](../../knowledge/subjects/documentation/S001_PRINCIPLES.md)
- [S002_ROUTING_AND_STRUCTURE.md](../../knowledge/subjects/documentation/S002_ROUTING_AND_STRUCTURE.md)
- [S003_WORKFLOW.md](../../knowledge/subjects/documentation/S003_WORKFLOW.md)
- [S004_MAINTENANCE_AND_REVIEW.md](../../knowledge/subjects/documentation/S004_MAINTENANCE_AND_REVIEW.md)
- [S005_FORMAT_AND_GIT.md](../../knowledge/subjects/documentation/S005_FORMAT_AND_GIT.md)

rejected / superseded legacy model:

- [S006_HISTORY.md](../../knowledge/subjects/documentation/S006_HISTORY.md)

S006には旧規範の本文を保存し、2026-09-22 cross-subject alignmentで「現行本文から除去した」理由も明示している。従って、version registry等をS001〜S005へ再昇格させない。

## 6. 残るgap

H2単位のowner不在は今回確認していない。一方、次は引き続きsemantic parity監査が必要。

1. 各H3 / YAML rule / exceptionが、active規範またはhistoryへ正しく分類されているか。
2. 最終英語sourceと2026-09-21日本語snapshotの差分。
3. `Git Commit Message Conventions` 等、旧repository固有運用と一般Project Documentation規範の境界。
4. 現在のdocumentation subjectに不要な旧file名・旧directory assumptionがnormative本文へ再混入していないか。

したがって中央legacy baselineでは **37 / 37 H2 classified**。旧独立repository由来34 H2と中央追加3 H2を区別して追跡する。ただしdocumentation-strategy全体を逐語的semantic migration PASSとはまだ宣言しない。


## 6.1 中央repository移行後に追加された3 H2

旧repository final snapshotの34 H2だけでは、中央legacy baseline 37 H2を説明できない。追加3節は次の後続sourceから導入された。

| 中央追加H2 | source | 現在の扱い |
|---|---|---|
| Work Documents: Active-Work Knowledge | [PR #19](../../knowledge/records/2026-09-20-work-identity-artifactization-pr/RECORD.md) | Work Documents自体はwork-identity、durable Project Documentationへのreconciliationはdocumentation |
| Managed Artifact Handling | [PR #16](../../knowledge/records/2026-09-15-cross-artifact-consistency-pr/RECORD.md) | documentation/S003へ復元。managed copyをproject-owned文書として直接patchしない |
| Use Case 6: Work Documents | [PR #19](../../knowledge/records/2026-09-20-work-identity-artifactization-pr/RECORD.md) | Work lifecycleはwork-identity、documentation destination semanticsはdocumentation/S003 |

これらは旧repo final snapshotへ後知恵で追加せず、中央repositoryの後続sourceとしてtraceする。

## 7. H3 / detail監査（2026-09-24）

final英語snapshotのH3・YAML rule・後続commit patchまで確認した。

### source recoveryで追加確認できた変更

- [4-file split commit](../../knowledge/records/2026-07-09-documentation-split-commit/RECORD.md): WHY / HOW+WHERE / FLOW / INDEXへ責務を分けた初期構造。
- [documentation atomicity commit](../../knowledge/records/2026-07-09-documentation-atomicity-commit/RECORD.md): 一時期「related docsを1 commitで更新」「docs-only branchを作らない」というpolicyを導入。
- [v2 restructure commit](../../knowledge/records/2026-07-09-documentation-v2-restructure-commit/RECORD.md): accuracy > routing > token efficiency、固定docs-jp分離、version registry等を導入。
- [consistency fixes commit](../../knowledge/records/2026-07-09-documentation-consistency-fixes-commit/RECORD.md): staleness、directory split、deletion、registry conflict等を追加。
- [v2.2 review fixes](../../knowledge/records/2026-07-09-documentation-v2-2-review-fixes-commit/RECORD.md): placement固定の撤回、entry fileを「routing only」から「rules + routing」へ修正、version registry細則等を調整。

### 現行normativeへ残すdetail

- entry fileは**routingだけではなく、agent起動直後に必要なproject-local operational constraintを保持してよい**。ただしProject Documentationの詳細knowledgeを複製するauthorityにはしない。
- INDEXはrouting hubとして保持するが、version registryとしてのcentral state sourceにはしない。
- cross referenceは局所文脈を許容し、別authorityの規範を独立再定義しない。
- brownfieldでは構造移行とcontent改善を同じtaskへ黙って拡大しない。
- deletion時は参照・INDEX routingを先にreconcileする。
- commit message formatはproject convention優先。documentation subjectはbranch/timingを所有しない。

entry fileの「routingする; 説明しない」という旧表現はv2.2の後続修正と衝突するため、現行S002/S003をrules+routingへ訂正した。

### historyへ留めるdetail

次はcurrent ruleとして復活させない。

- `documents/`=AI / `docs-jp/`=humanの固定分割
- per-document Semantic Version / `last_updated_commit`
- INDEX version registry
- commit hashのtwo-phase update
- registry中心のstaleness detection
- registry競合緩和
- 旧directory decision treeの固定placement
- intermediateな「documentation-only changeはbranchを作らない」「related docsは必ず1 commit」というGit workflow policy

atomicity policyは2026-07-09途中commitでは明示されたが、その後v2 restructureはcommit timing / branchingをdocumentationの管轄外とした。現行S005は後者を採用する。 8 subject化後は、commit / push authorityを `engineering-operation/S006_VERSION_CONTROL_AND_REPORTING.md`、Work固有branch/worktree materializationを `work-identity/`、documentation固有のcommit message / history利用を `documentation/S005_FORMAT_AND_GIT.md` が主所有する形へroutingを明示した。

### 後続decisionとの再整合（2026-09-24 review）

source recovery中に、旧v2.2の `documents/project/` / `documents/reference/` 固定shapeが現行S002/S003へ再混入していることを検出した。

2026-09-22の後続recordは、Project Documentation rootを `<project-root>/documents/` に統一しつつ、**内部構造は柔軟化**すると明示している。この後続decisionを優先し、現行規範を次へ修正した。

- `documents/INDEX.md` はrouting hubとして維持。
- `documents/project/` / `documents/reference/` は標準的な配置例であり必須directoryではない。
- 新規project setupも、root + INDEXを必須とし、内部directoryはproject固有routingに従う。
- brownfield mappingもAI-facing contentを固定project/referenceへ強制しない。

旧v2.2の固定shapeはfinal source snapshot / historyに残るため、原文は失われない。

### routing modelの最終整合（2026-09-24追加review）

active S002を再確認し、旧model由来の強すぎる表現を2点修正した。

- 「1つの関心事の変更は1ファイルだけ読めばよい」を、**1ファイルは1主関心事 / 1関心事は主authorityを持ち、必要な関連authorityはcross referenceで辿る**へ変更。
- agent entry fileのpurposeを「documents/INDEX.mdへのrouting」だけでなく、v2.2 sourceどおり**project-local conventions + routing**と明示。

これにより、旧strict SSOTを復活させず、現在の主authority + 局所再述 + reference modelとentry-file responsibilityが一致した。

## 8. Documentation側の現在判定

旧34 H2に加え、重要なH3 / operational detailを監査した結果、現時点で確認した範囲では新しいsubjectを必要とする未所有detailはない。

今後の確認はmigration blockerではなくregression auditとして扱う。旧英語sourceにのみ残る例外・反論が新しい後続sourceと衝突していないかは継続確認できるが、旧version registry model等の意図的historyを未移行扱いへ戻さない。
