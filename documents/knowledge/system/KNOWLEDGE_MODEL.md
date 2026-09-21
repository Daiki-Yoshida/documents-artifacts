# Knowledge Model

`documents/knowledge/` は、このrepositoryでファイル化された情報における第1情報源である。

このdirectoryは、情報を失わず保存することと、情報を理解可能な形へ整理することを両立するため、役割を分離する。

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

system文書はknowledge本文の代わりではない。情報をどう保存・整理・検証するかを定義する。

## 3. records/

第0情報源から得られた原文・記録・snapshotを、情報劣化を避けて保存する。

recordsの主目的は「何が実際に記録されていたか」を保持すること。

recordsでは読みやすさのための要約や意味の再構成を行わない。

## 4. subjects/

recordsを根拠に、責務範囲・概念・domain knowledgeとしてまとまった状態へ整理した日本語knowledgeを置く。

subjectsの主目的は「ある知識対象について、保持している情報を人間とAIが理解・利用しやすい状態にすること」。

ここでは整理・統合・再配置を許可するが、artifactのようなcontext圧縮を目的にしない。

情報の完全性を優先し、文書の肥大化は許容する。

## 5. 第1情報源内部の関係

```text
records
  実際の原文・記録
      ↓ 根拠
subjects
  意味を極力変えず整理したknowledge
```

通常利用ではsubjectsから読む。

subjectの記述に疑義がある場合、traceabilityを辿ってrecordsを確認する。

recordsとsubjectsの意味が明確に衝突する場合、recordsを根拠としてsubject側を修正する。

これは「records内の全発言を肯定する」という意味ではない。recordsに保存された提言・反論・否定・採用・時系列を含む記録関係を根拠とする。

## 6. 第2情報源との境界

`artifacts/` などの第2情報源では、AI利用効率のための圧縮・要約・再構成を許可する。

`documents/knowledge/` では、token削減を目的として知識を削らない。

```text
第0情報源
  ↓
records
  ↓
subjects
  ↓
artifacts等の第2情報源
```

情報の追加・訂正は上流から行う。
