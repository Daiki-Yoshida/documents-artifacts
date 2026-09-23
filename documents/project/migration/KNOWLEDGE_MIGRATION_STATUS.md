# Knowledge Migration Status

```yaml
document_type: "repository_local_migration_status"
authority: "derived_from_documents/knowledge"
language: "Japanese"
checked_main_commit: "e760eb38841650d60739750953c8342b639ce6f0"
checked_date: "2026-09-24"
```

## 現在地

`documents/knowledge/` を第1情報源として採用済み。旧legacy moduleの分類を正本とは扱わず、recordsを根拠に6 subjectへ整理する段階にある。

### 確認済み

- `documents/knowledge/system/` は `KNOWLEDGE_MODEL.md`、`RECORD_MODEL.md`、`SUBJECT_MODEL.md`、`TRACEABILITY_MODEL.md` とINDEXを所有する。
- `documents/knowledge/subjects/` にはencapsulation-horizon、documentation、workspace-structure、development-execution、development-safety、work-identityの6 subjectが存在する。
- `records/` は `YYYY-MM-DD-<short-title>/` 形式。record数は増減するため、個別の数を恒久モデルとは扱わない。
- 旧 `docs-jp/` 16ファイルは `records/2026-09-21-docs-jp-snapshot/` に保存済み。snapshot元commit `d68ec413b4bb3dafe90e1aaed3c8de9487b1453c` と保存先の16/16 Git blob SHAが一致することを確認済み。うち5ファイルは旧source log。
- 旧artifact14 Markdownを対象とする英語の意味保存監査候補は `semantic-preservation-candidate/` に保存されている。ただし、候補は第1情報源でも現在の採用状態でもない。
- 既存 `artifacts/` と `artifacts.sh` はlegacy consumer互換のため変更していない。

## 未完了

1. **旧artifact14ファイルと現行6 subjectのmeaning coverage**  
   旧移行候補の14/14 mappingは確認済みだが、現行6 subjectへの意味ごとの採用・保留・history対応を完全には証明していない。根拠と未移行テーマは [coverage audit](LEGACY_ARTIFACT_COVERAGE_AUDIT.md) を参照する。
2. **旧artifactしか残っていない知識の出典と採用状態**  
   現行artifactは主に英語の第2情報源であり、元の議論・source log・採用判断がすべて揃っているとは限らない。元原文が取得できない項目を、artifact本文だけで第0情報源に昇格させない。元sourceが見つからない場合はprovenanceと評価状態の不足を明示する。
3. **議論・提案の原文traceability**  
   短いユーザー承認recordが指す直前のAI提案・監査本文までrecord化されているとは限らない。取得できるsourceの原文とprovenanceを確認し、推測で復元しない。
4. **legacy artifactの再生成**  
   第1情報源のcoverageとlegacy知識の出典・評価状態が検証できるまで、旧moduleの破壊的置換は行わない。

## 旧source logと歴史的記述の扱い

旧文書に書かれたauthority、status、当時の判断は原文の一部として残す。これらは現在も全命題を肯定するものではない。採用・却下・訂正は後続recordとsubjectで判断する。

## 原文言語と旧artifactの出典

現在の `documents/knowledge/INDEX.md` は、`records/` では原文保持を優先し、`subjects/` と `system/` では日本語を標準とする。英語等の原文をrecordsへ無加工保存すること自体は、すでにこのモデルで扱える。

旧移行状況文書には言語と原文保存の両立方式が未決定と書かれていたが、これは後続の現行knowledge modelと一致しない古い状態である。

未解決なのは、**旧artifactに書かれた派生テキストしか取得できないときに、元の議論・source log・採用判断をどう特定し、出典・採用状態の未検証をどう示すか**である。旧artifactをそのまま原文recordと偽らず、元の第0情報源を可能な限り確認する。取得不能なら未検証と記載し、後続の確認・判断を別source eventとして保存する。
