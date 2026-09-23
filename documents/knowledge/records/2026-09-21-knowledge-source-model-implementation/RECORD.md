# Source record: 2026-09-21-knowledge-source-model-implementation

```yaml
record_type: "verbatim_external_source_snapshot"
source_kind: "GitHub PR body"
source_url: "https://github.com/Daiki-Yoshida/documents-artifacts/pull/23"
source_created_at: "2026-09-21T12:23:29Z"
source_updated_at: "2026-09-21T12:41:02Z"
retrieved_date: "2026-09-24"
source_text_status: "GitHub APIで取得した現存PR本文のsnapshot。作成当時から無編集かは未検証"
record_body_policy: "PR本文は無加工。直前のAI提案原文ではなく、後続の実装説明としてのみ参照する"
```

## 取得本文（原文）

~~~~text
## 概要

`documents/knowledge/` を、file化された情報における第1情報源・正本として扱うための基盤を導入します。

## 情報源モデル

```text
第0情報源: Chat / Issue / 調査 / 実験 / ユーザー・AI提言
  ↓ 原文を情報劣化なく記録
第1情報源: documents/knowledge/
  ↓ AI利用向けに解釈・圧縮・再構成
第2情報源: artifacts/
```

knowledge内の個々の提言・仮説を全て肯定するのではなく、提言・反論・評価・却下・採用・訂正を含む記録全体が正確であることを保証するモデルです。

## このPRで実施

- user決定メッセージ3件を無要約・無抜粋のrecordとして保存
- `documents/knowledge/INDEX.md` をrouting専用として追加
- repository update workflowをknowledge-firstへ統一
- legacy `docs-jp/**/source-logs/` 5件を本文無加工でknowledgeへコピー
- 5件すべてcopy元/copy先のGit blob SHA一致を確認
- 以前の意味再構成候補を `documents/project/migration/semantic-preservation-candidate/` へ退避
- README / documents routing / repository structureを新authorityモデルへ更新
- `artifacts/` は変更なし

## 未決定

英語など非日本語の原文について、

1. knowledgeを日本語とすること
2. source本文を原文のまま完全保存すること

をどう両立するかは未決定です。

現時点では英語主体のlegacy artifact 14ファイルを第1情報源へコピーせず、既存artifactと意味保存監査成果物を保持しています。

推奨案は「knowledgeの説明・metadataは日本語、原文payloadのみ原言語を例外として完全保存」です。

## Migration status

`documents/project/migration/KNOWLEDGE_MIGRATION_STATUS.md` を参照。
~~~~
