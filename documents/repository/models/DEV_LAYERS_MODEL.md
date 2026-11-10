# Dev Layers Model

## 3層と総称

| 層 | 固定名称 | 本質・責務 |
| --- | --- | --- |
| 第1層 | **Dev-Philosophy（開発哲学）** | Owner本人の思想・価値判断。境界・契約・責務・カプセル化等の判断原理を含み、他層との規範的衝突では優先する憲法的位置 |
| 第2層 | **Dev-Methodology（開発方法論）** | Dev-Philosophyを実現する開発指針・開発ライフサイクル。AI不使用の人間開発でも独立に有用 |
| 第3層 | **AI-Orchestration（AIオーケストレーション）** | 前二者を前提とするAIエージェント間プロトコル。特定のAI製品には依存しない |

**Dev-Artifacts** は第1層と第2層の総称。単独の **Artifacts** は従来どおり射影・配布パックを意味する。接頭辞 `Dev-` は担い手非依存、`AI-` はAIエージェントを前提とすることを示す。

全体の前提関係は **AI-Orchestration → Dev-Methodology → Dev-Philosophy** の一方向であり、下位層が上位層の概念を再定義しない。

## 固定された関係語彙

- **実現する**：哲学 → 方法論
- **具体化する**：意味を保ったまま一般概念を文脈に縛って具体形にする
- **拡張する**
- **参照する**：参照先の概念を再定義しない
- **包含する**
- **委譲する**
- **所有する**：概念の定義権を持つ

個別概念間の関係ラベルには「特殊化」「継承」を用いない。「依存」は全体の前提関係の説明に限り、個別概念の関係ラベルには用いない。

ここでは固定済みの語彙を列挙し、Stage 2の個々のsubjectにどの関係が当てはまるかまでは決定しない。

## Repositoryへの対応

- 第1層: `documents/knowledge/subjects/dev-philosophy/`
- 第2層: `documents/knowledge/subjects/dev-methodology/`
- 第3層: 本リポジトリの2層正本には含めず、AI-Orchestrationという別の責務として区別する。
- `documents/repository/`: 上記の**内容とは別**に、その管理モデル・運用契約を所有する。

AIが哲学を抽出・成形しても、Ownerの明示的な最終承認がなければ哲学の正式制定にはならない。詳細は [Authority / Governance](AUTHORITY_GOVERNANCE_MODEL.md)。

## 根拠

- [3層モデルと用語決定](../../knowledge/records/2026-11-10-dev-layers-terminology/)
- [Stage 1採用と設計方針](../../knowledge/records/2026-11-11-dev-artifacts-stage1-governance/)
- [Ownerが固定関係語彙を明示した相談メモ](../../knowledge/records/2026-11-11-dev-artifacts-owner-memo/)（このChatGPTメッセージの保存。元の別会話の全文保存ではない）
