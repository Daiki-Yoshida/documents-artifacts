# ドキュメント — 履歴・旧モデル

この文書は、現在のknowledge-first構造とそのまま混ぜると誤読しやすい旧documentation modelを保存する。

特に、旧 `docs-jp/` / `artifacts/` 配置、厳密な「1情報 = 1文書」規則、document version / `last_updated_commit` registryなどは、現在のknowledge systemやGit-history中心方針と競合するため、現行本文から分離している。

削除ではなく、**当時の設計・運用判断を保持するhistory**として扱う。

## Original preambles

### DOCUMENTATION_PHILOSOPHY_JP.md

# ドキュメント哲学

> **情報源ログ / 旧訳**: この文書は documentation-strategy 2.1.0 前後の日本語資料を履歴として保存したものです。現在の規範ではありません。現行の唯一の正本は `../../artifacts/documentation-strategy/` です。内容が異なる場合は必ず英語正本を優先してください。

```yaml
document_type: "documentation_philosophy"
target_audience: "human_readers"
language: "japanese"
source_snapshot_strategy_version: "2.1.0"
authority: "non_canonical_source_log"
status: "historical_translation"
```

### DOCUMENT_WORKFLOW_JP.md

# ドキュメントワークフロー

> **情報源ログ / 旧訳**: この文書は documentation-strategy 2.1.0 前後の日本語資料を履歴として保存したものです。現在の規範ではありません。現行の唯一の正本は `../../artifacts/documentation-strategy/` です。内容が異なる場合は必ず英語正本を優先してください。

```yaml
document_type: "workflow"
target_audience: "human_readers"
language: "japanese"
source_snapshot_strategy_version: "2.1.0"
authority: "non_canonical_source_log"
status: "historical_translation"
```

```yaml
ownership_split:
  this_doc: "FLOW — いつ行動するか、どの手順に従うか、いつ確認するか"
  FILE_AND_STRUCTURE.md: "HOW + WHERE — ファイル役割、ディレクトリ配置、バージョニング、git規約"
  DOCUMENTATION_PHILOSOPHY.md: "WHY — 正確性優先、スコープ、記録としてのgit"
  INDEX.md: "上記すべてへのルーティング"
```

---

### FILE_AND_STRUCTURE_JP.md

# ファイル役割とディレクトリ構造

> **情報源ログ / 旧訳**: この文書は documentation-strategy 2.1.0 前後の日本語資料を履歴として保存したものです。現在の規範ではありません。現行の唯一の正本は `../../artifacts/documentation-strategy/` です。内容が異なる場合は必ず英語正本を優先してください。

```yaml
document_type: "file_and_structure"
target_audience: "human_readers"
language: "japanese"
source_snapshot_strategy_version: "2.1.0"
authority: "non_canonical_source_log"
status: "historical_translation"
scope: "ファイル役割、ディレクトリ配置、バージョン管理、git規約、階層"
```

```yaml
ownership_split:
  this_doc: "HOW + WHERE — ファイル役割、ディレクトリ配置、バージョン管理、git規約、階層"
  DOCUMENTATION_PHILOSOPHY.md: "WHY — 正確性優先、スコープ、記録としてのgit"
  DOCUMENT_WORKFLOW.md: "FLOW — セットアップ、更新、バージョン更新、ブラウンフィールド"
  INDEX.md: "上記すべてへのルーティング"
```

---

---

## 唯一の情報源

```yaml
principle: "各情報は正確に1つのドキュメントに存在する。"
rules:
  - "概念が2つのファイルに現れる場合、一方が所有し他方はリンクする。"
  - "再述は最大1文 + 所有者へのリンクとしてのみ許可される。"
  - "ドキュメント間に矛盾が生じた場合、所有ドキュメントの記述が権威である。"
  - "トピックを「なぜ」と「どう」に分割することは許可される — クロスリファレンスで結合する。"
```

---

---

## design-principlesとの関係

本戦略には兄弟セット `design-principles` が存在する。両者は異なるドメインを持つ独立したアーティファクトセットだが、対象プロジェクトでは通常両方を使用する。

### ドメイン境界

