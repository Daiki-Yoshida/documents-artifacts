# Knowledge

`documents/knowledge/` は、このrepositoryでファイル化された情報における第1情報源である。

ここでは、単に「現在採用されている結論」だけではなく、提言・仮説・反論・調査・実験・採用・却下・訂正などを、その評価関係と時系列を含めて信頼可能な状態で保持する。

knowledge内に存在する個々の命題がすべて肯定されている、という意味ではない。

## 情報源モデル

```text
第0情報源
Chat / Issue / 調査 / 実験 / ユーザー・AIの提言・判断
        ↓
documents/knowledge/
第1情報源
        ↓
artifacts等
第2情報源
```

第1情報源では、情報の完全性・正確性・検証可能性を優先する。

第2情報源では、第1情報源を根拠としてAI可読性、context圧縮、token効率、progressive disclosureなどを優先してよい。

ファイル化された情報同士に疑義や意味差がある場合、knowledgeを最優先して確認する。

## 構造

```text
documents/knowledge/
├─ INDEX.md
├─ system/
├─ records/
└─ subjects/
```

### system/

knowledgeという仕組み自体の規則を置く。

- knowledge全体の責務
- recordの保存方法
- subjectの整理方法
- traceability
- 第1情報源からartifactへprojectionする規則

詳細は `system/` を参照する。

### records/

第0情報源から得られた原文・記録・snapshotを、可能な限り情報を変えず保存する。

「実際に何が記録されていたか」を確認するための根拠層。

通常の保存単位は:

```text
records/YYYY-MM-DD-<short-title>/
```

### subjects/

recordsを根拠として、責務範囲・概念・domain knowledgeごとに整理した日本語knowledgeを置く。

subjectsでは情報を理解可能な構造へ整理するが、artifactのようなcontext圧縮は目的にしない。

情報劣化を避けるため、必要であれば文書の肥大化を許容する。

## 基本的な読み方

通常は、目的に対応するsubjectから読む。

```text
subjects
  ↓ 疑義・詳細確認
records
```

knowledgeという仕組み自体を変更・保守する場合は `system/` を読む。

subjectsに存在しない情報を調査する場合はrecordsを直接確認してよい。

## 更新原則

新しい判断・訂正・提言が発生した場合、その意味をsubjectsへ直接発明しない。

```text
第0情報源
  ↓
records
  ↓
subjects
  ↓
第2情報源
```

過去のrecordは、後から判断が変わったという理由で書き換えない。

subjectの整理に誤りが見つかった場合はrecordsへ戻って検証し、subject側を修正する。

## 言語

整理されたknowledgeである `subjects/` と、knowledge systemを定義する `system/` は日本語を標準とする。

recordsは原文保持を優先する。技術用語、固有名詞、code、command、API等は意味精度のため原語を維持してよい。
