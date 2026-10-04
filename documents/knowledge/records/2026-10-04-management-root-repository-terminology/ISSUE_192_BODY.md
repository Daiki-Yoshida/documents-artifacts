## 決定

現行の repository role 名 **Project Repository** を廃止し、canonical current role 名を **Management Root Repository** へ変更する。

日本語では:

~~~text
管理ルートリポジトリ
~~~

を用いる。

この命名変更は候補検討ではなく、現時点の採用判断である。

## 背景

現行の `Project Repository` という名称は、roleの意味を十分に説明していない。

Repository自体が通常何らかのProjectに属するため、

~~~text
Project Repository
Component Repository
~~~

という対比では、`Project Repository` 側が何を追加的に意味しているのか名称から分かりにくい。

実際にこのroleが表しているのは、単に「Projectに属するrepository」ではなく、Project全体の:

- management / coordination
- Project Root ownership
- Project Documentation ownership
- agent entry / routing
- project-level policy
- public command surface
- stable repository identity resolution
- cross-component coordination
- Work Identity coordination state
- project-level `.worktrees/` namespace

の基準となるrepositoryである。

この責務を名称から明示するため、current canonical role nameを:

~~~text
Management Root Repository
~~~

へ変更する。

## 重要: 単なる文字列置換にしない

この変更は:

~~~text
Project Repository
  ↓ search/replace
Management Root Repository
~~~

というmechanical renameではない。

まずcurrent semantic roleを再確認し、**Management Root Repositoryという名称が表すべき責務・境界・filesystem関係をcanonical knowledgeとして明確にした上で**、各文書へ投影する。

特に、既存文書内の `Project Repository` という語には、文脈によって次が混在している可能性がある:

- repository roleそのもの
- Project Root ownership
- project-level coordination authority
- documentation ownership
- Git ownership boundary
- AI development session entry context
- historical / compatibility terminology
- 単なる一般英語としてのproject repository

したがって各出現箇所をsemanticに分類し、role名としての使用だけを適切に移行する。

## Current target model

### Management Root Repository

Project全体のmanagement / coordination rootを所有するrepository。

少なくとも次をproject-levelに所有または基準化する:

- Project Root
- Project Documentation
- agent-facing entry / routing
- project-level policy
- public command interface
- repository/component coordination
- stable repository identity / selector resolution
- Work Identity coordination state
- project-level `.worktrees/` namespace

### Component Repository

component/product固有の:

- source
- test
- component-specific CI / release
- Git history

を所有する独立repository。

### Physical topology

multi-repository Projectのdefault physical modelは、別Issue #191で扱っている通り、role名の変更とは独立して明確化する。

例:

~~~text
<project-root>/                  # Management Root Repository baseline working-tree root
├─ documents/
├─ <component-a>/               # independent Component Repository checkout
├─ <component-b>/               # independent Component Repository checkout
└─ .worktrees/
~~~

filesystem containmentはGit ownershipの親子関係を意味しない。

## Project Rootとの関係

このIssueで確定するのはrepository role名:

~~~text
Project Repository
→ Management Root Repository
~~~

である。

`Project Root` という用語は、現時点では自動的にrenameしない。

理由:

- `Project Root` は「Project全体のfilesystem / development contextの基準root」という意味を実際に追加している。
- `Management Root Repository` と `Project Root` は同じ概念ではない。
- repository roleのrenameを理由に、関連用語まで機械的に変更してはいけない。

必要であれば、`Project Root` を含む周辺terminologyはsemantic review後に別途変更する。

## NALとの関係

関連Issue:

- #190 Negative Alternative Leakage (NAL)
- #191 Project/Component配置とmulti-repo Worktree guidanceのNAL是正

Artifact runtime guidanceでは、旧 `Project Repository` という名称を長く説明して否定することで新名称を教える構造にしない。

原則:

~~~text
Bad:
  Project Repository is no longer used...
  Project Repository meant...
  Do not call it Project Repository...
  Use Management Root Repository instead.

Preferred:
  Management Root Repository owns ...
  Component Repository owns ...
  Default topology is ...
~~~

つまりArtifactではcurrent positive modelを直接投影する。

一方、subjects / historyではsemantic completenessとDecision Lineageのため:

- `Project Repository` がcurrent roleだった期間
- その採用理由
- 今回のrename decision
- Management Root Repositoryへの移行
- 旧 Workspace Repository / parent-child terminologyとの関係

を必要な範囲で保持する。

## Decision Lineage

今回のdecisionは、既存roleの意味をすべて破棄して別conceptへ置換することを意図しない。

基本方針:

~~~text
existing semantic responsibility
        ↓ refine / correct naming and role expression
Management Root Repository
~~~

