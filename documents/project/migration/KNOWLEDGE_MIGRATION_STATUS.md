# Knowledge Migration Status

```yaml
document_type: "repository_local_migration_status"
authority: "derived_from_documents/knowledge"
language: "Japanese"
checked_main_commit: "fc2af723d0c49236cca208697a96c84ff7b9f13f"
checked_date: "2026-09-24"
```

## 現在地

`documents/knowledge/` を第1情報源として採用済み。旧legacy moduleの分類を正本とは扱わず、recordsを根拠に8 subjectへ整理している。code-designとengineering-operationは2026-09-24のsource recovery後に追加した。

### 確認済み

- `documents/knowledge/system/` は `KNOWLEDGE_MODEL.md`、`RECORD_MODEL.md`、`SUBJECT_MODEL.md`、`TRACEABILITY_MODEL.md` とINDEXを所有する。
- `documents/knowledge/subjects/` にはencapsulation-horizon、code-design、engineering-operation、documentation、workspace-structure、development-execution、development-safety、work-identityの8 subjectが存在する。
- `records/` は `YYYY-MM-DD-<short-title>/` 形式。record数は増減するため、個別の数を恒久モデルとは扱わない。
- 旧 `docs-jp/` 16ファイルは `records/2026-09-21-docs-jp-snapshot/` に保存済み。snapshot元commit `d68ec413b4bb3dafe90e1aaed3c8de9487b1453c` と保存先の16/16 Git blob SHAが一致することを確認済み。うち5ファイルは旧source log。
- 旧artifact14 Markdownを対象とする英語の意味保存監査候補は `semantic-preservation-candidate/` に保存されている。ただし、候補は第1情報源でも現在の採用状態でもない。
- 既存 `artifacts/` と `artifacts.sh` はlegacy consumer互換のため変更していない。

## 現在の完了状態と残課題

1. **旧artifact14ファイルと現行8 subjectのmeaning / ownership coverage — 分類完了**

   design-principles側は次まで進んでいる。

   - 旧5ファイル・48 / 48 H2を一次分類。
   - CODING_STANDARDS 12 H2 + PROJECT_STRUCTURE 5 H2をcode-design gap auditで詳細化。
   - DESIGN_PHILOSOPHY 18 H2をEncapsulation Horizon移行済み / 部分移行 / owner未確定へ分類。
   - AI_WORKFLOW 8 H2はOperational Discipline / Brownfield / initial workflowのsource recovery後、engineering-operationとして正式subject化。
   - INDEX 5 H2は旧packaging / routingとして分類。
   - 2026-01-31の4段階source snapshot、2026-06-13 reference snapshot、2026-07-02 final substantive snapshotを回収し、保存した18 fileのGit blob SHAが旧repository指定commitと18 / 18一致。
   - versioned source stateと後続Issue / PR decisionから、layering / dependency / DI / Domain model / mapping / failure / async / testing / runtime topology / compatibility / performance等を新しい `code-design` subjectへ再構成。
   - Concept Altitudeのsemantic identityとContract L2 compatibilityは、2026-09-15の後続採用判断に合わせてencapsulation-horizon側も訂正。
   - 旧design-principlesのcommit message / patch sourceも段階的にrecord化し、導入・refinement時点を旧artifact最終状態と区別して追跡。

   documentation-strategy側は中央legacy baseline 4ファイル・37 / 37 H2（旧個別repo final 34 H2 + 中央追加3 H2）を [documentation gap audit](LEGACY_DOCUMENTATION_GAP_AUDIT.md) で active / history / replaced routing に分類し、主要H3/detailまで追加監査した。entry fileの最終v2.2定義（rules + routing）をsource patchから確認し、現行S002/S003を訂正した。旧repository final substantive commit `c53be461410e315f55c5aeee2cd972d3b471acdf` の4 artifactを全文snapshot化し、旧Git blobと4 / 4一致を確認した。document version registry、mandatory docs-jp split、strict one-information-one-document等は後続decisionによりhistoryへ分離済みであり、未移行gapとして復活させない。

   development-environment-strategy側は中央legacy baseline 5ファイル・44 / 44 H2（旧個別repo final 42 H2からWork Identity再構成でnet +2）を [development-environment gap audit](LEGACY_DEVELOPMENT_ENVIRONMENT_GAP_AUDIT.md) で workspace-structure / development-execution / development-safety / work-identity / history へ分類し、主要H3/detailまで追加監査した。task-scoped resourceの終了責任をsource patchから回収し、Work Identity S004へreconciliation完了条件を補強した。旧repository final substantive commit `821497fad747042de48a3d7b523c4f295496dfb3` の5 artifactを全文snapshot化し、旧Git blobと5 / 5一致を確認した。旧Task Worktree中心のcheckout modelはWork Identity導入後のstatic/dynamic責務分離へ置換されている。

   これによりlegacy artifact 14ファイルの全H2は、design-principles 48 + documentation-strategy 37 + development-environment-strategy 44 = 129 H2について、現行owner / intentional history / replacement decisionへの分類を完了した。主要H3 / YAML rule / exceptionまで監査範囲を広げた。完了の意味はsemantic ownershipを説明できることであり、全行の逐語一致や全source event回収を主張するものではない。現状は [coverage audit](LEGACY_ARTIFACT_COVERAGE_AUDIT.md)、[129 H2 inventory](LEGACY_ARTIFACT_SECTION_INVENTORY.md)、[code-design gap audit](LEGACY_CODE_DESIGN_GAP_AUDIT.md)、[documentation gap audit](LEGACY_DOCUMENTATION_GAP_AUDIT.md)、[development-environment gap audit](LEGACY_DEVELOPMENT_ENVIRONMENT_GAP_AUDIT.md) を参照する。

