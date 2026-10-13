## 最終レポート

### 参照したプロジェクト文書・再利用ガイダンス

**プロジェクト所有:**
- `README.md` — 検証ワークフロー（`tests/test-preview.sh`、`tests/test-export.sh`、`scripts/verify.sh`）
- `documents/INDEX.md` — 契約・検証のエントリポイント
- `documents/contact-export-v1.md` — 公開エクスポート契約（`<TAB>` 後の名前バイトは**元の輸入文字列をそのまま**保持することが必須と明記。プレビューの空白は「プレゼンテーション」であり別の所有者）

**インストール済み再利用ガイダンス（`documents/artifacts/`、読み取りのみ）:**
- `artifacts/INDEX.md` — ルータ
- `artifacts/operation/CHANGE_LIFECYCLE.md` — 変更ライフサイクル
- `artifacts/operation/PRE_IMPLEMENTATION_SCAN.md` — 実装前スキャン
- `artifacts/design/CONTRACTS.md` — 契約変更レベル（今回の修正は L0/L1 の内部プレゼンテーション変更。共有の `contact_name` を正規化すると公開ワイヤ契約の L3 破壊的変更になるため不可と判断）
- `artifacts/implementation/COMPATIBILITY.md` — 互換性の確認観点
- `artifacts/operation/VERIFICATION_AND_DONE.md` — 完了報告の要件

### 変更内容と理由

**変更ファイル:** `src/internal/preview.sh` のみ（12行追加・2行削除）

- `contact_name`（`src/shared/name.sh`）は**変更していません**。これはプレビューと公開エクスポートの両方が使う「生の輸入値」であり、ここを正規化すると `contact-export-v1.md` の公開契約（空白をそのまま保持）を壊します。
- 代わりにスタッフ向け表示層である `preview_contact` 内で、表示用コピー `display_name` に対してのみ正規化を実施:
  - `shopt -s extglob` を有効化し、`${display_name//+( )/ }` で連続する ASCII スペースを1つに圧縮
  - `${display_name# }` / `${display_name% }` で先頭・末尾のスペースを除去
- 外部コマンド（`tr`/`sed`/`awk` 等）を使わない Bash 純粋実装で、README の「Bash-only・依存インストール不要」方針に合致。`read -a` 方式と違い、パス名展開や埋め込み改行での打ち切りの懸念もありません。
- 不具合を示す旧コメント（`# Current defect: ...`）を、正規化の意図を説明するコメントに更新。

### 実行したコマンドと結果

| コマンド | 結果 |
|---|---|
| `git status --short && git log --oneline -5` | 変更前はクリーンなツリー |
| `bash tests/test-preview.sh` | `PASS: staff preview formatting` |
| `bash tests/test-export.sh` | `PASS: published export compatibility` |
| `bash scripts/verify.sh` | `PASS: Contact CLI final verification`（最終ゲート） |
| `bash bin/contactctl preview '  Ada   Lovelace  '` (`cat -A` 確認） | `Name: Ada Lovelace$` — 期待通り |
| `bash bin/contactctl export '  Ada   Lovelace  '` (`cat -A` 確認） | `contact^I  Ada   Lovelace  $` — 生バイト保持、契約遵守 |
| `bash bin/contactctl preview '   '` | `Name: ` — 空白のみの入力も安全に処理 |
| `bash bin/contactctl preview 'A  B    C'` | `Name: A B C` |
| `git diff --stat` | `src/internal/preview.sh` のみ変更 |

### 残る不確実性・未検証事項

- タスク記載の「スペース」のみを正規化対象とし、タブや改行など他の空白文字は意図的にそのまま残しています（エクスポートの生値と同様、報告された不具合範囲に限定）。タブを含む名前の表示を畳むべきかどうかは要件に明記なし。
- エクスポート側は一切変更せず、公開契約テストで互換性を確認済み。
- 未実施: コミット作成（依頼されていないため）。管理対象の `documents/artifacts/` スナップショットには触れていません。
