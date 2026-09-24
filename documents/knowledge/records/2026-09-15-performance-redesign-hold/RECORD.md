# Source record: 2026-09-15-performance-redesign-hold

```yaml
record_type: "verbatim_external_source_snapshot"
source_kind: "GitHub Issue body"
source_url: "https://github.com/Daiki-Yoshida/documents-artifacts/issues/11"
source_created_at: "2026-09-15T20:52:44Z"
source_updated_at: "2026-09-20T18:09:39Z"
retrieved_date: "2026-09-24"
source_text_status: "GitHub APIで取得した現存本文のsnapshot。作成当時から無編集かは未検証"
record_body_policy: "本文はsourceのAPI bodyから無加工で取り込んだ。PR/Issueは会話の原文そのものとは限らない"
```

## 取得本文（原文）

~~~~text
## 背景

旧 `Daiki-Yoshida/design-principles#1` の提案4を、中央正本への今回の改訂では**保留**としたため、将来検討として中央repoへ移管する。

## 問題意識

既存の `Performance vs. Abstraction Policy` は、性能最適化を原則として契約の内側で行う方針を持つ。一方、内部最適化だけでは要求を満たせず、batch / streaming / pagination / async など**interaction shape / contract granularity 自体**が性能上の制約になるケースは存在する。

## 現時点の合意方針

方向性は支持するが、次の境界条件を詰めるまで正本へ規範化しない。

- 性能が実際に **load-bearing requirement** である場合だけ対象にする
- 推測上の「遅そう」ではなく、測定・根拠を要求する
- まず既存contractを維持した内部最適化を検討する
- interaction shape 自体が要求達成を妨げている場合にのみ contract redesign を候補にする
- redesignしても semantic capability / ownership boundary は可能な限り維持する
- 既存contractを進化させる場合は通常のcompatibilityルールに従う

## 今回やらないこと

- `Performance vs. Abstraction Policy` の変更
- 性能を理由とした一般的なbatch/streaming推奨
- 具体的な閾値やbenchmark基準の固定

## 検討時の問い

1. 「内部最適化では不十分」と判断するためにどの程度の測定根拠を要求するか。
2. semantic capabilityを保ったinteraction-shape変更と、意味そのものの変更をどう区別するか。
3. public API / internal port / cross-runtime protocol で判断基準を分ける必要があるか。
4. compatibility / deprecationとどう接続するか。

Related: `Daiki-Yoshida/design-principles#1` proposal 4, `documents-artifacts` PR #10.
~~~~