2. **旧artifactしか残っていない知識の出典と採用状態 — 継続課題**  
   現行artifactは主に英語の第2情報源であり、元の議論・source log・採用判断がすべて揃っているとは限らない。元原文が取得できない項目を、artifact本文だけで第0情報源に昇格させない。元sourceが見つからない場合はprovenanceと評価状態の不足を明示する。
3. **議論・提案の原文traceability — 継続課題**  
   短いユーザー承認recordと後続PRの実装説明を [短文承認provenance監査](SHORT_APPROVAL_PROVENANCE_AUDIT.md) で関連付け、取得可能なPR本文を原文record化した。ただしPR本文は直前AI提案原文を代替しない。確認できないAI提案は未取得と明記して残す。
4. **legacy artifactの再生成 — 次工程**  
   第1情報源のcoverageとlegacy知識の出典・評価状態が検証できるまで、旧moduleの破壊的置換は行わない。

## 追加取得したsourceの取り扱い

2026-09-24にGitHub Issue・comment・PR本文の現存bodyを、provenance metadataとともに個別のrecordへ取得した。GitHub本文は取得以前に編集されていた可能性があるため、作成時点との逐語一致は未検証。旧artifactの派生テキスト、提案時の内容、後続の実装説明、ユーザーのチャット承認は異なるsourceとして扱う。

## 旧source logと歴史的記述の扱い

旧文書に書かれたauthority、status、当時の判断は原文の一部として残す。これらは現在も全命題を肯定するものではない。採用・却下・訂正は後続recordとsubjectで判断する。

## 原文言語と旧artifactの出典

現在の `documents/knowledge/INDEX.md` は、`records/` では原文保持を優先し、`subjects/` と `system/` では日本語を標準とする。英語等の原文をrecordsへ無加工保存すること自体は、すでにこのモデルで扱える。

旧移行状況文書には言語と原文保存の両立方式が未決定と書かれていたが、これは後続の現行knowledge modelと一致しない古い状態である。

未解決なのは、**旧artifactに書かれた派生テキストしか取得できないときに、元の議論・source log・採用判断をどう特定し、出典・採用状態の未検証をどう示すか**である。旧artifactをそのまま原文recordと偽らず、元の第0情報源を可能な限り確認する。取得不能なら未検証と記載し、後続の確認・判断を別source eventとして保存する。
