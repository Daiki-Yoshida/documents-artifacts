# Source record: 2026-06-21-project-structure-origin-commit

```yaml
record_type: "verbatim_external_source_snapshot"
source_kind: "Git commit message"
source_repository: "Daiki-Yoshida/design-principles"
source_commit: "f2ca10fa133bfa3fccb3cee18a3028e9131209b5"
source_url: "https://github.com/Daiki-Yoshida/design-principles/commit/f2ca10fa133bfa3fccb3cee18a3028e9131209b5"
source_author_date: "2026-06-21T17:21:52Z"
retrieved_date: "2026-09-24"
source_text_status: "GitHub APIで取得したcommit messageのsnapshot"
record_body_policy: "commit message本文は無加工。changed_filesはprovenance metadataでありcommit message原文ではない"
changed_files:
  - "artifacts/CODING_STANDARDS.md"
  - "artifacts/DESIGN_PHILOSOPHY.md"
  - "artifacts/INDEX.md"
  - "artifacts/PROJECT_STRUCTURE.md"
  - "documents/project/PROJECT_OVERVIEW_JP.md"
```

## Commit message原文

~~~~text
構造・境界の物理レイアウト指針(PROJECT_STRUCTURE)を追加

成果物にモジュール公開面・共有カーネル・ランタイム位相(フロント+バック)・
テスト配置を扱う新規 artifact を追加し、既存文書と整合させた。

- artifacts/PROJECT_STRUCTURE.md を新規作成(WHERE: 物理レイアウト)
- INDEX.md: Read Order/Ownership Map/Quick Task Routing に追加、
  Document Split Policy 節を追記
- CODING_STANDARDS.md: UI Boundary 小節と ViewModel 行を追加、
  公開面/テスト配置へのポインタを追加
- DESIGN_PHILOSOPHY.md: Module 節の単一情報源ポインタを更新
- documents/project/PROJECT_OVERVIEW_JP.md: 成果物一覧を更新

Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>
~~~~
