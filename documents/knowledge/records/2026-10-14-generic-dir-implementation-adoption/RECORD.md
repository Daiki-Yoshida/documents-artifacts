# Record — Generic DIR implementation authorization and Work Identity selection

```yaml
record_format: 1
record_kind: bundle
recorded_date: "2026-10-14"
scope: "Issue #209 Phase A設計レビュー、ユーザーの実装継続・Work Identity選定委任、選定したWork Identityと実装範囲宣言を関連する独立source eventとして保全"
source_issue: "https://github.com/Daiki-Yoshida/documents-artifacts/issues/209"
work_identity: "refactor/generic-dir-command-routing"
```

## Source inventory

| Payload | Source / locator | Coverage | Fidelity |
|---|---|---|---|
| `REVIEW_COMMENT.md` | [Issue #209 Phase A review](https://github.com/Daiki-Yoshida/documents-artifacts/issues/209#issuecomment-6164942185) | 指定のレビューコメント本文全体。その他のIssue履歴は含まない | GitHub connectorから取得したコメント本文をそのまま保全 |
| `USER_MESSAGE.md` | このChatGPT会話の最新のユーザーメッセージ（永続個別message locatorは未取得） | 実装進行とWork Identity選定の委任を示す一つの完全メッセージ。Chat全体は含まない | 会話表示中の本文を手動転記。文字列変更を意図しないがAPI原文のバイト一致・空白正確性は未検証 |
| `WORK_SELECTION_COMMENT.md` | [Issue #209 Phase B selection](https://github.com/Daiki-Yoshida/documents-artifacts/issues/209#issuecomment-6165398117) | 選定Work Identityと実装scopeを記した一つのコメント本文全体 | GitHub connectorから取得したコメント本文をそのまま保全 |

## Boundary, order and relation

取得対象を上表の3 eventで固定するbounded Bundle。Source eventsはレビュー提案 → ユーザーの進行・委任 → Work Identity選定宣言の順で発生した。ユーザーの短い進行指示が参照する設計対象はPhase Aレビューにより追跡可能であり、ユーザー本人が具体的なWork Identityを指定したとの主張はしない。

先行source: `../2026-10-14-generic-dir-command-target/`（Issue #209起票時の選定会話とIssue本文）、さらに `../2026-10-03-project-root-execution-routing/`（Issue #148原意）。

このRecordはhistorical source。採用すべきcurrent semanticsは責務ごとのsubjectsが所有し、Artifactにはそのcurrent-effective guidanceを投影する。今回のユーザー指示は作業着手・Work Identity選定の委任であり、mainへのmergeやtarget Project同期、外部CI・課金資産使用の包括許可ではない。
