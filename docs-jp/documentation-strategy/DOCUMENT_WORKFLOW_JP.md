# ドキュメントワークフロー

```yaml
document_type: "workflow"
target_audience: "ai_agents"
language: "english"
strategy_version: "2.1.0"
```

```yaml
ownership_split:
  this_doc: "FLOW — いつ行動するか、どの手順に従うか、いつ確認するか"
  FILE_AND_STRUCTURE.md: "HOW + WHERE — ファイル役割、ディレクトリ配置、バージョニング、git規約"
  DOCUMENTATION_PHILOSOPHY.md: "WHY — 正確性優先、スコープ、記録としてのgit"
  INDEX.md: "上記すべてへのルーティング"
```

---

## ユースケース

```yaml
1_new_project: "ゼロから戦略を適用する。"
2_existing_project: "既にドキュメントがあるプロジェクトに戦略を導入する。"
3_ongoing_updates: "プロジェクトは本戦略に従っている; 開発中にドキュメントを更新する。"
4_staleness_handling: "コミットハッシュがHEADより古いドキュメントを検出し修正する。"
```

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

## 確認ゲート

ドキュメント構造を変更する前に、影響を評価する。

```yaml
L0_content: "既存ファイル内の内容更新（構造変更なし） — 進める。"
L1_additive: "既存ディレクトリへの新規ファイルの追加 — 進めて報告する。"
L2_structural: "ファイルの移動、ルーティングパスの変更、ファイル名変更、ドキュメントの削除 — タスクによって明確に暗示される場合のみ進める; 明示的に報告する。"
L3_breaking: "コアドキュメントの削除、documents/ツリー全体の再構築、プロジェクトを単一から階層に変更 — 実装前に必ず確認する。"
rule: "迷った場合はユーザーに聞く。構造変更は将来の全AIエージェントセッションに影響する。"
```
