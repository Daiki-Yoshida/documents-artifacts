# Source record: 2026-09-23-knowledge-integrity-implementation

```yaml
record_type: "verbatim_external_source_snapshot"
source_kind: "GitHub PR body"
source_url: "https://github.com/Daiki-Yoshida/documents-artifacts/pull/31"
source_created_at: "2026-09-23T20:34:02Z"
source_updated_at: "2026-09-23T21:12:02Z"
retrieved_date: "2026-09-24"
source_text_status: "GitHub APIで取得した現存PR本文のsnapshot。作成当時から無編集かは未検証"
record_body_policy: "PR本文は無加工。ユーザーの短文指示や直前AI提案の原文とは区別する"
```

## 取得本文（原文）

~~~~text
## 目的

PR #28 マージ後のmain（`e760eb38841650d60739750953c8342b639ce6f0`）から、knowledge architecture残課題の**第1段階**として、古いrepository-local説明・参照・監査状態を修復する。旧artifactの意味移行完了を宣言するPRではない。

## 変更内容

- `KNOWLEDGE_UPDATE_WORKFLOW.md`: 旧単一file record参照を実在するrecordへ修正し、records → subjects → artifactsの更新フロー、短文承認のprovenance確認を反映。
- `REPOSITORY_STRUCTURE.md`: 旧 `K-YYYY-MM-DD-NNN.md` 構造を現行system / records / subjects構造へ更新。
- `docs-jp/README.md`: 旧「artifactsが唯一の正本」を現行knowledge-firstへ訂正。元の2026-09-21版はrecords snapshotに保存済み。
- `KNOWLEDGE_MIGRATION_STATUS.md`: 現行6 subject、旧docs-jp 16/16 snapshot、未移行テーマを反映。
- `LEGACY_ARTIFACT_COVERAGE_AUDIT.md`: 旧artifact14ファイルをsnapshot commitと各Git blob SHAで固定。コード設計・横断AI workflow等の未移行候補と未検証事項を区別。
- `semantic-preservation-candidate/` 6文書: **現在は非正本の歴史的再構成候補**と冒頭で明示。本文中の当時の検討内容は消さない。
- `tests/test-knowledge-integrity.sh`: subject連番 / HISTORY最後 / record命名・envelope / 現行entrypointの相対Markdownリンク / 旧artifact14件のSHA形式・重複・取得可能な場合の歴史的Git blob一致 / 旧候補のauthority表記を検証。
- 「修正を開始。」のユーザー原文を `records/` に保存。

## レビュー中の追加修正

1. **原文言語の規則を訂正。** 現行 `documents/knowledge/INDEX.md` はすでに「recordsは原文保持、subjects/systemは日本語標準」と定めている。古い移行状況文書から引き継いだ「英語原文の保存方式は未決定」という誤記を解消。残課題は旧第2情報源しか残らない知識の**元source・採用状態・provenance**の検証と明記し、Issue #29も整合。
2. **回帰テストを強化。** 行数だけでなく14件のファイル名・40文字SHA・重複と、snapshot commitが利用可能なcheckoutで実際のGit blob一致を検査。shallow checkoutでは明示warningを出す。
3. **歴史的候補のMarkdown段落修正。** 警告blockquoteと元の説明文が連結されないよう改行を調整。

## 検証状況

- GitHub上のbranch tree：6 subject、16 record directory。連番 / HISTORY最後 / record命名 / record envelopeの構造上の問題なし。
- 現行entrypointのMarkdown相対リンク：確認した13件の参照先が実在。
- 旧artifact14行の各blob SHAは、記載snapshot commitのGit treeと14/14一致。
- 旧再構成候補6文書はすべて冒頭に非正本警告があり、current `canonical_source` metadataなし。
- GitHubから取得したBashテストをローカルの模擬directoryで構文検証・正常系実行。重複entryと不正record名を注入し、エラー検出を確認。

**未実施：** 実repositoryのcloneがこの実行環境でDNS解決できないため、実checkout上でのBashテスト全体実行とCI実行。手元の完全履歴checkoutで `bash -n tests/test-knowledge-integrity.sh && bash tests/test-knowledge-integrity.sh` を実施する。

## 非対象と残課題

- 既存の`artifacts/` と配布script、6 subjectの現行normative本文、旧records / snapshotは変更しない。
- 旧artifactの意味ごとの移行と新subjectの採否は未完了。
- 旧artifactの本文は第2情報源であり、元sourceがないまま第0情報源に昇格させない。

継続課題: Issue #29（旧artifact14件のsource / 意味coverage）、Issue #30（短文承認に対応するAI提案の原文追跡）。

Draftのまま保持し、明示的なマージ指示を受けてからマージする。

~~~~
