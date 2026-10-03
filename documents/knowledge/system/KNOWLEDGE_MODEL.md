# Knowledge Model

`documents/knowledge/` は、このrepositoryでファイル化された情報における第1情報源である。

このdirectoryは、情報を失わず保存すること、semantic meaningを劣化なく整理すること、knowledgeの現在評価を明示することを両立するため、役割を分離する。

```text
documents/knowledge/
├─ INDEX.md
├─ system/
├─ records/
└─ subjects/
```

## 1. INDEX.md

knowledge自体の目的、信頼モデル、各directoryの責務、基本的な読み方を説明する恒久的な入口。

特定のrecord名、特定のsubject名、現在のfile数など、内容の増減で頻繁に変わる情報には依存しない。

## 2. system/

knowledgeという仕組みそのものを定義する。

ここには以下を置く。

- recordの保存規則
- subjectの整理規則
- traceability規則
- knowledgeの更新・保守に必要な構造規則
- 第1情報源からArtifact v2へprojectionする規則

system文書はknowledge本文の代わりではない。情報をどう保存・整理・検証するかを定義する。

## 3. records/

第0情報源から得られた原文・記録・snapshotを、情報劣化を避けて保存する。

recordsの主目的は「何が実際に記録されていたか」を保持する **source completeness** である。recordはsource eventを保存し、後から変わり得るcurrent statusそのものを固定しない。

recordsでは読みやすさのための要約や意味の再構成を行わない。

## 4. subjects/

recordsを根拠に、責務範囲・概念・domain knowledgeとしてまとまった状態へ整理した日本語knowledgeを置く。

subjectsの主目的は、**semantic completenessを維持しながら、保持しているknowledgeの現在評価を明示すること**である。

ここでは整理・統合・再配置を許可するが、artifactのようなcontext圧縮を目的にしない。superseded / rejectedだからという理由だけでreusable semantic knowledgeを捨てない。

一方で、すべてのknowledgeをcurrent authorityとして平坦化しない。current / superseded / rejected / unresolved等のeffective statusを区別する。

## 5. 第1情報源内部の関係

```text
records
  source completeness / immutable source events
      ↓ 根拠
Decision Lineage
  relation / scope / effective-status resolution
      ↓
subjects
  semantic completeness + current evaluation
```

Decision Lineageのrelation / scope / conflict解決は `DECISION_LINEAGE_MODEL.md` が所有する。

通常利用ではsubjectsから読む。

subjectの記述に疑義がある場合、traceabilityを辿ってrecordsを確認する。

recordsとsubjectsの意味が明確に衝突する場合、recordsとDecision Lineageを根拠としてsubject側を修正する。

これは「records内の全発言を肯定する」という意味ではない。recordsに保存された提言・反論・否定・採用・訂正・検証と、それらのrelation / scopeを解決し、subjectsでcurrent / non-current / unresolvedを明示する。日付が新しいことだけでauthorityを決めない。

## 6. 第2情報源との境界

`artifacts/` などの第2情報源では、AI利用効率のための圧縮・要約・再構成を許可する。具体的なprojection / routing規則は `ARTIFACT_MODEL.md` が所有する。

`documents/knowledge/` では、token削減を目的として知識を削らない。

```text
第0情報源
  ↓
records
  ↓ Decision Lineage resolution
subjects
  ↓ current-effective projection
artifacts等の第2情報源
```

情報の追加・訂正は上流から行う。

## Completeness goals

```text
records   = source completeness
subjects  = semantic completeness + effective-status resolution
artifacts = runtime relevance / current-effective projection
```

これらは同じcompleteの意味ではない。recordsの原文保存をsubjectsへ逐語複製せず、subjectsの全semantic historyをartifactsへ配布しない。

## 根拠records

- `../records/2026-09-21-knowledge-source-model/`
- `../records/2026-09-21-knowledge-record-accuracy/`
- `../records/2026-09-21-records-subjects-model/`
- `../records/2026-10-03-knowledge-effective-status-lineage/`
