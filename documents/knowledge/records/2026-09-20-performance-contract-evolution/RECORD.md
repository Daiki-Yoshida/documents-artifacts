# Source record: 2026-09-20-performance-contract-evolution

```yaml
record_type: "verbatim_external_source_snapshot"
source_kind: "GitHub PR body"
source_url: "https://github.com/Daiki-Yoshida/documents-artifacts/pull/17"
source_created_at: "2026-09-20T18:09:23Z"
source_updated_at: "2026-09-20T18:09:38Z"
retrieved_date: "2026-09-24"
source_text_status: "GitHub APIで取得した現存本文のsnapshot。作成当時から無編集かは未検証"
record_body_policy: "本文はsourceのAPI bodyから無加工で取り込んだ。PR/Issueは会話の原文そのものとは限らない"
```

## 取得本文（原文）

~~~~text
## 概要

残っていた3件のIssueをまとめて解消します。

### #11 design-principles: 性能要求と契約粒度
- 性能要件を load-bearing contract input として扱う条件を明文化
- 推測ではなく representative measurement または structural bound を根拠に要求
- 既存契約内の最適化を先に行い、interaction shape 自体が制約の場合のみ batch / streaming / pagination / async / cancellation / backpressure を契約候補にする
- module-local / published API / wire protocol / persistent-data-facing contract ごとの互換性扱いを整理
- AI workflow と INDEX routing に性能要件チェックを追加

### #13 repo docs
- `artifacts/` が唯一の正本である権威モデルを README / repository docs に明記
- `docs-jp/` を non-canonical companion / source-rationale log と明記
- development-environment-strategy 日本語文書5件の canonical source relative path を修正し、横断確認

### #14 docs-jp/documentation-strategy
- 方針Bを採用: 現行規範は英語正本へ一本化
- `INDEX_JP.md` を 2.4.0 の薄い現行日本語案内へ更新
- 2.1系の詳細日本語文書3件は non-canonical source log / historical translation として明示
- 古い Rule of Three 等が現行ルールとしてルーティングされないよう整理

## 検証
- branch は main から ahead / behind 0 で作成
- `docs-jp/` 全Markdownを横断し、旧 `../artifacts/...` source path が残っていないことを確認
- 配布スクリプトや実装コードは変更していないため runtime test 対象なし

Closes #11
Closes #13
Closes #14
~~~~
