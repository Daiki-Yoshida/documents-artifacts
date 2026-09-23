# Legacy Artifact → Knowledge Coverage Audit

```yaml
document_type: "repository_local_migration_audit"
authority: "derived_evidence_not_normative"
language: "Japanese"
legacy_snapshot_commit: "e760eb38841650d60739750953c8342b639ce6f0"
audit_date: "2026-09-24"
legacy_markdown_files: 14
candidate_mapping: "14 / 14（2026-09-21時点の旧監査候補）"
current_subjects: 6
current_non_history_subject_body_files_scanned: 31
semantic_coverage_verdict: "未完了"
```

## 目的と制約

旧 `artifacts/` 14 Markdownと現在の `documents/knowledge/subjects/` 6 subjectの間で、未移行の意味を発見するための**監査台帳**。現行の正式規範・独立したsource recordではない。

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

旧14ファイルの英語再構成候補と当時のsection mappingは `semantic-preservation-candidate/TRACEABILITY.md`。その候補が示す14/14は**当時の候補内での対応数**であり、現在の6 subjectへの意味移行完了の証明ではない。

## 2. 現行6 subjectへの対応仮説

| 旧file群 | 現在の主な受け皿 | 今回確認できたこと | 残る検証 |
|---|---|---|---|
| design-principles: DESIGN_PHILOSOPHY | `encapsulation-horizon`、今後整理するコード設計knowledge | Encapsulation Horizonの原文logは2026-09-21 snapshotで保存済み | Bounded Contractsの周辺知識まで網羅できているか |
| design-principles: CODING_STANDARDS / PROJECT_STRUCTURE | 現行6 subjectにはコード実装・内部module設計を主語とする独立authorityが存在しない | 旧artifact内にDI、Domain/Application/Infrastructure責務、Result/Either、async契約、testing、shared kernel等の具体節を確認 | 各節のsource原文と採用状態、コード設計の新subjectが必要か |
| design-principles: AI_WORKFLOW | `encapsulation-horizon` のcontract変更、`development-safety` の操作安全性、未整理の横断的作業規律 | 旧artifactにはno commit/push unless requested等のoperation規則が存在 | 複数subjectへ配賦可能か、横断的責務が独立知識対象か |
| design-principles: INDEX | 主に旧packagingのrouting | 当時の14/14候補はlegacy packaging-onlyを現行意味と区別 | 旧INDEX内にrouting以上の固有規範がないか |
| documentation-strategy: 4ファイル | `documentation`（旧状態は `S006_HISTORY.md`） | 旧日本語原文3本のH2 routingは30/30として再監査済み | 英語artifact固有の条件・例外・旧規範の採否までの対応 |
| development-environment-strategy: 5ファイル | `workspace-structure`、`development-execution`、`development-safety`、`work-identity` | 旧日本語4本文の初回再編coverageは36/36として記録済み | 英語artifact固有の条件・例外・横断作業規律の対応 |

この表の「受け皿」は監査時点の**仮説**であり、新subject名や新規範の採用判断ではない。

## 3. 優先的に確認する未移行候補

### A. Code design / implementation（重要）

`artifacts/design-principles/CODING_STANDARDS.md` の現存headingを確認:

- Architectural Boundaries (Layering) — Domain / Infrastructure / Application / UI
- Dependency Injection (DI)
- Error Handling Strategy — Result / system failure / boundary translation
- Concurrency & Async Contracts
- Testing Strategy — contract verification

`PROJECT_STRUCTURE.md` にもShared Kernel、runtime topology、test placement等の節が存在する。

2026-09-24時点の現行6 subject中、historyを除く31本文fileを対象に、関連する代表語（DI / dependency injection、Domain/Application Layer、expected failure、async contract、contract/unit/integration testing、shared kernel等）を検索したところ該当なし。このテキスト検索は**未移行の可能性を強く示すが、意味欠落の完全証明ではない**。

従来の英語再構成候補 `semantic-preservation-candidate/CODE_DESIGN.md` には34のH2区分があるが、これは監査候補であって現行の第1情報源ではない。

### B. 横断的なengineering operation（要調査）

旧 `AI_WORKFLOW.md` と候補 `ENGINEERING_OPERATING_MODEL.md` には、作業前の要求確認・既存資産調査・実装・検証・報告、commit/pushの扱い等がある。現在のsubjectはcontract / runtime / safety / Workの各領域を所有するが、横断規律の単一ownerを設けるべきかは未判断。

### C. 旧documentation規範の採否（要確認）

旧version registry、固定audience分離、strict SSOT等は現行documentationのhistoryへ分類されている。ただし、これは「旧artifact固有情報も含めて採用・却下・例外が全項目照合済み」という意味ではない。過去判断と現在の適用範囲をsource recordで確認する。

## 4. 実装前のgate

1. 旧artifact14ファイルのsourceを原文単位で特定し、Git SHA / issue / chat等のprovenanceを固定する。
2. 承認が短文だけのrecordについて、承認対象となったAI提案・議論の原文が別途保存されているか確認する。取れない場合は「欠落」と明示し推定補完しない。
3. 英語等の第0情報源は原文のまま `records/` に保存し、`subjects/` で日本語に整理する。元sourceが特定できない旧artifactの派生本文を、第0情報源の原文として偽って登録しない。
4. source事実・現在の評価関係を確認してから、独立した責務なら新subject、既存責務なら既存subjectへ情報を移行する。旧module分類は新subjectの根拠にしない。
5. 完了条件はheading数ではなく、規範の強さ、条件、例外、反論、採否、検証可能性とtraceabilityの保持である。

この監査台帳を更新する際も、欠落を推定で埋めず、source recordを先に確認する。
