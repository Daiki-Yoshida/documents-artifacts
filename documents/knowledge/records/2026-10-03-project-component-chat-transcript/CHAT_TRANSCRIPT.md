# Chat transcript — parent/child hierarchy → Project Repository / Component Repository

## Message 1 — User

`documentation` の **hierarchical project** と `workspace-structure` の **Component Repository**  &#x20;

について、適切にしていきたいな。　概念としては、　　親リポジトリ・子リポジトリ　という旧形式の管理階層だったものを、　適切な責務分けを下のが　管理リポジトリ・コンポーネントリポジトリという概念だ。　　なので　親リポジトリ・子リポジトリは古いものとして扱っていいかも。

---

## Message 2 — Assistant

うん、その整理がかなり自然です。調べた限り、今の `documentation` の **hierarchical project（親project / 子project）** は、旧Documentation Strategy由来の管理階層が現行本文に残っているものです。

一方、現在の `workspace-structure` ではすでに、

```text
Project Repository
= プロジェクト管理リポジトリ / 管理リポジトリ

Component Repository
= コンポーネントリポジトリ
```

という**責務ベースのモデル**へ移っています。

なので、現行モデルは次のように整理するのがよいと思います。

```text
旧:
親Repository
├─ 子Repository A
└─ 子Repository B

        ↓ 責務で再定義

現行:
Project / 管理Repository
├─ Project Documentation
├─ project-level policy / command / coordination
│
├─ Component Repository A
└─ Component Repository B
```

重要なのは、**Component Repositoryは「子Project」ではない**ことです。

### Documentationもrepository hierarchyではなくProject contextに合わせる

1つのProject contextでは、

```text
Project
│
├─ Project Repository
│   └─ documents/
│       └─ INDEX.md
│
├─ Component Repository A
└─ Component Repository B
```

を基本にするのがよいです。

つまり、

> Component Repositoryがあるから、その数だけ独立した `documents/INDEX.md` を作る

とはしない。

Project Documentationの入口はあくまで、

```text
<Project Root>/documents/INDEX.md
```

です。

Component固有のdocumentationをComponent Repository自身がGit ownershipする必要がある場合は置いてよいですが、それを自動的に「子Project Documentation」とは呼ばない。

```text
Project Documentation
  = Project context全体のcanonical knowledge

Component Repository内のdocs
  = component/repository固有knowledge
  = 必要ならProject Documentationからroute
```

くらいが適切です。

### 本当に独立Projectとして扱う場合だけ別Projectになる

これは今のWorkspace Structureにすでにある考え方とも一致します。

例えば、

```text
管理Repository
└─ game/     ← 通常はComponent Repository
```

だったとしても、その`game`を上位Projectとは独立して開発するcontextなら、

```text
game repository
  = そのcontextではProject Repository

game/
├─ AGENTS.md
└─ documents/
   └─ INDEX.md
```

になり得る。

つまり分類は物理的な親子関係ではなく、

```text
このWorkはどのProject contextに属しているか？
```

で決まります。

これはかなり重要です。

### 旧 hierarchical project はどうするか

現行 `documentation/S002_ROUTING_AND_STRUCTURE.md` の、

```text
## 8. 階層プロジェクト

親
↓
子project
↓
各子が独自documents/INDEX.md
```

は、**現行normativeから外してよい**と思います。

元の情報はすでに `documentation/S006_HISTORY.md` とsource recordに保存されています。

なので、

```text
旧:
Parent Project / Child Project
Parent Repository / Child Repository
hierarchical project documentation

→ History
```

として明確にできます。

現行側では代わりに、

```text
## 複数Repository ProjectのDocumentation ownership

Project Repository
  → Project Documentationを所有

Component Repository
  → component固有のGit/source ownership
  → Componentだからという理由だけで独立Project Documentationを持たない

Componentをstandalone Projectとして扱うcontext
  → そのrepository自身がProject Repository
  → 独自Project Documentationを持てる
```

とする方がかなり明瞭です。

### `children.md` も不要になる

旧モデルには、

```text
documents/project/children.md
```

がありました。

これも「子Project」という概念を捨てるなら不要です。

必要なのはせいぜい、

```text
Project Documentation
└─ component / repository topologyの説明
```

です。

その置き場所は固定せず、

```text
components.md
repositories.md
architecture.md
workspace.md
```

などproject routingに従えばよい。

**「children.mdという特別なfile role」も旧モデル扱い**でよいと思います。

### さらに `Workspace Repository` も整理余地がある

今回見ていて気になったのがこれです。

現在のWorkspace Structureには、

```text
Project Repository
Workspace Repository
Component Repository
```

の3語がありますが、定義を見ると、

```text
複数repository projectでは

Workspace Repository
= Project Repository
```

となっています。

つまり `Workspace Repository` は今やかなり冗長です。

ユーザーの言う、

```text
管理リポジトリ
コンポーネントリポジトリ
```

へ寄せるなら、

```text
Project Repository
  日本語: プロジェクト管理リポジトリ / 管理リポジトリ

Component Repository
  日本語: コンポーネントリポジトリ
```

の**2 roleだけ**でほぼ足ります。

`Workspace Repository` は旧用語・historical aliasへ落とせそうです。

すると最終モデルはかなり簡潔になります。

```text
Project
│
├─ Project Repository / 管理リポジトリ
│   ├─ Project Root
│   ├─ Project Documentation
│   ├─ public commands
│   ├─ project policy
│   └─ coordination
│
├─ Component Repository A
│   └─ component source/history
│
└─ Component Repository B
    └─ component source/history
```

