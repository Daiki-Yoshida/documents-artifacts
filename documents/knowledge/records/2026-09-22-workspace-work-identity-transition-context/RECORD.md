# Source record: workspace/work-identity transition context

```yaml
record_type: "verbatim_library_conversation_artifact_snapshot"
source_kind: "ChatGPT Library writing block"
source_name: "貼り付けたマークダウン（1）(5).md"
source_created_at: "2026-09-21T23:28:50Z"
source_modified_at: "2026-09-21T23:28:51.206447Z"
retrieved_date: "2026-09-24"
source_relation: "knowledge再編を別チャットへ引き継ぐためのcontext artifact。workspace/work-identity直近監査結果を詳細に保持する"
source_limit: "直前assistantメッセージそのものとは証明できない。Issue #30のapproval referent原文の代替として扱わない"
record_body_policy: "Library file本文を無要約・無抜粋で保存"
```

## Library artifact原文

~~~~~~text
以下のリポジトリの開発・知識整理を継続してください。

https://github.com/Daiki-Yoshida/documents-artifacts

まずGitHub上の現状を確認し、以下のコンテキストと齟齬がないか確認してから作業してください。

---

# 目的

このrepositoryは、再利用可能なengineering knowledgeを管理し、そこからAI向けの`artifacts/`を派生させるためのrepositoryです。

現在は大規模なknowledge architecture再設計中です。

当面は **`documents/knowledge/`** **を中心に整備**しています。

`artifacts/` の再設計は、knowledgeが十分整理されてから行います。

---

# 情報源モデル

基本モデルは次です。

```text
第0情報源
Chat / Issue / 調査 / 実験 / ユーザー・AIの提言・判断
        ↓
documents/knowledge/
第1情報源・正本
        ↓
artifacts/ 等
第2情報源

```

## 第0情報源

Chat、Issue、実験結果、調査、ユーザー判断、AI提言など。

## 第1情報源

```text
documents/knowledge/

```

ファイル化された情報における最優先の情報源です。

重要なのは、

```text
knowledge内の個々の命題がすべて肯定的に正しい

```

という意味ではありません。

例えば、

```text
Aがよさそうという提言
↓
議論
↓
Aは問題があると判断
↓
Bを提言
↓
Bを採用

```

なら、

「Aが正しい」のではなく、

```text
Aが提案された
Aが後に否定された
Bが提案された
Bが採用された

```

という評価・時系列を含む記録全体が正確であることを保証します。

## 第2情報源

`artifacts/`など。

第1情報源に基づき、

- context圧縮
- 重複除去
- AI向け再構成
- progressive disclosure
- token効率最適化
- 必要に応じた翻訳

などを行ってよい層です。

---

# knowledgeの現行構造

現在は概ね次の構造です。

```text
documents/knowledge/
├─ INDEX.md
├─ system/
├─ records/
└─ subjects/

```

## INDEX.md

knowledgeという仕組み自体の恒久的な入口です。

特定のrecord名やsubject名など、内部inventoryに依存しすぎないようにします。

## system/

knowledge管理そのものの規則です。

現在、

```text
system/
├─ INDEX.md
├─ KNOWLEDGE_MODEL.md
├─ RECORD_MODEL.md
├─ SUBJECT_MODEL.md
└─ TRACEABILITY_MODEL.md

```

があります。

## records/

第0情報源から得られた原文・記録・snapshotを、可能な限り情報を変えず保存します。

通常の単位は、

```text
records/YYYY-MM-DD-<short-title>/

```

です。

日付を年/月/日directoryへ分割しません。

原文本文について、

- 要約しない
- 抜粋しない
- 言い換えない
- 後の判断に合わせて過去記録を書き換えない

ことを原則とします。

## subjects/

recordsを根拠として、

```text
責務範囲
概念
domain knowledge

```

ごとに整理した日本語knowledgeです。

ここではartifactのような圧縮を目的にしません。

**情報完全性を優先し、肥大化は許容します。**

---

# subject設計ルール

subjectは単なるカテゴリやumbrellaではありません。

基本的には、

> その名前を主語にして、独立した概念・責務・制約・lifecycleを説明できる知識領域

とします。

複数の異なる責務を「関連しているから」という理由だけで1subjectへ集約しないでください。

兆候として、

- subject内部で主語が何度も変わる
- 他subjectとownershipが頻繁に衝突する
- safety / execution / structure / lifecycleなど別の判断軸が混ざる
- 新しい情報の置き場所を毎回例外判断する必要がある

場合は分割を検討します。

---

# subject file naming

subject内の本文fileは、

```text
S001_...
S002_...
S003_...

```

形式です。

例:

```text
subjects/work-identity/
├─ INDEX.md
├─ S001_IDENTITY_MODEL.md
├─ S002_WORK_ROOT_AND_REPOSITORIES.md
...

```

ルール:

