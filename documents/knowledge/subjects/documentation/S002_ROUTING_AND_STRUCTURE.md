# ドキュメント — ルーティングと構造

情報を削るのではなく責務ごとに配置し、INDEX・cross reference・project/reference構造・階層projectによって必要情報へ到達させる考え方を扱う。

## 切り詰めよりルーティング

```yaml
principle: "関心事ごとにファイルを分割し、エージェントを正しいファイルにルーティングする。情報を圧縮しない。"
mechanisms:
  index_file: "documents/INDEX.mdがすべてのドキュメントを目的とルーティングとともにリストする。"
  cross_references: "同じ規範を独立authorityとして複製せず、必要な局所再述と関連authorityへのlinkを使う。"
  concern_separation: "1ファイル = 1関心事。1つの関心事の変更は1つのファイルを読むだけで済むべき。"
  gradual_disclosure: "INDEX → 概要 → 詳細。エージェントは必要な分だけチェーンをたどる。"
```

エージェントは1つの答えを見つけるためにすべてを読むべきではない。ファイル構造そのものがルーティングシステムである。

---

---

## 2. ファイル役割

### documents/INDEX.md（必須）

```yaml
purpose: "Project Documentationのルーティングハブ"
placement: "documents/INDEX.md"
required: true
content:
  - "ドキュメントインベントリ: documents/ 配下のすべてのファイルとその目的"
  - "ルーティングマップ: どのタスクにどのドキュメントを読むべきか"
  - "相互参照マップ: どのドキュメントがどのドキュメントにリンクしているか"
```


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
design_rule: "エントリファイルは、agent固有の入口として必要なproject-local operational constraintsとroutingを保持してよい。一方、project knowledgeの詳細説明や重複authorityにはしない; 詳細はdocuments/配下へrouteする。"
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
content: "1段落のプロジェクトサマリー + Project Documentation等、詳細knowledgeへのポインタ"
rule: "README.mdをProject Documentationの代替authorityにしない。詳細knowledgeはdocuments/側へroutingする。"
```

---

---

## 3. 相互参照とルーティング戦略

```yaml
routing_chain: "agent entry → documents/INDEX.md → taskに必要なdocument role / topic → 詳細ファイル"
principles:
  - "INDEX.mdが唯一のルーティングハブである。すべてのドキュメントがそこにリストされる。"
  - "同じ規範を独立authorityとして複製しない。理解に必要な局所再述は許容し、主authorityへリンクする。"
  - "1ファイル = 1関心事。1つの関心事に関わるタスクは1つのファイルを読むだけで済むべき。"
  - "エージェントは必要な範囲だけルーティングチェーンをたどる。"
  - "相互参照は参照元ファイルからの相対パスを使用する。"
```

### 参照フォーマット

```yaml
format: "簡潔なコンテキスト付きのmarkdownリンク"
example_from_index: "アーキテクチャ概要については [project/architecture.md](project/architecture.md) を参照。"
example_from_project_doc: "API仕様については [../reference/api-specs.md](../reference/api-specs.md) を参照。"
rule: "別authorityの内容を独立規範として再定義しない。必要な文脈を局所的に再述し、主authorityへリンクする。"
path_note: "パスはリンクを含むファイルからの相対パスである。documents/INDEX.mdから、documents/project/overview.mdへのリンクは project/overview.md と書く。"
```

---

---

## 7. ディレクトリ分割ガイド

新しい `documents/<topic>/` ディレクトリを作成するか、ファイルを
`documents/project/` または `documents/reference/` に配置するかの判断基準。

```yaml
default_placement:
  project_level: "documents/project/ — project-level documentの標準的な配置例"
  reference_level: "documents/reference/ — reference documentの標準的な配置例"

when_to_create_topic_directory:
  criteria:
    - "トピックに3つ以上のファイルがあり、それらがまとまった単位を形成する。"
    - "トピックが自己完結している — エージェントはそのディレクトリだけを読めばトピックを理解できる。"
    - "ファイルをproject/またはreference/に配置すると、それらのディレクトリが雑然とする。"
  rule: "1〜2ファイルだけなら既存role directoryを優先し、独立した責務・まとまりが明確になった時点でtopic directoryを検討する。file数は判断材料の一つであり固定閾値ではない。"

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
child_independence: "各子は独自のdocuments/INDEX.mdを持つ。"
parent_containment: "親のdocuments/は子を高レベルで記述するが、子の詳細を複製しない。"
information_flow: "親 → 子（一方向）。子は親の内部ドキュメントを参照しない。"
external_reference: "子が親のコンテキストを必要とする場合、親を外部プロジェクトとして扱う。"
```

### 構造

```yaml
parent_project:
  documents:
    index: "documents/INDEX.md（親のルーティング）"
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
- `../../records/2026-07-09-documentation-strategy-final-source-snapshot/MANIFEST.md`
- `../../records/2026-07-09-documentation-v2-2-review-fixes-commit/RECORD.md`
