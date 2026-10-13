## 設計方向の確認 — 長時間稼働中の保存・Work完了処理（2026-10-13）

このChatGPT会話における、先行する設計整理へのユーザー指摘と、その後の同意を、**別の後続source event**として記録する。

- **Coverage:** 下記のユーザー発言2件を選定した。会話全体や直前のassistant回答全文の保存ではない。最終承認が参照する設計内容は更新後のIssue本文「3. 長時間稼働・Work完了の設計方針」を確認する。
- **Fidelity:** 会話表示本文からの転記。原文APIとのbyte-for-byte一致は未検証。見出し・引用用fenceは保存時の外枠。
- **Status:** 設計方針の了承。規約の実装、Git/外部実行、mergeや追加費用の承認ではない。

### U1 — 共通規約の独立性と設計検討対象

~~~~text
Supervisor・Executor・Reviewerの概念は持ち込まないでいい。documetns-artifacts とオーケストレーションの依存関係を逆にしないで。　貯時間稼働の保存と、Work完全処理を考えていこうか
~~~~

### U2 — 提案への了承

~~~~text
これでいいと思う。
~~~~

今回確認された設計方向:

- 特定の開発オーケストレーション・エージェント役割に依存しない共通規約
- 重要な作業区切りでの軽量なファイルcheckpoint。commit/push/baseline公開との分離
- Work全体の検証・統合確認、正本reconciliation、Record締め、Archive移管・保存確認、Work Documents/資源整理、Work完了という順序
- Archive移管失敗時は元記録を保持し未完了扱い、既存Archiveへ無条件に上書きしない
- ファイル名競合や同名Work再開、公開経路、最小INDEX等の実装細部は引き続き設計・検証対象

過去の選定source Bundle（PR #205）は上書きしない。正式なknowledge / Artifact反映時にはこの追加判断も独立してrecordに取り込む。