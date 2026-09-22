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

## 6 subject横断整合前のnormative snapshot

以下は2026-09-22の6 subject横断整合直前、mainに存在したdocumentationの現行本文をそのまま保存したsnapshotである。

このsnapshot内のversion registry、固定directory、旧file参照等は現在の規範ではない。現在の規範はS001〜S005を参照する。


### 旧 S001_PRINCIPLES.md

# ドキュメント — 基本原則

project documentationを、情報正確性を優先しつつAIが適切に読める形で維持するための基本原則を扱う。このrepo自身のknowledge保存規則は `../../system/` が優先する。

## 核心原則: 情報正確性優先

ドキュメントの目的は、AIエージェントに正確で完全な情報を適切なタイミングで提供することである。トークン効率も重要だが、**情報の劣化を代償にして追求してはならない**。

```yaml
priority_order:
  1: "情報正確性 — ドキュメントは正確かつ完全でなければならない"
  2: "適切なルーティング — エージェントは必要なときに必要なものだけを読む"
  3: "トークン効率 — 無駄を最小化するが、トークンを節約するために情報を切り詰めてはならない"
```

正確性とトークン効率が競合する場合、正確性が勝つ。トークンコストの解決策は、ドキュメントを薄くすることではなく、**より良いファイル構造とルーティング**である。

```yaml
wrong_approach: "トークン予算に合わせてドキュメントを縮小し、重要な詳細を失う。"
right_approach: "関心事ごとにドキュメントを分割し、エージェントが関連部分だけを読み込むようにする。"
```

---

---

## スコープ: 本戦略が管轄するもの

```yaml
governs:
  - "documents/ ディレクトリ — すべての内容、構造、ルーティング、保守"
  - "documents/INDEX.md — ルーティングハブとバージョンレジストリ"
  - "ドキュメント変更のGitコミットメッセージ規約"
  - "ドキュメントのバージョン管理 — どのコミットにドキュメントが対応しているかの追跡"

does_not_govern:
  - "ソースコードの設計、アーキテクチャ、パターン"
  - "Gitコミットのタイミング — いつコミットするかはコード側の関心事"
  - "Gitブランチ戦略 — これは開発ワークフローの関心事"
  - "コードレビュープロセス — これは開発プロセスの関心事"
```

本戦略は**記録とドキュメント化**に関するものであり、コードに関するものではない。Gitは記録ツールであるため部分的に管轄下にある：ドキュメントコミットにどうラベルを付けるか（コミットメッセージ規約）、そしてドキュメントがどのコード状態を記述しているかをどう追跡するか（バージョン + コミットハッシュ）。いつコミットするか、ブランチを切るかどうか、どうレビューするかはコード側の決定である。

---

---

## デフォルトでAI向け

```yaml
principle: "documents/ 配下のすべてはAIエージェント向けに書かれる。"
rationale: |
  ユーザーは「@documents/ — これを理解して開発して」とAIエージェントに指示する。
  もしdocuments/に人間向けの散文が含まれていたら、エージェントは実行不可能な
  内容をパースするためにトークンを無駄にする。したがってdocuments/は完全にAI向けである。

human_facing:
  location: "docs-jp/（独立したトップレベルディレクトリ）"
  language: "日本語"
  purpose: "プロジェクトの背景、セットアップチュートリアル、人間向けの設計根拠"
  rule: "人間向けの内容はdocuments/配下には置かない"
```

---

---

## 汎用性

```yaml
principle: "本戦略はAIエージェントを使用するあらゆるプロジェクトで機能する。"
scope:
  single_project: "1つのリポジトリ、1つのdocuments/ツリー、1つのINDEX.md。"
  hierarchical_project: "親+子プロジェクト、それぞれが独立したdocuments/ツリーを持つ。"
  scale_independence: "単一スクリプトのリポジトリからマルチサービスのモノレポまで。"
```

> **唯一の情報源**: 階層構造ルールは
> `FILE_AND_STRUCTURE.md` → "階層プロジェクト" にある。

---

## Sources

- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/documentation-strategy/DOCUMENTATION_PHILOSOPHY_JP.md`
- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/documentation-strategy/DOCUMENT_WORKFLOW_JP.md`
- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/documentation-strategy/FILE_AND_STRUCTURE_JP.md`


### 旧 S002_ROUTING_AND_STRUCTURE.md

# ドキュメント — ルーティングと構造

情報を削るのではなく責務ごとに配置し、INDEX・cross reference・project/reference構造・階層projectによって必要情報へ到達させる考え方を扱う。

## 切り詰めよりルーティング

```yaml
principle: "関心事ごとにファイルを分割し、エージェントを正しいファイルにルーティングする。情報を圧縮しない。"
mechanisms:
  index_file: "documents/INDEX.mdがすべてのドキュメントを目的とルーティングとともにリストする。"
  cross_references: "各ドキュメントは内容を複製する代わりに関連ドキュメントへリンクする。"
  concern_separation: "1ファイル = 1関心事。1つの関心事の変更は1つのファイルを読むだけで済むべき。"
  gradual_disclosure: "INDEX → 概要 → 詳細。エージェントは必要な分だけチェーンをたどる。"
```

エージェントは1つの答えを見つけるためにすべてを読むべきではない。ファイル構造そのものがルーティングシステムである。

---

---

## 2. ファイル役割

### documents/INDEX.md（必須）

```yaml
purpose: "ルーティングハブ + ドキュメントバージョンレジストリ"
placement: "documents/INDEX.md"
required: true
content:
  - "ドキュメントインベントリ: documents/ 配下のすべてのファイルとその目的"
  - "ルーティングマップ: どのタスクにどのドキュメントを読むべきか"
  - "バージョンレジストリ: 各ドキュメントのバージョン + 最終更新gitコミットハッシュ"
  - "相互参照マップ: どのドキュメントがどのドキュメントにリンクしているか"
versioning: "INDEX.md自身のバージョン（index_version）を持つ。インベントリやルーティングが変更された時に更新する。§4を参照。"
```

バージョンレジストリのフォーマットについては§4「ドキュメントバージョン管理システム」を参照。

### エージェントエントリファイル（CLAUDE.md, AGENTS.md, GEMINI.md）

```yaml
purpose: "AIエージェントの入口 — documents/INDEX.mdへルーティングする"
placement: "プロジェクトルート（エージェントツールごとに1つ）"
content:
  - "role: このプロジェクトにおけるエージェントの責務"
  - "constraints: プロジェクト固有のルール"
  - "emergency_action: 意図が不明な場合の対応"
  - "routing: documents/INDEX.mdを主参照とする"
  - "focus_files: エージェントが優先すべきglobパターン"
  - "current_priority: 現在の開発フォーカス"
design_rule: "エントリファイルはルーティングする; 説明しない。詳細はdocuments/配下に存在する。"
when_to_create: "プロジェクトが実際に使用する各AIツールについて1つ作成する。使用しないツールのファイルは作成しない（YAGNI）。"
```

### プロジェクトドキュメント（documents/project/）

```yaml
purpose: "AIエージェントがすべてのタスクで必要とするプロジェクトレベルのコンテキスト"
placement: "documents/project/"
content_examples:
  - "プロジェクト概要、目的、スコープ"
  - "アーキテクチャサマリー"
  - "制約（ビジネスルール、コンプライアンス、パフォーマンス）"
  - "現在のステータスとロードマップ"
routing_rule: "INDEX.mdがこれらのファイルへルーティングする。各ファイルは1つの関心事を扱う。"
```

### 参照ドキュメント（documents/reference/）

```yaml
purpose: "エージェントがオンデマンドで読む参照資料"
placement: "documents/reference/"
content_examples:
  - "API仕様、データモデル、スキーマ"
  - "プロジェクト固有のコーディング標準"
  - "戦略を示す例プロジェクト"
  - "用語集、ドメイン用語"
routing_rule: "プロジェクトドキュメントとINDEX.mdが必要時にリンクする。タスクで要求されない限りエージェントは読まない。"
```

### README.md

```yaml
purpose: "簡潔な人間向けプロジェクト説明"
placement: "プロジェクトルート"
audience: "人間の開発者、プロジェクトオーナー"
content: "1段落のプロジェクトサマリー + 詳細へのdocs-jp/のポインタ"
rule: "AIエージェントはプロジェクトコンテキストの取得にREADME.mdに依存すべきではない。READMEは人間向けである。"
```

---

---

## 3. 相互参照とルーティング戦略

```yaml
routing_chain: "agent.md → documents/INDEX.md → project/ または reference/ → 詳細ファイル"
principles:
  - "INDEX.mdが唯一のルーティングハブである。すべてのドキュメントがそこにリストされる。"
  - "各ドキュメントはコンテンツを複製する代わりに関連ドキュメントへリンクする。"
  - "1ファイル = 1関心事。1つの関心事に関わるタスクは1つのファイルを読むだけで済むべき。"
  - "エージェントは必要な範囲だけルーティングチェーンをたどる。"
  - "相互参照は参照元ファイルからの相対パスを使用する。"
