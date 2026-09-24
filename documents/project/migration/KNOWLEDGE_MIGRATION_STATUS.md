# Knowledge Migration Status

```yaml
document_type: "repository_local_migration_status"
authority: "derived_from_documents/knowledge"
language: "Japanese"
checked_main_base: "7bc486da868fd1c6d2553ab225ae18b965b1a30c"
artifact_v2_content_promotion_commit: "08785223b2200cf6548b11202c0477c112202aa1"
checked_date: "2026-09-24"
```

## 現在地

`documents/knowledge/` を第1情報源として採用し、legacy artifactの意味を8 subjectへ整理済み。

Artifact v2 architecture / candidate reviewはPR #34でmainへ統合済み。review済み41-file candidateを正式 `artifacts/` へpromotionし、旧3 module / 14 runtime artifactは現行treeから削除した。

## 完了済み

### Knowledge migration

- 8 subject: encapsulation-horizon / code-design / engineering-operation / documentation / workspace-structure / development-execution / development-safety / work-identity。
- legacy artifact 14 files / 129 H2について、現行owner / intentional history / replacement decisionへの分類完了。
- design / documentation / development-environmentの主要H3・condition・exceptionまでgap auditを実施。
- source snapshot / commit / Issue / PR / short-approval provenanceを可能な範囲でrecordsへ回収。
- 取得不能な元sourceを推定で補完しない方針を維持。

### Artifact v2

- Artifact Modelをknowledge/systemへ追加。
- whole-pack delivery + selective readingを採用。
- root router 1 + directory router 7 + leaf 33 = **41 files**。
- current non-history subject body 50 / 50をprojection map上で説明。
- legacy 129 H2 classificationからのsemantic regression audit完了。
- representative routing simulation完了。
- candidate internal reference: 0 broken。
- cross-file authority audit: unresolved double-owner conflictなし。
- runtime language: concise English default / canonical knowledge Japanese。
- reviewed candidateを正式 `artifacts/` へpromotion。
- migration candidate directoryは二重派生物を避けるため削除。

## Legacy evidence

旧14 artifactは現行treeのruntime pathには残さない。

次は引き続き保持する:

- Git history上のfixed legacy commit / blob SHA。
- `LEGACY_ARTIFACT_SECTION_INVENTORY.md`
- `LEGACY_ARTIFACT_COVERAGE_AUDIT.md`
- topic別gap audit。
- source snapshot records。

これによりhistorical evidenceとcurrent runtime artifactを分離する。

## 継続課題

### Provenance

旧artifactしか残っていない一部knowledgeについて、元のチャット・提案・承認sourceを完全回収できていない箇所は引き続き未解決。

Issue #29 / #30等のprovenance課題は、Artifact v2 promotionによって解決したことにはしない。

### Artifact maintenance

Artifact v2は完成固定物ではない。

今後subjectsが更新された場合:

```text
records → subjects → projection review → artifacts → target sync
```

で更新し、semantic weakening / routing regression / duplicate authorityを監査する。

## 完了の意味

Artifact v2 promotionにより、legacy artifact layoutをruntimeとして維持するmigration課題は終了。

一方、全歴史sourceの完全回収や逐語line parityを完了条件とはしない。取得不能なprovenanceは明示したまま継続追跡する。
