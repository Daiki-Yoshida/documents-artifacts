# Legacy Artifact → Knowledge Coverage Audit

```yaml
document_type: "repository_local_migration_audit"
authority: "derived_evidence_not_normative"
language: "Japanese"
legacy_snapshot_commit: "e760eb38841650d60739750953c8342b639ce6f0"
audit_date: "2026-09-24"
legacy_markdown_files: 14
candidate_mapping: "14 / 14（2026-09-21時点の旧監査候補）"
current_subjects: 8
baseline_non_history_subject_body_files_scanned_before_code_design: 31
current_non_history_subject_body_files: 50
semantic_coverage_verdict: "未完了"
```

## 目的と制約

旧 `artifacts/` 14 Markdownと現在の `documents/knowledge/subjects/` 7 subjectの間で、未移行の意味を発見するための**監査台帳**。現行の正式規範・独立したsource recordではない。

旧artifactは元々第2情報源であり、現在のGitに存在するからといって第0情報源へ昇格させない。旧source log、当時の議論・Issue・実験を可能な限り原文recordとして辿り、採用・却下・訂正を確認してからsubjectへ整理する。

`records/` は原文言語を維持し、`subjects/` と `system/` は日本語を標準とする現行規則がある。したがって英語の第0情報源を無加工保存する方式自体は未決定ではない。ただし旧英語artifactは第2情報源であるため、それだけを第0情報源と誤認しない。ここではsnapshot commitとGit blob SHAで旧artifactの参照を固定し、元sourceの特定と採用状態の照合を残作業とする。

## 1. 監査対象（14 / 14）

以下のblob SHAはsnapshot commit `e760eb38841650d60739750953c8342b639ce6f0` のrecursive Git treeから取得した値。後続編集に追随する値ではない。

| 旧module | 旧file | Git blob SHA |
|---|---|---|
| design-principles | `AI_WORKFLOW.md` | `6e3e4caccedccb8a13cdc6638c7ad3819a9aef6e` |
| design-principles | `CODING_STANDARDS.md` | `5fd238fc44094a2ac1435792cfe2de5993801b2b` |
| design-principles | `DESIGN_PHILOSOPHY.md` | `bb6103f87c5259b6b339f8a9497631044eedd011` |
| design-principles | `INDEX.md` | `78b4e0586234ef67a9a880fba5168f6e1e84da3f` |
| design-principles | `PROJECT_STRUCTURE.md` | `4538ada096c5e8ad8b872ca347152715592469d6` |
| development-environment-strategy | `DEVELOPMENT_ENVIRONMENT_PHILOSOPHY.md` | `45d064572ac884ccb5afd8765387e4662e3a94f2` |
| development-environment-strategy | `ENVIRONMENT_STANDARDS.md` | `90c8e33dd080f9bd18fe9115fc70e2e74937c0df` |
| development-environment-strategy | `ENVIRONMENT_WORKFLOW.md` | `fe05113a4cdc8e1166a9ac6ada60b49310250c60` |
| development-environment-strategy | `INDEX.md` | `95c831e350559203577e95bb3925f144bb2bbcae` |
| development-environment-strategy | `WORKSPACE_STRUCTURE.md` | `b1ed4e30545321a1d19f4340386fe832d4d67479` |
| documentation-strategy | `DOCUMENTATION_PHILOSOPHY.md` | `0c00113e4cdf39f2e87027f6f4d4fd13a3b54486` |
| documentation-strategy | `DOCUMENT_WORKFLOW.md` | `e51e6570940ec21ac0bba419922bf62529f6e302` |
| documentation-strategy | `FILE_AND_STRUCTURE.md` | `ceeb4082b4584a2876a22394f53ab63c4cda181a` |
| documentation-strategy | `INDEX.md` | `cb10d7d1932e28f1d98f6311786b5cf90051ee0b` |

旧14ファイルの英語再構成候補と当時のsection mappingは `semantic-preservation-candidate/TRACEABILITY.md`。その候補が示す14/14は**当時の候補内での対応数**であり、現在のsubjectへの意味移行完了の証明ではない。

## 2. 現行subjectへの対応状況

