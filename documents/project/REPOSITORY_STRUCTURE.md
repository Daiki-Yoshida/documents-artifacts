# Repository Structure

このrepositoryは、第1情報源・repository-local運用文書・第2情報源・legacy source logを分離する。

```yaml
first_source:
  path: "documents/knowledge/"
  role: "情報の正本"
  language: "subjects/systemはJapanese標準; recordsは原文言語を維持"
  property: "原文・評価・時系列を情報劣化なく保存"
  precedence: "file化された情報の中で最優先"

repository_docs:
  path: "documents/project/"
  role: "このrepository自体の運用・移行documentation"
  authority: "knowledgeから派生"
  precedence: "knowledgeと衝突した場合はrepository_docsを修正"

artifact_projection:
  path: "artifacts/"
  role: "Artifact v2 / AI向け第2情報源"
  optimization: ["task routing", "small relevant context", "token efficiency", "progressive disclosure"]
  authority: "derived from documents/knowledge/"
  language: "concise English by default"
  distribution: "whole-pack delivery + selective reading"

legacy_docs_jp:
  path: "docs-jp/"
  role: "従来の人間向け説明・設計経緯・実験/source log"
  migration_state: "2026-09-21時点の16ファイルは原文snapshot済み。legacy参照領域として残す"
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
Artifact v2 / 第2情報源
        ↓
target project / documents/artifacts/
```

通常の情報更新方向は上から下。

第2情報源から意味を逆輸入してknowledgeを書き換えない。artifact側で問題を見つけた場合はknowledgeへ戻り、必要なら第0情報源となる訂正・判断を新しいrecordとして追加する。

## documents/knowledge/

基本形:

```text
documents/knowledge/
├─ INDEX.md
├─ system/
│  ├─ INDEX.md
│  ├─ KNOWLEDGE_MODEL.md
│  ├─ RECORD_MODEL.md
│  ├─ SUBJECT_MODEL.md
│  ├─ TRACEABILITY_MODEL.md
│  └─ ARTIFACT_MODEL.md
├─ records/
│  └─ YYYY-MM-DD-<short-title>/
│     ├─ RECORD.md
│     └─ ...
└─ subjects/
   ├─ INDEX.md
   └─ <subject>/
      ├─ INDEX.md
      ├─ S001_<NAME>.md
      └─ ...
```

`records/` はsource event・snapshotの原文を保持する。現在は8 subject（encapsulation-horizon、code-design、engineering-operation、documentation、workspace-structure、development-execution、development-safety、work-identity）で整理している。

## documents/project/

このrepository自身の運用、migration、projection設計・監査を置く。

Artifact v2の主要文書:

```text
documents/project/ARTIFACT_ARCHITECTURE_V2.md
documents/project/migration/ARTIFACT_PROJECTION_MAP_V2.md
documents/project/migration/ARTIFACT_V2_CANDIDATE_AUDIT.md
documents/project/migration/ARTIFACT_V2_LEGACY_REGRESSION_AUDIT.md
documents/project/migration/ARTIFACT_V2_ROUTING_SIMULATION.md
documents/project/migration/ARTIFACT_V2_CROSS_FILE_AUTHORITY_AUDIT.md
```

reviewed candidateは正式 `artifacts/` へpromotion済みであり、candidate directoryを重複保持しない。過程はGit historyと上記auditで追跡する。

## artifacts/

Artifact v2のAI-facing runtime guidance。

```text
artifacts/
├─ INDEX.md
├─ design/
├─ implementation/
├─ operation/
├─ documentation/
├─ project/
├─ execution/
└─ safety/
```

## tests/

deterministic testとexecution-agent behavior testを同じtest rootで管理する。

```text
tests/
├─ INDEX.md
├─ test-*.sh
├─ scripts/
├─ repositories/   # Gitなしのfixture templates
├─ scenarios/      # PROMPT + evaluator-only EXPECTATIONS
└─ .runs/          # generated / Git ignored
```

`tests/repositories/` は実行時にcopyされ、そのcopy側だけを `git init` する。fixture原本へnested `.git/` を保持しない。

詳細は `AGENT_ARTIFACT_TEST_HARNESS.md` を参照する。

root `INDEX.md` と各directory `INDEX.md` はrouter。leafはtask consumption単位で分割する。

subject directoryとの1:1対応は要求しない。semantic ownershipはsubjectsが保持し、artifactはcontext co-occurrenceに合わせて非正規化する。

## Distribution

`artifacts.sh` はArtifact v2全体を:

```text
<target>/documents/artifacts/
```

へstaging後にwhole-pack exact replacementする。置換失敗時は旧packへのrollbackを試みる。

- 部分module選択は行わない。
- updateはmanaged rootを完全置換する。
- removalは `--remove` で明示する。
- symlinked destination/source packを拒否する。
- project側のlocal overrideはinstalled artifact copyへ直接patchしない。

## Legacy evidence

旧14 artifactは現行 `artifacts/` には残さない。

旧baseline内容はGit history・fixed blob SHA・migration inventory/auditで追跡し、現在のAI runtime guidanceへ旧packagingを戻さない。

## Agent Entry

このrepository自身を扱うagentは、まず:

```text
documents/knowledge/INDEX.md
```

を確認し、repository操作は:

```text
documents/project/KNOWLEDGE_UPDATE_WORKFLOW.md
```

に従う。
