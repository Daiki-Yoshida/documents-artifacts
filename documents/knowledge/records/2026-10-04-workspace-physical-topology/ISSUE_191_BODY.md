## 背景

Artifact v2を把握したAIエージェントによる実運用で、multi-repository Projectのrepository / worktree配置を誤る事象が発生した。

観測された誤配置:

~~~text
<projects-root>/
├─ <project-repository>/
├─ <component-repository-a>/
├─ <component-repository-b>/
├─ hoge-main-branchname/
├─ hoge-component-a-branchname/
└─ hoge-component-b-branchname/
~~~

具体的には:

1. Project全体の管理rootを所有するrepositoryと、参加するComponent RepositoryのPrimary Checkoutを同じfilesystem階層へ配置した。
2. Project Root配下にComponent Repository checkoutを配置しなかった。
3. Project Root配下の `.worktrees/` namespaceを利用せず、Project Rootのsiblingとして `hoge-main-branchname` 等のad-hoc checkout/worktree directoryを作成した。
4. Work Identity → Work Root → repository-specific worktree という現行contractを物理配置へ正しく反映できなかった。

この失敗を、単なるagent mistakeとして終わらせず、canonical knowledge / Artifact projection / routing / regression coverageの問題として調査・是正する。

関連するprojection anti-pattern:

- #190 **Negative Alternative Leakage (NAL)**

## 期待するcurrent physical model

multi-repository Projectのdefault physical topologyは、役割名そのものとは分離して、少なくとも次の意味を表現する。

~~~text
<project-root>/                    # project-level management/coordination root
├─ documents/
├─ <component-a>/                 # independent Component Repository checkout
├─ <component-b>/                 # independent Component Repository checkout
└─ .worktrees/
   └─ <work-type>/
      └─ <work-name>/
         ├─ documents/
         ├─ <repository-selector-a>/
         ├─ <repository-selector-b>/
         └─ ...
~~~

Component Repositoryは独立したGit ownership / historyを持つ。

filesystem上でProject Root配下にcontainedされることと、Git ownership / authority / dependency上のparent-child hierarchyであることは別の軸である。

このIssueでは、後者を説明するために旧 parent/child modelをArtifactへ長く再導入するのではなく、**current positive topology / ownership / routingを直接明確化する**。

## 調査で確認された現状

### 1. canonical knowledgeのpositive topologyは存在するがnormative strengthが弱い

Current:

~~~text
documents/knowledge/subjects/workspace-structure/S001_PROJECT_AND_REPOSITORY_MODEL.md
~~~

には典型形として:

~~~text
<project-root>/
├─ ...
├─ <component-a>/
├─ <component-b>/
└─ .worktrees/
~~~

が存在する。

一方、Component Repositoryについての本文は概ね:

> Project Repository配下にcheckoutを置ける

という表現であり、default / recommended physical placementとしての強度が弱い。

旧sourceでは:

> 各Component Repositoryには、workspace内に一つのPrimary Checkoutを置きます。

というより直接的なpositive modelが存在していた。

### 2. Artifact projectionでdefault physical topologyが薄くなっている

Current:

~~~text
artifacts/project/WORKSPACE.md
~~~

はProject Repository / Component Repositoryのownershipは説明するが、Component Repository checkoutのdefault physical placementを十分直接的に示していない。

一方で:

> Do not describe this relationship as parent/child repository hierarchy.

等のnegative guardが比較的目立つ。

これは #190 で定義する **Negative Alternative Leakage (NAL)** の実例になり得る。

本来runtime agentに必要なのは、旧modelの説明ではなく:

- project-level management/coordination rootはどこか
- participating Component Repository checkoutはどこに置くか
- Project Root / Component checkout / Work Rootの関係
- worktreeをどこへmaterializeするか

というcurrent positive modelである。

### 3. Issue #167のscopeとfilesystem placementが混同された可能性

Issue #167:

~~~text
docs: parent/child hierarchyをProject Repository / Component Repository責務モデルへ収束する
~~~

では、旧parent/child repository / hierarchical documentation modelをcurrent role modelから外した。

しかし同Issue本文自身も:

> Component Repositoryは「子Repository」ではない。filesystem上でProject Repository配下にcheckoutされていても、Git ownership上の親子関係を意味しない。

としている。

したがって #167 は:

- role / authority / documentation hierarchyとしてのparent-childを廃止する

