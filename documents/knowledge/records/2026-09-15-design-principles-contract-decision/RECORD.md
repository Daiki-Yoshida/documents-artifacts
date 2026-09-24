# Source record: 2026-09-15-design-principles-contract-decision

```yaml
record_type: "verbatim_external_source_snapshot"
source_kind: "GitHub PR body"
source_url: "https://github.com/Daiki-Yoshida/documents-artifacts/pull/10"
source_created_at: "2026-09-15T20:51:54Z"
source_updated_at: "2026-09-15T20:52:50Z"
retrieved_date: "2026-09-24"
source_text_status: "GitHub APIで取得した現存本文のsnapshot。作成当時から無編集かは未検証"
record_body_policy: "本文はsourceのAPI bodyから無加工で取り込んだ。PR/Issueは会話の原文そのものとは限らない"
```

## 取得本文（原文）

~~~~text
## Summary

旧 `Daiki-Yoshida/design-principles` Issue #1 の5提案を、中央正本 `artifacts/design-principles/` へそのまま移植せず、会話で採否を確定したうえで反映します。

### 採用（修正して採用）
1. **契約適合と要求達成を分離**
   - Contract Test = contract conformance の正本
   - User requirement / observable outcome は別に narrowest meaningful path で確認
   - formal acceptance-criteria 文書は必須化しない（proportionality維持）

2. **Concept Altitude と semantic identity を分離**
   - feature名を外せることは neutrality の signal であって generality の proof ではない
   - invariants / pre-postconditions / failure semantics / lifecycle / reason-to-change で semantic identity を確認
   - 証拠不足なら consumer-neutral だが local に保持し、shared abstraction を宣言しない

3. **additive と compatibility を分離**
   - consumer/caller と provider/implementer の両側から互換性を判定
   - relevant な source/binary/wire/schema/persisted-data 次元だけ確認
   - L2 を `compatible public evolution`、published breaking を L3 として扱う
   - module-local の contained break は実blast radiusで分類

5. **state ownership と cross-boundary consistency responsibility を境界判断へ追加**
   - mutable state は1つのownerを持つ
   - 複数state ownerにまたがるbusiness outcomeには orchestration/failure ownerを置く
   - cross-boundary invariant は自動的なmodule mergeを意味しない
   - topologyに応じ atomic transaction / retry / idempotency / compensation / explicit intermediate state を選ぶ

### 保留
4. **性能要求を契約粒度の入力にする提案**
   - 問題意識と方向性は支持
   - ただし contract redesign を許す境界条件は別途検討する
   - 今回 `Performance vs. Abstraction Policy` は変更しない

## Files
- `DESIGN_PHILOSOPHY.md`: WHY（semantic identity / state consistency）
- `CODING_STANDARDS.md`: HOW（compatibility / semantic identity / state ownership / verification）
- `AI_WORKFLOW.md`: FLOW（task outcome / compatibility gate / requirement verification）
- `INDEX.md`: ownership/routing更新

Related: Daiki-Yoshida/design-principles#1
~~~~
