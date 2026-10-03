## Purpose

旧 parent/child repository / hierarchical project modelをcurrent normativeから外し、現在の責務ベースのProject Repository / Component Repository modelへDocumentation ownershipを収束する。

Work Identity:

~~~text
docs/project-component-documentation-boundary
~~~

Base:

~~~text
main: ddb63f925ac98766792d9bbae1e191ab6def19f0
~~~

User intent:

- 旧「親リポジトリ / 子リポジトリ」という管理階層はhistorical modelとして扱う
- 現行は「管理リポジトリ / コンポーネントリポジトリ」という責務分離を正本とする
- documentationの hierarchical project / parent-child modelをこの現行modelへ合わせる
- historyは削除せず保存する

## Current role model

### Project Repository

日本語では「プロジェクト管理リポジトリ」「管理リポジトリ」と表現できる。

Project全体のcoordination stateを所有する。代表責務:

- Project Root
- Project Documentation
- agent entry / routing
- project policy
- public command surface
- cross-component coordination
- stable repository identity mapping
- Work Identity coordination state

### Component Repository

日本語では「コンポーネントリポジトリ」。component/product固有のsourceとGit historyを所有する。

Component Repositoryは「子Repository」ではない。filesystem上でProject Repository配下にcheckoutされていても、Git ownership上の親子関係を意味しない。

## Problem 1 — Documentation still owns a hierarchical parent/child model

Current normative file:

~~~text
documents/knowledge/subjects/documentation/S002_ROUTING_AND_STRUCTURE.md
~~~

contains:

~~~text
## 8. 階層プロジェクト
parent_project
child_projects
children.md
親 → 子
~~~

This model originated in the older documentation strategy and predates the current Project Repository / Component Repository responsibility model.

The original source/history must remain preserved, but current normative documentation should no longer treat repository topology as a parent/child documentation hierarchy.

## Problem 2 — Component Repository can be misread as Child Project

A Component Repository participating in a Project does not automatically own an independent Project Documentation tree.

Default:

~~~text
Project
├─ Project Repository
│  └─ documents/INDEX.md
├─ Component Repository A
└─ Component Repository B
~~~

The Project Repository owns the Project-level canonical documentation/routing.

A Component Repository may own component-specific docs/files according to project-local needs, but:

- that does not automatically create a separate Project context;
- it does not automatically require its own documents/INDEX.md;
- it must not create a competing Project-level authority;
- Project-level routing should make component-specific knowledge reachable when needed.

## Standalone context

A repository normally used as a Component Repository can be developed as an intentionally standalone Project.

In that context:

~~~text
same physical repository
  → Project Repository for that standalone Project context
  → owns its own Project Root / Project Documentation
~~~

Classification depends on the Project context that owns the Work, not on a permanent repository label or parent/child filesystem relationship.

## Documentation replacement model

Replace current hierarchical-project normative semantics with a multi-repository Project documentation model.

Desired current model:

~~~text
Project
│
├─ Project Repository / 管理リポジトリ
│   ├─ Project Root
│   ├─ Project Documentation
│   ├─ routing / policy
│   └─ cross-component coordination
│
├─ Component Repository A
│   └─ component-owned source/history/docs as needed
│
└─ Component Repository B
    └─ component-owned source/history/docs as needed
~~~

### Routing rule

Project Documentation should document/route:

- repository/component topology;
- responsibility boundaries;
- cross-component relationships;
- where component-specific knowledge lives when it matters to Project work.

Do not require a special children.md role. Possible project-local files such as components.md, repositories.md, architecture.md, or workspace.md are routing choices, not universal filenames.

## Parent/child terminology

Current normative guidance should avoid parent repository / child repository / parent project / child project when describing Project Repository / Component Repository relations.

Reason:

- implies ownership/dependency direction not actually guaranteed;
- conflates filesystem containment with Git ownership;
- conflicts with standalone Component Repository context;
- duplicates the responsibility model already owned by workspace-structure.

Parent/child terminology may remain in source records, history files, and explicit descriptions of the old model.

## Workspace Repository

Current workspace-structure also defines Workspace Repository and then states that in multi-repository Projects Workspace Repository = Project Repository.

### Decision

- Project Repository is the canonical current role name.
- Component Repository is the canonical participating repository role.
- Workspace Repository should not be required as a third peer role.
- Where useful for traceability, Workspace Repository may be described as a historical / compatibility term for a Project Repository that primarily owns workspace coordination.

Do not require a separate Workspace Repository concept in the current model.

## Subject ownership

### workspace-structure owns

- Project Repository / Project Root
- Component Repository
- stable repository identity / location
- project-level Git ownership boundary
- multi-repository topology
- standalone Project context classification

### documentation owns

- Project Documentation routing and structure
- how Project-level docs route to component-specific knowledge
- no duplicate authority
- no automatic independent documentation tree per Component Repository

Documentation must consume repository roles from workspace-structure rather than redefine repository hierarchy.

## History preservation

Do not delete historical material.

Existing parent/child hierarchy source remains in documents/knowledge/records/** and documents/knowledge/subjects/documentation/S006_HISTORY.md.

Current history should explicitly state that the old parent/child hierarchical-project model is superseded by the responsibility-based Project Repository / Component Repository model.

## Expected canonical changes

Likely:

~~~text
documents/knowledge/subjects/documentation/INDEX.md
documents/knowledge/subjects/documentation/S001_PRINCIPLES.md
documents/knowledge/subjects/documentation/S002_ROUTING_AND_STRUCTURE.md
documents/knowledge/subjects/documentation/S003_WORKFLOW.md
documents/knowledge/subjects/documentation/S006_HISTORY.md

documents/knowledge/subjects/workspace-structure/INDEX.md
documents/knowledge/subjects/workspace-structure/S001_PROJECT_AND_REPOSITORY_MODEL.md
documents/knowledge/subjects/workspace-structure/S002_GIT_OWNERSHIP_AND_MULTI_REPOSITORY.md
documents/knowledge/subjects/workspace-structure/S003_HISTORY.md
~~~

Only touch additional canonical files when required for consistency.

## Artifact projection

Likely:

~~~text
artifacts/documentation/PRINCIPLES_AND_ROUTING.md
artifacts/documentation/WORKFLOW_AND_MAINTENANCE.md
artifacts/project/WORKSPACE.md
~~~

Do not introduce new Artifact domains or partial/module distribution.

## Regression guards

Add deterministic guards for:

- no current normative hierarchical-project parent/child repository model;
- no required children.md role;
- Project Repository / Component Repository remain canonical current roles;
- Component Repository does not automatically imply independent Project Documentation;
- Workspace Repository is not required as a separate third peer role;
- historical parent/child source remains preserved.

## Non-goals

- do not remove support for genuinely independent Projects;
- do not forbid a physical repository from acting as Project Repository in one context and Component Repository in another;
- do not force component-specific documentation into the Project Repository if Git ownership requires it elsewhere;
- do not redesign Work Identity / DIR / Project Root semantics;
- do not delete historical records.

## Validation

~~~bash
bash -n tests/test-knowledge-integrity.sh
bash tests/test-knowledge-integrity.sh
bash tests/test-artifacts.sh
bash tests/test-agent-harness.sh
~~~

Independent review before merge.