# dev-artifacts — restructuring branch

このリポジトリは、旧`documents-artifacts`の記録・Git履歴を引き継ぎ、**Dev-Philosophy（開発哲学）**と**Dev-Methodology（開発方法論）**を区別する新体系へ再編する。GitHub上のリポジトリ名の変更はまだ行っていない。

この`refactor/dev-artifacts-restructure`ブランチは**開発中**。現行の`main`と既存Artifact配布はそのまま残す。

## 新しい構造

```text
documents/
├── repository/
│   ├── models/            # 管理契約・定義権・層と承認
│   ├── operations/        # 管理契約を実行する手順
│   ├── legacy/            # 非現行の旧管理設計・監査
│   └── REPOSITORY_STRUCTURE.md
└── knowledge/
    ├── records/           # 従来の原文保存（形式維持）
    └── subjects/
        ├── dev-philosophy/
        └── dev-methodology/

artifacts/                 # Stage 3で再構築
tests/
install.sh
artifacts.sh
```

## 開発の段階

1. **Stage 1:** 階層・管理モデル・外枠の運用契約を整える。
2. **Stage 2:** records→subjectsの抽出規則と正本を構築する。哲学の制定にはOwnerの最終承認が必要。
3. **Stage 3:** 実際のsubjectsを見てartifactsの射影・読込・配布方式を設計し、構築する。

`subjects/`と`artifacts/`の旧本文はこのブランチでは外したが、`main`とGit履歴に残る。`records/`は引き継いでいる。空の`artifacts/`を既存プロジェクトへ配布しない。

## Stage 2 — 哲学先行（進行中）

[Owner採用済みのStage 2 Workflow](documents/repository/operations/STAGE2_WORKFLOW.md) に従い、現在は **A-1 / A-2を開始した段階**。粗哲学は未承認であり、[調査資料](documents/repository/operations/stage2/INDEX.md)と `subjects/dev-philosophy/` を区別する。

## Stage 1 の検証

```bash
bash tests/test-dev-artifacts-stage1.sh
```

旧Artifact v2向けテストはこの開発ブランチの未構築領域には非適用。詳細は[tests/INDEX.md](tests/INDEX.md)。

## 文書の入口

- [documents/INDEX.md](documents/INDEX.md)
- [Repository models](documents/repository/models/INDEX.md)
- [Repository operations](documents/repository/operations/INDEX.md)
- [Repository structure](documents/repository/REPOSITORY_STRUCTURE.md)
- [Stage 1 tracking Issue #221](https://github.com/Daiki-Yoshida/documents-artifacts/issues/221)

旧Artifact v2で採用していた`selective routing`、旧レイアウト、配布時のファイル粒度は新体系では未制定。Stage 3の正式な設計で判断する。
