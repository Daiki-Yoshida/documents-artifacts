## Owner採用判断 — 規範分類の名称を RuleClass（RC1〜RC3）に確定

**Source event:** このChatGPT会話におけるOwnerの発言（2026-10-31、個別message URL取得不可）。以下は選定した1メッセージの表示原文。引用以外の本コメントは判断の整理であり、原文の一部ではない。

> RCを採用！　それでいこう。　記録した後に、今 RC1~2にされているのは何か知りたい

**採用対象:** 直前の提案「RuleClass（RC）」という呼称と分類名。今後の規範分類・議論・実装では次を正式名称として使用する。

| Current label | Meaning | Prior proposed name |
|---|---|---|
| `RuleClass1` / `RC1` | Project Defined — 具体方式・選択・値はProjectの裁量 | `NormLevel1` / `NL1` |
| `RuleClass2` / `RC2` | Recommended — defaultとして推奨し、具体的理由で別案を選べる | `NormLevel2` / `NL2` |
| `RuleClass3` / `RC3` | Required — 適用条件を満たすときの必須契約 | `NormLevel3` / `NL3` |

### 解釈・移行境界

- **RuleClassは規則の拘束力と具体方式の委譲先に関する分類**であり、変更影響レベル `L0〜L3` / `DOC_Lx` / `SAFETY_Lx` および `NAL` とは独立。
- `RC1` は「無視可能」ではない。Projectが決定した具体的事項はそのProject固有の権限・契約に従う。
- `RC3` でも適用条件は必ず評価する。「常に全ての関連行為を行う」という意味ではない。
- 旧分類を示す#219の既存Issue本文・9コメント・222分類候補は**歴史的な提案として維持**し、読替え `NL1→RC1`, `NL2→RC2`, `NL3→RC3`, `NL3*→RC3*（強度/適用範囲の追加判断待ち）` とする。旧名称は今後の新規採用分類として使わない。
- **名称の採用と222件すべての候補分類の個別承認は別**。分類表は引き続き候補。特にWork Identityの適用範囲、Agent entry、project-local authorityは独立した採用・正本反映判断を要する。
- 第0情報源として本コメントへappend-onlyで判断を保全した。canonical `documents/knowledge/records → subjects → artifacts` への実装・projectionは後続の明示的なWorkで行い、未変更のArtifactが既にRC分類に対応済みと主張しない。

**Status:** `TERMINOLOGY_ADOPTED / CANDIDATE_CLASSIFICATIONS_UNDER_REVIEW / CANONICAL_AND_ARTIFACT_NOT_CHANGED`.
