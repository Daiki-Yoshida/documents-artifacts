# ドキュメント — 保守とレビュー

documentの削除、再読、構造変更時の確認境界を扱う。旧commit-hash version registryに依存したstaleness判定はhistoryへ分離している。

## ドキュメント削除ワークフロー

```yaml
when_to_delete:
  - "ドキュメントが廃止済み — 記述していた内容がもはや存在しない。"
  - "ドキュメントが別のドキュメントに統合され、重複している。"
  - "ユーザーが明示的に削除を求めた。"

deletion_steps:
  1: "documents/ツリー全体を検索し、当該ドキュメントへの参照を探す。"
  2: "参照している全リンクを更新または削除する。"
  3: "documents/INDEX.mdからドキュメントのエントリを削除する。"
  4: "INDEX.mdのindex_versionをバンプする（マイナー — レジストリからファイル削除）。"
  5: "コミット: 'refactor: <document>を削除' とし、本文に理由を記載する。"

rule: "他のドキュメントがまだ参照しているドキュメントを、その参照を先に修正せずに削除しない。"
confirmation: "L2_structural — タスクによって明確に暗示される場合のみ進める; 明示的に報告する。"
```

---

---

## 再読み込みトリガー

AIエージェントが行動前に本戦略を再読み込みすべきタイミング。

```yaml
must_re_read:
  - "本戦略を使用するプロジェクトへの初回接触（最初にINDEX.mdを読む）。"
  - "documents/ディレクトリツリーの作成または再構築。"
  - "AIエージェントを使用する新規プロジェクトのセットアップ。"
  - "既存プロジェクトへの本戦略導入（ブラウンフィールド）。"

should_re_read:
  - "新しいエージェントエントリファイルの追加。"
  - "ドキュメントの再構築（ディレクトリ間でファイルを移動）。"
  - "プロジェクトを単一から階層に変更（またはその逆）。"
  - "情報がどこに属するか不確実な場合。"

no_re_read_needed:
  - "既存ファイル内の日常的な内容更新。"
  - "確立されたディレクトリへの新規ドキュメントの追加。"
  - "既存のプロジェクトドキュメントの制約やステータスの更新。"
```

---

---

## 確認ゲート

ドキュメント構造を変更する前に、影響を評価する。

```yaml
L0_content: "既存ファイル内の内容更新（構造変更なし） — 進める。"
L1_additive: "既存ディレクトリへの新規ファイルの追加 — 進めて報告する。"
L2_structural: "ファイルの移動、ルーティングパスの変更、ファイル名変更、ドキュメントの削除 — タスクによって明確に暗示される場合のみ進める; 明示的に報告する。"
L3_breaking: "コアドキュメントの削除、documents/ツリー全体の再構築、プロジェクトを単一から階層に変更 — 実装前に必ず確認する。"
rule: "迷った場合はユーザーに聞く。構造変更は将来の全AIエージェントセッションに影響する。"
```

---

## 9. ドキュメント削除ルール

`documents/` 配下のドキュメントが削除される場合:

```yaml
deletion_steps:
  1: "ドキュメントが本当に廃止されたことを確認 — まずすべての相互参照をチェックする。"
  2: "削除されるドキュメントを指すすべてのリンクを削除または更新する（documents/ツリー全体を検索）。"
  3: "documents/INDEX.mdのバージョンレジストリからドキュメントのエントリを削除する。"
  4: "INDEX.mdのindex_versionを更新する（minor — レジストリからファイルが削除された）。"
  5: "コミット: 'refactor: <document>を削除' とし、本文に理由を記載する。"
rule: "他のドキュメントがまだ参照しているドキュメントを、まずその参照を修正せずに削除しない。"
```

---

## Sources

- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/documentation-strategy/DOCUMENTATION_PHILOSOPHY_JP.md`
- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/documentation-strategy/DOCUMENT_WORKFLOW_JP.md`
- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/documentation-strategy/FILE_AND_STRUCTURE_JP.md`
