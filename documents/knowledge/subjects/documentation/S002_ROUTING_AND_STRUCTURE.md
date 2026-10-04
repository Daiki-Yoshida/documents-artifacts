# ドキュメント — ルーティングと構造

情報を削るのではなく責務ごとに配置し、INDEX・cross reference・project/reference等のrole例・複数repository Projectのroutingによって必要情報へ到達させる考え方を扱う。

## 切り詰めよりルーティング

```yaml
principle: "関心事ごとにファイルを分割し、エージェントを正しいファイルにルーティングする。情報を圧縮しない。"
mechanisms:
  index_file: "documents/INDEX.mdがproject-owned Project Documentation authorityを目的とroutingとともにinventoryする。managed derived subtreeはentrypoint単位でrouteしてよい。"
  cross_references: "同じ規範を独立authorityとして複製せず、必要な局所再述と関連authorityへのlinkを使う。"
  concern_separation: "1ファイルは1つの主関心事へ集中させる。1つの関心事には主authorityを定め、必要な関連authorityはcross referenceで辿る。"
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
  - "project-owned Project Documentation inventory: canonical authorityとなるdocument / routed unitとその目的"
  - "managed derived subtree: internal leafを全列挙せず、managed entrypointを1 routed unitとして登録してよい"
  - "ルーティングマップ: どのタスクにどのdocument / managed entrypointを読むべきか"
  - "相互参照マップ: project-owned authority間の有用なcross reference"
```


### エージェントエントリファイル（CLAUDE.md, AGENTS.md, GEMINI.md）

```yaml
purpose: "AIエージェントの入口 — project-local conventions + documents/INDEX.mdへのrouting"
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

### プロジェクトレベル文書（配置はproject routingに従う）

```yaml
purpose: "AIエージェントが複数taskで参照するproject-level context"
placement: "project固有。documents/project/ は標準的な配置例だが必須directoryではない。documents/直下やtopic directoryでもよい。"
content_examples:
  - "プロジェクト概要、目的、スコープ"
  - "アーキテクチャサマリー"
  - "制約（ビジネスルール、コンプライアンス、パフォーマンス）"
  - "現在のステータスとロードマップ"
routing_rule: "INDEX.mdがこれらのファイルへルーティングする。各ファイルは1つの関心事を扱う。"
```

### 参照ドキュメント（配置はproject routingに従う）

```yaml
purpose: "エージェントがオンデマンドで読む参照資料"
placement: "project固有。documents/reference/ は標準的な配置例だが必須directoryではない。topic directoryや既存の明示されたrole directoryでもよい。"
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
  - "INDEX.mdがProject Documentationのルーティングハブである。project-owned canonical authorityはそこから到達可能にし、managed derived subtreeはentrypoint単位でrouteして内部inventoryを複製しない。"
  - "同じ規範を独立authorityとして複製しない。理解に必要な局所再述は許容し、主authorityへリンクする。"
  - "1ファイルは1つの主関心事へ集中させる。関連subject / documentが必要なtaskでは、主authorityから必要なcross referenceだけを辿る。"
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

新しい `documents/<topic>/` directoryを作成するか、既存のproject-level / reference-level roleへ置くかの判断基準。

```yaml
default_placement_examples:
  project_level: "documents/project/ — project-level documentを分けたい場合の標準例。既存project routingを優先"
  reference_level: "documents/reference/ — reference documentを分けたい場合の標準例。既存project routingを優先"
  rule: "これらのdirectoryを存在必須にしない。Project Documentation rootはdocuments/だが、その内部shapeはprojectの責務とroutingに合わせる"

when_to_create_topic_directory:
  criteria:
    - "トピックに3つ以上のファイルがあり、それらがまとまった単位を形成する。"
    - "トピックが自己完結している — エージェントはそのディレクトリだけを読めばトピックを理解できる。"
    - "ファイルをproject/またはreference/に配置すると、それらのディレクトリが雑然とする。"
  rule: "1〜2ファイルだけなら既存routing内の適切なroleを優先し、独立した責務・まとまりが明確になった時点でtopic directoryを検討する。file数は判断材料の一つであり固定閾値ではない。"

when_not_to_create:
  - "トピックが既存のproject-level / reference-level roleと重複する。"
  - "ファイル間で相互参照が頻繁に必要（1つのdirectoryにまとめる）。"
  - "トピックが単一fileなら、既存routing内の最も近いroleへ置く。"
```

