# Knowledge Update Workflow — Stage 1

この文書は`documents/repository/models/`の管理契約に基づき、dev-artifactsリポジトリ内での**更新手順**を定める。規範の意味や哲学の内容を独立に再定義しない。

## 情報源の取り込み

1. 新しい採用・却下・訂正・検証に関わる第0情報源を確認する。
2. [RECORD_MODEL](../models/RECORD_MODEL.md)に従い、event / bundle / snapshotの適切な単位で`documents/knowledge/records/YYYY-MM-DD-<short-title>/`へ保存する。
3. sourceの境界、locator、Coverage、Fidelityを明示する。承認など短い発言は対象提案・検証への参照を失わせない。
4. 旧recordを後続判断で上書きしない。転記ミスの訂正は原文照合に基づく。
5. 意味上の権威・変更の有効性は[Decision Lineage](../models/DECISION_LINEAGE_MODEL.md)を根拠に判断する。Issueの状態や日付だけで採否を確定しない。

## 哲学の制定と改訂

Dev-Philosophyの制定・意味変更・撤回には**Ownerの明示的な最終承認**が必要。AIの抽出や文書化は候補として扱う。承認対象を特定し、証拠となるsource eventをrecordへ保存してから正式な制定済み内容へ反映する。

未承認候補の配置・昇格や、実際のrecords→subjects処理は**Stage 2**の規則で定める。現段階で新しい属する意味を恣意的に追加しない。

## Stageごとの更新境界

- **Stage 1:** `repository/models/`、`operations/`、入口文書および体系の権威・所有を整える。`subjects/`と`artifacts/`は未構築。
- **Stage 2:** records→subjectsの詳細ルールを制定し、Dev-PhilosophyとDev-Methodologyの正本を構築する。
- **Stage 3:** 実際のsubjectsを確認して、artifactsの構造、射影、読み込み、配布を制定する。

Stage 2・3が未制定であることを、過去のArtifact v2の規則で補完しない。

## リポジトリ変更

- 開発ブランチ: `refactor/dev-artifacts-restructure`。`main`の既存運用・配布物へ変更を加えない。
- 変更前に現行の関連文書とGitHub Issue / PRを確認する。
- modelsの意味を変更する前にOwner判断など根拠になるsource eventをrecordへ保存する。
- 調査・提案・Owner採用・実際のGitHub反映を区別する。
- 既存の記録、採用/却下の関係、Decision Lineageを取り込み直すために書き換えない。
- 検証はStageに相応しいものを実施し、未実行テストをPASSと報告しない。
- Stage 1の構造smokeは `bash tests/test-dev-artifacts-stage1.sh`。旧Artifact v2専用テストは未構築のsubjects/artifactsに非適用であり、Stage 2・3で新体系に応じて見直す。

旧Artifact v2の手順とAgent評価設備は [legacy](../legacy/INDEX.md) に保存し、Stage 3の方式が定まるまで未完成packを配布しない。

## Links

[Repository models](../models/INDEX.md) / [Stage 1 design issue](https://github.com/Daiki-Yoshida/documents-artifacts/issues/221)
