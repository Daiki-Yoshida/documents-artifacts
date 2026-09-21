# ドキュメント — FormatとGit

Gitを履歴・説明責任の基盤として使う考え方、commit message、Markdown/YAML等のformat基準を扱う。

## 記録ツールとしてのGit

```yaml
principle: "Gitは何がいつ変更されたかを記録する。ドキュメントはこの記録を利用して説明責任を保つ。"
governed_aspects:
  commit_message_format: "Conventional Commitsのプレフィックス（docs:, feat:, fix:）+ 日本語の説明。FILE_AND_STRUCTURE.mdを参照。"
  version_tracking: "各ドキュメントは自身のバージョンと最後に更新されたgitコミットハッシュを記録する。FILE_AND_STRUCTURE.mdを参照。"
not_governed:
  - "いつコミットするか（コード側の決定）"
  - "ブランチを切るかどうか（コード側の決定）"
  - "レビュープロセス（コード側の決定）"
```

ドキュメントコミットはgit履歴で識別可能であるべき。コード変更を記述するドキュメント変更は、そのコード変更がどのコミットに含まれていたかを記録すべきであり、これにより読者はドキュメントがコードと一致していることを確認できる。

---

---

## 5. Gitコミットメッセージ規約

ドキュメントコミットはConventional Commitsプレフィックスと日本語説明を使用する。

### フォーマット

```yaml
format: "<type>: <日本語説明>"
types:
  docs: "ドキュメント変更（新規ファイル、コンテンツ更新、ルーティング変更）"
  feat: "新規ドキュメント機能（新規セクション、新規バージョン管理エントリ）"
  fix: "ドキュメント修正（不正確な情報の訂正）"
  refactor: "ドキュメント再構築（ファイル移動、セクション再編成）"
  chore: "メンテナンス（バージョン更新、メタデータ更新、コミットハッシュ記録）"
examples:
  - "docs: プロジェクト概要を更新"
  - "fix: API仕様のエンドポイントURLを修正"
  - "refactor: documents/reference/ 配下を整理"
  - "feat: セキュリティ要件ドキュメントを追加"
  - "chore: ドキュメントバージョンを1.2.0に更新"
```

### ルール

```yaml
rules:
  - "プレフィックス後の説明には日本語を使用する。"
  - "プレフィックスは英語（docs:, feat:, fix:, refactor:, chore:）。"
  - "説明は簡潔にし、何が変更されたかを記述する（なぜはdiffが示す）。"
  - "ドキュメントコミットがコード変更に伴う場合、ドキュメントコミットの本文にコードコミットハッシュを参照として含める。"
```

### 管理外の事項

```yaml
not_governed:
  - "いつコミットするか（これはコード側 / 開発ワークフローの決定）"
  - "ブランチするかどうか（これはコード側 / 開発ワークフローの決定）"
  - "コミットサイズや粒度（これは開発プラクティスの決定）"
```

---

---

## 6. ファイルフォーマット標準

```yaml
base_format: "埋め込みYAMLブロック付きmarkdown"
format_selection:
  structured_data: "YAML（設定、メタデータ、バージョンレジストリ、リスト）"
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
