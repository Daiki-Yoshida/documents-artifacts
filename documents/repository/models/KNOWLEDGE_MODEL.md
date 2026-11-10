# Knowledge Model

## 目的と適用範囲

このモデルは、`dev-artifacts` リポジトリ内の**情報保存・知識正本・派生配布物**の責務と相互関係を定義する。Dev-Philosophyの内容そのものを定義しない。

`documents/repository/models/` が管理契約を所有し、`documents/repository/operations/` が実際の運用を定める。`documents/knowledge/` は、管理規則を包含する親ではなく、情報を保持する領域である。

## 3種類のcomplete

| 対象 | 目的 |
| --- | --- |
| `documents/knowledge/records/` | 原文・source eventの **source completeness** |
| `documents/knowledge/subjects/` | reusableな意味・判断・評価関係の **semantic completeness** と現在評価 |
| `artifacts/` | AIによる利用のための派生物。具体的な射影・読込方式はStage 3で制定 |

`records` は後続判断の都合で書き換えない。`subjects` ではsourceの意味・採否・未決を整理し、`artifacts` は独立した意味上の正本にならない。

## 知識の経路

`第0情報源`（会話 / Issue / 判断 / 調査 / 実験等）から、原則として次へ向かう。

```text
第0情報源
  ↓ 原文・source event
records
  ↓ Decision Lineageと根拠の評価
subjects（Dev-Philosophy / Dev-Methodology）
  ↓ 射影（Stage 3で設計）
artifacts
  ↓
対象プロジェクト / リポジトリ越しのAI参照
```

情報源の保存規則は [RECORD_MODEL](RECORD_MODEL.md)、decisionの評価関係は [DECISION_LINEAGE_MODEL](DECISION_LINEAGE_MODEL.md)、traceabilityは [TRACEABILITY_MODEL](TRACEABILITY_MODEL.md) が所有する。

## Authorityは単純なdirectory順位ではない

- **記録の原文・実際に発言された内容**はrecordsと第0情報源を照合する。
- **現在有効な意味上の知識**はDecision Lineageによって評価されたsubjectsで表現する。
- **Dev-Philosophyの内容の制定権**はOwnerが持ち、規範的な衝突では制定済みの哲学が方法論より優先する。
- **管理規則の定義権**は`repository/models/`、**具体的な実施手順**は`repository/operations/` が所有する。
- **配布物**はsubjectsから派生し、独自に一般規範を新設しない。

それぞれの対象が違うため、「knowledgeの全ファイルがrepositoryの全ファイルより優先」など単一の物理パス順で解決しない。境界の詳細は [AUTHORITY_GOVERNANCE_MODEL](AUTHORITY_GOVERNANCE_MODEL.md)。

## Stage境界

Stage 1では、この管理構造と正本・派生物の境界のみを制定する。

- **Stage 2:** records→subjectsの実際の整理規則、哲学と方法論の分類、正本の構築。
- **Stage 3:** subjects→artifactsの投影・圧縮・読込・配布の詳細。

現時点で`subjects`、`artifacts` の未完成内容をcurrent authorityや正式配布物とみなさない。

## 根拠

- [3層用語・モデルrecord](../../knowledge/records/2026-11-10-dev-layers-terminology/)
- [Stage 1採用record](../../knowledge/records/2026-11-11-dev-artifacts-stage1-governance/)
