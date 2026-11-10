# Subject Model — Stage 1 Boundary

## 対象

`documents/knowledge/subjects/` はrecordsを根拠とした**意味上の正本**であり、原文の複写領域でもAI向けの圧縮済み配布物でもない。

```text
subjects/
├── dev-philosophy/
└── dev-methodology/
```

- `dev-philosophy/`: Dev-Philosophyの正本。**Ownerが内容の制定権を所有する**。
- `dev-methodology/`: Dev-Philosophyを実現する、AIに依存しない開発方法論の正本。

両者の一般的な関係は [DEV_LAYERS_MODEL](DEV_LAYERS_MODEL.md) が所有する。具体的な既存leafの所属判断・分割方法はStage 2で決める。

## 変わらない保存原則

- reusableなsemantic knowledgeの意味、条件、例外、反論、旧世代の評価関係を失わせない。
- 単に新しいrecordだからcurrent、古いから無効とは決めない。
- effective status（current / superseded / rejected / unresolved）とsource event（proposal / adoption等）は別軸である。
- semantic ownerを重複定義せず、traceabilityとDecision Lineageを維持する。
- 未承認の哲学候補を制定済みcurrentなDev-Philosophyとして提示しない。
- token削減のためにsubjectsを圧縮しない。

## Stage 2に留保する事項

以下はこのStage 1文書で勝手に制定しない。

- 個別subject / leafの分類、粒度、ファイル命名・分割・統合ルール
- recordsからの意味抽出、混在概念の仕分け、dispositionの具体手順
- 哲学候補の配置、審査から承認済みsurfaceへの昇格方法
- Stage 2に必要な履歴・未承認候補の表示方法

旧詳細規則は`documents/repository/legacy/system/SUBJECT_MODEL.md` に非現行の参考資料として保存し、Stage 2で根拠recordと照合して再評価する。

## 根拠・関連モデル

- [Knowledge Model](KNOWLEDGE_MODEL.md)
- [Authority / Governance](AUTHORITY_GOVERNANCE_MODEL.md)
- [Decision Lineage](DECISION_LINEAGE_MODEL.md)
- [Traceability](TRACEABILITY_MODEL.md)
