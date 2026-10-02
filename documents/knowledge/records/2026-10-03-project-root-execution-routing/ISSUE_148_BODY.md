# GitHub Issue #148 body snapshot

```yaml
record_type: "verbatim_external_source_snapshot"
source_kind: "GitHub Issue body"
source_url: "https://github.com/Daiki-Yoshida/documents-artifacts/issues/148"
source_issue: 148
retrieved_date: "2026-10-03"
record_body_policy: "GitHub connectorで取得した現存bodyを無加工保存"
```

~~~~markdown
## 背景

現在の `workspace-structure` / `work-identity` では、

- Project Repository / Project Root
- Workspace Repository
- Component Repository
- Work Root
- repository-specific worktree

の責務と物理配置はかなり明確になっている。

一方で、**AI development sessionをどこから起動するべきか**は、Project Rootの責務としてまだ十分に強く規範化されていない。

これはmulti-repository projectやWork Identity導入時に重要な欠落になり得る。

例えばRPG開発projectで、経路探索アルゴリズム改善のWork Identityを

```text
feat/pathfinding-improvement
```

として実装する場合、物理構造が次のようになっていても、

```text
<project-root>/
├─ AGENTS.md
├─ Makefile
├─ documents/
│  ├─ INDEX.md
│  └─ artifacts/
├─ scripts/
├─ game/                                  # Component Repository checkout
└─ .worktrees/
   └─ feat/
      └─ pathfinding-improvement/          # Work Root
         ├─ documents/
         └─ game/                          # repository-specific worktree
```

AI agentは原則として、

```text
<project-root>/
```

から起動されるべきであり、

```text
<project-root>/.worktrees/feat/pathfinding-improvement/
<project-root>/.worktrees/feat/pathfinding-improvement/game/
<project-root>/game/
```

をAI sessionのentry rootとして扱ってはならない。

## 懸念

Work RootやComponent Repository/worktreeからagentを起動すると、agentがそのsubtreeを「project全体」と誤認し、Project Repository側にある以下を見落とす可能性がある。

- Project Documentation
- `AGENTS.md` 等のagent entrypoint
- `documents/INDEX.md`
- managed `documents/artifacts/` のrouting入口
- project-level architecture / policy
- Makefile / public command wrapper
- project-level scripts
- cross-component coordination rule
- repository ownership / selector mapping
- Work Identity lifecycle rule
- project固有の開発経路・検証方法

その結果、

> Component Repository単体としては妥当だが、Project全体としては誤った実装

が発生し得る。

特にArtifact v2は、project-owned entry hookから `documents/artifacts/INDEX.md` へroutingし、必要なleafだけを読む設計であるため、**Project Rootをentry contextとして保持すること自体がArtifact利用の前提条件になり得る**。

## 提案する設計

### 1. Project RootをAI development sessionの基準入口とする

Projectに属するdevelopment workでは、

> **AI development session MUST be initialized from the Project Root.**

を基本規範とする。

Project Rootは単なるpath-resolution / helper実行基準ではなく、

> **project context / policy / documentation / routingを取得するdevelopment entry surface**

でもあると定義する。

### 2. Work RootはAgent Rootではない

```text
.worktrees/<work-type>/<work-name>/
```

は引き続きWork Identityの物理的なWork Rootであり、

- Work Documents
- participating repository worktrees
- Work-specific filesystem state

を束ねる。

ただし、

> **Work Root MUST NOT be treated as the AI session entry root.**

Work Rootの役割を弱めるのではなく、Project Rootとは別の責務として明示する。

### 3. Component Repository / repository worktreeもAgent Rootではない

Projectに参加しているComponent Repositoryのcheckoutや、Work Root配下のrepository-specific worktreeも、Project全体のdevelopment sessionのentry rootにはしない。

```text
Project Root
  ↓ project context / policy / routing
Work Identity
  ↓ participating repositories
repository worktree
  ↓ actual source changes
```

という解決順序を基本とする。

### 4. Agent session root と command working directory を分離する

この規範は、repository-specific commandの実行directoryまでProject Rootへ固定するものではない。

例えばagent sessionがProject Rootから開始され、project guidance / Work Identity / repository selectorを解決した後なら、

```bash
cd .worktrees/feat/pathfinding-improvement/game
dotnet test
```

や、

```bash
git -C .worktrees/feat/pathfinding-improvement/game status
```

のような操作は許容される。

区別する:

```text
Agent Session Root
  = Project Root

Command Working Directory
  = operationに応じてProject/Component repository worktreeへ移動可能
```

重要なのは、command CWDではなく**agentがproject全体を理解するcontext root**である。

### 5. Project Repository自身がWorkに参加する場合も同じ

Project Repository自身にsource変更があり、そのWork用worktreeが

```text
.worktrees/<identity>/main/
```

に存在していても、AI sessionはそこから開始しない。

Project Rootからproject contextを取得し、その後対象repository worktreeを操作する。

### 6. standalone Component Repositoryの扱い

Component Repositoryが、上位Projectから切り離された独立projectとして意図的に開発される場合、そのdevelopment contextではそのrepository自身がProject Repositoryとして扱われ得る。

したがって規則は、

> 「Component Repositoryでは絶対にagentを起動できない」

ではなく、

> **あるWorkが属するProjectのProject Rootから起動する**

と定義する。

上位Projectに属するWorkなのに、そのComponent Repositoryだけをproject rootとして扱うことを禁止する。

