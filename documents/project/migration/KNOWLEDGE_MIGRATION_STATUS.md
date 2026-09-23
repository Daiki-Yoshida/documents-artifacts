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
2. **非日本語の原文保存方式**  
   現行artifactは主に英語。原文無加工の保存と、日本語標準のknowledgeの両立について既存の明示判断はまだない。英語artifactのcopyを第0情報源とみなしたり、原文を要約・翻訳して上書きしたりしない。
3. **議論・提案の原文traceability**  
   短いユーザー承認recordが指す直前のAI提案・監査本文までrecord化されているとは限らない。取得できるsourceの原文とprovenanceを確認し、推測で復元しない。
4. **legacy artifactの再生成**  
   第1情報源のcoverageと原文保存方式が解決するまで、新artifact構造の設計・旧moduleの破壊的置換は行わない。

## 旧source logと歴史的記述の扱い

旧文書に書かれたauthority、status、当時の判断は原文の一部として残す。これらは現在も全命題を肯定するものではない。採用・却下・訂正は後続recordとsubjectで判断する。

## 非日本語sourceの取り込みに関する未決事項

既存の運用文書に記録されていた候補例は次のとおり。ここでは採否を決めない。

- 原文をknowledge内に完全保存し、日本語onlyを「整理本文の標準」と解釈する。
- 原文bytesを別raw storeへ置き、knowledgeには完全日本語訳とraw参照を置く。
- 原文と完全日本語訳を同一recordに併記する。

いずれの場合も要約・抜粋・意訳によって原文の意味を削らない。
