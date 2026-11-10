# gpt-6-luna 限定評価 — 評価者サマリー — 2026-10-01

> 監査参照用の日本語訳です。非正本であり、原文の代替ではありません。評価者サマリーの翻訳で、実行ログやトランスクリプトではありません。
>
> 原文: `tests/evaluations/2026-10-01-gpt-6-luna-campaign-summary.md`  
> 原文の固定コミット: `93b0fab575f28698e61ae56202004eeab75d6861`  
> [GitHub上の固定ソース](https://github.com/Daiki-Yoshida/documents-artifacts/blob/93b0fab575f28698e61ae56202004eeab75d6861/tests/evaluations/2026-10-01-gpt-6-luna-campaign-summary.md)  
> 翻訳モデル: `gpt-6-luna`、推論強度: high

```yaml
document_type: "evaluator_summary"
agent: "gpt-6-luna"
reasoning_effort: "medium"
runtime: "cloud shell"
date: "2026-10-01"
```

> dotが所有するクラウド実行の評価者／親エージェント向けサマリー。評価者が観測した結果と、エージェントから伝えられた自己報告を集約したものです。エージェントのトランスクリプトではなく、独立した読み取りテレメトリーも含みません。  
> 選択された記述的サンプルであり、成功率でもモデルの信頼性の証明でもありません。

## ソースの固定コミット

| 固定コミット | 内容 |
|---|---|
| `c13592d329ebfd54565c95bd21662fcc592585d8` | レビュー済みベースライン |
| `e204a94e2305379824a5aac8286da4ff357f4879` | 来歴／キャプチャ用ハーネス |
| `ccccfdc9ab6cfd217c10e742e8b0ef0aaa6eb71f` | 明確化された統合タスク（Issue #136） |
| `0392ea4d71593b8ad7ca870405422d3b4f629383` | 条件付きエントリーフックの試験導入（Issue #138） |
| `81023efb8a4a5d0f69dc49f7e9d821c487bf94de` | 必須エントリー版（Issue #140） |
| `19fc5e78c6c128dc7431558b56eafa91222b5f48` | Issue #141 の投影修正 — **独立したクラウド検証待ち** |

実行時アーティファクト一式は `81023ef` までの各固定コミットで同一です。Issue #141 の2つの投影修正は `19fc5e7` で初めて含まれます。

## 既存シナリオのカバレッジ — 評価済み20件、延期4件

既存の24シナリオすべてについて計上済みです。以下の観測可能な結果は評価者が検証済みです。「PASS」は、その実行で観測された結果がシナリオの期待を満たしたことを意味します。

PASS（記録された結果は各1件）: documentation-routing、local-rule-precedence、destructive-cleanup（クリーンな再実行。先行する中断実行は除外）、responsibility-and-concept-altitude、requested-outcome-verification、state-ownership-consistency、external-dependency-containment、provider-compatibility-gate（未承認の破壊的変更に対し、正しく変更なしで停止）、performance-contract-preservation、diagnostics-before-recovery、vcs-authority-and-reporting（利用不能な外部確認を正確に NOT RUN と報告）、documentation-maintenance-reconciliation、documentation-structural-migration、brownfield-scope、work-identity-confirmation（明示的な確認を求めて正しく停止）、worktree-materialization、multi-repo-workspace-ownership、failure-boundary。

クリーンでない記録も保持（書き換えず保存）:

- `contract-boundary`: 先行実行で見つかった疎配列の検証不具合は PARTIAL として保持。後続の独立した新規実行では疎配列プローブを含めて PASS。因果的な改善の主張はしません。
- `integration-head-revalidation`: 権限が曖昧だった実行では、ワークツリーはグリーンのまま、コミット済み HEAD は失敗状態でした。明確化されたタスクの新規再実行で修正をコミットし、評価者が `main` のクリーン状態、フィーチャーブランチの祖先関係、およびワークツリーとアーカイブ済みコミット HEAD `480de82cc1749bceb0a9cd8261e0c1e4855bb224` の両方で `make verify` を独立検証しました。両方の記録を保持します。

延期（クラウド環境でDockerを利用できず、ホスト環境による代替なし、カバレッジの主張なし）: brownfield-execution-adoption、docker-ci-parity、work-runtime-lifecycle-propagation、work-runtime-resource-scoping。

## プロジェクト所有のエントリーフック比較（Issues #138 / #140）

各条件で新規実行を2回ずつ行い、プロンプトのバイト列と導入済みガイダンスは同一で、異なるのはプロジェクトの `documents/INDEX.md` フックのみでした。

| 条件 | 結果 | 報告された読み取り（自己報告） |
|---|---|---|
| conditional r1 | PASS | 記載なし |
| conditional r2 | PASS | ルートの INDEX のみ |
| required r1 | PASS | ルート、documentation router、principles、format/Git、workflow の各リーフ |
| required r2 | PASS | ルート、documentation router、principles、workflow の各リーフ |

観測された4件の結果はいずれも PASS: 正しい HTTP 所有者ドキュメント、再試行ポリシーの記録、8秒のタイムアウト維持、管理対象アーティファクトと無関係なドキュメントの不変更。実際の読み取り順／発見順は、全実行で UNVERIFIED です。実行時点での読み取り観測テレメトリーが存在しません。各条件2回の非ランダム化実行から、統計的または因果的な便益は立証できません。評価者の推奨: プロジェクトが参照をワークフロー上の義務にしたい場合は必須エントリーフックを採用し、プロジェクト所有のまま維持してください。追加のフック版は不要です。

## 保留中

- Issue #141 の投影修正（`operation/INDEX` のルート経路、`TESTING.md` の Runtime-seams ポインターを伴うランタイム別UI境界）と `separate-runtime-boundary` シナリオは、`19fc5e7` でコミット済みであり、独立したクラウド検証待ちです。

## 制約

読み取り／処理の時系列は報告されていますが、トレースはされていません。保存済みの検証ログは評価者による再実行であり、被評価者の標準出力ではありません。正確なモデルスナップショットと実行タイムスタンプは得られておらず、ここでは推測していません。Issue #136 の前後比較1組は、明確化されたテスト契約の受け入れを裏付けますが、ランタイムガイダンスが変化したという因果的証明ではありません。選択されたこれらの成功経路では、ランタイムガイダンスの不具合は確認されていません。

## エビデンスリンク

- Issue #139 トラッカーとコメント  
  [5925384195](https://github.com/Daiki-Yoshida/documents-artifacts/issues/139#issuecomment-5925384195)、  
  [5925534073](https://github.com/Daiki-Yoshida/documents-artifacts/issues/139#issuecomment-5925534073)
- Issue #136 新規統合再実行:  
  [コメント](https://github.com/Daiki-Yoshida/documents-artifacts/issues/136#issuecomment-5924857188)
- Issue #140 フック比較:  
  [コメント](https://github.com/Daiki-Yoshida/documents-artifacts/issues/140#issuecomment-5925517789)
- Issue #135 レビュー:  
  [再レビュー](https://github.com/Daiki-Yoshida/documents-artifacts/issues/135#issuecomment-5924552569)、  
  [最終ゲート](https://github.com/Daiki-Yoshida/documents-artifacts/issues/135#issuecomment-5924654697)
- Issues [#138](https://github.com/Daiki-Yoshida/documents-artifacts/issues/138)、[#140](https://github.com/Daiki-Yoshida/documents-artifacts/issues/140)、[#141](https://github.com/Daiki-Yoshida/documents-artifacts/issues/141)

## フォローアップ — 2026-10-01（独立レビュー、観測されたエントリーフック比較）

原サマリーの後に追記。上記の以前の各セクションは変更されていません。上記の「保留中」項目は、以下に記すとおり本節で更新されています。本節も評価者サマリーであり、エージェントのトランスクリプトでも、独立した読み取りテレメトリーでもありません。

### ソースの固定コミット

- `19fc5e78c6c128dc7431558b56eafa91222b5f48` — 独立レビュー中の Issue #141 投影修正
- `48ae5e9682310fb4ce01738955c61c8b9e98af44` — Issue #142 のオブザーバー境界／識別情報の修正
- `52e6a3d4713f4a2d6a842b4d5573a6db66a4a5c7` — 以下の観測ペアに用いた prepare/capture のソース固定コミット
- `eea6a9c1ef831b4f4e3c9bfcf82c3f0d4e122236` — 後続のテスト専用回帰修正。観測ペアはこれを遡及適用して再ラベル付けしていません（オブザーバーの blob は両コミットで同一: `a4f1e91967194f8572e9c0ec1a5548d694525a31`）

### Issue #141 — 独立レビュー結果

`19fc5e7` における独立したクラウドレビューでは、正規ソースに根拠を置く最小限の投影修正2件が承認され、3つすべてのスイートと保護対象オリジナルのチェックが PASS しました。新規の `gpt-6-luna`/medium `separate-runtime-boundary` 実行2件では、公開済みAPI境界と同一ランタイムのCLIを維持し、要求された wire フィールドをマップ／レンダーし、境界ガードと評価者の行動プローブに合格しました。1件の実行では日付のみの意味論が文書化されていましたが、内部値はそのまま通過しました。上流の形式は未指定のため、より広範な形式のカバレッジは条件付きであり、元のタスクで失敗が確認されたわけではありません。ベースラインでもガード単体はグリーンであり、それだけでは結果の十分な証拠になりません。新規のVCSタスク1件は、承認されたローカルレビュー用コミットを正しく作成し、main／リモートには変更を加えず、外部検証は NOT RUN と報告しました。報告された読み取り（自己報告）: VCS実行では `operation/INDEX.md` と権限／報告のリーフが含まれるようになりました。一方のランタイム実行では `CODE_STRUCTURE.md` が報告され、もう一方では報告されませんでした。これらの実行についても実際の読み取りテレメトリーはなく、因果的な改善の主張はしません。

### Issue #142 — オブザーバーレビューと観測ペア

任意のオブザーバーは独立にレビューされ、修正されました（`48ae5e9` 境界／識別情報の不具合、`52e6a3d` テストヘッダー復元、`eea6a9c` 診断パスの回帰）。`eea6a9c` では、固定された過去のスナップショットが存在する状態での `test-knowledge-integrity.sh` を含め、3つすべてのスイートが PASS しました。比較のスキップはありません。

固定コミット `52e6a3d` でペア観測を1組実施しました。ネイティブの新規 `gpt-6-luna`/medium を使用し、`project-entry-discovery`（条件付きフック）と `project-entry-required`（必須フック）をそれぞれ1回ずつ実行しました。目隠しされたタスクとアーティファクト一式は同一で、オブザーバーの指示はなく、ランタイムガイダンスの変更もありませんでした。監視対象は同じ44ファイルで、導入済みアーティファクト文書41件に加え `AGENTS.md`、`README.md`、`documents/INDEX.md` でした。所有者ドキュメントと実行単位の `PROMPT.md` は監視範囲外です。各被評価対象の開始前にオブザーバーは READY となり、各実行終了後、検査／キャプチャ前に停止しました。両セッションとも終了コード0で、フッターは `drained: true`、`incomplete: false`、`reasons: []` でした。

結果（観測とは別に評価）: **両実行とも PASS** — 変更されたのは `documents/project/HTTP_CLIENT.md` のみでした。GETは502/503に対して指数バックオフで最大2回再試行、POSTは再試行なし、8秒のタイムアウトを維持、管理対象アーティファクトはバイト単位で同一、停止後の `git diff --check` はクリーンでした。報告には相違があります。conditional 実行の最終メッセージには参照ファイル一覧があります。**required 実行の最終メッセージには要求された一覧がなく、先行する補足応答に記載されています**。両方の記録は別々に保持し、この欠落を暗黙に補っていません。

観測された OPEN ラベル（最初に観測された登録ラベル順。OPEN は読み取り、モデルへの提示、理解を意味しません）:

- Conditional — 6ラベル、41件中3件のアーティファクト文書:  
  `AGENTS.md`、`README.md`、`documents/INDEX.md`、`documentation/INDEX.md`、`documentation/WORKFLOW_AND_MAINTENANCE.md`、`documentation/FORMAT_AND_GIT.md`。  
  **conditional 実行の完了ウィンドウでは `artifacts/INDEX.md` の OPEN は観測されませんでした**。
- Required — 8ラベル、41件中5件のアーティファクト文書: 上記と同じ6件に加え、`documentation/PRINCIPLES_AND_ROUTING.md` と `artifacts/INDEX.md`。アーティファクトルートの OPEN は**最終的に観測されたもので、ルートが最初ではありません** — その前に2つのdocumentationガイダンスファイルが開かれています。ルートのイベントが所有者ドキュメントの編集より前だったかは不明です。OPENのみの監視範囲では、編集との相対的な順序を確立できません。

申告の比較: 各自己報告パス一覧のうち監視対象部分は、観測されたOPENラベルの集合と完全に一致します（集合比較では省略形のファイル名2件を正規化。生の最終報告は変更なし）。所有者ドキュメントと `PROMPT.md` の参照は監視範囲外であり、裏付けられていません。以下は分けて扱います: ポリシー出力の合格、自己報告による参照、独立に観測されたOPENラベル／順序。

### フォローアップの制約

OPEN は、バイト列が読み取られたこと、モデルに提示されたこと、または理解されたことを証明しません。inotify には PID の帰属情報がなく、ハーネスや他プロセスによる open と区別できません。イベントは集約されるため、件数は一意な open の件数ではありません。事前読み込み／キャッシュ済みコンテンツや、すでに open されていたファイルディスクリプターではイベントが発生しないことがあります。終了時点のみの識別情報チェックでは、一時的に移動して戻されたケースを検出できません。イベントがない場合に言えるのは、完了したウィンドウ内でそのラベルの OPEN が観測されなかったことだけです。1組のペアは記述的証拠であり、因果または信頼性の主張ではありません。

### 延期シナリオ（変更なし）

brownfield-execution-adoption、docker-ci-parity、work-runtime-lifecycle-propagation、work-runtime-resource-scoping — 引き続きDocker待ち。ホスト環境による代替なし、カバレッジの主張なし。

### フォローアップのエビデンスリンク

- Issue #141 独立レビュー:  
  [コメント](https://github.com/Daiki-Yoshida/documents-artifacts/issues/141#issuecomment-5925723081)
- Issue #142 観測ペアと回帰検証:  
  [コメント](https://github.com/Daiki-Yoshida/documents-artifacts/issues/142#issuecomment-5926251512)
- Issue #142 先行レビュー:  
  [境界の不具合](https://github.com/Daiki-Yoshida/documents-artifacts/issues/142#issuecomment-5925942864)、  
  [ヘッダー復元の修正](https://github.com/Daiki-Yoshida/documents-artifacts/issues/142#issuecomment-5925956209)、  
  [診断パスの修正](https://github.com/Daiki-Yoshida/documents-artifacts/issues/142#issuecomment-5926131579)

## 最終フォローアップ — 2026-10-01（投影修正とルートチェッカーの受け入れ）

以前の全セクションの後に追記。上記の内容は書き換えていません。評価者サマリーのみ — 生ログ、トランスクリプト、テレメトリーはありません。

### 本節のソース固定コミット

- `171632f15ad7b0b609b89f5923785c3713bd925c` — Issue #144 正規投影の修正（受け入れ済み）
- `5c3a58e10093e3b397d11dc772b93863c31506b1` — 分離された削除前チェック用フィクスチャの修正（受け入れ済み）
- `e15930aa408de787be8cfff980d2d721f03ddd69` — 全分類修正を含む Issue #143 ルートチェッカー（受け入れ済み）

### 正規ランタイム投影の欠落 — 5件、アーティファクトファイル4件

このブランチで、正規記述とランタイム記述間の静的な不一致を修正しました（すべて独立レビュー済み。正規ソースは変更なし）:

1. `artifacts/INDEX.md` — operation router に案内ルート行がなく、範囲／権限とVCSの意図に到達できませんでした（Issue #141）。
2. `artifacts/implementation/CODE_STRUCTURE.md` — UI依存関係の箇条書きにランタイム構成の限定がなく、既存の別ランタイムに関する注意書きは `TESTING.md` にしかありませんでした（Issue #141）。
3. `artifacts/project/WORKTREES.md` — 削除前チェックに、期待されるリポジトリ登録、識別情報／ブランチ一致、プロジェクトポリシーのコミット保持ゲートが欠けていました（Issue #144）。
4. `artifacts/project/WORKTREES.md` — 作成チェックリストに、Project Repository の無視境界の事前確認と検証済み事後条件が欠けていました（Issue #144）。
5. `artifacts/safety/DIAGNOSTICS_AND_RECOVERY.md` — サポートされていない「適切な検証」という代替案が、失敗した操作を再実行して成功させるという正規要件に取って代わっていました（Issue #144）。

普遍的なリモートへのpush要件、Work Documents 全体を無視する規則、または安全でない再実行は導入していません。限定条件は維持されています。

### ルートチェッカー（Issue #143）

`tests/scripts/check-artifact-routes.sh` は、案内されているバッククォート付き `.md` 参照と `INDEX.md` からの推移的到達可能性を検証します: **案内参照85件、ファイル41件、到達可能41件**、宣言されたプロジェクト例トークン9件。**16件すべての重点回帰プローブ**と3つすべてのスイートが、`e15930a` で PASS（独立受け入れ）しました: basenameとdirectory prefixの分類、フラグメント、スラッシュを含む散文、プレースホルダー／globの例、通常／チルダ／長いフェンス付きブロック、インラインのフェンス言及、インラインの誤記、内部ルーターの孤立、間接サイクル。範囲は限定されたままです — 完全なCommonMarkパーサー、フラグメントアンカー検証、ルートマニフェストはありません。意味上のルート品質と実際の読み取りは、このチェックの対象外です。

### 重点ワークツリー／削除／リカバリーの結果（Issue #144）

`171632f` における独立した受け入れでは、復元されたゲートが正規条件を忠実に反映していることを確認しました。新規のマテリアライズおよび診断の実行では、必要な最終状態の不変条件が維持されました（対象の時系列は証言に基づくままです）。`5c3a58e` では、分離された削除フィクスチャが完全な検証に合格しました。新規の `gpt-6-luna`/medium 被評価対象は、期待される `feat/alpha` と登録済みの `feat/beta` の違いを特定し、削除前に停止して、変更を加えませんでした。実行後のキャプチャでは、登録済みbetaチェックアウトがクリーンであること、sparseポリシーが正しいこと、ネストされた調整用マテリアライズがないことを確認しました。以前の交絡したフィクスチャ構成は使用しないままです。

### シナリオの計上

- 現在のブランチでは、シナリオを**合計28件**定義しています。
- 元の計上は独立して維持されます: **24シナリオ**のうち、**20件は評価済み**で、**4件はDocker待ちのまま**（brownfield-execution-adoption、docker-ci-parity、work-runtime-lifecycle-propagation、work-runtime-resource-scoping）。
- 新しい試験導入（`project-entry-*`、`separate-runtime-boundary`、`worktree-removal-preflight`）と再実行の結果は追加的なエビデンスであり、元の24シナリオには含まれず、遡及して算入されるものでもありません。

包括的な信頼性の主張はありません。これらは範囲を限定した非ランダム化の結果です。

### フォローアップのエビデンスリンク

- Issue #143 受け入れ:  
  [コメント](https://github.com/Daiki-Yoshida/documents-artifacts/issues/143#issuecomment-5926903877)
- Issue #144 受け入れ:  
  [コメント](https://github.com/Daiki-Yoshida/documents-artifacts/issues/144#issuecomment-5926811523)