```yaml
this_artifact_set:
  name: "documentation-strategy"
  domain: "ドキュメント（documents/, docs-jp/, エージェントエントリファイル）"
  owns: "AIエージェント向けドキュメントをどう構造化・ルーティング・バージョン管理・保守するか"

sibling_artifact_set:
  name: "design-principles"
  domain: "コード（src/, tests/, packages/ 等）"
  owns: "AIエージェントが生成するコードをどう設計・記述するか"
```

### 使用パターン

```yaml
pattern_1_independent:
  description: "ユーザーがドメイン固有のタスクで一方のセットを参照する。"
  examples:
    - "コードのバグ修正 → design-principles/ を参照"
    - "プロジェクトドキュメントの更新 → documentation-strategy/ を参照"

pattern_2_combined:
  description: "ユーザーがプロジェクト全体のタスクで両セットを一度に参照する。"
  examples:
    - "'@documents/artifacts/ に従ってこのプロジェクトを開発してください'（両フォルダ）"
    - "プロジェクトのAGENTS.mdが両アーティファクトセットを参照として記載"
  implication: "AIエージェントは両方のコンテキストを同時に保持する。"
```

### 両方が同時に読まれる場合

```yaml
guidance:
  domain_routing: "タスクがコード（src/, tests/）に触れる場合、design-principlesに従う。タスクがドキュメント（documents/, README.md）に触れる場合、documentation-strategyに従う。"
  mixed_tasks: "タスクがコードとドキュメントの両方に触れる場合、各セットをそれぞれのドメインに適用する。ドメイン間でルールを混ぜない。"
  shared_concepts: "SSOT、brownfield policy、confirmation gate、proportionalityは両セットに存在する。それぞれドメインごとに適用され、統合されない。"
```

---

---

## 誤読防止

```yaml
misreadings:
  - "'正確性 > トークン' != トークンコストを無視する（エージェントが効率的に読むようにファイルをうまく構造化する; ただしトークンを節約するために情報を削除してはならない）"
  - "'documents/ はAI向け' != 人間は読めない（読める; AI向けに最適化されているだけで人間が読むことを制限しない）"
  - "'切り詰めよりルーティング' != 無限に細かいファイルを作る（1ファイル = 1関心事; 複数の関心事をカバーするようになったら分割するのであり、トークン数に達したから分割するのではない）"
  - "'記録としてのgit' != gitワークフローを管理する（コミットメッセージ形式とバージョン追跡を管理する; タイミングとブランチングはコード側の決定）"
  - "'docs-jp/ は人間向け' != documents/ に日本語を書いてはならない（AIエージェントが日本語のコンテキストを必要とする場合は書ける; デフォルトは処理効率のため英語）"
  - "'唯一の情報源' != 概念を2度言及してはならない（1文の再述 + リンクは許可される）"
  - "'汎用性' != 1つの固定テンプレート（戦略は単一プロジェクトと階層プロジェクトに適応する）"
  - "本戦略 != ドキュメント生成器（構造とルーティングを定義する; AIエージェントがこれらのルールに従って内容を記述する）"
```

---

## ユースケース4: 古さの処理（Staleness Handling）

**いつ:** AIエージェントがドキュメントの `last_updated_commit` がHEADより古く、
そのドキュメントに関連するコードがその後変更されたことを検出した時。

### 検出

```yaml
detection: "FILE_AND_STRUCTURE.md → §4 Staleness Detection in Practiceを参照。"
summary: "関連コードパスに対するgit logを使用して、ドキュメントのlast_updated_commitとHEADを比較する。"
```

### 古さ更新フロー

```yaml
step_1_detect: "git log --oneline <last_updated_commit>..HEAD -- <relevant_code_paths> を実行する。"
step_2_assess: "リストされたコミットをレビューする。ドキュメントがまだ正確か判断する。"
step_3_classify:
  still_accurate: "コード変更がドキュメント化された情報に影響しなかった。"
  needs_update: "コード変更がドキュメント化された情報に影響する。"
  needs_full_rewrite: "コード変更が非常に大規模で、ドキュメントを再構築する必要がある。"
step_4_act:
  still_accurate: "アクション不要。任意でlast_updated_commitをHEADに更新し、ドキュメントがレビューされたことを確認する。"
  needs_update: "ドキュメントの内容を更新する。バージョンをバンプする（マイナーまたはパッチ）。二段階コミットワークフローを使用する。"
  needs_full_rewrite: "メジャーバージョンバンプとして扱う。再構築前にユーザーに確認する（L2/L3ゲート）。"
step_5_report: "検出された内容、更新された内容、新しいバージョンを報告する。"
```