---

---

## 複数Repository ProjectのDocumentation routing

repository topology / Git ownershipは `../workspace-structure/` が主所有する。Documentationはそのroleを再定義せず、Project-level knowledgeからComponent固有knowledgeへどう到達するかを扱う。

### 基本model

```text
Project
│
├─ Management Root Repository
│   └─ documents/
│       └─ INDEX.md
│
├─ Component Repository A
└─ Component Repository B
```

Management Root RepositoryはProject-level canonical documentationとroutingを所有する。

Component Repositoryはcomponent/product固有のsource・Git history・必要なcomponent-specific documentationを所有できる。ただし、**Component Repositoryであること自体は独立Project Documentation treeを要求しない**。

```yaml
management_root_repository:
  documentation_role: "Project-level canonical knowledge / routing authority"
  index: "<project-root>/documents/INDEX.md"

component_repository:
  default_role: "component固有knowledgeを必要なGit ownershipの場所で保持できる"
  does_not_imply:
    - "独立Project context"
    - "独自documents/INDEX.md必須"
    - "Project-level authority"
routing:
  rule: "Project Documentationから、Project workに必要なcomponent固有knowledgeのlocation / authorityへ明示的にrouteする"
```

component固有documentをManagement Root Repositoryへ複製して二重authorityにしない。逆に、Project全体のpolicy / architecture / coordinationを各Component Repositoryへ独立複製しない。

### standalone Project context

通常はComponent Repositoryとして参加するphysical repositoryでも、上位Projectとは切り離された独立Projectとして意図的に開発される場合、そのcontextではrepository自身がManagement Root Repositoryになり得る。

```text
same physical repository
  ├─ enclosing Project context  → Component Repository
  └─ standalone Project context → Management Root Repository
```

分類はfilesystem上の親子位置ではなく、**そのWorkがどのProject contextに属するか**で決める。

### topology documentのfile名を固定しない

Project Documentationは、必要に応じてrepository/component topology、責務境界、cross-component relationship、component-specific knowledgeのroutingを記述する。

`children.md` のような特別file roleは要求しない。

```text
components.md
repositories.md
architecture.md
workspace.md
```

等はproject-local routingの例であり、普遍的な必須file名ではない。

### parent / child terminology

Management Root Repository / Component Repositoryの関係をcurrent normativeで「親repository / 子repository」「親project / 子project」と表現しない。

親子表現はfilesystem containment、Git ownership、dependency direction、Project contextを一つの上下関係へ誤って束ねるためである。

旧hierarchical project / parent-child modelは `S006_HISTORY.md` とsource recordsへhistorical contextとして保存する。

## Sources

- `../../records/2026-10-03-project-component-documentation-boundary/`

- `../../records/2026-10-03-subject-consistency-convergence/`

- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/documentation-strategy/DOCUMENTATION_PHILOSOPHY_JP.md`
- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/documentation-strategy/DOCUMENT_WORKFLOW_JP.md`
- `../../records/2026-09-21-docs-jp-snapshot/files/docs-jp/documentation-strategy/FILE_AND_STRUCTURE_JP.md`
- `../../records/2026-07-09-documentation-strategy-final-source-snapshot/MANIFEST.md`
- `../../records/2026-07-09-documentation-v2-2-review-fixes-commit/RECORD.md`
- `../../records/2026-09-22-six-subject-cross-audit-implementation/RECORD.md`（Project Documentation root固定 + 内部構造柔軟化）
