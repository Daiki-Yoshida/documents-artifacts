# Subject Model

`subjects/` は、recordsを根拠として、責務範囲・概念・domain knowledgeごとに整理した日本語knowledgeを置く層である。

## 目的

recordsは情報保存には強いが、量が増えるほど横断的な理解が難しくなる。

subjectsは、原文を単に並べるのではなく、保持している情報を意味構造に沿って整理する。

```text
records
  ↓ 情報を失わない根拠
subjects
  ↓ 整理された第1情報源
artifacts
  ↓ 圧縮された第2情報源
```

## Directory

```text
subjects/
└─ <subject>/
   ├─ INDEX.md
   └─ <responsibility>.md
```

例:

```text
subjects/work-identity/
subjects/encapsulation-horizon/
```

subject directoryはtopic tagではなく、独立して理解・保守する価値のある知識対象を表す。

## File naming

subject内の整理済み本文fileには、公式な構造順・推奨読書順を表す `SNNN_` prefixを付ける。

```text
subjects/<subject>/
├─ INDEX.md
├─ S001_<NAME>.md
├─ S002_<NAME>.md
└─ ...
```

規則:

- `INDEX.md` はsubject本文のsectionではなく入口なので番号を付けない。
- `S001`, `S002`, ... はsubject内の公式な構造・推奨読書順を表す。
- 3桁zero paddingを使用する。
- 番号は恒久IDではない。subject構造を大きく再編した場合は、Git historyを利用して必要に応じてrenameしてよい。
- 将来挿入用の空き番号を確保する目的で10刻みにはしない。
- file名の意味部分は責務を表す大文字snake caseを基本とする。

例:

```text
INDEX.md
S001_CORE_PRINCIPLE.md
S002_RESPONSIBILITY_AND_HORIZON.md
S003_HARDENING_POLICY.md
```

## 分割基準

subject内部はWHY/HOW/WHERE/FLOWのような一律のfacetでは分けない。

その知識対象自身の責務・概念構造・lifecycleに沿って分ける。

例えばWork Identityであれば、必要に応じて次のような責務に分割できる。

- identity model
- Work Root
- Work Documents
- repository / branch relation
- worktree materialization
- resource ownership
- completion

実際のfile分割は情報量と責務境界に応じて決める。

## 情報保存方針

subjectsでは整理のために以下を許可する。

- 関連recordの統合
- 時系列情報の再配置
- 同一概念の近接配置
- 重複説明の整理
- 日本語表現の統一
- headingやfile構造の再設計

ただし目的はcontext圧縮ではない。

禁止・注意:

- token削減のために重要情報を落とす
- 過去の却下案や反論が理解に必要なのに削除する
- 不確定情報を確定事項へ変える
- 「Aが提案された」を「Aが正しい」へ変える
- 条件・例外・評価の強さを弱める
- sourceに存在しない結論を追加する

肥大化は許容する。短さより情報完全性と理解可能性を優先する。

## 日本語

subjects本文は日本語を標準とする。

技術用語、固有概念、code、command、API名などは意味精度のため原語を維持してよい。

## INDEX.md

各subjectの`INDEX.md` は、そのsubjectに固有の入口として使用する。

含めてよい:

- subjectが扱う範囲
- 内部documentの責務
- 読み順
- 関連subject
- source recordへのtraceability

subject本文の別コピーになるような過剰な要約は避ける。

## Overlap

1つの情報が複数subjectに関係することは許容する。

DRYより意味の完全性を優先する。

ただし同じ規範・定義を複数箇所で独立して更新する状態は避け、主責務を明確にする。

## 根拠records

- `../records/2026-09-21-records-subjects-model/`
- `../records/2026-09-21-knowledge-structure-implementation/`