```

### 参照フォーマット

```yaml
format: "簡潔なコンテキスト付きのmarkdownリンク"
example_from_index: "アーキテクチャ概要については [project/architecture.md](project/architecture.md) を参照。"
example_from_project_doc: "API仕様については [../reference/api-specs.md](../reference/api-specs.md) を参照。"
rule: "他の場所に存在するコンテンツを複製しない。1文の説明付きでリンクする。"
path_note: "パスはリンクを含むファイルからの相対パスである。documents/INDEX.mdから、documents/project/overview.mdへのリンクは project/overview.md と書く。"
```

---

---

## 7. ディレクトリ分割ガイド

新しい `documents/<topic>/` ディレクトリを作成するか、ファイルを
`documents/project/` または `documents/reference/` に配置するかの判断基準。

```yaml
default_placement:
  project_level: "documents/project/ — エージェントがすべてのタスクで必要とするコンテキスト"
  reference_level: "documents/reference/ — エージェントがオンデマンドで読む資料"

when_to_create_topic_directory:
  criteria:
    - "トピックに3つ以上のファイルがあり、それらがまとまった単位を形成する。"
    - "トピックが自己完結している — エージェントはそのディレクトリだけを読めばトピックを理解できる。"
    - "ファイルをproject/またはreference/に配置すると、それらのディレクトリが雑然とする。"
  rule: "1〜2ファイルのためにトピックディレクトリを作成しない。3つ目のファイルが現れるまでproject/またはreference/に配置する（スリーの法則）。"

when_not_to_create:
  - "トピックがproject/またはreference/のコンテンツと重複する。"
  - "ファイル間で相互参照が頻繁に必要（1つのディレクトリにまとめる）。"
  - "トピックが単一ファイル — project/またはreference/を使用する。"
```

---

---

## 8. 階層プロジェクト

マルチサービスまたはマルチパッケージプロジェクトの場合、各子は独立した
`documents/` ツリーを持つ。親は子のツリーに入らない。

### 原則

```yaml
child_independence: "各子は独自のdocuments/INDEX.mdとバージョンレジストリを持つ。"
parent_containment: "親のdocuments/は子を高レベルで記述するが、子の詳細を複製しない。"
information_flow: "親 → 子（一方向）。子は親の内部ドキュメントを参照しない。"
external_reference: "子が親のコンテキストを必要とする場合、親を外部プロジェクトとして扱う。"
```

### 構造

```yaml
parent_project:
  documents:
    index: "documents/INDEX.md（親のルーティング + バージョンレジストリ）"
    project: "documents/project/（親プロジェクトコンテキスト）"
    reference: "documents/reference/（共有参照、子概要）"
    children_overview: "documents/project/children.md（高レベルの子記述、親専用）"

child_projects:
  each_child:
    documents: "独自のINDEX.mdを持つ独立したdocuments/ツリー"
    parent_awareness: false
    rule: "子のINDEX.mdは親ドキュメントをリストしない。子は自己完結する。"
```

### 親のchildren.md

```yaml
placement: "documents/project/children.md"
purpose: "子プロジェクトの高レベル概要 — 名前、境界、責務、サービス間通信"
audience: "親レベルのAIエージェントのみ"
rule: "子はこのファイルを参照しない。明示的に協調されない限り、子は互いを認識しない。"
```

---

## Sources

- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/documentation-strategy/DOCUMENTATION_PHILOSOPHY_JP.md`
- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/documentation-strategy/DOCUMENT_WORKFLOW_JP.md`
- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/documentation-strategy/FILE_AND_STRUCTURE_JP.md`


### 旧 S003_WORKFLOW.md

# ドキュメント — 導入と更新ワークフロー

新規project、brownfield、継続的更新という主要なdocumentation workflowを扱う。

