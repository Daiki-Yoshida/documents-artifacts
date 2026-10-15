# Record — Generic DIR command target clarification / Issue #209

```yaml
record_format: 1
record_kind: bundle
recorded_date: "2026-10-14"
scope: "汎用DIR指定の意図の再確認とIssue #209起票: このChatGPT会話から選定したユーザーメッセージ4件、直前のassistant提案1件、起票時点のIssue本文1件"
source_issue: "https://github.com/Daiki-Yoshida/documents-artifacts/issues/209"
```

## Source inventory

| Payload | Source / locator | Coverage | Fidelity |
|---|---|---|---|
| `USER_MESSAGES.md` | 2026-10-14のこのChatGPT会話のユーザーメッセージ（永続的な個別message locatorは未取得） | 汎用DIRの調査依頼、WORK入力への違和感と希望操作、汎用パスとしての明示的な説明、Issue/records保存指示の**選定した4メッセージの本文全体**を順序どおり収録。会話全体は含めない | 会話上で利用できる本文から手動転記。要約・抜粋・言い換えは意図しない。event見出しと外側のfenceは追加。原文API exportとのbyte-for-byte一致、空白・改行の完全一致は未検証 |
| `DESIGN_CONTEXT.md` | 同じChatGPT会話の「Issueにして」指示の直前のassistant返信（個別message locatorは未取得） | 最終指示が参照する、汎用DIR・コマンド固有の意味解決・既存WORK/REPO規約との関係についてのassistant返信1件の本文全体。その他のassistant返信・ツール結果・会話全体は収録しない | 会話で利用できる返信をMarkdown本文として手動転記。原文API exportとのbyte-for-byte一致およびレンダリング差異は未検証 |
| `ISSUE_209_BODY.md` | GitHub Issue #209: https://github.com/Daiki-Yoshida/documents-artifacts/issues/209 | 起票直後に取得したIssue本文全体。Issueの後続編集・コメントは含まない | GitHub connectorから取得したIssueの`body`文字列を、追加の本文加工なしに保存 |

## Boundary and relation

このBundleは、2026-10-14に改めて明示された `DIR` 指定の意図と、そのIssue化・原文保存依頼を検証可能にする**範囲を確定したsource event集合**であり、全Chat履歴ではない。選定したuser eventの順序を保持し、短い最終保存指示が参照するassistantの直前の設計提案を独立したpayloadとして残す。Issue本文はその後に作成された別のeventであり、先行するChat原文の代わりではない。

関連する以前の設計源泉は `../2026-10-03-project-root-execution-routing/`（Issue #148）に保存されている。本Bundleはそれを改変・複製するものではない。

ユーザーが今回明示したのは「`DIR` はパスそのもので、各コマンドがそのパスの用途・解決方法を決める」「公開インターフェイスで一貫したパス入力を使いたい」という設計意図、およびそのIssue・recordsへの記録である。

これはIssue起票・source保存の記録であり、`WORK + REPO` 規約全体の廃止、具体的なWorktree API改定、subjects/artifactsの改定、target Projectへの変更、実装・mergeの包括承認を意味しない。後続判断・実験結果は別のsource event/recordに保存し、このBundleの原文を書き換えない。

`record_kind: bundle` はsource保存の形状であり、後続のcurrent/superseded等の意味評価をこのrecordに固定しない。現行のRecord Modelは `../../system/RECORD_MODEL.md`、更新手順は `../../../project/KNOWLEDGE_UPDATE_WORKFLOW.md` が所有する。
