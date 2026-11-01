---
record_format: 1
record_kind: bundle
recorded_date: "2026-10-31"
scope: "RuleClass（RC1〜RC3）の名称採用、全要素分類の議論、Work Identity適用目的、実装ブランチ作成のOwner指示とIssue #219採用記録をまとめた限定source bundle"
---

# RuleClass adoption — source event bundle

## Source inventory

| Payload | Source / locator | Coverage | Fidelity |
|---|---|---|---|
| `USER_MESSAGES.md` (U1–U6) | 2026-10-31の本ChatGPT会話、個別message locator不明 | 三分類要望、Work単位を必須にしたい背景、名称選択、棚卸し、RC正式採用、branch実装指示に関係する選定6メッセージ全文。会話全量ではない | visible本文から手動転記。原文API byte-level照合なし。event見出し・外側fenceは新設 |
| `ISSUE_219_BODY.md` | https://github.com/Daiki-Yoshida/documents-artifacts/issues/219 | GitHub取得時点のIssue本文全体。既存のNL候補表現を含み、コメント・将来変更は含まない | connectorが返した`body`文字列をそのまま保存 |
| `ISSUE_219_RC_ADOPTION_COMMENT.md` | https://github.com/Daiki-Yoshida/documents-artifacts/issues/219#issuecomment-6543416942 | RuleClass名称の採用判断コメント本文全体 | connectorが返したコメント`body`文字列をそのまま保存 |

## Decision lineage and scope

- **Current:** OwnerはRuleClassの3分類を採用。RC1 = Project Defined、RC2 = Recommended、RC3 = Required。個々の規則には適用条件があり、RC1は「無視可能」を意味しない。RCはDOC_Lx/SAFETY_Lx/contract Lx等のchange-impact levelとは独立する。
- **Current direction:** Ownerは、Artifactを読んだAIがWork単位の作業を単なる推奨として不採用にしていることを具体的な問題として報告した。Artifact v2を開発規範として採用するProjectの具体的実装作業では、Work Identityをrequired contract（RC3）として扱う。既存Workは再利用、未確定の新規WorkはOwner確認/有効委譲が必要。これはGit worktree等の強制作成を含まない。
- **Refined predecessor:** `engineering-operation/S001_CHANGE_LIFECYCLE.md`の従来の適用条件「Work Identity modelを採用済みのProjectで」は、この後続判断でArtifact v2採用Projectへscopeを拡張。元のWork Identityの意味・owner confirmationは維持する。
- **Candidate only:** #219の222分類候補は一括で全て受入済みではない。個別classification、Agent entryのmandatory化、Project固有の有効な例外判定は別のreview/evidence対象。過去Issueコメントやrecord原文は変更しない。
- **Authority boundary:** この記録はUserからのbranch上の開発指示を示すが、実装以外のremote mergeやtarget project自動同期を許可するものではない。

## Implementation reference

- Work Identity / branch: `feat/rule-class-contract`
- Starting `main`: `960c3682fe9172b90b60d05c22078eb1cafc0df1`
- Work Issue: https://github.com/Daiki-Yoshida/documents-artifacts/issues/219
- 後続の検証・評価・訂正は新source eventとして記録する。このBundleは収録時点で固定する。
