# Repository Structure

このrepositoryは、第1情報源・repository-local運用文書・第2情報源・legacy source logを分離する。

```yaml
first_source:
  path: "documents/knowledge/"
  role: "情報の正本"
  language: "Japanese"
  property: "原文・評価・時系列を情報劣化なく保存"
  precedence: "file化された情報の中で最優先"

repository_docs:
  path: "documents/project/"
  role: "このrepository自体の運用・移行documentation"
  authority: "knowledgeから派生"
  precedence: "knowledgeと衝突した場合はrepository_docsを修正"

artifact_projection:
  path: "artifacts/"
  role: "AI向け第2情報源"
  optimization: ["context compression", "AI readability", "token efficiency", "progressive disclosure"]
  authority: "derived from documents/knowledge/"
  migration_state: "legacy projection retained until redesign"

legacy_docs_jp:
  path: "docs-jp/"
  role: "従来の人間向け説明・設計経緯・実験/source log"
  migration_state: "原文単位でdocuments/knowledge/へ順次移行対象"
```

## Information Flow

```text
第0情報源
Chat / Issue / 調査 / 実験 / 提言
        ↓
documents/knowledge/records/
  ↓
documents/knowledge/subjects/
第1情報源
        ↓
artifacts/
第2情報源
        ↓
target project
```

通常の情報更新方向は上から下。

第2情報源から意味を逆輸入してknowledgeを書き換えない。

artifact側で問題を見つけた場合はknowledgeへ戻り、必要なら第0情報源となる訂正・判断を新しいrecordとして追加する。

## documents/knowledge/

現在の基本形:

```text
documents/knowledge/
├─ INDEX.md              # 恒久的な入口
├─ system/               # knowledge管理規則
│  ├─ INDEX.md
│  ├─ KNOWLEDGE_MODEL.md
│  ├─ RECORD_MODEL.md
│  ├─ SUBJECT_MODEL.md
│  └─ TRACEABILITY_MODEL.md
├─ records/              # 原文・source event・snapshot
│  └─ YYYY-MM-DD-<short-title>/
│     ├─ RECORD.md       # 原文recordの場合
│     └─ ...             # snapshotならMANIFEST.md + files/等
└─ subjects/             # 日本語の整理済みknowledge
   ├─ INDEX.md
   └─ <subject>/
      ├─ INDEX.md
      ├─ S001_<NAME>.md
      └─ ...
```

`records/` はsource event・snapshotの原文を保持する。現在は6 subject（encapsulation-horizon、documentation、workspace-structure、development-execution、development-safety、work-identity）で整理している。subject間の主責務は `../knowledge/subjects/INDEX.md` を参照する。

source event例:

- Chatの1メッセージ
- Issue本文
- Issue comment
- 調査報告原文
- 実験結果原文
- AI提言原文
- 採用・却下・訂正のユーザーメッセージ

`documents/knowledge/INDEX.md` は特定のrecord名やsubject数へ依存しない恒久的な入口とする。`subjects/INDEX.md` は現在のsubjectへのroutingを担当する。recordのprovenanceは各recordと必要に応じたmanifestで保持する。

## documents/project/

このrepositoryの運用方法やmigration成果物を置く。

現在:

```text
documents/project/
├─ REPOSITORY_STRUCTURE.md
├─ KNOWLEDGE_UPDATE_WORKFLOW.md
└─ migration/
   ├─ KNOWLEDGE_MIGRATION_STATUS.md
   ├─ LEGACY_ARTIFACT_COVERAGE_AUDIT.md
   ├─ LEGACY_ARTIFACT_SECTION_INVENTORY.md
   ├─ LEGACY_CODE_DESIGN_GAP_AUDIT.md
   ├─ LEGACY_DESIGN_SUBJECT_OWNERSHIP.md
   ├─ LEGACY_DESIGN_PHILOSOPHY_GAP_AUDIT.md
   ├─ LEGACY_ENGINEERING_OPERATION_GAP_AUDIT.md
   ├─ SHORT_APPROVAL_PROVENANCE_AUDIT.md
   └─ semantic-preservation-candidate/
```

`semantic-preservation-candidate/` は旧artifactの意味保存詳細監査で作られた**当時の再構成候補**。意味欠落の調査には使えるが、現在の第1情報源ではない。現在の採用・却下・訂正は `documents/knowledge/` を優先し、候補内の旧version registry等を現行規範へ戻さない。

`docs-jp/` の2026-09-21時点の16ファイルは `documents/knowledge/records/2026-09-21-docs-jp-snapshot/` に原文snapshotとして保存済み。今後の旧artifact14ファイルのcoverage監査は別途行う。

## artifacts/

AI向けのmaterialized/derived view。

将来のartifact構造はlegacy module境界に拘束されない。

将来的に可能:

- small always-on core
- concept/task-specific references
- playbook
- agent/profile別projection
- single delivery set
- generated projection

どの形でもknowledgeへのtraceabilityを失ってはならない。

## Current Legacy Distribution

現在の `artifacts.sh` は:

```text
<target>/documents/artifacts/
```

へlegacy moduleをinstall/update/removeする。

このbehaviorは既存consumer互換のため一時維持しているだけで、将来のknowledge architectureを定義しない。

## Agent Entry

このrepositoryはtarget projectへ一律の `AGENTS.md` / `CLAUDE.md` を強制しない。

このrepository自身を扱うagentは、まず:

```text
documents/knowledge/INDEX.md
```

を確認し、repository操作は:

```text
documents/project/KNOWLEDGE_UPDATE_WORKFLOW.md
```

に従う。
