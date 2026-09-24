# Code Design — 旧artifactと現行subjectの意味差分監査（第1巡）

```yaml
document_type: "repository_local_semantic_gap_audit"
authority: "derived_analysis_not_normative"
audit_date: "2026-09-24"
baseline_legacy_commit: "e760eb38841650d60739750953c8342b639ce6f0"
legacy_files_in_scope:
  - "artifacts/design-principles/CODING_STANDARDS.md"
  - "artifacts/design-principles/PROJECT_STRUCTURE.md"
current_subject_comparison: "現行7 subject。encapsulation-horizonとcode-designを主照合先とする"
review_unit: "H2の17節と重要なH3・条件・例外"
semantic_migration_complete: false
```

## この監査の位置付け

この文書は、旧第2情報源に書かれていた**具体的な条件・禁止・例外を失わずに**現行第1情報源へ移行するための差分表であり、規範本文そのものではない。旧artifact14ファイル・129 H2の機械inventoryは [LEGACY_ARTIFACT_SECTION_INVENTORY.md](LEGACY_ARTIFACT_SECTION_INVENTORY.md)。本監査はそのうち実装設計の中心となる2ファイル・17 H2を深掘りする。

元artifactの内容が確認できても、元の第0情報源や当時の採否が不明な項目を「現在採用済み」とは認定しない。GitHub PR本文は実装内容を説明する資料であり、ユーザーの当時のチャット原文そのものとは限らない。

### 根拠の種類

