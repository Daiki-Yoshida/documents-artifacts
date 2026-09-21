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
