# Knowledge

`documents/knowledge/` は原文記録と、そこから意味を整理した正本を持つ領域である。**知識管理の契約自体は`documents/repository/models/`が所有**する。

## 構造

```text
knowledge/
├── INDEX.md
├── records/
│   └── YYYY-MM-DD-<short-title>/
└── subjects/
    ├── dev-philosophy/
    └── dev-methodology/
```

### records/

会話、Issue、判断、調査、実験等の第0情報源から原文とprovenanceを保持する。意見の採用・却下、未決定事項、哲学と方法論の混在をそのまま記録してよい。既存の記録は再分類・改変しない。

### subjects/

recordsを根拠としてsemantic completenessと現在評価を維持する正本。第1層`dev-philosophy/`（Owner制定権）と第2層`dev-methodology/`（哲学を実現するAI非依存の方法論）に分かれる。

個々の知識の抽出・分類・配置手順はStage 2で設計し、その後に構築する。現時点の空領域を完成済みの正本として扱わない。

## 情報の判断

- 何がsource eventとして記録されたか：recordsと第0情報源を確認する。
- どれがcurrentな判断か：Decision LineageとOwner承認を確認する。
- どの内容が何を所有するか：Dev Layers / Governanceモデルを確認する。
- 通常の内容参照は制定済みsubjects、疑義があればrecordsへ遡る。

情報源の信頼性と規範的な優先関係は別であり、すべてのファイルをパスの上下で順位づけない。

## モデル入口

[Repository Models](../repository/models/INDEX.md) / [Repository Operations](../repository/operations/INDEX.md)
