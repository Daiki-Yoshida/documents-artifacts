# Source record: 2026-09-22-six-subject-cross-audit-implementation

```yaml
record_type: "verbatim_external_source_snapshot"
source_kind: "GitHub PR body"
source_url: "https://github.com/Daiki-Yoshida/documents-artifacts/pull/28"
source_created_at: "2026-09-22T14:20:12Z"
source_updated_at: "2026-09-22T22:21:32Z"
retrieved_date: "2026-09-24"
source_text_status: "GitHub APIで取得した現存PR本文のsnapshot。作成当時から無編集かは未検証"
record_body_policy: "PR本文は無加工。直前のAI提案原文ではなく、後続の実装説明としてのみ参照する"
```

## 取得本文（原文）

~~~~text
## 概要

6 subject体制の横断監査で見つかったauthority衝突・旧umbrella残留・用語衝突を修正します。

## 対象

- documentation
- development-execution
- development-safety
- work-identity
- workspace-structure
- encapsulation-horizon

## 主な修正

- documentationの旧document version / last_updated_commit registryを現行normative本文から除去
- 固定docs-jp配置・strict 1情報1文書・旧file authority参照をhistoryへ限定
- development-executionからrepository/worktree/lifecycle/safety ownershipを除去
- confirmation levelを CONTRACT_ / DOC_ / SAFETY_ namespaceへ分離
- Project DocumentsをProject Documentationへ整理
- generic public commandとWork Identity固有commandのownershipを接続
- integration lifecycleとsafe integration operationを接続
- Project Documentationのtop-level ownershipと内部routing ownershipを接続
- 旧意味はhistory / source record / Git historyへ保持

## Record

`documents/knowledge/records/2026-09-22-six-subject-cross-audit-fixes/`

## Merge

再監査後にユーザー確認を受けてmergeします。

## 再監査・レビュー

- 6 subject体制: 維持
- current normativeで旧 `Task Worktree` / 旧 `.worktrees/<component>/...` 追加: 0
- bare `L0-L3` namespace衝突: 0
- current normativeで `Project Documents` 旧用語追加: 0
- current normativeから旧 `FILE_AND_STRUCTURE.md` 等をauthority参照: 0
- legacy document version / `last_updated_commit` registryのpositive requirement: 0
- documentation source H2 routing anchors: 30 / 30 exactly once
- development-execution変更対象H2 routing anchors: 10 / 10 exactly once
- knowledge配下以外の変更: 0

### Reviewで追加修正した点

- RECORD_MODEL違反になっていた要約付きrecordを、ユーザー原文 + provenance metadataだけへ修正
- Project Documentation rootを `<project-root>/documents/` に統一し、内部構造だけを柔軟化
- workspace-structureのDocker / Makefile等のownershipを「静的配置 / Git ownership」に限定し、execution semanticsと分離
- 過剰な全文rewriteを撤回し、元の有効なrouting / workflow / command detailを復元
- documentationの局所再述ルールとauthority ruleを整合
- commit conventionをproject convention優先へ統一
- 機械置換由来のdouble prefix・旧registry残留・旧file参照を除去

H2数の監査はrouting anchor coverageを示すもので、後続判断後の本文がsourceと逐語一致することを意味しません。原文はrecords、旧判断はhistory / Git historyへ保持します。

## Merge

Draftのまま保持します。ユーザー確認後にmergeします。

~~~~
