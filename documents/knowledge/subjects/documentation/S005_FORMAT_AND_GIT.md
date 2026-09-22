# ドキュメント — FormatとGit

Gitを履歴・説明責任の基盤として使う考え方、commit message、Markdown/YAML等のformat基準を扱う。

## Gitを履歴機構として使う

```yaml
principle: "documentの変更・移動・削除の履歴はGitが所有する"
use:
  - "いつ何が変わったか"
  - "過去の内容"
  - "rename / deletionの追跡"
  - "実装変更との対応確認"
avoid:
  - "Gitと同じ履歴を複製するarchive directory"
  - "必須document Semantic Version"
  - "last_updated_commit registry"
  - "履歴専用のparallel database"
```

documentが現在の実装と一致するかは、必要に応じてGit diff / log、関連source、test、decision recordを照合して判断する。単一metadataがHEADより古いというだけでstaleと確定しない。

## Commit message

projectに既存のcommit conventionがある場合はそれを優先する。

独自規則がない場合は、document変更を識別可能な簡潔なmessageを推奨する。

```text
docs: プロジェクト概要を更新
fix: API仕様の不正確な記述を修正
refactor: documentation routingを整理
```

commit message本文には、変更理由・関連Issue・実装commit等が追跡上有用な場合だけ記載する。document自身へcommit hashを埋め込むことは必須ではない。

## Format

formatは内容の役割に合わせる。

```yaml
markdown: "説明、判断、workflow、guide"
yaml: "人とmachineの双方が扱う構造化情報"
json_or_schema: "machine-readable specification"
mixed: "Markdown本文 + 必要なYAML/code block"
```

format選択の原則:

- projectの既存conventionを尊重する。
- machine-readableである必要がなければ、構造化のためだけに過剰なmetadataを追加しない。
- headingとfile nameは内容の主責務を表す。
- format変換だけを目的に情報の意味を落とさない。

## Sources

- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/documentation-strategy/DOCUMENTATION_PHILOSOPHY_JP.md`
- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/documentation-strategy/DOCUMENT_WORKFLOW_JP.md`
- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/documentation-strategy/FILE_AND_STRUCTURE_JP.md`
- `../../records/2026-09-22-six-subject-cross-audit-fixes/`