| 旧file群 | 現在の主な受け皿 | 今回確認できたこと | 残る検証 |
|---|---|---|---|
| design-principles: DESIGN_PHILOSOPHY | `encapsulation-horizon` / `code-design` | Encapsulation Horizon原文と旧PROGRAMMING_PARADIGM referenceを保存し、48/48 H2を一次分類。source-backedな設計原理をcode-designへ初期移行 | Composition等を含む未回収detailの採否 |
| design-principles: CODING_STANDARDS / PROJECT_STRUCTURE | `code-design`（source-backed範囲） / `encapsulation-horizon`（hardening） | `code-design` を正式追加。state ownership / compatibility / verification / performance等をsource-backedに移行 | DI、layering、Result/Either詳細、async、mapping、shared kernel、test placement等の元source回収 |
| design-principles: AI_WORKFLOW | `engineering-operation`（change process）+ `encapsulation-horizon` / `code-design` / `development-safety`へのrouting | Operational Discipline / Brownfield / verification sourceを回収し、engineering-operationを正式subject化 | 固定reporting language等、current普遍規範にしないhistorical detailの扱い |
| design-principles: INDEX | 主に旧packagingのrouting | 当時の14/14候補はlegacy packaging-onlyを現行意味と区別 | 旧INDEX内にrouting以上の固有規範がないか |
| documentation-strategy: 4ファイル | `documentation` + Work Documents lifecycleは`work-identity` | 中央legacy baseline 37/37 H2を分類。Managed Artifact HandlingをS003へ復元し、Work Documentsは後続subject splitへ接続 | 全YAML fieldの逐語parityではなく、未所有exceptionの探索を継続 |
| development-environment-strategy: 5ファイル | `workspace-structure`、`development-execution`、`development-safety`、`work-identity` | 中央legacy baseline 44/44 H2を分類。Work Identity / Worktree後続sourceをPR #19〜#22へ追跡 | 4 subject間でidentity / materialization / destructive safetyを二重authority化しないことを継続監査 |

この表は現在のroutingと残るgapを示す。`code-design` は正式subject化済みだが、表中の未回収detailを採用済みとみなさない。

## 3. 優先的に確認する未移行候補

### A. Code design / implementation（重要）

`artifacts/design-principles/CODING_STANDARDS.md` の現存headingを確認:

- Architectural Boundaries (Layering) — Domain / Infrastructure / Application / UI
- Dependency Injection (DI)
- Error Handling Strategy — Result / system failure / boundary translation
- Concurrency & Async Contracts
- Testing Strategy — contract verification

`PROJECT_STRUCTURE.md` にもShared Kernel、runtime topology、test placement等の節が存在する。

`code-design` 作成前の6 subject baselineで、historyを除く31本文fileを対象に、関連する代表語（DI / dependency injection、Domain/Application Layer、expected failure、async contract、contract/unit/integration testing、shared kernel等）を検索したところ該当なし。このテキスト検索は**未移行の可能性を強く示すが、意味欠落の完全証明ではない**。

従来の英語再構成候補 `semantic-preservation-candidate/CODE_DESIGN.md` には34のH2区分があるが、これは監査候補であって現行の第1情報源ではない。現在の正式なcode-designは `documents/knowledge/subjects/code-design/` であり、回収済みrecordsを根拠にした部分だけを所有する。

### B. 横断的なengineering operation（正式subject化済み）

旧 `AI_WORKFLOW.md` のOperational Discipline、Brownfield、verification、approach questionのsourceを回収し、`engineering-operation` を正式subject化した。各domain ruleを複製せず、change lifecycle・authority/scope・pre-scan・confirmation routing・verification/done・VCS/reportingを所有する。

### C. Documentationの中央追加detail（分類済み）

旧repo final 34 H2に加え、中央PR #16/#19でManaged Artifact HandlingとWork Documents関連3 H2が増え、legacy baselineは37 H2となった。Managed Artifact Handlingはdocumentation/S003へ復元し、Work Documentsのactive lifecycleはwork-identity、Project Documentationへのdurable reconciliationはdocumentationへ分担した。version registry、固定audience分離、strict SSOT等は後続decisionによりhistoryへ留める。

## 4. 実装前のgate

1. 旧artifact14ファイルのsourceを原文単位で特定し、Git SHA / issue / chat等のprovenanceを固定する。
2. 承認が短文だけのrecordについて、承認対象となったAI提案・議論の原文が別途保存されているか確認する。取れない場合は「欠落」と明示し推定補完しない。
3. 英語等の第0情報源は原文のまま `records/` に保存し、`subjects/` で日本語に整理する。元sourceが特定できない旧artifactの派生本文を、第0情報源の原文として偽って登録しない。
4. source事実・現在の評価関係を確認してから、独立した責務なら新subject、既存責務なら既存subjectへ情報を移行する。旧module分類は新subjectの根拠にしない。
5. 完了条件はheading数ではなく、規範の強さ、条件、例外、反論、採否、検証可能性とtraceabilityの保持である。

この監査台帳を更新する際も、欠落を推定で埋めず、source recordを先に確認する。

## 5. 取得済み第0情報源と証拠の範囲（2026-09-24追加調査）

