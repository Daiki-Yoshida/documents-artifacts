---
record_format: 1
record_kind: bundle
recorded_date: "2026-10-30"
scope: "Issue #216に基づくWork Documents baseline中心運用の判断。選定したユーザー発言2件と、調査時点のIssue #216本文を独立source eventとして保存する"
---

# Source record — Management baseline coordination

## Source inventory

| Payload | Source / locator | Coverage | Fidelity |
|---|---|---|---|
| USER_MESSAGES.md / U1, U2 | 2026-10-30のChatGPT会話。個別message locator取得不可 | 今回の方針と実装権限を示した選定ユーザー発言2件の本文。会話全体ではない | 表示テキストから手動転記。原文APIのbyte-level検証なし。外枠の見出し・fenceはrecord側で追加 |
| ISSUE_216_BODY.md | https://github.com/Daiki-Yoshida/documents-artifacts/issues/216 | 2026-10-30にGitHub connectorで取得したIssue本文の全体。コメント・将来編集は含まない | GitHubが返したIssue body文字列を無加工で保存 |

## Decision scope and lineage

- Issue #216はKotoba RogueのGit所有・ref/checkout・publication authority混同を証拠として記録した原因分析の出発点。Issue自体は作成時にArtifact改定を承認していない。
- U1はManagementのWork Documentsをmain（一般化するとproject-defined baseline）で管理する方向と、Management自身の仕組みに変更が必要な場合のbranch分離、NAL/context肥大抑制を提案した。
- U2は今回の根拠調査を踏まえ、reusable artifactsを適切に更新し、行動テストの実測を重視しつつmain統合まで進める権限を付与した。これは既存プロジェクトのすべてのmain pushを一般許可するものではない。
- 「別のプロジェクトにも似た事例」はOwnerからの観測報告であり、このBundleでは個々の別プロジェクトの具体的発生記録を独立検証していない。
- 前後のassistant分析全体・Chat全量は保存対象外。Issue #216の一次資料リンク、およびこの変更のPR/検証報告を辿って実装判断の根拠を補完する。

## Subject disposition

- **current**: active Work Documentsと通常coordination stateはManagement Rootのproject-defined baselineに、承認済みVCS経路でpublicationする運用を標準とする（work-identity/S003）。
- **current**: Repositoryごとのbranchは実際の実装変更・必要な隔離によって選び、Work Identity共有だけで派生branchを増やさない（work-identity/S001/S002）。
- **represented**: commit/push/merge authorityはengineering-operation/S006のproject-local優先規則が所有し続ける。baselineへの無条件書込み許可を新設しない。
- **evidence_only**: 事故の具体的やり取り、Git state、Ownerの別案件についての報告はこのrecordおよびIssue #216で保全。runtime Artifactへ事故の全経緯を重複投影しない。

後日のagent behavior test・再評価・訂正はこのBundleへ追加せず、別のsource eventとして記録する。