---

---

## バージョンバンプワークフロー

### いつバンプするか

```yaml
when_to_bump:
  major: "構造的変更 — ファイルの追加、削除、リネーム、またはルーティングの大幅な変更"
  minor: "内容の追加または大幅な更新 — 新しいセクション、新しい情報"
  patch: "小さな修正 — タイポ、明確化、軽微な修正"
```

### バンプ方法（二段階コミットワークフロー）

コミットハッシュはコミット作成前に知ることはできない。以下の二段階アプローチを使用する:

```yaml
phase_1:
  1: "ドキュメントの内容を更新する。"
  2: "ドキュメントのYAMLヘッダーのdocument_versionをバンプする。"
  3: "last_updated_commitを'pending'に設定する（または空のままにする）。"
  4: "documents/INDEX.mdのドキュメントエントリを更新する（バージョン + 日付）。"
  5: "新規ファイルの追加またはルーティング変更があった場合、INDEX.mdのindex_versionをバンプする。"
  6: "適切なメッセージプレフィックスでコミットする。"
phase_2:
  1: "コミットハッシュを取得する: git rev-parse --short HEAD"
  2: "ドキュメントのヘッダーのlast_updated_commitを更新する。"
  3: "INDEX.mdのドキュメントエントリのlast_updated_commitを更新する。"
  4: "コミット: 'chore: <document>のコミットハッシュを記録'"
alternative: "コミットがまだプッシュされていない場合、git commit --amendを使用して1コミットでハッシュを記入する。"

example:
  document: "documents/project/architecture.md"
  change: "キャッシュ戦略の新しいセクションを追加"
  version_bump: "1.0.0 → 1.1.0（マイナー — 内容追加）"
  phase_1_commit: "feat: アーキテクチャドキュメントにキャッシュ戦略セクションを追加"
  phase_2_commit: "chore: アーキテクチャドキュメントのコミットハッシュを記録"
```

---

---

## ドキュメント作成デシジョンツリー

```yaml
question_1: "この情報は開発中にAIエージェントに必要か？"
  no: "docs-jp/（人間向け）に配置する。"
  yes: "質問2へ続く。"

question_2: "プロジェクトレベルのコンテキストか（概要、アーキテクチャ、制約、ステータス）？"
  yes: "documents/project/<topic>.md に配置する。"
  no: "質問3へ続く。"

question_3: "参照資料か（仕様、スキーマ、標準、例）？"
  yes: "documents/reference/<topic>.md に配置する。"
  no: "質問4へ続く。"

question_4: "3以上のファイルからなる、まとまりのある自己完結型のトピックか？"
  yes: "documents/<topic>/ を作成し、そこにファイルを配置する（FILE_AND_STRUCTURE.md → §7を参照）。"
  no: "再評価 — おそらくproject/またはreference/の単一ファイルに属する。"

anti_pattern: "小さな情報ごとに新規ファイルを作成しない。既存ファイルに新しいセクション + INDEX.mdのルーティング更新を追加することを優先する。"
```

---

---

## 1. トップレベルディレクトリ配置

```yaml
project_root:
  documents: "AI向けドキュメント（以下のすべてのコンテンツはAIエージェント向け）"
  docs-jp: "人間向けドキュメント（日本語、プロジェクトオーナーと開発者向け）"
  artifacts: "エクスポートされた戦略ファイル（このセット）— ターゲットプロジェクトにコピー"
  CLAUDE_md: "Claude Code入口（プロジェクトルート）"
  AGENTS_md: "Devin / Codex入口（プロジェクトルート）"
  GEMINI_md: "Gemini入口（プロジェクトルート、使用時）"
  README_md: "簡潔な人間向けプロジェクト説明（詳細はdocs-jp/を参照）"
```

### documents/ — AI向け

