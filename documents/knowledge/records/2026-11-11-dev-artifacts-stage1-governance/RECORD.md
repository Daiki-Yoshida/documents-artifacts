---
record_format: 1
record_kind: bundle
recorded_date: "2026-11-11"
scope: "ChatGPT会話中のStage 1構造採用、旧管理モデル継承・不足規則の提案、その実施了承を示す選定メッセージ（当該会話の全件記録ではない）"
decision_lineage:
  event: "adoption"
  scope: "dev-artifacts Stage 1 repository layout and management design direction"
---

# Dev-Artifacts Stage 1 — Owner adoption and management-model direction

## Source inventory

| Payload | Source / locator | Coverage | Fidelity |
| --- | --- | --- | --- |
| `USER_MESSAGES.md` (U1–U3) | このChatGPT会話（conversation ID・個別message IDは取得不可） | 関連するOwnerメッセージ3件を選択し、それぞれの表示全文を会話順で収録。間の発言・AI応答を全収録したものではない | 会話上で閲覧できる本文から転記。区切り見出しは取り込み時に追加。APIとのbyte-level照合なし |
| `ASSISTANT_PROPOSAL.md` (P1) | U3直前のassistant提案（同ChatGPT会話。URL / message ID取得不可） | U3が了承した直前の提案メッセージ1件を表示全文として収録。U1が参照した以前の構造提案はこのBundleには収録していない（内容はIssue #221にも要約） | 会話表示から転記。UIや空白差を含むbyte-level同一性の確認なし。Markdown code fence markerのみ記録時に通常のトリプルbacktickへ正規化 |

## Scope and decision lineage

- **U1:** `documents/repository/models/` と `operations/`、`knowledge/records/` と階層別`subjects/` という前掲の構造案を採用。
- **U2:** 既存の管理モデルを継承し、パス変更へ適応させる。records→subjectsの具体規則はStage 2、subjects→artifactsの具体規則はStage 3に残す。
- **U3:** 直前のP1（権威・承認管理、Dev Layersの追加と旧モデル移行）を受け、「これで行こうか」と実施の方向を了承。
- 採用されたのはStage 1設計・実施の方向であり、Stage 2の個別分類結果やStage 3の配布仕様まで承認したわけではない。
- 有効性の判断は個々の発言・採用関係による。record自体が以後のstatusを固定しない。
- このrecordは既存の `2026-11-10-dev-layers-terminology/` に新事象を追記するものではない。

## Related

- GitHub Issue #221: https://github.com/Daiki-Yoshida/documents-artifacts/issues/221
- Initial development branch: `refactor/dev-artifacts-restructure`