## ユースケース

```yaml
1_new_project: "ゼロから戦略を適用する。"
2_existing_project: "既にドキュメントがあるプロジェクトに戦略を導入する。"
3_ongoing_updates: "プロジェクトは本戦略に従っている; 開発中にドキュメントを更新する。"
4_staleness_handling: "コミットハッシュがHEADより古いドキュメントを検出し修正する。"
```

---

---

## ユースケース1: 新規プロジェクトセットアップ

**いつ:** AIエージェントを使用する新規プロジェクトを開始する時。

### ステップ1: エージェントエントリファイル作成

```yaml
action: "プロジェクトが使用する各AIツールにつき1つのエントリファイルを作成する。"
files:
  CLAUDE_md: "Claude Codeを使用する場合"
  AGENTS_md: "DevinまたはCodexを使用する場合"
  GEMINI_md: "Geminiを使用する場合"
content:
  essential:
    - "role: 本プロジェクトにおけるエージェントの責務"
    - "constraints: プロジェクト固有ルール"
    - "emergency_action: 意図が不明な場合の対応"
  routing:
    - "primary_ref: documents/INDEX.md"
  efficiency:
    - "focus_files: エージェントが優先すべきglobパターン"
    - "current_priority: 現在の開発フォーカス"
rule: "エントリファイルはdocuments/INDEX.mdへルーティングする。プロジェクトの詳細は含めない。"
```

### ステップ2: documents/ディレクトリ作成

```yaml
action: "ディレクトリツリーを作成する。"
structure:
  - "documents/INDEX.md（必須 — ステップ3で作成）"
  - "documents/project/（プロジェクトレベルのコンテキスト）"
  - "documents/reference/（参照資料）"
rule: "内容を投入するディレクトリのみ作成する。投機的に空ディレクトリを作成しない（YAGNI）。"
```

### ステップ3: documents/INDEX.md作成

```yaml
action: "ルーティングハブとバージョンレジストリを作成する。"
content:
  - "ドキュメントインベントリ: documents/配下の全ファイルとその目的をリストする"
  - "ルーティングマップ: どのタスクにどのドキュメントを読むべきか"
  - "バージョンレジストリ: 各ドキュメントのバージョン + 最終更新gitコミットハッシュ"
  - "相互参照マップ"
format: "FILE_AND_STRUCTURE.md → §4 Document Versioning Systemを参照"
index_version: "1.0.0で開始する。"
```

### ステップ4: プロジェクトドキュメント作成

```yaml
action: "documents/project/にプロジェクトレベルのコンテキストドキュメントを作成する。"
content:
  - "プロジェクト概要、目的、スコープ"
  - "アーキテクチャサマリ"
  - "制約（ビジネスルール、コンプライアンス、パフォーマンス）"
  - "現在のステータスとロードマップ"
rule: "1ファイル = 1関心事。複数の関心事をカバーする場合は分割する。"
versioning: "各ファイルはバージョン1.0.0で開始する。コミットハッシュには二段階ワークフローを使用する（Version Bumpingを参照）。"
```

### ステップ5: docs-jp/作成（人間向けコンテンツが必要な場合）

```yaml
action: "人間向けドキュメントとしてdocs-jp/を作成する。"
content:
  - "プロジェクト背景と動機"
  - "セットアップチュートリアル"
  - "設計の根拠"
rule: "人間向けコンテンツはdocuments/配下には置かない。docs-jp/に配置する。"
```

### ステップ6: 参照ドキュメントとトピック固有ドキュメントを必要に応じて追加

```yaml
action: "プロジェクトの成長に合わせてドキュメントを作成する — 一度にすべてではない。"
trigger: "既存のプロジェクトドキュメントに収まらないコンテキストをタスクが要求する時、新規ファイルを作成する。"
placement: "documents/reference/<topic>.md または documents/<topic>/（FILE_AND_STRUCTURE.md → §7 Directory Splitting Guideを参照）"
rule: "重複する内容の多い多数ファイルより、明確なルーティングのある少数ファイルを優先する。"
versioning: "新規ファイルはすべてdocuments/INDEX.mdにバージョン1.0.0で登録する。index_versionをマイナーバンプする。"
```

---

---

## ユースケース2: 既存プロジェクト導入（ブラウンフィールド）

