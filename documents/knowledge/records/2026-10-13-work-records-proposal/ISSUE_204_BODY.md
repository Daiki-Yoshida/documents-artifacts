## 背景・目的

ブラウザChatGPT、WSL内のCLI実行エージェント、レビュー担当など、実行主体にかかわらず、リポジトリに関係する開発・調査・変更・検証の重要な経緯を**リポジトリ自身が引き継げる**ようにする。

Gitのcommit/PRは変更と統合の証跡として重要だが、会話で生まれた判断理由、検討・棄却の経緯、発生した問題、原因究明、エージェント間のやり取りが常に十分記録されるわけではない。Chat履歴・CLIセッションだけに残る知識が喪失する問題を解決したい。

このIssueは**Work Records Protocolの設計・規約化を検討するためのIssue**であり、作成時点でコード・canonical subjects・runtime artifactsの変更を承認するものではない。

## 今回の会話で確認された設計方向

### Work進行中: Work Records

- Work Documentsは従来どおり `.worktrees/<work-type>/<work-name>/documents/` に置く。
- その中に、開発中の判断・調査・問題・解決・検証等を記録する **Work Records** の領域を設ける。候補: `.../documents/records/`。
- ブラウザChat / CLI agent / review agentなど、実行主体とUIの違いに依存せず共通の記録原則を適用する。
- 目的は必要な開発経緯の保存であり、全ツール呼出・全発言を無差別に複写することではない。記録契機・粒度・保全すべき判断の基準は本Issueで明確化する。
- `documents-artifacts`自身の `documents/knowledge/records/`（厳密な第0情報源原文保存）と、一般ProjectのWork Records（適切な開発過程の記録）は**別の保存責務**。厳密な逐語記録を全Work Recordsへ強制しない。

### Work完了時: 正本文書への吸収と履歴記録の移管

- 元来のWork Documentsの意図は「**開発終了後、永続的な知識は通常のProject Documentationへ吸収・整理され、役目を終えたWork Documentsは削除してよい。削除後もGit履歴に残る**」である。
- その意図を維持し、現行仕様・確定設計・長期的な制約と必要な判断理由は、従来どおり適切な `<project-root>/documents/` の正本へreconcileする。
- 一方、Work Recordsに蓄積された**開発過程そのものの歴史的記録**は、Work完了後に、通常参照しないProject-ownedのarchiveへ移す案を検討する。配置候補は `<project-root>/documents/archive/works/<work-type>/<work-name>/`。
- Archiveは現在有効な仕様のauthorityではない。通常のAI taskで自動preloadせず、過去の判断を調査するときだけWork Identity等から発見・参照できるようにする。
- Work Documents全体を機械的に永久保存する案ではない。Records以外は既存のreconciliation / cleanup原則を維持する。
- Gitは引き続きファイルのバージョン履歴を管理し、archiveは**歴史的記録の現在の所在と発見可能性**を担う。別の履歴DB・独自version registryは導入しない。

## 記録の品質と運用上の確認事項

1. **記録契機・粒度:** 重要な判断・仕様変更・調査結果・問題発見と解決・検証・引継ぎ・Work終了など、何を必須にするか。無意味な操作ログで埋めない。
2. **Minimum useful record:** Work Identity、実行主体、目的、判断理由、確認した事実と未確認事項、結果、関連Issue/PR/commit/検証証拠を必要な範囲で残す。固定テンプレートを過度に強制しない。
3. **証拠と申告:** 他エージェントの報告と、自分が実際に確認した証拠を区別する。推測や失敗も後から「成功」に書き換えない。
4. **中間保存:** 長時間実行中にcontext/sessionが失われても主要判断が残るよう、重要な区切りで適切に追記・保存できること。
5. **公開・書込み権限:** Work Recordsの記録義務は、新たなcommit/push/merge・外部資源消費・監視システム起動の権限を与えない。Project-local workflowのauthorityに従い、公開できない場合はpendingと区別する。
6. **機密・公開範囲:** Chatやログの転載に伴う秘密情報・個人情報・認証情報の混入を防ぎ、記録不能な部分は限界を明示する。
7. **完了/移管:** 複数Component RepositoryにまたがるWorkの全体完了を確認してからarchiveする。正本へのreconciliation、移管後の参照、Git所有権、同名Workの再開・衝突、移管失敗時の保全を検討する。
8. **Routing:** 通常の`documents/INDEX.md`に全archiveを展開しない。必要時のみ辿れる軽量入口・Workごとの識別方法を検討する。

## 既存規約との整合・変更候補

現在の`work-identity/S003_WORK_DOCUMENTS.md`および`documentation/S003_WORKFLOW.md`には「Work Documentsをreconcileし、歴史のための独自archiveを作らずGit historyを使用する」旨がある。これは元来、吸収後の不要なWork Documentsを重複保持しないという意図だった。

本案はそのreconciliation原則を保ったまま、**Work Recordsという異なる性質の履歴資料に限って明示的なarchive保存を追加する**ものである。既存記述を単純に削るのではなく、その適用範囲を意味上明確にする。

検討する所有領域:

- `documents/knowledge/subjects/work-identity/S003_WORK_DOCUMENTS.md` — Work Recordsの位置・所有・archiveへの移管
- `.../work-identity/S004_LIFECYCLE_AND_RESOURCES.md` — Work完了処理・multiple repositories
- `.../engineering-operation/` — AI作業時の記録契機・証拠・reporting・VCS authority
- `.../documentation/` — Project正本への統合とhistorical archiveのrouting/maintenance
- 採用後に`artifacts/project/`、`artifacts/operation/`、`artifacts/documentation/` の関係leafへ最小限にprojectionする

`documents/knowledge/records/`（本リポジトリの原文保存）とProject-specific `documents/archive/works/`（提案するWork完了後の開発史）を混同しない。

## 進め方・完了条件（次の実装Work向け）

- [ ] この議論・ユーザー判断・Issue本文を、現行`RECORD_MODEL.md`に従う新規source recordとして保存する（このIssue準備作業の一部）。
- [ ] 現行正本とsource設計原本を読み、意味上の差分・ownership・具体的な記録発火条件を確定する。
- [ ] Work Recordsの軽量な保存例（ブラウザChatとCLI agent双方）を設計・検証する。
- [ ] Work終了時の正本reconciliation → archive移管 → Work Documents整理を、Git履歴・所有権・失敗時の保全込みで定義する。
- [ ] ユーザーが採用した規約を`records → subjects → artifacts`の順序で正規化する。不要な二重authorityを作らない。
- [ ] 適切なテスト・独立レビューで通常routingと終了後の履歴発見を検証し、実行していない検証をPASS扱いしない。
- [ ] 必要なProjectへの導入・同期は、各Projectの権限と手順に従って別途判断する。

## 非目標・権限境界

- 現時点でのcanonical / Artifactの即時改変、既存Work Documentsの一括移動や削除。
- 全Chat/全CLI出力の無差別コピー、常駐監視デーモン、別履歴DB、追加の外部サービス導入。
- GitHub Actions・外部CI・有料実行基盤の無断利用。
- Issue作成やsource record保存を、今後の設計実装・Work Identity確定・PR mergeの包括承認と解釈すること。

出典となった2026-10-13のChatGPT会話は、Source inventoryで範囲とFidelityを明示した独立したrecordへ保存する。