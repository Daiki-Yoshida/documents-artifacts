# Source record: 2026-08-03-docker-resource-reuse-pr

```yaml
record_type: "verbatim_external_source_snapshot"
source_kind: "GitHub PR body"
source_url: "https://github.com/Daiki-Yoshida/development-environment-strategy/pull/3"
source_created_at: "2026-08-03T20:54:26Z"
source_updated_at: "2026-08-03T20:55:23Z"
retrieved_date: "2026-09-24"
source_text_status: "GitHub APIで取得した現存PR本文のsnapshot。作成当時から無編集かは未検証"
record_body_policy: "PR本文は無加工。会話の原文そのものとは限らない"
```

## 取得本文（原文）

~~~~text
## 変更内容

- `ENVIRONMENT_STANDARDS.md` のDocker基準へ、task/worktree単位の過剰なresource作成を防ぐ判断基準を追加
- task・branch・worktreeの存在だけではimage、container、network、volumeを分離しないことを明記
- build入力が同じimageと安全なcacheはproject/component単位で再利用
- 並列実行、可変状態、設定差異、明示的なproject規則がある場合だけruntime resourceを分離
- checkout等が変わっただけではimageをrebuild・retagしないことを明記
- 日本語版を同じ意味で同期

## 文書肥大化への配慮

- 変更先をDocker規範の所有文書1箇所に集約
- Workflow、Structure、INDEXには重複記載しない
- 新しいArtifact、schema、resource別の大きな表は追加しない
- 英語正本・日本語版とも8行追加のみ

## 影響

既存のcleanup規則は変更せず、resource作成前の判断だけを補強します。`strategy_version` は既存方針の明確化として据え置いています。
~~~~
