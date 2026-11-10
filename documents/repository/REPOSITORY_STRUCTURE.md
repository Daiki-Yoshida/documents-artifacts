# Repository Structure — Stage 1

## 位置づけ

現行`documents-artifacts`と**同じリポジトリ・同じ役割**を継承し、将来GitHub上の名称を`dev-artifacts`に変更する。Stage 1は`refactor/dev-artifacts-restructure`という開発ブランチ上の再構築であり、`main`は変更しない。

```text
dev-artifacts/
├── README.md
├── documents/
│   ├── INDEX.md
│   ├── repository/
│   │   ├── INDEX.md
│   │   ├── REPOSITORY_STRUCTURE.md
│   │   ├── models/
│   │   │   ├── INDEX.md
│   │   │   ├── DEV_LAYERS_MODEL.md
│   │   │   ├── AUTHORITY_GOVERNANCE_MODEL.md
│   │   │   ├── KNOWLEDGE_MODEL.md
│   │   │   ├── RECORD_MODEL.md
│   │   │   ├── SUBJECT_MODEL.md
│   │   │   ├── DECISION_LINEAGE_MODEL.md
│   │   │   └── TRACEABILITY_MODEL.md
│   │   ├── operations/
│   │   │   ├── INDEX.md
│   │   │   └── KNOWLEDGE_UPDATE_WORKFLOW.md
│   │   └── legacy/            # 非現行の旧管理文書・資料
│   └── knowledge/
│       ├── INDEX.md
│       ├── records/
│       │   └── YYYY-MM-DD-name/
│       └── subjects/
│           ├── dev-philosophy/
│           └── dev-methodology/
├── artifacts/                 # Stage 3で構築
├── tests/
├── install.sh
└── artifacts.sh
```

## 所有権・更新境界

- `repository/models/`は**管理契約**を所有する。哲学の内容を所有しない。
- `repository/operations/`は管理モデルを参照して具体的な運用手順を定める。
- `knowledge/records/`は原文記録で、日付＋名称形式を維持する。哲学/方法論の強制区分を行わない。
- `knowledge/subjects/`は第1層と第2層の意味上の正本。内容と抽出の詳細はStage 2で決める。
- `artifacts/`は従来同様、対象プロジェクトの`./documents/artifacts/`への配置とAIエージェントのリポジトリ横断参照を目的とする。Stage 3で形式を決める。
- `legacy/`は旧文書の比較・歴史参照用であり、現行モデルや運用を定義しない。

## 開発期間

1. **Stage 1:** 階層設計と外枠の運用設計（管理規則）。
2. **Stage 2:** records→subjectsの規則と内容（正式な哲学の制定にはOwner最終承認）。
3. **Stage 3:** 実際のsubjectsを見てsubjects→artifactsの変換・読み込み・配布を設計する。

`subjects/`と`artifacts/`は、再構築開始時に旧本文を外している。旧内容は`main`およびGit履歴に残り、recordsも継承される。

## 移行と配布の区別

`main`の既存配布と、未完成な開発ブランチは別。開発ブランチの`artifacts/`はStage 3までは正式配布用パックではなく、このブランチから既存プロジェクトへ同期しない。

`install.sh`、`artifacts.sh`と旧テストは当面保持するが、Stage 3の設計を先取りしたものではない。Stage 3では配布URL・GitHub rename・テストの整合性を別途確認する。