decisionであり、

- Project Root内へのComponent checkout containment自体を廃止する

decisionとは限らない。

Current:

~~~text
documents/knowledge/subjects/workspace-structure/S003_HISTORY.md
~~~

の「旧用語と旧配置はhistory」という表現を含め、Decision Lineage / semantic scopeを再監査する。

**role hierarchyの廃止とphysical containmentの廃止を同一視しない。**

### 4. Worktree path contract自体は比較的明確

Current:

~~~text
artifacts/project/WORK_IDENTITY.md
artifacts/project/WORKTREES.md
documents/knowledge/subjects/work-identity/
~~~

では:

~~~text
<project-root>/.worktrees/<work-type>/<work-name>/<repo-selector>/
~~~

が明示されている。

したがってProject Rootのsiblingへ:

~~~text
hoge-main-branchname/
hoge-front-branchname/
hoge-back-branchname/
~~~

等を作ることは、current Work Root / worktree path modelと整合しない。

この失敗については、Worktree Contractそのものの欠落だけでなく:

- `WORKSPACE.md` → `WORKTREES.md` のcross-routing不足
- multi-repository setup taskで必要leafを選択できなかった可能性
- project-local helper / deterministic path contractの不使用
- agent validation coverage不足

も確認する。

### 5. 現行agent testsにcoverage gapがある

`multi-repo-workspace-ownership` scenarioでは、fixture作成時点で:

~~~text
components/api/
components/web/
~~~

がProject Root配下へ正しく配置されている。

そのためagent自身に「Component RepositoryのPrimary Checkoutをどこへ配置するか」を判断させていない。

一方 `worktree-materialization` scenarioは:

- `.worktrees/<type>/<name>/<repo-selector>/`
- linked worktree registration
- nested `.worktrees/` exclusion

を強く検証するが、reference caseはsingle-repository topologyである。

Current `WORKTREES.md` もreal multi-repository mapping / independent Component Repository normal materialization pathをfully validatedとはしていない。

したがって:

~~~text
multi-repo topology
× component primary checkout placement
× Work Root
× repository-specific worktree materialization
~~~

の交点にregression coverage gapがある。

## NAL観点での修正方針

#190の原則に従い、Artifactでは旧parent/child modelを詳しく説明して否定するのではなく、current positive modelを直接提示する方向を優先する。

例:

~~~text
A multi-repository Project has one project-level management/coordination root.

Participating Component Repository primary checkouts live under that Project Root
by default, while retaining independent Git ownership.

<project-root>/
├─ <component-a>/
├─ <component-b>/
└─ .worktrees/
~~~

Work-specific checkoutが必要なら:

~~~text
<project-root>/.worktrees/<work-type>/<work-name>/<repo-selector>/
~~~

へrouteする。

旧modelへのnegative guardが不要ならArtifactから削減する。
必要なnegative guardが残る場合も、old model全体をruntimeへ再導入せず短く表現する。

一方、subjectsではsemantic completeness / Decision Lineageのため:

- 旧parent/child model
- #167のdecision
- role hierarchyとphysical containmentの違い
- 今回の誤読と訂正

を必要な範囲で保持してよい。

## Repository role namingについての重要な留保

現在canonical guidanceでは **Project Repository** というrole名を使用しているが、この名称自体は別途再検討予定である。

ユーザーの現時点の認識:

- 元々は「管理リポジトリ」と呼んでいた。
- AI提案を受けて「Project Repository」を採用した。
- 現在は `Project Repository` という名称がroleを十分正確に表していない可能性を感じている。
- 候補として「管理ルートリポジトリ」等を検討している。
- 正式な名称・英語名・role taxonomyは**後続の議論/decisionで決める**。

### このIssueでしてはいけないこと

- `Project Repository` という名称を新たに強くcanonicalizeする。
- regression fixのついでに広範なrole renameを行う。
- 「管理ルートリポジトリ」等の候補を未決定のままcurrent authorityへ昇格する。
- naming discussionが未解決なのにArtifactへ新名称を先行projectionする。

### このIssueで扱うもの

名称ではなく、roleの意味と構造:

- project-level management / coordination rootが存在する。
- Project Rootを所有する。
- Component Repository primary checkoutはdefaultではそのProject Root配下に配置される。
- Component Repositoryは独立Git ownershipを維持する。
- Work RootはProject Root配下の `.worktrees/` namespaceに置く。
- repository-specific worktreesはWork Root配下へ決定的に配置する。

