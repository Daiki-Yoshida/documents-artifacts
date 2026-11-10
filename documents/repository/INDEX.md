# Repository Design

`documents/repository/` は、dev-artifacts リポジトリ自身の構造・知識管理契約・運用方法を扱う領域である。

## 採用された責務分離

| 領域 | 所有する責務 |
| --- | --- |
| `models/` | 知識体系の構造、各領域の責務、定義権、管理上の契約 |
| `operations/` | models の規則を具体的なリポジトリ管理・更新・検証へ適用する手順 |
| `REPOSITORY_STRUCTURE.md` | リポジトリ内の配置と管理対象の境界 |

`models/` は運用コマンドを定義する場所ではなく、`operations/` はモデルの意味を再定義する場所ではない。

## 知識と権威

- `documents/knowledge/records/` は原文・判断・証拠の保存先であり、従来の保存形状を維持する。
- `documents/knowledge/subjects/` は Dev-Philosophy と Dev-Methodology の正本を保持する。実際の内容と records → subjects の規則はStage 2で整備する。
- Dev-Philosophy の **内容の制定権はOwnerが持つ**。管理モデルが哲学の内容を独自に制定するわけではない。
- `artifacts/` は正本をAI向けに提供する配布物であり、射影規則・具体的構造はStage 3で決める。
- 未完成の開発ブランチは既存の`main`配布物に代わるものではない。

## 状態

**Stage 1 の階層案と領域の責務は採用済み。Stage 1全体は未完了。**

旧 `documents/knowledge/system/` と `documents/project/` の既存文書は、移行・相互参照の整理が済むまで、この開発ブランチに元のパスで残している。二重の規則を独立に制定する意図はない。

設計とOwner判断の追跡: [Issue #221](https://github.com/Daiki-Yoshida/documents-artifacts/issues/221)。この文書は原文recordの代替ではない。