**いつ:** プロジェクトには既にドキュメントがあるが、本戦略を導入したい場合。

### ステップ1: 既存ドキュメントの監査

```yaml
action: "既存の全ドキュメントを読み、各ファイルを分類する。"
classification:
  ai_facing: "開発中にAIエージェントが必要な内容"
  human_facing: "人間の開発者向けの内容（セットアップ、チュートリアル、背景）"
  shared: "両方の読者が必要な内容"
  obsolete: "古いまたは冗長な内容"
```

### ステップ2: 新構造へのマッピング

```yaml
mapping:
  ai_facing: "documents/project/ または documents/reference/（AI向け）"
  human_facing: "docs-jp/（人間向け）"
  shared: "documents/（デフォルトはAI向け; 必要に応じて人間向けサマリをdocs-jp/に抽出）"
  obsolete: "削除またはアーカイブ — 移行しない"
```

### ステップ3: エージェントエントリファイルとINDEX.md作成

```yaml
action: "CLAUDE.md / AGENTS.md / GEMINI.md を必要に応じて作成し、documents/INDEX.mdを作成する。"
note: "これらについてはユースケース1のステップ1〜3に従う。"
```

### ステップ4: ドキュメントの移行

```yaml
action: "既存ドキュメントを新しい構造に移動または書き直す。"
rules:
  - "AI向けコンテンツは適切なバージョニングを行いdocuments/に配置する。"
  - "人間向けコンテンツはdocs-jp/に配置する。"
  - "重複を排除する: 2つのファイルが同じトピックをカバーしていた場合、1つに統合し他方からリンクする。"
  - "情報を保持する — ユーザー確認なしに内容を削除しない。"
  - "移動・統合・廃止フラグを付けたものを報告する。"
```

### ステップ5: INDEX.mdと相互参照の更新

```yaml
action: "移行した全ドキュメントをdocuments/INDEX.mdにバージョン1.0.0で登録する。"
check: "エージェントエントリファイルとINDEX.mdの全ルーティングパスが正しい場所を指している。"
```

### ブラウンフィールドガード

```yaml
guard:
  scope: "ドキュメント移行が内容の書き直しに拡大しないようにする。"
  rule: "構造的移行と内容改善は別のタスクである。一方を行ってから他方を行う。"
  violation_handling: "戦略に違反する既存ドキュメントを見つけた場合、報告に記録する。タスクが明示的に求めない限り、黙って修正しない。"
  local_convention: "明示的なプロジェクト慣習は、競合する場合、本戦略より優先される。矛盾を一度報告し、その後ローカルルールに従う。"
```

---

---

## ユースケース3: 継続的ドキュメント更新

**いつ:** プロジェクトは本戦略に従っており、ドキュメントの更新が必要な場合。

### いつ更新するか

```yaml
update_triggers:
  architecture_change: "プロジェクトアーキテクチャドキュメントとINDEX.mdのバージョンレジストリを更新する。"
  new_feature: "必要に応じて参照ドキュメントを追加; INDEX.mdのルーティングを更新する。"
  constraint_change: "プロジェクト制約ドキュメントとINDEX.mdのバージョンレジストリを更新する。"
  tech_stack_change: "プロジェクトドキュメントを更新; 既存ドキュメントがまだ正確か確認する。"
  directory_restructure: "INDEX.mdとエージェントエントリファイルの全ルーティング参照を更新する。"
```

### 何を更新するか

```yaml
decision_tree:
  question: "変更はAIエージェントが知る必要がある内容に影響するか？"
  yes:
    action: "documents/配下の関連ドキュメントを更新する。"
    check: "情報は既存ファイルにあるか、新規ファイルが必要か？"
    existing_file: "ファイルを更新しバージョンをバンプする。"
    new_file: "ファイルを作成し、INDEX.mdに登録し、ルーティングを追加する。"
  no:
    action: "人間向けコンテンツが影響を受ける場合、docs-jp/を更新する。"
    ai_docs: "documents/は変更しない。"
```

### 更新規律

```yaml
rules:
  - "変更トリガー: スケジュールではなく、コードが変更された時にドキュメントを更新する。"
  - "比例的: 1行のコード修正に完全なドキュメントレビューは不要。"
  - "ルーティング優先: 新規ドキュメントを追加する場合、INDEX.mdに登録する。"
  - "正確性優先: 更新によってドキュメントが不正確になる場合、不正確さを修正する — 古い情報を放置しない。"
  - "SSOTチェック: 情報を追加する場合、既存ドキュメントと重複しないか確認する。重複する代わりにリンクする。"
```

