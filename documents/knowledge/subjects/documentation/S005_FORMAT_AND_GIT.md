# ドキュメント — FormatとGit

Gitを履歴・説明責任の基盤として使う考え方、commit message、Markdown/YAML等のformat基準を扱う。

## 記録ツールとしてのGit

```yaml
principle: "Gitは何がいつ変更されたかを記録する。ドキュメントはこの記録を利用して説明責任を保つ。"
governed_aspects:
  commit_message_format: "project conventionを優先し、独自規則がなければConventional Commits系の明示的なprefix + 説明を推奨"
  history_tracking: "変更・移動・削除の履歴はGit historyを利用する"
not_governed:
  - "いつcommit/pushするか（engineering-operationのversion-control authority）"
  - "Work固有branch / worktreeのidentity・lifecycle・materialization（work-identityが主所有。default branch guardやcommit / push authorityはengineering-operation）"
  - "code changeのreview process（engineering-operation / project-local workflowの責務）"
```

ドキュメント変更はGit historyで追跡可能にする。実装との対応確認が必要な場合はGit log / diffや関連Issue・PRを利用し、document固有の `last_updated_commit` を必須化しない。

---

---

## 5. Gitコミットメッセージ規約

projectに既存のcommit conventionがある場合はそれを優先する。独自規則がない場合は、Conventional Commits系prefix + 日本語説明を推奨する。

### フォーマット

```yaml
recommended_format: "<type>: <日本語説明>"
types:
  docs: "ドキュメント変更（新規ファイル、コンテンツ更新、ルーティング変更）"
  feat: "新規ドキュメント機能または大きな情報追加"
  fix: "ドキュメント修正（不正確な情報の訂正）"
  refactor: "ドキュメント再構築（ファイル移動、セクション再編成）"
  chore: "documentation tooling / metadata等のmaintenance"
examples:
  - "docs: プロジェクト概要を更新"
  - "fix: API仕様のエンドポイントURLを修正"
  - "refactor: documents/reference/ 配下を整理"
  - "feat: セキュリティ要件ドキュメントを追加"
  - "chore: documentation routing metadataを更新"
```

### ルール

```yaml
rules:
  - "project固有規則がなければ、プレフィックス後の説明には日本語を推奨する。"
  - "project固有規則がなければ、英語prefix（docs:, feat:, fix:, refactor:, chore:）を推奨する。"
  - "説明は簡潔にし、何が変更されたかを記述する（なぜはdiffが示す）。"
  - "実装commit / Issue / PRへの参照が追跡上有用な場合はcommit本文等へ記載してよい。"
```

### 管理外の事項

```yaml
not_governed:
  - "いつcommit/pushするか（`../engineering-operation/S006_VERSION_CONTROL_AND_REPORTING.md` が主所有）"
  - "Work固有branch / worktreeをどうmaterializeするか（work-identityが主所有。default branch guardやcommit / push authorityはengineering-operation）"
  - "commit size / granularity（project-local engineering workflowへroute）"
```

---

---

## 6. ファイルフォーマット標準

```yaml
base_format: "埋め込みYAMLブロック付きmarkdown"
format_selection:
  structured_data: "YAML（設定、メタデータ、リスト等）"
  explanations: "markdown（手順、ガイド、根拠）"
  api_specs: "JSONまたはYAML（OpenAPI、マシン可読スキーマ）"
  mixed: "markdown + YAMLブロック（1ファイルで構造+コンテキスト）"
naming: "ファイルは小文字・ハイフン区切り; ディレクトリは小文字"
```

---

## Sources

- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/documentation-strategy/DOCUMENTATION_PHILOSOPHY_JP.md`
- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/documentation-strategy/DOCUMENT_WORKFLOW_JP.md`
- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/documentation-strategy/FILE_AND_STRUCTURE_JP.md`
- `../../records/2026-07-09-documentation-atomicity-commit/RECORD.md`（historical intermediate policy）
- `../../records/2026-07-09-documentation-v2-restructure-commit/RECORD.md`（branch/timingをdocumentation scope外へ再整理）
- `../engineering-operation/S006_VERSION_CONTROL_AND_REPORTING.md`