```yaml
rule: "documents/ 配下のすべてはAIエージェントが読むために書かれる。"
language: "デフォルトは英語。AIエージェントが日本語コンテキストを必要とする場合（日本語API仕様、日本語ドメイン用語など）は日本語も許可される。"
structure:
  - "documents/INDEX.md — ルーティングハブ + バージョンレジストリ（必須）"
  - "documents/project/ — プロジェクトレベルのコンテキスト（概要、アーキテクチャ、制約）"
  - "documents/reference/ — 参照資料（仕様、標準、例）"
  - "documents/<topic>/ — トピック固有ディレクトリ（§7 ディレクトリ分割ガイドを参照）"
principle: "関心事で分割する、読者で分割しない。documents/ 内に読者分割は存在しない — すべてAI向けである。"
```

### docs-jp/ — 人間向け

```yaml
rule: "人間向けコンテンツはここに配置する。documents/ 配下には決して置かない。"
language: "日本語"
naming: "descriptive.md または descriptive_JP.md"
content_examples:
  - "プロジェクト背景と動機"
  - "人間の開発者向けセットアップチュートリアル"
  - "設計根拠と意思決定記録"
  - "AI向けドキュメントの日本語訳（人間によるレビュー用）"
```

---

---

## 4. ドキュメントバージョン管理システム

`documents/` 配下のすべてのドキュメントはバージョンを持ち、最終更新時のgitコミットを追跡する。
これにはINDEX.md自身も含まれる。

### バージョンフォーマット

```yaml
scheme: "セマンティックバージョニング（MAJOR.MINOR.PATCH）"
major: "構造的変更 — ファイル追加、削除、リネーム、またはルーティングの大幅変更"
minor: "コンテンツ追加または大幅更新 — 新規セクション、新規情報"
patch: "小修正 — タイポ、明確化、軽微な修正"
initial_version: "1.0.0"
```

### ドキュメントごとのバージョンヘッダー

各ドキュメントは先頭のYAMLブロックにバージョンブロックを含める:

```yaml
# 各ドキュメントの先頭、既存のYAMLブロック内:
document_version: "1.2.0"
last_updated_commit: "abc1234"
last_updated_date: "2025-07-09"
```

```yaml
format_rule: "document_type, target_audience などを保持する既存のYAMLコードブロック（```yaml）を使用する。別のフロントマターブロック（---）は使用しない。"
```

### INDEX.mdのバージョンレジストリ

INDEX.mdはすべてのドキュメントのレジストリを管理する。INDEX.md自身はレジストリのバージョンを追跡する
`index_version` フィールドを持つ。

```yaml
# documents/INDEX.md の例エントリ
index_version: "1.3.0"
documents:
  - path: "documents/project/overview.md"
    version: "1.2.0"
    last_updated_commit: "abc1234"
    last_updated_date: "2025-07-09"
    purpose: "プロジェクト概要と目的"
  - path: "documents/project/architecture.md"
    version: "1.0.0"
    last_updated_commit: "def5678"
    last_updated_date: "2025-07-09"
    purpose: "アーキテクチャサマリー"
```

### INDEX.mdのバージョン更新

```yaml
index_version_bump:
  major: "レジストリ再構築 — 一括再編成、多数のファイル追加/削除"
  minor: "新規ファイル登録、またはファイルのルーティングエントリ変更"
  patch: "エントリのタイポ修正、メタデータ修正"
```

### コミットハッシュ: 二段階ワークフロー

コミットハッシュはコミット作成前に知ることはできない。以下のワークフローを使用する:

```yaml
phase_1_commit:
  action: "ドキュメントの内容を更新し、バージョン番号を更新する。"
  commit_hash_field: "last_updated_commitは空のままにするか 'pending' に設定する。"
  commit: "適切なメッセージプレフィックスでコミットする。"
phase_2_record:
  action: "コミット後、以下でハッシュを取得: git rev-parse --short HEAD"
  update: "ドキュメントヘッダーとINDEX.mdの両方のlast_updated_commitに記入する。"
  commit: "ハッシュ更新をフォローアップコミットする: 'chore: <document>のコミットハッシュを記録'"
alternative: "まだプッシュされていない場合、git commit --amend で最終化前にハッシュを記入することも可能。"
```

### なぜコミットハッシュを追跡するか

```yaml
rationale: |
  AIエージェントがドキュメントを読む時、コミットハッシュを確認してドキュメントが
  コードの現在の状態を反映しているか検証できる。ドキュメントのlast_updated_commitが
  HEADより古い場合、エージェントはドキュメントが古くなっている可能性を認識し、
  依存する前にコードと照合して検証すべきである。
