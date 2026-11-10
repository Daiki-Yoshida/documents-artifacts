# Repository Structure — Stage 1 Target

Status: **Owner-approved directory layout, implementation in progress**.

```text
dev-artifacts/
├── documents/
│   ├── repository/
│   │   ├── INDEX.md
│   │   ├── models/
│   │   ├── operations/
│   │   └── REPOSITORY_STRUCTURE.md
│   └── knowledge/
│       ├── records/
│       │   └── YYYY-MM-DD-<short-title>/
│       └── subjects/
│           ├── dev-philosophy/
│           └── dev-methodology/
├── artifacts/
├── tests/
├── install.sh
└── artifacts.sh
```

## 責務

- `documents/repository/models/`:体系の構造・管理契約・定義権。
- `documents/repository/operations/`:モデルを前提とする具体的な手順・運用・検証。
- `documents/knowledge/records/`:原文・source eventの保全（既存形式維持）。
- `documents/knowledge/subjects/dev-philosophy/`:Ownerが内容の制定権を持つ開発哲学。
- `documents/knowledge/subjects/dev-methodology/`:哲学を実現する開発方法論。
- `artifacts/`:AI向け配布物。内部構造・投影・読み込み契約はStage 3で確定する。

`tests/` と配布用スクリプトは既存リポジトリから継続する。リポジトリ名称は将来 `dev-artifacts` に変更するが、この開発ブランチ作成時点でGitHub上の改名は行わない。

## 移行途中の境界

開発ブランチには、移行前の `documents/knowledge/system/` と `documents/project/` がまだ存在する。これらは現行 `main` から保持した移行元であり、新しい `models/` / `operations/` への詳細な配置は別途検証してから実施する。

`documents/knowledge/subjects/` および `artifacts/` の旧本文はこのブランチの出発時点で取り外され、Git履歴と現行 `main` に保持されている。新たなsubjects本文を、Stage 2の規則とOwnerの哲学承認前に制定済みと扱わない。

## 進行段階

1. Stage 1: この階層と外枠の管理・運用契約を整える。
2. Stage 2: records → subjects の規則と正本を整える。
3. Stage 3: 実際のsubjectsを踏まえてsubjects → artifacts の投影・配布方式を定める。

設計と判断: [Issue #221](https://github.com/Daiki-Yoshida/documents-artifacts/issues/221)。
