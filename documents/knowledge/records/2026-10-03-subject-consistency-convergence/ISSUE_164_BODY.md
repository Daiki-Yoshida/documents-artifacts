
## Purpose

2026-10-03 に documents/knowledge/subjects/ の8 subjectを横断監査した結果、Work Identity / Project Root / generic DIR / Artifact v2 導入後の正本収束が一部不完全であることが判明した。

このIssueを今回の修正Workの第0情報源として固定し、context lossを防ぐ。

Repository:
~~~
Daiki-Yoshida/documents-artifacts
base main: 4c270afe4d45550eeef89d68d66f221d277c0e1a
~~~

Work Identity:
~~~
docs/subject-consistency-convergence
~~~

User request:
- subjects の見直しと矛盾監査を行う
- 古いworktree構造、DIR指定、Work Identity導入前後の残存記述を確認する
- 監査結果をIssueへ記録してcontext lossを防ぐ
- その後、見つかった問題へすべて対応する

## Current subject ownership

現行8 subjectの責務分離自体は維持する。

~~~
workspace-structure
  = Project / repository の静的構造

work-identity
  = Work Identity / Work Root / Work Documents /
    repository-specific worktree / Work lifecycle

development-execution
  = command / runtime / execution target

development-safety
  = destructive operation / diagnosis / recovery / integration safety

engineering-operation
  = engineering change の進行 / authority / verification / reporting

documentation
  = Project Documentation routing / structure / maintenance

encapsulation-horizon
  = どこをhard boundaryとして扱うか

code-design
  = 選択されたboundaryをcodeとしてどう実現するか
~~~

今回の監査ではsubject再分割は不要と判断した。

## Canonical contracts already aligned

### Project Root / Work Root

~~~
Agent Session Root = Project Root
Work Root          = .worktrees/<work-type>/<work-name>/
~~~

Work Root / Component checkout / repository-specific worktreeをProject-level AI session rootへ昇格させない。

### Worktree lifecycle identity

~~~
WORK + REPO (+ BASE)
~~~

からbranch/path/materializationをdeterministically解決する。
caller supplied DIR をWork Identity sourceへしない。

### Generic execution target

~~~
DIR=<path>
~~~

は既に存在するExecution Target Directoryを指定するpath primitive。

DIR は次ではない:
- Work Identity
- Work Root
- REPO selector
- branch identity
- runtime identity
- authorization

### Historical old worktree layout

旧:
~~~
.worktrees/<component>/<task-identity>/
Task Worktree / TASK_ID based model
~~~

は現行normative本文から除去済みであり、主に work-identity/S008_HISTORY.md と workspace-structure/S003_HISTORY.md へ隔離され、「現在の規範ではない」と明示されている。このhistorical preservationは維持する。

# Findings requiring convergence

## F1 — Documentation subject still contains pre-v2 module packaging
Severity: HIGH

Current normative file documentation/S003_WORKFLOW.md contains:
~~~
documents/artifacts/<module>/
installed module
~~~

しかしCurrent Artifact v2 distributionは whole-pack delivery、targetは documents/artifacts/、旧 --modules は廃止済み。

Resolution:
- documents/artifacts/ を1つのmanaged derived Artifact v2 packとして扱う
- documents/artifacts/INDEX.md をmanaged pack entrypointとする
- module-selective install semanticsを復活させない

## F2 — documents/INDEX inventory rule conflicts with managed Artifact routing
Severity: HIGH

documentation/S002_ROUTING_AND_STRUCTURE.md は documents/INDEX.md が documents/配下のすべてのfileを列挙すると要求する一方、S003_WORKFLOW.md はmanaged Artifact内部fileをproject INDEXがmirrorする必要はないとしている。

Resolution:
~~~
documents/INDEX.md
  MUST inventory / route project-owned Project Documentation authorities.

Managed derived subtrees
  MAY be represented by their managed entrypoint as one routed unit.
  MUST NOT require mirroring every managed internal leaf.
