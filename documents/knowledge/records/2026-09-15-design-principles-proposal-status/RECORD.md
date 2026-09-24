# Source record: 2026-09-15-design-principles-proposal-status

```yaml
record_type: "verbatim_external_source_snapshot"
source_kind: "GitHub Issue comment"
source_url: "https://github.com/Daiki-Yoshida/design-principles/issues/1#issuecomment-5687927559"
source_created_at: "2026-09-15T20:53:02Z"
source_updated_at: "2026-09-15T20:53:02Z"
retrieved_date: "2026-09-24"
source_text_status: "GitHub APIで取得した現存本文のsnapshot。作成当時から無編集かは未検証"
record_body_policy: "本文はsourceのAPI bodyから無加工で取り込んだ。PR/Issueは会話の原文そのものとは限らない"
```

## 取得本文（原文）

~~~~text
中央正準版への移行結果です。

`Daiki-Yoshida/documents-artifacts` PR #10 で、提案1/2/3/5を会話で詰めた内容に修正して反映し、squash mergeしました。

反映内容:
- 1: Contract conformance と user requirement / observable outcome satisfaction を分離。Contract Testを「契約適合の正本」とし、要求達成は narrowest meaningful path で別確認。formal acceptance criteria の必須化はしない。
- 2: Concept Altitude の one-sentence test を neutrality の signal に降格。semantic identity は invariants / pre-postconditions / failure semantics / lifecycle / reason-to-change で確認。証拠不足なら consumer-neutral だが local に保持。
- 3: additive と compatibility を分離。consumer/caller と provider/implementer の両側を確認し、L2=`compatible public evolution`、published breaking=L3 と整理。
- 5: state ownership と cross-boundary consistency responsibility を境界判断へ追加。cross-boundary invariant は自動的なmodule mergeを意味せず、明示的な orchestration/failure owner と consistency model を要求。

提案4は今回の正本変更には入れていません。方向性は支持するものの、性能を理由に contract granularity を再設計してよい境界条件を別途詰める必要があるため、中央repo Issue #11 `design-principles: 性能要求と契約粒度の再設計条件を検討` として移管しました。

中央正本 merge commit: `56f6dd8e49a84cae51f08193ae746951023d6f7c`
中央PR: https://github.com/Daiki-Yoshida/documents-artifacts/pull/10
保留Issue: https://github.com/Daiki-Yoshida/documents-artifacts/issues/11

なお `docs-jp/design-principles/ENCAPSULATION_HORIZON_JP.md` には旧来の「日本語原本がsource of truth」という記述が残っており、現在の中央repo方針（英語 `artifacts/` が正本）と食い違っています。これは本Issueの5提案とは別の既存不整合として、今回の変更には混ぜていません。
~~~~
