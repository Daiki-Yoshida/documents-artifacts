# ドキュメント — 基本原則

project documentationを、情報正確性を優先しつつ必要な読者が適切に到達できる形で維持するための基本原則を扱う。このrepo自身のknowledge保存規則は `../../system/` が優先する。

## 核心原則: 情報正確性優先

ドキュメントの目的は、AIエージェントに正確で完全な情報を適切なタイミングで提供することである。トークン効率も重要だが、**情報の劣化を代償にして追求してはならない**。

```yaml
priority_order:
  1: "情報正確性 — ドキュメントは正確かつ完全でなければならない"
  2: "適切なルーティング — エージェントは必要なときに必要なものだけを読む"
  3: "トークン効率 — 無駄を最小化するが、トークンを節約するために情報を切り詰めてはならない"
```

正確性とトークン効率が競合する場合、正確性が勝つ。トークンコストの解決策は、ドキュメントを薄くすることではなく、**より良いファイル構造とルーティング**である。

```yaml
wrong_approach: "トークン予算に合わせてドキュメントを縮小し、重要な詳細を失う。"
right_approach: "関心事ごとにドキュメントを分割し、エージェントが関連部分だけを読み込むようにする。"
```

---

---

## スコープ: 本戦略が管轄するもの

```yaml
governs:
  - "Project Documentation内部の内容・構造・routing・maintenance"
  - "documents/INDEX.md — Project Documentationのrouting hub"
  - "ドキュメント変更のGit commit message / formatに関する規則"

does_not_govern:
  - "Project Rootやrepositoryの静的配置 — workspace-structure"
  - "Work Documentsのidentity / ownership / lifecycle — work-identity"
  - "source codeの設計・architecture・contract — encapsulation-horizon"
  - "開発commandの実行環境 — development-execution"
  - "破壊操作・host変更等のoperational safety — development-safety"
```

`<project-root>/documents/` を **Project Documentation** のcanonical rootとする。top-level placement / Git ownershipは `../workspace-structure/`、その内部routing / file role / maintenanceはこのsubjectが主所有する。

document固有のSemantic Versionや `last_updated_commit` registryは必須化しない。履歴と変更過程は原則Git historyを利用する。



## 汎用性

```yaml
principle: "本戦略はAIエージェントを使用するあらゆるプロジェクトで機能する。"
scope:
  single_project: "1つのリポジトリ、1つのdocuments/ツリー、1つのINDEX.md。"
  hierarchical_project: "親+子プロジェクト、それぞれが独立したdocuments/ツリーを持つ。"
  scale_independence: "単一スクリプトのリポジトリからマルチサービスのモノレポまで。"
```

階層projectのdocumentation構造は `S002_ROUTING_AND_STRUCTURE.md` の「階層プロジェクト」を参照する。

---

## Sources

- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/documentation-strategy/DOCUMENTATION_PHILOSOPHY_JP.md`
- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/documentation-strategy/DOCUMENT_WORKFLOW_JP.md`
- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/documentation-strategy/FILE_AND_STRUCTURE_JP.md`