~~~

## F3 — Project Documentation root semantics do not exclude managed derived subtree
Severity: HIGH

documentation/S001_PRINCIPLES.md は <project-root>/documents/ 全体をcanonical Project Documentation rootとしているが、documents/artifacts/ はmanaged derived snapshotでありproject-owned canonical authorityではない。

Resolution:
~~~
documents/
  = Project documentation namespace / routing root

project-owned Project Documentation
  = canonical project knowledge

documents/artifacts/
  = managed derived guidance subtree
  != project-owned canonical authority
~~~

物理配置がdocuments配下であることとauthorityを分離する。

## F4 — Worktree materialization applicability can miss future .worktrees growth
Severity: HIGH

work-identity/S005_WORKTREE_MATERIALIZATION.md は、Project Repository linked worktreeへworktree-local sparse exclusionを適用し、後からbaselineへ新しいWork Documentsが増えてもnested .worktrees/をrecursive materializeしないことを検証済み。

しかし S006_WORKTREE_COMMANDS.md は selected branch tree が既に project-level tracked .worktrees/** を含む場合にMaterialization Contractを適用するとしており、first Work / old base branchで見逃す可能性がある。

Resolution:
- applicabilityはstable Project Repository role / project-level coordination ownershipを主基準にする
- current branch tree contentsはdiagnostic/inputには使えるが、future safetyを現在の存在有無だけへ依存させない
- independent Component Repositoryへsparse exclusionを無条件適用しない

## F5 — literal main is used as a generic baseline branch
Severity: HIGH-MEDIUM

Work Identity canonical textには:
~~~
Work Documents exist on main
Work Documents created on Project main
main is the current-state reference plane
~~~
が残る。

generic projectは master その他のbaseline branchを使える。Artifact v2側は既に current baseline (normally main) へ一般化されている。

Resolution:
Project baseline branch = project-defined stable branch representing current Project coordination/documentation state として正規化する。mainは例に留める。

## F6 — REPO=main, main/, Git branch main are semantically overloaded
Severity: MEDIUM

main が:
1. stable repository selector
2. Work Root child directory
3. Git baseline/default branch
の3意味を持つ。

Resolution:
- REPO selectorはproject-local stable repository identityでありGit branch名ではないと明記
- 汎用例では必要に応じ REPO=project 等の曖昧でない例を使う
- Reference validation の REPO=main は実験事実として保持し、universal recommendationにしない

## F7 — Work Documents on baseline branch vs commit authority is underspecified
Severity: HIGH-MEDIUM

Work Identity lifecycle:
~~~
Work Identity confirmed
→ Work Documents created on Project baseline
→ branch/worktree prepared
→ implementation
~~~

Engineering Operation default:
~~~
commit/push only when user asks
do not directly commit implementation on default branch
~~~

baseline-visible tracked Work Documentsをどう成立させるかが未接続。

Resolution:
- Work Identityはdesired lifecycle/stateを所有
- Engineering Operationはcommit/push/merge authorityとpublication mechanismを所有
- baseline publication権限が無い場合、成立したと偽らず、authorizedな安全なstateへ保持しpending publicationを報告
- project-local workflowはcoordination/docs commit等を明示的に許可できる
- generic knowledgeにsilent commit-authority exceptionは追加しない

## F8 — Engineering Operation does not explicitly route the Work Identity confirmation gate
Severity: HIGH-MEDIUM

work-identity/S001_IDENTITY_MODEL.md:
~~~
implementation goal concrete
→ user explicitly confirms Work Identity
→ implementation starts
~~~

Engineering Operationのgeneric lifecycleにはこの必須gateが明示されていない。

Resolution:
concrete implementation effortへ移行し、projectがWork Identity modelを採用している場合、implementation前にwork-identityへrouteしexplicit confirmation gateを満たす。exploration / analysisでは急いでWork Identityを作らない。

## F9 — S002 retains pre-validation materialization text
Severity: MEDIUM

work-identity/S002_WORK_ROOT_AND_REPOSITORIES.md に:
~~~
candidate: worktree-local sparse checkout
specific implementation must be validated before artifactization/implementation
~~~
が残るが、S005/S007で既に実機検証済み。

Resolution:
S002はcurrent-stateとしてS005/S006へdelegateし、pending validationを主張しない。historical candidate stateはrecords/historyに保持。

## F10 — current normative files retain completed artifact migration actions
Severity: MEDIUM

例:
~~~
S005 artifact_action: encode Worktree Materialization Contract...
S007 artifact_action: record branch/upstream separation...
~~~

Artifact v2へ既にprojection済み。

Resolution:
historical outcome metadataと明示するかcompleted projection statusへ更新し、pending actionに見せない。

## F11 — Worktree command required wording lacks adoption precondition
Severity: MEDIUM

S006_WORKTREE_COMMANDS.md はcreate/status/removeをrequiredとするが、Work Identityは全Workにworktreeを強制せず、development-executionも必要なprojectだけpublic surfaceへ接続するとする。

Resolution:
~~~
If a project adopts the Work Identity worktree lifecycle capability,
its public semantic surface MUST provide create/status/remove semantics.

Work Identity existence alone does not require Work-specific worktrees.
~~~

## F12 — path placeholder alternates between split identity and one token
Severity: LOW

Canonical filesystem form:
~~~
.worktrees/<work-type>/<work-name>/
~~~

一部current normative例:
~~~
.worktrees/<work-identity>/documents/
~~~

Resolution:
filesystem contractは明示的な <work-type>/<work-name> を使う。<work-identity> はsemantic valueとしてslash expansionが明示される場合だけ使用。

## F13 — plaru_expo project-specific DIR precedent is potentially misleading
Severity: LOW-MEDIUM

development-execution/S003_COMMAND_INTERFACE_AND_CI.mdには plaru_expo固有:
~~~
DIR=.worktrees/<task>
→ operationごとに /main / /android をproject-local derivation
~~~
が例として残る。

本文はgeneric DIRへ持ち込まないと明記しているため直接矛盾ではないが、example-first readingでは誤誘導し得る。

Resolution:
- generic literal-path examplesを先に維持
- plaru_expoはproject-specific specialization / counterexampleとして明確にラベル
- generic recommendationではないことを強調

# Additional audit conclusions

## Encapsulation Horizon / Code Design
No structural contradiction found.
module hardening prior と feature/module-first code organizationは別軸として共存可能。

## Resource ownership/materialization
No major contradiction found.
~~~
work-identity = scope/identity/lifecycle
development-execution = runtime materialization
development-safety = destructive cleanup/recovery
~~~

## Verification ownership
No major contradiction found.
~~~
code-design = test/contract/outcome semantics
development-execution = execution command / CI parity
engineering-operation = done claim / verification process
~~~

# Implementation plan

1. このIssueを source record として documents/knowledge/records/2026-10-03-subject-consistency-convergence/ にsnapshotする
2. F1–F13をcurrent normative subjectsへ反映し、historical evidenceは削除しない
3. ownershipを維持:
   - documentation問題 → documentation
   - Work Identity/worktree問題 → work-identity
   - overall Work confirmation routing → engineering-operation
   - generic DIR → development-execution
4. cross-subject consistencyを再監査
5. changed canonical meaningをArtifact v2へprojection
6. duplicate authorityを作らず、必要なrouter/leafだけ更新
7. regression-prone boundaryへdeterministic integrity guardを追加
8. tests:
~~~
bash tests/test-knowledge-integrity.sh
bash tests/test-artifacts.sh
bash tests/test-agent-harness.sh
~~~
9. independent review before merge

# Non-goals

- historical records内の旧layoutを削除しない
- 8-subject decompositionを今回変更しない
- generic DIR semanticsを再設計しない
- partial/module Artifact distributionを復活させない