ただしsemantic reviewで、`Project Repository` 名の下に不適切に混在していた責務や誤った含意が見つかった場合は、単なるrenameとして処理せず、scopeを明示してcorrect / refineする。

Decision Lineage上で:

- 何がsemantic continuationか
- 何がterminology replacementか
- 何が今回新たに明確化されたcontractか

を区別する。

## 想定変更箇所

### records

このIssueと採用判断を第0情報源としてrecord化する。

### canonical knowledge

少なくとも:

~~~text
documents/knowledge/subjects/workspace-structure/
documents/knowledge/subjects/work-identity/
documents/knowledge/subjects/documentation/
documents/knowledge/subjects/development-execution/
documents/knowledge/subjects/development-safety/
~~~

を検索し、role名としての `Project Repository` 使用をsemantic reviewする。

特に:

~~~text
documents/knowledge/subjects/workspace-structure/S001_PROJECT_AND_REPOSITORY_MODEL.md
documents/knowledge/subjects/workspace-structure/S002_GIT_OWNERSHIP_AND_MULTI_REPOSITORY.md
documents/knowledge/subjects/workspace-structure/S003_HISTORY.md
documents/knowledge/subjects/workspace-structure/INDEX.md
~~~

は主要対象。

### Artifact v2

少なくとも:

~~~text
artifacts/project/WORKSPACE.md
artifacts/project/WORK_IDENTITY.md
artifacts/project/WORKTREES.md
artifacts/project/WORK_LIFECYCLE.md
artifacts/project/INDEX.md
~~~

およびrepository roleを参照する関連leafを監査する。

Artifactでは旧名称のmigration explanationを通常runtime contextへ残さず、current positive modelを直接表現する。

### repository-local docs / tests

必要に応じて:

~~~text
documents/project/
tests/test-knowledge-integrity.sh
tests/test-agent-harness.sh
tests/scenarios/
~~~

を更新する。

## 検索・分類方針

全repositoryで `Project Repository` / `Project_Repository` 等を検索する。

各hitを最低限次へ分類する:

~~~yaml
current_role_reference:
  action: "Management Root Repositoryへsemantic rename"

historical_reference:
  action: "historyとして保持。必要ならcurrent nameとのrelationを明示"

quoted_source_record:
  action: "原文保持。変更しない"

generic_english_phrase:
  action: "role名でなければ機械置換しない"

test_fixture_or_expectation:
  action: "current semanticsを検証するfixtureなら更新。historical fixtureなら保持"

project_root_reference:
  action: "Project Rootとrepository roleを混同せず個別判断"
~~~

## Regression guard

最低限、次を機械的またはagent scenarioで確認する:

- current normative surfaceでcanonical roleが `Management Root Repository` になっている。
- current Artifact runtime guidanceが `Management Root Repository` をpositive modelとして使用する。
- current roleとして `Project Repository` が不用意に残っていない。
- raw records / quoted historical sourceは改変されていない。
- historical subject areaでは旧名称が適切にhistoryとして保存されている。
- `Project Root` が誤って一括renameされていない。
- Component Repositoryとのownership / topology semanticsがrenameで変質していない。
- #191で明確化するphysical topologyと整合する。
- #190のNAL原則に反して旧名称の長い否定説明をArtifactへ持ち込んでいない。

## 実装順序

推奨:

1. このdecisionをrecord化。
2. current semantic role / ownership / topologyを再確認。
3. Decision Lineageを整理。
4. workspace-structureのcanonical current surfaceを更新。
5. 関連subjectsをsemantic reviewして追従。
6. Artifact projectionをcurrent positive modelとして更新。
7. repository-local docs / tests / scenariosを更新。
8. 全repository検索で未分類hitを0にする。
9. deterministic tests + agent harnessを実行。
10. independent reviewで、mechanical renameになっていないことを確認。

## 非目標

- `Project Root` の自動rename
- Component Repositoryのrename
- repository topologyそのものの全面再設計
- Git submodule化
- historical source / recordsの書換え
- parent/child historyの削除
- NAL一般原則の再定義（#190がowner）
- physical placement問題の主修正（#191がowner。ただしterminology変更後の整合は本Issueでも確認する）

## 完了条件

- current canonical role nameが **Management Root Repository** である。
- 日本語current role nameが **管理ルートリポジトリ** である。
- roleの責務が名称変更後も明確で、単なる文字列置換になっていない。
- `Project Repository` の各既存使用箇所がsemanticに分類され、current / historical / source / unrelated phraseとして適切に処理されている。
- Artifact runtime guidanceがManagement Root Repositoryのpositive modelを直接提示する。
- subjectsでは旧名称・Decision Lineage・historyが情報削減されず保持される。
- `Project Root` 等の関連概念が誤って巻き込まれていない。
- #190 / #191との整合が検証されている。
- regression guardと必要なagent testがPASSする。

