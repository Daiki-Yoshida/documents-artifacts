# Source record: 2026-09-21-subject-prefix-implementation

```yaml
record_type: "verbatim_external_source_snapshot"
source_kind: "GitHub PR body"
source_url: "https://github.com/Daiki-Yoshida/documents-artifacts/pull/25"
source_created_at: "2026-09-21T14:54:27Z"
source_updated_at: "2026-09-21T15:39:18Z"
retrieved_date: "2026-09-24"
source_text_status: "GitHub APIで取得した現存PR本文のsnapshot。作成当時から無編集かは未検証"
record_body_policy: "PR本文は無加工。直前のAI提案原文ではなく、後続の実装説明としてのみ参照する"
```

## 取得本文（原文）

~~~~text
## 概要

`documents/knowledge/subjects/*` の整理済み本文fileに `SNNN_` prefixを付与します。

## ルール

- `INDEX.md` は入口なので番号対象外
- 本文fileは `S001_`, `S002_`, ... の3桁zero padding
- 番号はsubject内の公式な構造・推奨読書順
- 恒久IDではなく、subject再編時はGit historyを前提にrename可能
- 10刻み等の空き番号は作らない

## 対象

- `subjects/work-identity/`: S001〜S008
- `subjects/encapsulation-horizon/`: S001〜S009

## 検証

- rename前後の本文blob SHA一致を各fileで確認
- subject本文17fileすべて `SNNN_[A-Z0-9_]+.md` に適合
- INDEX内の旧filename参照を更新
- `system/SUBJECT_MODEL.md` に命名規則を追加
- 変更範囲は `documents/knowledge/` のみ
- ユーザー指示もrecordsへ原文保存
~~~~
