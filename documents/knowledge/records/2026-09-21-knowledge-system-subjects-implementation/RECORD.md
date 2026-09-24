# Source record: 2026-09-21-knowledge-system-subjects-implementation

```yaml
record_type: "verbatim_external_source_snapshot"
source_kind: "GitHub PR body"
source_url: "https://github.com/Daiki-Yoshida/documents-artifacts/pull/24"
source_created_at: "2026-09-21T14:01:55Z"
source_updated_at: "2026-09-21T14:29:51Z"
retrieved_date: "2026-09-24"
source_text_status: "GitHub APIで取得した現存PR本文のsnapshot。作成当時から無編集かは未検証"
record_body_policy: "PR本文は無加工。直前のAI提案原文ではなく、後続の実装説明としてのみ参照する"
```

## 取得本文（原文）

~~~~text
## 概要

`documents/knowledge/` を長期運用できる構造へ再編します。

```text
documents/knowledge/
├─ INDEX.md
├─ system/
├─ records/
└─ subjects/
```

## 主な変更

- root `INDEX.md` を具体的record/subject名に依存しない恒久入口へ変更
- `system/` に Knowledge / Record / Subject / Traceability model を追加
- record保存単位を `records/YYYY-MM-DD-<short-title>/` に統一
- standalone `manifests/` を廃止し、snapshot recordの `MANIFEST.md` へ同居
- 旧 `legacy-docs-jp` / `legacy-source-logs` を1つの `docs-jp` snapshot recordへ統合
- `subjects/` を追加
- 初期subjectとして `work-identity` と `encapsulation-horizon` を作成
- 今回のknowledge構造決定に関するユーザーメッセージも原文recordとして保存

## 情報保存検証

- docs-jp snapshot payload: 16 / 16 files がmainのsourceとGit blob SHA一致
- 初期subject seed: 5 / 5 documents が対応record payloadとGit blob SHA一致
- `manifests/` / `legacy-*` record directoryは新構造から解消
- 変更範囲は `documents/knowledge/` のみ
- system/index generated Markdown fence sanity: PASS

## Subject初期状態

初期subject本文は、情報劣化を避けるため既存の整理済みsource logを同一blobでseedしています。
各subject INDEXでrecordとのtraceabilityと、本文中の旧authority表現がhistoricalであることを明示しています。

今後subject-nativeに再整理する際も、token圧縮ではなく情報完全性を優先します。

## Work Identity subject-native再編

追加で `subjects/work-identity/` を旧source-log横並び構造から責務別へ再編。

```text
work-identity/
├─ INDEX.md
├─ IDENTITY_MODEL.md
├─ WORK_ROOT_AND_REPOSITORIES.md
├─ WORK_DOCUMENTS.md
├─ LIFECYCLE_AND_RESOURCES.md
├─ WORKTREE_MATERIALIZATION.md
├─ WORKTREE_COMMANDS.md
├─ VALIDATION.md
└─ HISTORY.md
```

再編方針:

- source recordのsection本文を原則そのまま再配置
- legacy section番号のみ除去
- title / intro / source traceabilityを追加
- 旧artifact authority・反映予定・当時の未検証事項は `HISTORY.md` へ分離
- userの「作り直していこう」指示もrecord化

検証:

- source record 4文書のnumbered section: **72 / 72**
- 新subject内で **全sectionがexactly once**
- missing: 0
- duplicate: 0
- non-knowledge changes: 0


## Encapsulation Horizon subject-native再編

`subjects/encapsulation-horizon/` も原本1枚構造から責務別へ再編。

```text
encapsulation-horizon/
├─ INDEX.md
├─ CORE_PRINCIPLE.md
├─ RESPONSIBILITY_AND_HORIZON.md
├─ HARDENING_POLICY.md
├─ CONCEPT_ALTITUDE.md
├─ CONTRACT_COMPLETENESS.md
├─ EVOLUTION_AND_GRADUATION.md
├─ GLOSSARY.md
├─ OPERATIONAL_GUARDS.md
└─ HISTORY.md
```

検証:

- source H2 sections: **17 / 17**
- all sections exactly once: **PASS**
- missing: 0
- duplicate: 0
- original preamble count: 1
- generated Markdown fence sanity: PASS
- non-knowledge changes: 0

~~~~
