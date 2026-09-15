# ファイル役割とディレクトリ構造

```yaml
document_type: "file_and_structure"
target_audience: "ai_agents"
language: "english"
strategy_version: "2.1.0"
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