- `INDEX.md`は番号対象外
- `SNNN_`はsubject内の公式な構造・推奨読書順
- 3桁zero padding
- 恒久IDではない
- Git historyを前提にrename可能
- 10刻みなどの空き番号は作らない

---

# 既存subjects

mainでは現在、

```text
subjects/
├─ encapsulation-horizon/
├─ documentation/
├─ work-identity/
├─ development-environment/

```

がありました。

その後、現在作業中branchで、

```text
development-environment

```

をumbrella subjectとして不適切と判断し、分解中です。

---

# 現在作業中のbranch / PR

現在の作業branch:

```text
docs/split-development-environment-subject

```

Draft PR:

```text
PR #27
docs: development-environment subject を責務別に分解

```

**まだmainにはマージしていません。**

main側の直近基準commitは、前回確認時点で:

```text
e585f20d408a88cff057aedfc85169847d03f2c5

```

です。

GitHub上で必ず最新状態を確認してください。

---

# development-environment分解

旧:

```text
development-environment/

```

は削除し、現在branchでは次へ分解しています。

```text
subjects/
├─ workspace-structure/
├─ development-execution/
├─ development-safety/
└─ work-identity/

```

## workspace-structure

責務:

```text
Project全体の静的repository/filesystem構造
Workspace Repository
Component Repository
Git ownership boundary
multi-repository
workspace tool dependency

```

## development-execution

責務:

```text
host / container boundary
Docker-first
公開command
local / CI
reproducibility
resource materialization
導入 / brownfield migration

```

## development-safety

責務:

```text
destructive operation
diagnostics
recovery
integration
confirmation boundary
再読条件

```

## work-identity

既存subjectをほぼ維持します。

責務:

```text
Work Identity
Work Root
Work Documents
Work lifecycle
Work-scoped resource identity
Git branch / worktree mapping
worktree materialization
worktree commands

```

旧Task Worktree / Primary Checkout等の前身モデルは、

```text
work-identity/S008_HISTORY.md

```

へ履歴として移しています。

---

# 重要: workspace-structure と work-identity の直近監査結果

ユーザーから、

```text
workspace-structure と work-identity が共存可能か
矛盾・責務重複がないか

```

という調査依頼があり、直近の監査では以下を発見しました。

## 結論

subject分割そのものは良いです。

基本境界は、

```text
workspace-structure
    = Project全体の静的構造

work-identity
    = 1つのWorkの動的構造

```

で整理できます。

ただし、**現在branchのworkspace-structure本文に旧Task Worktreeモデルがまだnormativeに残っており、修正が必要です。**

### 問題1: `.worktrees/` path構造の矛盾

workspace-structure側には旧形式:

```text
.worktrees/<component>/<task>

```

が残っています。

work-identity側の現行形式は:

```text
.worktrees/<work-type>/<work-name>/
├─ documents/
├─ front/
└─ back/

```

です。

現行ownershipはwork-identity側に寄せるべきです。

workspace-structureは、

```text
<project-root>/
└─ .worktrees/

```

というnamespaceの存在だけ扱い、

`.worktrees/`内部構造はwork-identityが所有する形がよいです。

### 問題2: `.worktrees/` Git ownershipの矛盾

workspace-structure側には、

```text
.worktrees/ 全体をignore

```

という旧規則があります。

しかしwork-identityでは、

```text
.worktrees/<work-type>/<work-name>/documents/

```

をProject Repositoryがtracked filesとして所有します。

一方、

```text
.worktrees/<work-type>/<work-name>/<repository>/

```

はrepository-specific worktreeなので親Project Repositoryの通常fileとして管理しません。

したがって、

```text
.worktrees/ 全体ignore

```

は誤りです。

### 問題3: Task Worktreeのstatus

work-identityでは、

```text
Task Worktree = Work Identity導入前の旧モデル

```

としてhistory扱いです。

workspace-structureには現在も現役基本概念として残っています。

これもworkspace側のnormative本文から除去し、historyへ送るべきです。

### 問題4: Workspace Repository と Project Repository の関係が未定義

workspace-structure:

```text
Workspace Repository
Component Repository

```

work-identity:

```text
Project Repository
Project Root
Component Repository

```

を使っています。

現在の設計からは次が自然です。

```text
Project Repository
  = Project全体のcoordination stateを所有するrepository

multi-repo:
  Project Repository = Workspace Repository

single-repo:
  Project Repository = 唯一のrepository

Component Repository:
  Projectへ参加するcomponent/product repository

```

これを明文化する必要があります。

### Project Root / Workspace Root

これも接続した方がよいです。

```text
Project Root
  = Project Repositoryのworking tree root

multi-repoで
Project Repository = Workspace Repository
なら

Project Root = Workspace Root

```

と整理可能です。

### REPO selector

work-identityのworktree commandでは、

```text
WORK=feat/user-auth
REPO=front

```

のようなstable repository selectorがあります。

意味上、

