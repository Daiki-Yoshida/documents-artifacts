# Tests — dev-artifacts restructuring

このブランチでは、Stageごとに有効なテストを区別する。

## Stage 1：新しい管理モデル・階層

```bash
bash tests/test-dev-artifacts-stage1.sh
```

このチェックは、モデル・運用文書の存在、旧管理ルートの除去、recordsと層別subjects領域の維持などを検証する。**records→subjectsの内容品質やAIの行動検証を証明するものではない**。

## 旧Artifact v2テストの扱い

既存の `test-artifacts.sh`、`test-knowledge-integrity.sh`、`test-agent-harness.sh`、旧fixtures/scenarios/evaluationsは、**旧packと旧ディレクトリ配置を前提にした参考資産**として残している。開発ブランチの `subjects/` と `artifacts/` は意図的に未構築のため、これら旧テストの失敗をStage 1設計の失敗と混同しない。

新しいStage 2・3の検証契約と必要なテスト更新は、それぞれの段階で決定する。旧テストを実行した場合は、結果と非適用理由を区別して報告する。

旧 `tests/INDEX.md` の全文は[旧テスト仕様](../documents/repository/legacy/project/TESTS_INDEX_V2.md)として保全している（現行の実行指示ではない）。

[Repository models](../documents/repository/models/INDEX.md) / [Issue #221](https://github.com/Daiki-Yoshida/documents-artifacts/issues/221)