| 記号 | 根拠 | 何を証明するか |
|---|---|---|
| L | baselineの旧artifact Git blob `CODING_STANDARDS.md=5fd238fc44094a2ac1435792cfe2de5993801b2b`、`PROJECT_STRUCTURE.md=4538ada096c5e8ad8b872ca347152715592469d6` | 旧第2情報源が当該baselineでその文章を持っていたこと |
| EH | [Encapsulation Horizon旧日本語source snapshot](../../knowledge/records/2026-09-21-docs-jp-snapshot/MANIFEST.md) | Encapsulation Horizonに関連する旧原文・当時の議論の保存状態 |
| DP1 | [旧design-principles Issue #1](../../knowledge/records/2026-09-06-design-principles-proposals/RECORD.md) | 5件の改善提案。提案時点で全部採用済みという意味ではない |
| DP2 | [中央PR #10](../../knowledge/records/2026-09-15-design-principles-contract-decision/RECORD.md) と[後続結果comment](../../knowledge/records/2026-09-15-design-principles-proposal-status/RECORD.md) | 提案1/2/3/5を修正採用、提案4を保留した当時の改訂内容 |
| DP3 | [中央Issue #11](../../knowledge/records/2026-09-15-performance-redesign-hold/RECORD.md) | 性能契約粒度の提案を保留した当時の条件 |
| DP4 | [中央Issue #15](../../knowledge/records/2026-09-15-cross-artifact-consistency-issue/RECORD.md) と[PR #16](../../knowledge/records/2026-09-15-cross-artifact-consistency-pr/RECORD.md) | 境界/contract/技術エラー等の旧artifact横断修正の提案と後続実装 |
| DP5 | [中央PR #17](../../knowledge/records/2026-09-20-performance-contract-evolution/RECORD.md) | 以前保留した性能によるcontract形状再設計について、後日条件付きで実装されたこと |

DP1→DP2→DP3→DP5を一つの時点の「同時採用」として扱わない。DP4のIssue/PRも、修正の提案と実装を区別する。現行 `knowledge/system/TRACEABILITY_MODEL.md` に従い、現在の規範に反映できるのは原文と**その後続評価**を追跡できる部分だけとする。

## 1. CODING_STANDARDS.md：12 H2の意味差分

開始行はlegacy baselineの実file行番号。現在のEHの記述は部分一致と完全移行を区別する。

| 行 | 旧節 | 旧artifactで確認した具体的な判断軸 | 現行EHにあるもの／不足するもの | 第0情報源・評価状態 |
|---:|---|---|---|---|
| 20 | Interface Design Rules | boundary componentのinterface必要条件と不要条件、局所interfaceの許容、言語別命名、Entity/VOの例外、load-bearing Semantics・ISP | S003に硬化の条件、S004に概念高度、S005に契約完全性はある。**具体的なinterface作成threshold・命名・ISPは未移行の可能性** | Concept GeneralityはDP1/DP2で修正採用。他の詳細はL中心で元の意思決定sourceを要確認 |
| 113 | Contract Evolution & Versioning | additiveとcompatibilityを分離、consumerとproviderの両側、媒体別互換性、deprecation、局所変更と公開変更のblast radius | S006のouter契約保持、S008のconfirmation levelが部分対応。S008のL2を後続DP2に従い**compatible public evolution**へ修正。versioning手順全体は未移行の可能性 | DP1の提案3→DP2で修正採用。DP4にもcross-runtime seamの追認修正 |
| 142 | Performance-Shaped Contracts | 依頼側から見えるload-bearing条件、計測か構造的下限、内部最適化先行、interaction shapeを制約時のみ再設計、媒体別互換性、結果測定 | S005のresource leakageは原理的に関連するが、**性能に基づく再設計gate全体は未移行** | DP1提案4→DP2/DP3保留→DP5で条件付き実装。採用時期を混ぜない |
| 179 | Architectural Boundaries (Layering) | feature-first / layer-inside、Domain/Application/Infrastructure/UI依存方向、contract owner、UseCaseの調停と非所有、状態ownerと越境outcomeの失敗責任、DTO配置 | S002は責務意味、S003は硬化面を扱う。**具体的layer依存方向・DTO/port配置の独立規範は未移行** | state ownershipはDP1提案5→DP2で修正採用。他のlayer具体契約の元sourceは要確認 |
| 281 | External Dependency Boundary Policy | project-owned domain語彙、vendor typeの内向漏洩禁止、wrap/adapt発火条件、UI/Infrastructure内の直接依存例外 | S005が漏洩channelの一般原理を扱うが、**SDK等の例外込み判断基準は未移行** | L中心。元source／現行採否の確認が必要 |
| 315 | Domain Purity Rules | 技術機構とdomain概念の出自を分離、Date/Color等がdomain概念となる例外、Clock/Logger等の扱い | S008のmisreadingに「Domain purity ≠ Date/Color/Text禁止」がある。**具体例と依存禁止条件は未移行** | EHに関連原文あり。ただし現行の詳細運用に関する独立source要確認 |
| 338 | Dependency Injection (DI) | behavioral componentのconstructor DI、Service Locator禁止、volatile dependencyのnew禁止、stable Entity/VOはnew可能、Entity/VOはconstructor DIしない・必要サービスはmethod引数 | S001の内部自由・S005の境界完全性は原理的関連のみ。**具体的DI運用契約は現行6 subject内で独立authority未確認** | L中心。特に「全dependencies MUST constructor」の適用境界とEntity例外の採否を元sourceで確認 |
| 368 | Error Handling Strategy | expected business failureは既存Result/Either/Outcome優先、boolean/null/通常例外を失敗制御に使わない、standard typeがなければbootstrap可能、障害は例外可、技術例外はboundaryで意味へ翻訳・原因は診断用保持 | S008の「Resultは全例外禁止ではない」だけが部分対応。**既存type優先・bootstrap例外・boundary translationの詳細は未移行** | DP4でDbExceptionを外に漏らす例の不整合と修正が確認できる。全体の元sourceは要確認 |
| 419 | Concurrency & Async Contracts | asyncをsignatureに明示、thread-safety分類、長時間IOのcancel、Domainにscheduler漏洩禁止、共有可変状態保護、所有外境界でasync blocking禁止 | S005にdeterminism / resource / failureのleakage channelはある。**具体的async契約は未移行** | L中心。元source・評価を要確認 |
| 435 | Data Model & Internal Implementation | domain complexity別のRich/Lightweight選択、domain規則の所有は一貫、内部paradigm自由、rich mutableとtype-driven state transition | S001/S005が内部自由の原則を保持するが、**model選択とstate lifecycleの具体条件は未移行** | L中心。元source・評価を要確認 |
| 493 | Mapping & Conversion Policy | Domainから外部DTOへ依存禁止、Application/Infrastructure/UIのmapping owner、one-off inline許容・再利用mapping抽出、Mapper/Converter/Adapter等の役割 | S005が境界漏洩の原理を扱うのみ。**型変換の方向とownerの詳細は未移行** | L中心。元source・評価を要確認 |
| 519 | Testing Strategy | unit/integration/contractの役割、AAA、side-effect隔離、安定境界優先、Contract Conformanceとユーザー要求達成の別検証、全実装/フェイク共通suite | S002の「独立テスト可」は分割の判断材料にすぎず、**テスト戦略の本文は移行されていない** | DP1提案1→DP2修正採用。DP4がContract Testをcorrectness全体と混同しないよう追加修正 |

## 2. PROJECT_STRUCTURE.md：5 H2の意味差分

| 行 | 旧節 | 旧artifactで確認した具体的な条件・例外 | 現行主体の状態 | 第0情報源・評価状態 |
|---:|---|---|---|---|
| 29 | Module Public Surface | default-internal・cross-module deep import禁止、named audienceがある複数public surface例外、runtime別可視性手段とcross-module依存規則 | encapsulation-horizonが硬化する責務と外面を扱うが、**物理的に公開面を守る手法とaudience別例外は未移行** | EH旧原文で原理確認可。詳細はL中心 |
| 81 | Shared Kernel & Cross-Cutting Placement | T0純粋kernel / T1横断port / T2共有contract / T3共有domain VO、dependent direction、既存util優先と共有昇格条件、Entity共有抑制 | S004のneutral-localと物理昇格の区別は部分対応。**T0〜T3の運用契約は未移行** | L中心。特にRule of Two/Threeを単なるfile数閾値と誤読しないよう、元sourceで確認 |
| 104 | Runtime Topology & Multi-Deployable Layout | single runtimeでmodule内UI、multi deployableでfrontendを別bounded context、wire seamの双方互換性、runtime-firstとfeature-firstの選択条件、composition root | workspace-structureはrepositoryの静的配置、development-executionは実行環境を所有。**アプリのcode topologyとruntime seamのsemantic contractは既存責務で明示未移行** | wire compatibilityはDP4に明示。他はL中心 |
| 162 | Test File Placement | co-location、contract suiteはport所有者のそば、real/fake同一suite、再利用fakeはtest-support公開面、cross-runtime E2Eの位置 | documentationは文書構造、workspace-structureはGit/repository配置であり**code test placementのownerは未確定** | L中心。DP4のcontract conformance整理は後続関連source |
| 193 | How These Interlock | 公開面・shared kernel・runtime seam・test suiteが同一contract方針で接続 | EHには公開面の原理のみ部分対応。各詳細が保留のため**一括で完了判定できない** | Lおよび上記の関連後続source |

## 3. ほかのdesign-principles旧本文との接続

- `DESIGN_PHILOSOPHY.md`：EHの原理・地平線・Concept Altitudeは旧日本語原文から再編済み。一方、Composition Over Inheritance、Reliability & Safety、External Dependency Containment、Domain Purity、Design/Mistake Priority、Performance vs. Abstractionは個別に意味照合が必要。特に後続DP2・DP5の採用内容と旧日本語原文のままの記述を同一視しない。
- `AI_WORKFLOW.md`：境界設計の原理だけでなく、Step 1の要求結果・pre-scan / Step 3の要求達成をcontract conformanceと分ける検証 / Operational Disciplineのreporting・commit/push・確認 / Brownfield方針がある。現行development-executionは**実行環境とcommand**、development-safetyは**操作の安全性**が主責務であり、AI作業過程をすべて自動的に引き受けるわけではない。横断workflowのownerは別途判断する。
- `DESIGN_PHILOSOPHY.md` のPerformance policyと `CODING_STANDARDS.md` のPerformance-Shaped Contractsは、当初の提案保留（DP2/DP3）から後続の条件付き改訂（DP5）までの履歴をセットで読む。
- 旧INDEXのOwnership Mapは旧packagingの説明であり、現行6 subjectの単純な置換表として使用しない。

## 4. 今回のsourceで修正できる現行規範

**明示の修正を実施した項目は次の2つだけ。** いずれも旧日本語原本をrecordsに残したまま、後続の修正採用を別recordで示せる。

1. [encapsulation-horizon/S004_CONCEPT_ALTITUDE.md](../../knowledge/subjects/encapsulation-horizon/S004_CONCEPT_ALTITUDE.md)：責務を一文で表せることを**中立性のsignal**へ限定し、共有contractの前に不変条件・事前事後条件・失敗の意味・lifecycle・変更理由でsemantic identityを確認する。DP1→DP2の採用による更新。
2. [encapsulation-horizon/S008_OPERATIONAL_GUARDS.md](../../knowledge/subjects/encapsulation-horizon/S008_OPERATIONAL_GUARDS.md)：`CONTRACT_L2_public_additive` を `CONTRACT_L2_compatible_public_evolution` へ更新。caller / consumerとprovider / implementer、必要な媒体別互換性と従来保証を確認する。追加でも必須memberで既存implementerを壊すならL2に分類しない。DP1→DP2の採用による更新。

これ以外のL由来の詳細規範は、旧artifact本文が存在するだけでは新しいnormative subjectへ転載しない。

## 5. Subject ownershipの現在地

責務境界の詳細判断は [LEGACY_DESIGN_SUBJECT_OWNERSHIP.md](LEGACY_DESIGN_SUBJECT_OWNERSHIP.md) に分離した。source recovery後、code structure / implementation側は [code-design](../../knowledge/subjects/code-design/INDEX.md) として正式subject化した。engineering change processは引き続き `engineering-operation` 候補として保留する。Encapsulation Horizonへlegacy設計規範を一括吸収しない方針は維持する。

| 候補となる知識対象 | 取り扱う問い | 現行subjectとの差 |
|---|---|---|
| code-design（正式subject） | 境界が決まった後、source-backedなstate / compatibility / verification / performance等をどう実現するか。DI / layering / mapping等はsource回収まで未昇格 | encapsulation-horizonの「どのscaleで境界を硬化するか」とは別の判断軸 |
| code-design内の今後の拡張候補 | error / async / thread-safety / detailed test strategy等。現時点ではsource-backed部分だけcanonical | 境界完全性という抽象原理だけで具体運用を代替できない |
| AI実装作業の規律 | 事前scan→contract→実装→検証→報告、brownfield、commit/push権限の取り扱い | execution環境・破壊操作risk・Work Identityとは主語が異なる可能性 |

旧module名の `design-principles` はsubject名として復活させない。`code-design` は回収したreference原本と後続の採用recordを根拠に初期核だけ正式化し、source未回収detailはこの監査へ残す。

## 6. 旧design-principles INDEX 5 H2の扱い

旧 `artifacts/design-principles/INDEX.md` の5 H2も確認した。

| 旧INDEX節 | 扱い |
|---|---|
| Read Order | WHY / HOW / WHERE / FLOWの旧packaging routing。現在のsubject reading orderへ直接持ち込まない |
| Document Split Policy | one semantic owner / link-not-duplicateは現行SUBJECT_MODELのownership思想と整合するが、WHY/HOW/WHERE/FLOWというfile分割方式自体は現行subject modelが採用していない |
| Foundational Lens | Bounded Contracts / recursive boundaries / shell-vs-coreの短い再述。独立規範ではなく、現在はencapsulation-horizonへroute |
| Ownership Map | 当時の4 artifact文書へのconcept owner一覧。未移行topicのinventoryとして有用だが、現行subject authorityではない |
| Quick Task Routing | 上記ownerへのrouting table。独立規範は持たず、現行subjectへの単純置換もしない |

PROJECT_STRUCTURE追加commitは当時の `WHY / HOW / WHERE / FLOW` 分割を明示するため、旧INDEXの構造意図のsourceとして利用できる。一方、現在は `SUBJECT_MODEL.md` が「subject内部をWHY/HOW/WHERE/FLOWのような一律facetで分けない」と明示しており、**旧document split policyは現行のsubject構造を拘束しない**。

これにより旧design-principles 5ファイルのH2は、CODING_STANDARDS 12 + PROJECT_STRUCTURE 5 + AI_WORKFLOW 8 + DESIGN_PHILOSOPHY 18 + INDEX 5 = **48 / 48 H2を一次分類済み**となる。ただし、H2分類完了は各H3/本文のsource-backed semantic migration完了を意味しない。

## 7. 残る検証gate

- 旧CODING_STANDARDSのH3以下については表に代表的条件・例外を記載したが、逐語一致や完全なsemantic coverageのPASSではない。項目別source原文を確認して初めて採用できる。
- source eventを取得できていないL-only項目は**未検証**のまま保持し、後から過去recordを推測修復しない。必要な場合は新しい独立した第0情報源として評価・採用判断を記録する。
- 旧 `DESIGN_PHILOSOPHY.md` の18 H2と `AI_WORKFLOW.md` の8 H2は全件inventory済みだが、本文の意味照合は未完了。
- `artifacts/` の再生成は、対応する現行第1情報源のcoverageが担保されるまで行わない。