```text
workspace-structure
    stable repository identity / locationを所有
        ↓
work-identity
    REPO selectorとして利用

```

というownershipにすると綺麗です。

duplicate registryを作る必要はありません。

---

# 直近の推奨修正

PR #27をmainに入れる前に、次を直すのが安全です。

## workspace-structure/S001_PROJECT_AND_REPOSITORY_MODEL.md

- `Task_Worktree`を現行基本概念から除去
- 旧 `.worktrees/<component>/<task>` を除去
- Project Repository / Project RootとWorkspace Repositoryの関係を追加
- `.worktrees/`はWork Identity-owned namespaceとしてのみ記述

## workspace-structure/S002_GIT_OWNERSHIP_AND_MULTI_REPOSITORY.md

- `.worktrees/`全体ignore規則を撤回
- Work Documents trackingとrepository worktree ignoreの境界を明文化
- stable repository identityとWork Identityの`REPO` selectorを接続
- Primary Checkoutを使う場合は静的repository resolution用途へ限定

## workspace-structure/S003_HISTORY.md

- 削除した旧Task Worktree / old path / old ignore semanticsをhistoryとして保存

## work-identity

大きくは直さなくてよいです。

INDEXまたは`S002_WORK_ROOT_AND_REPOSITORIES.md`に、

```text
Project Repository / Project Rootの静的定義は
workspace-structure subjectを参照する

```

というcross-referenceを追加する程度で十分です。

---

# 既存subjectの状態

## work-identity

```text
work-identity/
├─ INDEX.md
├─ S001_IDENTITY_MODEL.md
├─ S002_WORK_ROOT_AND_REPOSITORIES.md
├─ S003_WORK_DOCUMENTS.md
├─ S004_LIFECYCLE_AND_RESOURCES.md
├─ S005_WORKTREE_MATERIALIZATION.md
├─ S006_WORKTREE_COMMANDS.md
├─ S007_VALIDATION.md
└─ S008_HISTORY.md

```

## encapsulation-horizon

```text
encapsulation-horizon/
├─ INDEX.md
├─ S001_CORE_PRINCIPLE.md
├─ S002_RESPONSIBILITY_AND_HORIZON.md
├─ S003_HARDENING_POLICY.md
├─ S004_CONCEPT_ALTITUDE.md
├─ S005_CONTRACT_COMPLETENESS.md
├─ S006_EVOLUTION_AND_GRADUATION.md
├─ S007_GLOSSARY.md
├─ S008_OPERATIONAL_GUARDS.md
└─ S009_HISTORY.md

```

## documentation

```text
documentation/
├─ INDEX.md
├─ S001_PRINCIPLES.md
├─ S002_ROUTING_AND_STRUCTURE.md
├─ S003_WORKFLOW.md
├─ S004_MAINTENANCE_AND_REVIEW.md
├─ S005_FORMAT_AND_GIT.md
└─ S006_HISTORY.md

```

これらは現状大きな問題なしと判断しています。

---

# 情報保存監査の基本方針

subject再編時は、原recordのsectionを削らないでください。

これまで、

```text
元H2 section
↓
新subject

```

のcoverageを機械確認し、

```text
missing: 0
duplicate: 0
exactly once

```

を確認して進めています。

例えばdevelopment-environment分解では、元4文書のH2:

```text
36 / 36

```

が、

```text
workspace-structure
development-execution
development-safety
work-identity history

```

へexactly onceで再配置済みです。

この性質を壊さないでください。

---

# 作業方針

以下のサイクルで進めてください。

```text
GitHub上の現状確認
↓
records / subjects / systemを確認
↓
既存knowledgeとユーザー指示を設計
↓
必要なら第0情報源となるユーザー判断をrecordsへ原文保存
↓
subjectsを編集
↓
source recordとの情報保存監査
↓
PR更新
↓
ユーザーへ報告

```

現在はknowledge整理フェーズです。

**ユーザーから明示されない限り、artifactsの再設計や変更へ進まないでください。**

また、このrepositoryではGit履歴を積極的に利用するため、構造変更やrenameを過度に恐れなくて構いません。

---

# まず行う作業

1. PR #27 / branch `docs/split-development-environment-subject` をGitHub上で確認
2. `workspace-structure` と `work-identity` の最新本文を再確認
3. 上記監査結果が現在も妥当か確認
4. 問題なければ、
   - workspace-structure側の旧Task Worktree規範
   - `.worktrees/` path矛盾
   - `.worktrees/` ignore矛盾
   - Project Repository / Workspace Repository接続不足
   - Project Root / Workspace Root接続不足
   - REPO selectorとのownership接続
     を修正
5. 修正前の意味はhistory/recordsへ残す
6. `workspace-structure` と `work-identity` の共存監査を再実施
7. PR #27を更新
8. mainへのmergeはユーザー確認後に行う

勝手にmainへmergeしないでください。
~~~~~~
