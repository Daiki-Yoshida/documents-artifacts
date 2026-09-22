# ドキュメント — 基本原則

project documentationを、情報正確性を優先しつつ必要な読者が適切に到達できる形で維持するための基本原則を扱う。このrepo自身のknowledge保存規則は `../../system/` が優先する。

## 核心原則: 情報正確性優先

ドキュメントは、利用者が判断・実装・運用に必要な情報を正確に取得できなければならない。token効率や短さは重要だが、**情報の劣化を代償にして追求しない**。

```yaml
priority_order:
  1: "情報正確性・意味の完全性"
  2: "適切なrouting"
  3: "読み取り効率・token効率"
```

情報量の問題は、重要情報の削除ではなく、責務分割・INDEX・cross reference・progressive disclosureで解決する。

## Scope

このsubjectが主に所有する:

- Project Documentation内部のfile roleとrouting
- documentation directory内部の責務分割
- documentationの導入・更新・保守
- documentation固有のreview / confirmation boundary
- documentationに対するGit履歴・formatの利用方針

このsubjectが主所有しない:

- Project Rootやrepositoryの静的配置 → `../workspace-structure/`
- Work Documentsのidentity / ownership / lifecycle → `../work-identity/`
- source codeの境界設計 → `../encapsulation-horizon/`
- 開発commandの実行環境 → `../development-execution/`
- 破壊操作・host変更等のoperational safety → `../development-safety/`

## Project Documentation

`<project-root>/documents/` を、Project全体の現在knowledgeを保持する **Project Documentation** の代表的なrootとして扱う。

ただし、`documents/project/` や `documents/reference/` などの内部directoryは**意味roleを表す選択肢**であり、全projectへ固定templateとして強制しない。既存の明確なlocal conventionがある場合は、それを尊重する。

人間向け / AI向けという読者差だけを理由に、固定のtop-level directory名へ機械的に分離しない。必要なaudience、language、detail levelはproject documentation自身が明示する。

## Authority と overlap

同じ概念が複数documentで言及されること自体は禁止しない。

```yaml
principle:
  - "同じ規範・定義を複数箇所で独立authorityとして更新しない"
  - "主責務を持つdocumentを明確にする"
  - "理解に必要な局所的再述は許容する"
  - "DRYより意味の完全性を優先する"
```

厳密な「1情報 = 1文書」は要求しない。

## Git history

document固有のSemantic Versionや `last_updated_commit` registryを必須化しない。

履歴・変更過程・削除済み情報の追跡は原則としてGit historyを利用する。現在の正確性は、固定metadataの古さではなく、関連する実装・判断・Git履歴との照合で確認する。

## Sources

- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/documentation-strategy/DOCUMENTATION_PHILOSOPHY_JP.md`
- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/documentation-strategy/DOCUMENT_WORKFLOW_JP.md`
- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/documentation-strategy/FILE_AND_STRUCTURE_JP.md`
- `../../records/2026-09-22-six-subject-cross-audit-fixes/`