必要な文書変更では、現行名称を使わざるを得ない箇所でも、**将来rename可能なsemantic roleとして扱い、名称そのものを論拠にしない。**

## 想定変更箇所

canonical knowledge:

~~~text
documents/knowledge/subjects/workspace-structure/S001_PROJECT_AND_REPOSITORY_MODEL.md
documents/knowledge/subjects/workspace-structure/S002_GIT_OWNERSHIP_AND_MULTI_REPOSITORY.md
documents/knowledge/subjects/workspace-structure/S003_HISTORY.md
documents/knowledge/subjects/workspace-structure/INDEX.md

documents/knowledge/subjects/work-identity/
~~~

Artifact projection:

~~~text
artifacts/project/WORKSPACE.md
artifacts/project/WORK_IDENTITY.md      # 必要な場合のみ
artifacts/project/WORKTREES.md          # 必要なcross-routing/clarificationのみ
artifacts/project/INDEX.md
artifacts/INDEX.md                      # routing変更が必要な場合のみ
~~~

tests:

~~~text
tests/test-knowledge-integrity.sh
tests/test-agent-harness.sh
tests/scenarios/
~~~

projection rule自体の一般化は #190 がowner。

## Regression scenario案

今回の事故を直接再現できるscenarioを追加する。

例:

~~~text
multi-repo-workspace-bootstrap
~~~

または同等の名称。

Agentへ:

- project-level management repository
- Component Repository A
- Component Repository B
- confirmed Work Identity
- component repositoriesを配置/materializeする必要があるproject-local task

を与え、正しいtopologyをagent自身に解決させる。

Expected:

~~~text
<project-root>/
├─ <component-a>/
├─ <component-b>/
└─ .worktrees/
   └─ <type>/
      └─ <name>/
         ├─ documents/
         ├─ <repo-a-selector>/
         ├─ <repo-b-selector>/
         └─ ...
~~~

Must not:

~~~text
<projects-root>/<component-a>/
<projects-root>/<component-b>/

<projects-root>/<project>-main-<branch>/
<projects-root>/<project>-<component>-<branch>/

<project-root>/<ad-hoc-worktree-name>/
~~~

ただしproject-local explicit specializationがあるfixtureでは、そのlocal ruleを優先する。

## 実装方針

1. 今回の実運用失敗と調査結果を第0情報源としてrecord化する。
2. #167および旧Workspace Structure sourceを含めDecision Lineage / semantic scopeを再確認する。
3. physical containmentに関するcurrent canonical ruleをpositive formで明確化する。
4. role hierarchy / Git ownership / filesystem containmentを別軸として整理する。
5. #190のNAL原則に従ってArtifact `WORKSPACE.md` を再projectionする。
6. multi-repo + Worktree taskで必要なroutingを確認・補強する。
7. combined regression scenarioを追加する。
8. deterministic integrity guardを追加する。
9. naming問題は未解決として維持し、このIssueではrenameしない。
10. naming decisionが後続で確定した場合、本Issueで整えたsemantic modelを名称変更へ追従させる。

## 非目標

- repository roleの最終命名決定
- `Project Repository` → 別名称への全面rename
- Component RepositoryのGit ownershipをProject-level repositoryへ統合すること
- Git submodule化を要求すること
- Project Root配下に置かれたComponent Repository source/historyをproject-level repositoryで通常trackすること
- Worktree capabilityを全project / 全Workへ強制すること
- subjectsからparent/child historyを削除すること
- NAL一般原則をこのIssueだけで定義すること（#190がowner）

## 完了条件

- Project-level management/coordination rootとComponent Repositoryのdefault physical topologyがcanonical knowledgeで明確である。
- filesystem containmentとGit/authority parent-child semanticsが混同されない。
- Artifactがcurrent positive topologyを直接伝え、不要なold-model否定説明へ依存しない。
- Work-specific repository checkoutがProject Root配下の `.worktrees/<type>/<name>/<repo-selector>/` に解決される。
- Project Root siblingへのad-hoc worktree配置をcurrent guidanceが正当化しない。
- multi-repo topology + component placement + worktree materializationを組み合わせたregression coverageがある。
- #190のNAL原則との整合が確認されている。
- repository role namingは未解決/後続課題として保持され、このIssueで不用意に固定化されていない。

