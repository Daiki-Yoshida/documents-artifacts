# artifacts 改善の監査ガイド（日本語参考訳）

対象リポジトリ: `Daiki-Yoshida/documents-artifacts`  
監査対象: `93b0fab575f28698e61ae56202004eeab75d6861`  
比較元: `c13592d329ebfd54565c95bd21662fcc592585d8`

このディレクトリは、人間による監査用の参考資料です。日本語正本である `documents/knowledge/` でも、配布される `artifacts/` でもありません。規約の権威・配布内容を変更しません。英語文書の全文参考訳は指定の **GPT-6-Luna / high** で作成しています。以下の順序・着眼点は監査のための案内であり、新しい規約ではありません。

参考訳は上記コミットの固定スナップショットです。今後ブランチが進んでも自動更新されません。原文に出てくるファイル名・コマンド・識別子は原則そのまま残しています。本文中の相対パスは原文の配置を基準とします。

## まず読む5文書

### 1. 入口と判断の振り分け

[01 — artifacts の入口（全文参考訳）](01-artifacts-index.ja.md)

今回の変更は、作業範囲・権限・進め方だけの相談・既存コード・commit/push/reportingの判断から `operation/INDEX.md` へ辿る行の追加です。

確認したいこと:
- 必要な操作規約へ入口から辿れるか
- すべての規約を毎回読むような指示になっていないか
- 既存の通常変更・統合・安全操作の振り分けを壊していないか

照合先（日本語正本）:
- [ARTIFACT_MODEL.md](https://github.com/Daiki-Yoshida/documents-artifacts/blob/93b0fab575f28698e61ae56202004eeab75d6861/documents/knowledge/system/ARTIFACT_MODEL.md)
- [S006_VERSION_CONTROL_AND_REPORTING.md](https://github.com/Daiki-Yoshida/documents-artifacts/blob/93b0fab575f28698e61ae56202004eeab75d6861/documents/knowledge/subjects/engineering-operation/S006_VERSION_CONTROL_AND_REPORTING.md)
- [S007_BROWNFIELD_AND_APPROACH.md](https://github.com/Daiki-Yoshida/documents-artifacts/blob/93b0fab575f28698e61ae56202004eeab75d6861/documents/knowledge/subjects/engineering-operation/S007_BROWNFIELD_AND_APPROACH.md)

### 2. UIとApplicationの関係

[02 — コード構造（全文参考訳）](02-code-structure.ja.md)

今回の変更は、UI→Applicationという説明に、同一ランタイムと別ランタイムの区別を戻した点です。

確認したいこと:
- 同一デプロイ単位では既存の依存関係を維持しているか
- SPA/APIなど別ランタイムでは、バックエンド内部への直接依存を誘発しないか
- どんなモジュール間通信でもHTTPを必須にするような拡大解釈になっていないか

照合先（日本語正本）:
- [S009_TESTING_AND_RUNTIME.md](https://github.com/Daiki-Yoshida/documents-artifacts/blob/93b0fab575f28698e61ae56202004eeab75d6861/documents/knowledge/subjects/code-design/S009_TESTING_AND_RUNTIME.md)

### 3. worktreeの作成・削除条件

[03 — worktree（全文参考訳）](03-worktrees.ja.md)

今回の変更は2点です。作成時のignore境界と成功条件、削除時のidentity/branch一致とcommit保全条件を補っています。

確認したいこと:
- Work Documentsを一括ignoreしてしまわないか
- コマンド終了コードが0でも、作成後の状態が条件を満たさなければ成功としないか
- 「パスはalphaだが実際のbranchはbeta」のような不一致を削除前に止められるか
- commit保全をプロジェクト方針で判断し、常にremote push必須という新ルールにしていないか
- sparse materializationを不要な独立Component Repositoryへ無条件適用していないか

照合先（日本語正本）:
- [S006_WORKTREE_COMMANDS.md](https://github.com/Daiki-Yoshida/documents-artifacts/blob/93b0fab575f28698e61ae56202004eeab75d6861/documents/knowledge/subjects/work-identity/S006_WORKTREE_COMMANDS.md)
  - 主な照合箇所: Create preflight / Create postconditions / Remove contract

### 4. 復旧完了の基準

[04 — 診断と復旧（全文参考訳）](04-diagnostics-and-recovery.ja.md)

今回の変更は、「失敗した元の操作が再実行され成功したこと」を復旧完了の条件として戻した点です。

確認したいこと:
- 補助チェックだけの成功で復旧完了としないか
- 再実行が危険・未承認・実行不能なら、無理に繰り返さず未検証／未完了と報告するか

照合先（日本語正本）:
- [S003_DIAGNOSTICS_AND_RECOVERY.md](https://github.com/Daiki-Yoshida/documents-artifacts/blob/93b0fab575f28698e61ae56202004eeab75d6861/documents/knowledge/subjects/development-safety/S003_DIAGNOSTICS_AND_RECOVERY.md)

### 5. 検証の結果と限界

[05 — 評価キャンペーンまとめ（全文参考訳）](05-campaign-summary.ja.md)

最初は「既存シナリオの集計」と「限界」を読み、その後に日付付き追補を読むと経過を追えます。途中時点の「pending」と後続の完了記録は、原文どおり時系列で残しています。

確認したいこと:
- 元の24シナリオのうち20件を評価し、Docker依存の4件を未実行としているか
- 新しいpilotや再実行を、元のシナリオ数と混同していないか
- 実装ミス・曖昧な承認条件・成功した再実行を、過去の結果を書き換えずに残しているか
- 自己申告の読了、観測したOPEN、出力の正しさを区別しているか
- OPENをモデルの理解や因果的な改善の証明にしていないか

検証基盤の説明を詳しく見る場合は、既存の日本語説明 [AGENT_ARTIFACT_TEST_HARNESS.md](https://github.com/Daiki-Yoshida/documents-artifacts/blob/93b0fab575f28698e61ae56202004eeab75d6861/documents/project/AGENT_ARTIFACT_TEST_HARNESS.md) を参照してください。

## 差分全体の確認

[比較元から監査対象までの差分](https://github.com/Daiki-Yoshida/documents-artifacts/compare/c13592d329ebfd54565c95bd21662fcc592585d8...93b0fab575f28698e61ae56202004eeab75d6861)

配布用規約で変更したのは上記1〜4の4ファイルです。差分全体には検証スクリプト、新しいfixture/scenario、導入説明、評価まとめも含まれます。このガイドはコードの逐語訳ではありません。

日本語正本 `documents/knowledge/**` と `docs-jp/**` は監査対象まで変更していません。PR #137は古い途中段階のDraftであり、専用ブランチ全体の監査対象とは一致しません。

## 指摘を残すとき

文書名・見出し・該当文と、対応する日本語正本の箇所を添えると、翻訳の問題か、artifactsの投影・導線の問題かを切り分けやすくなります。参考訳の表現に疑問がある場合も、正本と固定した英語原文を照合してください。