```

### 実践的な古さ検出

```yaml
how_to_detect_staleness:
  step_1: "ドキュメントヘッダーからlast_updated_commitを読む。"
  step_2: "実行: git log --oneline <last_updated_commit>..HEAD -- <relevant_code_paths>"
  step_3: "出力が空でない場合、ドキュメント最終更新以降にコードが変更されている。"
  step_4: "リストされたコミットを確認し、ドキュメントがまだ正確か判断する。"
  step_5: "不正確な場合、ドキュメントを更新する（DOCUMENT_WORKFLOW.md → 古さ更新フローを参照）。"
example: |
  # ドキュメントヘッダー: last_updated_commit: "abc1234"
  # src/ がその後変更されたか確認:
  git log --oneline abc1234..HEAD -- src/
  # 出力にコミットがあれば、ドキュメントが古くなっている可能性がある。
```

---

---

## 10. 複数開発者によるINDEX.md競合緩和

INDEX.mdのバージョンレジストリは、すべてのドキュメント変更が触れる単一ファイルであり、
複数開発者が並行してドキュメントを更新する際にマージ競合を引き起こす可能性がある。

```yaml
mitigation:
  - "競合サーフェスを減らすため、INDEX.mdのエントリをパス順にソートして保持する。"
  - "各開発者は自分のドキュメントのエントリのみを更新する。"
  - "競合が発生した場合、通常はバージョンレジストリブロック内 — 両方のエントリを保持してソートすることで解決する。"
  - "大規模チームの場合、ドキュメント変更とは別のコミットでINDEX.mdを更新し、競合を分離することを検討する。"
note: "これはバージョンレジストリを中央集権化する既知のトレードオフである。メリット（単一ルーティングハブ）は、ほとんどのプロジェクトで競合コストを上回る。"
```

---

---

## これらがどう連携するか

```yaml
entry_file_routes: "agent.mdがdocuments/INDEX.mdへルーティングする"
index_routes: "INDEX.mdがタスクに基づいてproject/またはreference/へルーティングする"
version_registry: "INDEX.mdがすべてのドキュメントのバージョン + コミットハッシュを追跡し、古さ検出に使用する"
cross_references: "ドキュメントは参照元ファイルからの相対パスを使用して互いにリンクする"
hierarchy: "親と子はそれぞれ独立したdocuments/ツリーを持つ; 協調は親のchildren.md経由"
deletion: "ドキュメントの削除は参照の修正 + INDEX.mdの更新を必要とする"
one_idea: "INDEX.mdが地図、ドキュメントが目的地、バージョンヘッダーがタイムスタンプ。エージェントは地図を読み、目的地を選び、必要な範囲だけリンクをたどる。"
```

## Sources

- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/documentation-strategy/DOCUMENTATION_PHILOSOPHY_JP.md`
- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/documentation-strategy/DOCUMENT_WORKFLOW_JP.md`
- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/documentation-strategy/FILE_AND_STRUCTURE_JP.md`


---

## 2026-09-22 cross-subject alignment

6 subject横断監査で、旧modelとしてhistoryへ分離済みと宣言していた次の規範が、S001〜S005の現行本文へ残っていることを確認した。

- document Semantic Version / `last_updated_commit` registry
- INDEXをversion registryとして扱う規則
- audienceごとの固定 `docs-jp/` placement
- 厳格な「1情報 = 1文書」運用
- `FILE_AND_STRUCTURE.md` / `DOCUMENT_WORKFLOW.md` 等の旧file名を現行authorityとして参照する規則

これらは現行normative本文から除去し、このhistoryとsource recordで保持する。

現行modelはGit history、routing、主authority、意味の完全性を優先し、固定registryを新しい状態source of truthとして要求しない。

Source decision:

- `../../records/2026-09-22-six-subject-cross-audit-fixes/`


---

## デフォルトでAI向け

旧modelでは `documents/` をAI向け、`docs-jp/` を人間向けとして固定分離していた。

この規則は現在のnormative modelではない。現在はaudienceだけを理由に固定top-level directoryを強制せず、project固有のrouting・audience・local conventionで表現する。

元の詳細はsource recordおよびこのhistory内の旧top-level placement記録を参照する。
