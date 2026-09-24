# Documentation Strategy — 旧34 H2の意味差分監査

```yaml
document_type: "repository_local_semantic_gap_audit"
authority: "derived_analysis_not_normative"
audit_date: "2026-09-24"
legacy_source_snapshot: "../../knowledge/records/2026-07-09-documentation-strategy-final-source-snapshot/"
legacy_files: 4
legacy_h2_sections: 34
semantic_migration_complete: false
```

## 結論

旧 `documentation-strategy` の4ファイル・34 H2は、H2単位では **34 / 34を現行knowledgeへ分類できる**。

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

## 1. DOCUMENTATION_PHILOSOPHY.md — 9 / 9

| 旧H2 | 現在の扱い | 現行owner |
|---|---|---|
| Core Principle: Information Accuracy First | 現行。情報量削減より意味の正確性を優先 | documentation/S001 |
| Scope: What This Strategy Governs | 現行。Project Documentationの責務境界 | documentation/S001 |
| AI-Facing by Default | **旧model**。audienceだけを理由に固定top-levelを強制しない | documentation/S006_HISTORY |
| Routing Over Truncation | 現行。情報を切り捨てずroutingで必要範囲を読む | documentation/S002 |
| Git as a Recording Tool | 現行。Git historyを記録機構として利用 | documentation/S005 |
| Single Source of Truth | **旧表現を置換**。厳密な1情報=1文書はhistory。現在は主authorityと参照関係を優先 | documentation/S006_HISTORY + system traceability |
| Universality | 現行。固定templateではなくprojectへ適応 | documentation/S001 |
| Relationship to design-principles | **旧artifact packagingの関係**としてhistory。現在はsubject routingで分離 | documentation/S006_HISTORY |
| Common Misreadings | 旧model固有の誤読guardをhistoryとして保持。現行規範の解釈はS001〜S005自身で決まる | documentation/S006_HISTORY |

## 2. DOCUMENT_WORKFLOW.md — 10 / 10

| 旧H2 | 現在の扱い | 現行owner |
|---|---|---|
| Use Cases | routing heading。新規 / brownfield / ongoingへ再編 | documentation/S003 |
| New Project Setup | 現行 | documentation/S003 |
| Existing Project Adoption (Brownfield) | 現行 | documentation/S003 |
| Ongoing Document Updates | 現行 | documentation/S003 |
| Staleness Handling | **旧version registry依存model**としてhistory | documentation/S006_HISTORY |
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

したがって **34 / 34 H2 classified** だが、documentation-strategy全体をsemantic migration PASSとはまだ宣言しない。


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

## 8. Documentation側の現在判定

旧34 H2に加え、重要なH3 / operational detailを監査した結果、現時点で確認した範囲では新しいsubjectを必要とする未所有detailはない。

残る検証は**逐語的な全YAML field parity**ではなく、旧英語sourceにのみ残る例外・反論がS001〜S006のいずれにも現れないケースの探索である。旧version registry modelは意図的なhistoryであり、未移行扱いに戻さない。