そして、

```text
親 / 子
```

という表現は**Git/filesystem上下関係を意味してしまうため現行モデルでは使わない**。

これは現在の思想と非常によく合っています。

---

実装するなら、主に次を触ることになります。

- `documentation/S002_ROUTING_AND_STRUCTURE.md`
  - hierarchical projectを現行normativeから除去
  - multi-repository Project documentation ownershipへ置換
- `documentation/S006_HISTORY.md`
  - parent/child hierarchyを旧モデルとして明示
- `documentation/INDEX.md`
  - 「階層project」の説明を除去
- `workspace-structure/S001_PROJECT_AND_REPOSITORY_MODEL.md`
  - Parent/Childが旧概念であることをさらに明確化
  - `Workspace Repository` の扱いも整理
- `workspace-structure/INDEX.md`
- Artifact側の `documentation/*` / `project/WORKSPACE.md`
- regression tests

ここからは実装に入るので、現在のルール通りWork Identityを明示確認したいです。

**候補:**

```text
docs/project-component-documentation-boundary
```

意味は、

> 旧parent/child hierarchyをHistoryへ退避し、Project Repository / Component Repositoryを基準にDocumentation ownershipを再定義する

です。

このWork Identityで進めるのがよいと思います。

---

## Message 3 — User

これで進めていきたい。　Issueに記述した後作業開始して

---

## Message 4 — Assistant

進めました。設計のIssue化から実装開始まで完了しています。

現在の状態はこうです。

- Issue #167: `parent/child hierarchyをProject Repository / Component Repository責務モデルへ収束する`
- Work Identity: `docs/project-component-documentation-boundary`
- branch: `docs/project-component-documentation-boundary`
- implementation head: `31c46ce3e183d2edd84ae06259f896ee78fe35c8`
- Draft PR #168: `Converge documentation on Project and Component repository roles`
- 独立検証TASK: Issue #169

今回すでに実装したのは、主に以下です。

```text
Current:
Project Repository
  = プロジェクト管理リポジトリ
  = 管理リポジトリ

Component Repository
  = コンポーネントリポジトリ
```

旧モデルは、

```text
親リポジトリ / 子リポジトリ
親project / 子project
hierarchical project
Workspace Repository（独立した第三role）
```

としてcurrent normativeから外し、History / compatibility contextへ移しています。

Documentationも、

```text
Project Repository
  → Project-level Project Documentation / routing

Component Repository
  → component-specific knowledgeを必要に応じて所有
  → Componentだからといって独立Project Documentationは不要
```

に統一されています。

重要なのは、

```text
Component Repository
≠ Child Project
≠ 独立Project Documentation必須
≠ documents/INDEX.md必須
```

という点です。

同じphysical repositoryをstandaloneで開発するときだけ、

```text
Component Repository
        ↓ context change
Project Repository
```

になれる、という現在のProject contextモデルも維持しています。

また旧 `children.md` もcurrent required roleから外しました。repository/component topologyの文書名は、

```text
components.md
repositories.md
architecture.md
workspace.md
```

などproject-local routingに任せます。

`Workspace Repository` についても、

```text
旧:
Workspace Repository
Project Repository
Component Repository

現行:
Project Repository
Component Repository
```

へ整理しました。Workspace Repositoryという語自体はsource/historyや既存project説明用のcompatibility termとして残せますが、第三のcurrent roleではありません。

旧情報は削除していません。今回の判断自体も、

```text
documents/knowledge/records/
  2026-10-03-project-component-documentation-boundary/
```

へ保存済みです。

残るのは独立検証だけです。実行エージェントには #169 を渡してください。

---

## Message 5 — User

実行した

---

## Message 6 — Assistant

完了しました。独立検証で残っていた旧語も追加修正され、その後mainへマージ済みです。

- Issue #167: **closed / completed**
- Validation Issue #169: **closed / completed**
- PR #168: **merged**
- 最終検証head: `f985cf30f2237aa011af2a734c26d42f19406693`
- main merge commit: `86f20509516e2a33b9f6ce5c500b80ce6ad81ebd`

現在のcanonical modelは、

```text
Project Repository
  = プロジェクト管理リポジトリ
  = 管理リポジトリ

Component Repository
  = コンポーネントリポジトリ
```

です。

そして旧、

```text
親Repository / 子Repository
親Project / 子Project
hierarchical project
Workspace Repository（第三のcurrent role）
```

は、**current authorityではなくHistory / compatibility用語**として整理されました。

特にDocumentation側も、

```text
Project Repository
  → Project-level Project Documentation / routing

Component Repository
  → component-specific knowledgeを必要に応じて所有
  → Componentだからといって独立Project Documentationは不要
```

に統一されています。

独立レビューでは、追加で `development-safety` / `development-execution` / Artifact側に残っていた `Workspace Repository` 系の表現まで拾って修正されています。

全テストもPASSです。

```text
bash -n tests/test-knowledge-integrity.sh  PASS
bash tests/test-knowledge-integrity.sh     PASS
bash tests/test-artifacts.sh               PASS
bash tests/test-agent-harness.sh            PASS
```

なので、今回の **parent/child hierarchy → Project Repository / Component Repository責務モデル** への移行は完了と見て大丈夫です。

---

## Message 7 — User

一旦この**parent/child hierarchy → Project Repository / Compに関してのこのChatの会話をrecordに記録してほしい**