### 7. wrong-rootに対するdefense in depth

launcher / workflow側ではProject Root起動をMUSTとする。

加えてagentが誤ってsubdirectory / Work Root / Component Repositoryから開始されたことを検知できた場合は、

1. mutation / implementationを開始しない;
2. enclosing Project Repository / Project Rootを解決する;
3. project-owned entry documentation / routingを読み直す;
4. environment上Project Root contextへ戻れない場合はfail closedする;

という防御も検討する。

これはwrong-root起動を許可する例外ではなく、誤起動時の安全策である。

## 用語

「親repository / 子repository」はownershipを誤解させるため使わない。

現在のcanonical English termである、

```text
Project Repository
Component Repository
```

は維持する方向を第一候補とする。

一方、日本語では `Project Repository` がComponent Repositoryとの対比でやや直感的でないため、説明名として、

```text
Project Repository
= プロジェクト管理リポジトリ
= 文脈上明確なら「管理リポジトリ」
```

を併記する案を検討する。

ただし「管理」という語が単なるadministrative repositoryに狭く解釈されないよう、定義には必ず以下を含める。

- project-level coordination state
- Project Documentation
- development entrypoint
- project policy / routing
- public tooling / helper
- Work Identity coordination

用語変更そのものをこのIssueの主目的にはせず、まず責務とentry-root invariantを確定する。

## Subject ownership案

### workspace-structure

主所有:

- Project Repository / Project Rootのstatic role
- Project Rootをdevelopment/agent entry surfaceとする規範
- Component Repositoryとのcontext ownership boundary
- standalone component contextの扱い

主な更新候補:

```text
documents/knowledge/subjects/workspace-structure/S001_PROJECT_AND_REPOSITORY_MODEL.md
documents/knowledge/subjects/workspace-structure/S002_GIT_OWNERSHIP_AND_MULTI_REPOSITORY.md
```

### work-identity

補助所有:

- Work RootはAgent Rootではない
- Work Root / repository worktreeはProject Rootから解決される
- Work Identity確定後にparticipating repositoryへ操作をroutingする

主な更新候補:

```text
documents/knowledge/subjects/work-identity/S002_WORK_ROOT_AND_REPOSITORIES.md
```

必要ならlifecycle/materialization文書にも最小限のcross-referenceを追加する。

### documentation / execution

新しいownershipを重複させない。

ただし、project-owned agent entry hook / public commandとの接続を明確にするため、既存ownerへのcross-referenceが必要か監査する。

## Artifact v2 projection案

最低限、次へのprojectionを検討する。

```text
artifacts/project/WORKSPACE.md
artifacts/project/WORK_IDENTITY.md
```

必要性を監査してから、

```text
artifacts/project/WORK_LIFECYCLE.md
artifacts/execution/EXECUTION_MODEL.md
artifacts/documentation/PRINCIPLES_AND_ROUTING.md
```

へcross-referenceまたは補助規範を追加する。

同じ規範を複数leafへ全文複製しない。

## Source / knowledge update flow

この変更は既存artifactへの直接patchではなく、通常のknowledge flowに従う。

```text
今回の設計判断
  ↓
documents/knowledge/records/
  ↓
workspace-structure / work-identity
  ↓
Artifact v2 projection review
  ↓
artifacts/
  ↓
behavior/static validation
```

今回のユーザー提案・設計判断を第0情報源としてrecord化し、そこからcanonical knowledgeを更新する。

## Validation案

### Static / integrity

既存:

```bash
bash tests/test-knowledge-integrity.sh
bash tests/test-artifacts.sh
bash tests/test-agent-harness.sh
```

に加え、projection時に以下を確認する。

- Project Root entry invariantがcanonical→artifactで欠落していない
- Work RootをAgent Rootと誤認させる既存記述がない
- Component Repositoryからの直接session起動を推奨する矛盾がない
- command working directoryまで不必要にProject Rootへ固定していない

### Behavior scenario候補

multi-repo fixtureで、

- Project Repositoryにproject-level policy / routing / public commandがある
- Component Repository側だけを見ると局所的には別の実装が可能
- 正しい結果にはProject Repository側のcontextが必要
- agentはProject Root contextを保持したままComponent Repository worktreeを編集する

というscenarioを追加することを検討する。

既存の `multi-repo-workspace-ownership` coverageと重複しないよう、**repository ownershipではなくagent entry/context preservation**を主評価点にする。

wrong-root launchそのものをblind behavior testでどう再現するかは、現行harnessの起動modelを確認して決める。テスト都合で概念モデルを歪めない。

## 完了条件

- Project RootがAI development sessionの正式なentry surfaceとしてcanonical knowledgeに定義される
- Work Root / Component Repository / repository-specific worktreeはProject-level session entry rootではないと明示される
- Agent Session RootとCommand Working Directoryの差が明確になる
- standalone componentの例外ではなく「そのcontextで何がProject Repositoryか」という形で一貫して説明できる
- Project Repository / Component Repositoryの日本語表現方針が確定する
- Artifact v2へ意味を落とさずprojectionされる
- static/integrity testsが通る
- 必要ならagent behavior testが追加される
- managed target copyを直接編集せず、knowledge → artifact projection flowを守る

## 非目標

- Work Root構造そのものの再設計
- worktree lifecycleの全面変更
- Component Repositoryを廃止・統合すること
- AIの全commandをProject Rootから実行すること
- 全既存文書で一括して用語置換を行うこと

~~~~