---

## Sources

- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/documentation-strategy/DOCUMENTATION_PHILOSOPHY_JP.md`
- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/documentation-strategy/DOCUMENT_WORKFLOW_JP.md`
- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/documentation-strategy/FILE_AND_STRUCTURE_JP.md`


### 旧 S004_MAINTENANCE_AND_REVIEW.md

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


### 旧 S005_FORMAT_AND_GIT.md

# ドキュメント — FormatとGit

Gitを履歴・説明責任の基盤として使う考え方、commit message、Markdown/YAML等のformat基準を扱う。

## 記録ツールとしてのGit

```yaml
principle: "Gitは何がいつ変更されたかを記録する。ドキュメントはこの記録を利用して説明責任を保つ。"
governed_aspects:
  commit_message_format: "Conventional Commitsのプレフィックス（docs:, feat:, fix:）+ 日本語の説明。FILE_AND_STRUCTURE.mdを参照。"
  version_tracking: "各ドキュメントは自身のバージョンと最後に更新されたgitコミットハッシュを記録する。FILE_AND_STRUCTURE.mdを参照。"
not_governed:
  - "いつコミットするか（コード側の決定）"
  - "ブランチを切るかどうか（コード側の決定）"
  - "レビュープロセス（コード側の決定）"
```

ドキュメントコミットはgit履歴で識別可能であるべき。コード変更を記述するドキュメント変更は、そのコード変更がどのコミットに含まれていたかを記録すべきであり、これにより読者はドキュメントがコードと一致していることを確認できる。

---

---

## 5. Gitコミットメッセージ規約

ドキュメントコミットはConventional Commitsプレフィックスと日本語説明を使用する。

### フォーマット

```yaml
format: "<type>: <日本語説明>"
types:
  docs: "ドキュメント変更（新規ファイル、コンテンツ更新、ルーティング変更）"
  feat: "新規ドキュメント機能（新規セクション、新規バージョン管理エントリ）"
  fix: "ドキュメント修正（不正確な情報の訂正）"
  refactor: "ドキュメント再構築（ファイル移動、セクション再編成）"
  chore: "メンテナンス（バージョン更新、メタデータ更新、コミットハッシュ記録）"
examples:
  - "docs: プロジェクト概要を更新"
  - "fix: API仕様のエンドポイントURLを修正"
  - "refactor: documents/reference/ 配下を整理"
  - "feat: セキュリティ要件ドキュメントを追加"
  - "chore: ドキュメントバージョンを1.2.0に更新"
```

### ルール

```yaml
rules:
  - "プレフィックス後の説明には日本語を使用する。"
  - "プレフィックスは英語（docs:, feat:, fix:, refactor:, chore:）。"
  - "説明は簡潔にし、何が変更されたかを記述する（なぜはdiffが示す）。"
  - "ドキュメントコミットがコード変更に伴う場合、ドキュメントコミットの本文にコードコミットハッシュを参照として含める。"
```

### 管理外の事項

```yaml
not_governed:
  - "いつコミットするか（これはコード側 / 開発ワークフローの決定）"
  - "ブランチするかどうか（これはコード側 / 開発ワークフローの決定）"
  - "コミットサイズや粒度（これは開発プラクティスの決定）"
```

---

---

## 6. ファイルフォーマット標準

```yaml
base_format: "埋め込みYAMLブロック付きmarkdown"
format_selection:
  structured_data: "YAML（設定、メタデータ、バージョンレジストリ、リスト）"
  explanations: "markdown（手順、ガイド、根拠）"
  api_specs: "JSONまたはYAML（OpenAPI、マシン可読スキーマ）"
  mixed: "markdown + YAMLブロック（1ファイルで構造+コンテキスト）"
naming: "ファイルは小文字・ハイフン区切り; ディレクトリは小文字"
```

---

## Sources

- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/documentation-strategy/DOCUMENTATION_PHILOSOPHY_JP.md`
- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/documentation-strategy/DOCUMENT_WORKFLOW_JP.md`
- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/documentation-strategy/FILE_AND_STRUCTURE_JP.md`