旧artifactの初期設計から現在までの**すべての**第0情報源が取得できたわけではない。次のsource eventについてはGitHubから現存するIssue・PR本文またはcommentの完全なbodyを取得し、原文のまま別々のrecordとして保存した。GitHub側で取得前に編集されていた可能性は未検証である。

### Design Principlesの個別source event

| 略号 | source record | 確認できる情報 |
|---|---|---|
| DP1 | [旧design-principles提案Issue #1](../../knowledge/records/2026-09-06-design-principles-proposals/RECORD.md) | 契約適合と要求達成、概念の同一性、両側の互換性、性能による契約粒度、状態整合性の5提案（提案時点では未採用） |
| DP2 | [中央PR #10](../../knowledge/records/2026-09-15-design-principles-contract-decision/RECORD.md) | 提案1/2/3/5の修正採用と、提案4の保留を記載するPR本文 |
| DP3 | [旧Issue #1への後続comment](../../knowledge/records/2026-09-15-design-principles-proposal-status/RECORD.md) | 中央PR #10への移行結果と保留項目の当時の報告 |
| DP4 | [中央Issue #11](../../knowledge/records/2026-09-15-performance-redesign-hold/RECORD.md) | 性能に関する提案4を保留した理由・条件 |
| DP5 | [中央Issue #15](../../knowledge/records/2026-09-15-cross-artifact-consistency-issue/RECORD.md) | 配布artifact横断の8不整合と改訂提案。Issueとしての提案・監査時点を記録 |
| DP6 | [中央PR #16](../../knowledge/records/2026-09-15-cross-artifact-consistency-pr/RECORD.md) | Issue #15の修正反映を示すPR本文 |
| DP7 | [中央PR #17](../../knowledge/records/2026-09-20-performance-contract-evolution/RECORD.md) | 保留していた性能要求による契約形状見直しを条件付きで追加したPR本文 |

DP1（提案）→DP2/DP3（提案1/2/3/5の採用・4の保留）→DP4（提案4の保留条件）→DP7（後日の採用側への更新）という**時点ごとの評価関係**を混ぜない。DP5とDP6も監査の提案と実装結果を区別する。PR本文は合意の経過を説明する証拠ではあるが、チャット中のユーザー承認メッセージそのものではない。

### Development Environmentの旧source event

| 略号 | source record | 確認できる情報 |
|---|---|---|
| ENV1 | [旧開発環境PR #1](../../knowledge/records/2026-07-18-development-environment-initial-pr/RECORD.md) | 旧repository初版のPR本文 |
| ENV2 | [旧開発環境PR #2](../../knowledge/records/2026-08-02-task-resource-ownership-pr/RECORD.md) | task-scoped resourceのownership変更を記録するPR本文 |
| ENV3 | [旧開発環境PR #3](../../knowledge/records/2026-08-03-docker-resource-reuse-pr/RECORD.md) | Docker resource再利用基準の変更を記録するPR本文 |
| JP | [旧docs-jp原文snapshot](../../knowledge/records/2026-09-21-docs-jp-snapshot/MANIFEST.md) | 2026-09-21時点の旧16ファイル（うち旧source log5ファイル）。snapshot時点のGit blobを検証済み |

ENV1〜3は後続の実装説明を含むが、旧env artifactの各行が全てそのPR由来であることまでは証明しない。JPも「snapshot時点でその文章が存在した」証拠であって、個々の命題が現時点で採用中であることの証明ではない。

## 6. 全14ファイルのsource / 現行subject対応（ファイル単位・暫定）

旧artifactの各H2見出し（**129件**、旧本文の行番号付き）は [LEGACY_ARTIFACT_SECTION_INVENTORY.md](LEGACY_ARTIFACT_SECTION_INVENTORY.md) に固定した。H2単位の機械inventoryは本文全体の意味保存判定に代わらない。

| 対象artifact | 利用可能なsource evidence | 既存subjectの主な対応先（暫定） | sourceと意味の未確認部分 |
|---|---|---|---|
| design-principles/AI_WORKFLOW.md | initial/final snapshot、Operational Discipline commit、Brownfield commit、DP1/DP2 | engineering-operation +各domain ownerへのrouting | historical wordingをcurrent普遍規範へ過剰一般化しない |
| design-principles/CODING_STANDARDS.md | DP1〜DP7（主に後続改訂） | encapsulation-horizon（境界原理・変更level） | DI、層責務、外部依存、Result/例外、非同期、モデル・変換、テストの詳細原文と現行owner |
| design-principles/DESIGN_PHILOSOPHY.md | JP内ENCAPSULATION_HORIZON_ORIGINAL_NOTES_JP.md、DP1〜DP7 | encapsulation-horizon（当該原本17 H2を再配置） | その他の設計原理の原資料、採用後の未移行部分 |
| design-principles/INDEX.md | DP2・DP6・DP7（当時のrouting変更の一部） | subjects/INDEX.mdは現行routingのみ | 旧packaging説明と固有規範の峻別・当時の全ownership mapの対応 |
| design-principles/PROJECT_STRUCTURE.md | DP5・DP6（runtime seam・contract test）、JPのEncapsulation原本は間接資料 | encapsulation-horizon（公開境界の原理のみ） | shared kernel、runtime topology、composition root、test placementの実装契約 |
| development-environment-strategy/DEVELOPMENT_ENVIRONMENT_PHILOSOPHY.md | JP内同名日本語文書、ENV1〜ENV3 | development-execution / work-identity / workspace-structure / development-safety | 英語版の追加条件・旧思想からの変更の時系列 |
| development-environment-strategy/ENVIRONMENT_STANDARDS.md | JP内同名日本語文書、ENV1〜ENV3 | development-execution / development-safety | 英語版固有の環境・Docker・CI詳細、後続条件 |
| development-environment-strategy/ENVIRONMENT_WORKFLOW.md | JP内同名日本語文書・Work Identity source logs、ENV1〜ENV3 | work-identity / development-execution / development-safety | 英語版の実行・統合・cleanup時の差分 |
| development-environment-strategy/INDEX.md | JP内同名日本語INDEX、ENV1〜ENV3 | subjects/INDEX.mdほか現行入口 | 旧routing / Worktree Selectionに固有規範がないか |
| development-environment-strategy/WORKSPACE_STRUCTURE.md | JP内同名日本語文書・Work Identity source logs | workspace-structure / work-identity | Git materialization・tool dependency等の英語版固有条件 |
| documentation-strategy/DOCUMENTATION_PHILOSOPHY.md | JP内日本語哲学文書、中央Issue #14 / PR #17（後続の旧日本語資料の扱い） | documentation / work-identity | 英語版で追加された構造・規範の個々の採用状態 |
| documentation-strategy/DOCUMENT_WORKFLOW.md | JP内日本語workflow、DP5・DP6のmanaged artifact境界 | documentation / work-identity | 英語版のstaleness / version / managed subtree等の条件の採否 |
| documentation-strategy/FILE_AND_STRUCTURE.md | JP内日本語structure、DP5・DP6の旧version/hash改訂 | documentation（旧version registryはhistory） | 旧file role・互換性・format等の英語版固有条件 |
| documentation-strategy/INDEX.md | JP内INDEX_JP.md、中央Issue #14 / PR #17の後続整理 | subjects/INDEX.md / documentation/INDEX.md | 旧routing-only記述と実質規範の分離 |

この表は**sourceにたどり着ける範囲と現在の調査方向**を示す。全14ファイルをsemantic coverage PASSと判定するものではない。特に日本語の旧source logと英語artifactの差分、元の議論本文の不在を無視して未移行知識を確定させない。

## 7. 現在の設計・実装知識で検証対象となる具体的な差分

具体的な契約・条件・例外を17 H2まで深掘りした結果は [LEGACY_CODE_DESIGN_GAP_AUDIT.md](LEGACY_CODE_DESIGN_GAP_AUDIT.md) を参照する。元sourceを確認できるConcept Altitudeと公開契約L2の2件のみ、後続採用判断に基づいて現行encapsulation-horizon本文を訂正した。その他の旧artifactにしか残っていない規範は未移行扱いを維持する。

旧 `CODING_STANDARDS.md` では、Interface Design Rules（契約作成threshold）、Contract Evolution、Performance-Shaped Contracts、Layering、External Dependency Boundary、Domain Purity、DI、Error Handling、Concurrency & Async、Data Model、Mapping & Conversion、Testing Strategyを**それぞれ独立したH2節**として保持する。これに対し、現行のencapsulation-horizonは境界硬化・概念高度・contract completenessなどの設計原理が中心である。

例えば、`encapsulation-horizon/S008_OPERATIONAL_GUARDS.md` にResultと例外の混同を避ける注意はあるが、旧CODING_STANDARDSにある具体的なboundary translationやResultの運用契約全体を意味保存した証拠にはならない。同様に、contractがconcurrency等の制約を含むという原則だけでは、旧Concurrency & Async節の細かい仕様を保持したことにはならない。

`PROJECT_STRUCTURE.md` にあるShared Kernel / multi-runtime / test placementや、`AI_WORKFLOW.md` にある作業全体のprocess / reportingも、boundary hardeningと同一の知識対象であるとは限らない。

**次の意味監査では:** 新subjectの有無を先に決めず、旧各H2の配下の条件・例外・強い規範と、先行・後続recordでの採否を照合する。確かなsourceがない部分は「元の第0情報源は未取得／第2情報源からの逆算は保留」と分けて記録する。
