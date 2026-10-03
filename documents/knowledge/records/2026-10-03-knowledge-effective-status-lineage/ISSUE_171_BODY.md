## Purpose

`records → subjects → artifacts` の知識昇格で、古い情報・新しい情報・提案・採用・訂正・却下・検証を十分に区別せず平坦化すると、supersededな旧モデルがcurrent normativeと同格に見える。

2026-10-03 の parent/child hierarchy → Project Repository / Component Repository 収束作業で、旧Documentation Strategy由来の hierarchical project / Workspace Repository 等がcurrent normativeへ残っていたことが具体例となった。

このIssueでは、情報を削除するのではなく **subjects内でknowledgeの現在評価を明示的に解決する仕組み** を設計する。

Base main at issue creation:

~~~text
75744a9bab0a40bf5f53b1f45b2d599e334a6302
~~~

## Adopted design correction

初期案ではsubjectsを「current effective knowledgeだけのmaterialized view」とし、superseded情報をcurrent subjectsから除外してrecords/HISTORYへ委譲する方向を検討した。

この方向は採用しない。

理由:

- AIが「不要」と判断して、本来subjectsに保持すべきsemantic informationまで削る危険がある。
- 現行Subject Modelの「情報を変更・劣化させず、recordsに散らばるknowledgeを整理する」という強みを失う。
- recordsが原文、subjectsがsemantic knowledge、artifactsがruntime projectionという3層責務を維持した方が安全。

採用する中核原則:

> **subjectsは保存済みknowledgeを捨てない。recordsに散らばった情報を意味構造に沿って整理し、それぞれが現在有効か、現在有効ではないか、未解決か、どのdecision/evidenceに支えられているかを明示する。**

## Three-layer responsibility

~~~text
records
  「何があったか」を完全保存
  source completeness / immutable evidence

        ↓ semantic organization + evaluation

subjects
  「何が記録され、それぞれが現在どう評価されているか」を
  情報劣化なく完全に整理
  semantic completeness + effective-status resolution

        ↓ current-effective projection

artifacts
  「現在AIが使うべきknowledge」を
  routing / compression / translation / distributionへ最適化
  runtime guidance
~~~

### records — source completeness

- 第0情報源本文・snapshotを原文として保持する。
- proposal / adoption / rejection / correction / validation / experimentを削除しない。
- 後続判断のために過去recordを書き換えない。
- Git historyとrecordsがhistorical completenessを担う。

### subjects — semantic completeness + current evaluation

- recordsの単純合集ではなく、意味構造に沿って統合・整理する。
- 意味を変更・弱化・欠落させない。
- superseded / rejected / obsoleteだからという理由だけでsemantic knowledgeを捨てない。
- ただし、**current effectiveかどうかを必ず区別できるようにする。**
- 同じsubject内で旧modelと新modelが無評価で同格に見える状態を禁止する。

### artifacts — current runtime projection

- 原則としてcurrent effective knowledgeを主入力とする。
- runtime判断に不要なhistory / rejected model / provenance detailは通常配布しない。
- ただし現在の誤読防止に必要なnegative guardはcurrent guidanceとして投影できる。
- Artifactは改善・圧縮・再構成してよいが、current subjectの意味・条件・例外・強度を弱めない。

## Semantic completeness vs source completeness

subjectsがrecordsを逐語再掲する必要はない。

区別:

~~~text
records
  source completeness
  = 原文・event・evidenceを完全保存

subjects
  semantic completeness
  = reusableな意味・判断・制約・反論・評価関係を
    情報劣化なく整理して保持
~~~

重複原文・raw execution log・snapshot payloadをsubjectsへそのまま複製する必要はない。

一方、semantic meaningを持つ旧判断を「もう使わないから」とsubjectsから消すこともしない。

## Effective status model

subjectsでは少なくとも次を区別できるようにする。

~~~yaml
effective_status:
  current: "現在有効なknowledge / decision / constraint"
  superseded: "以前は有効だったが後続decisionにより置換された"
  rejected: "提案・候補だったが明示的に不採用となった"
  unresolved: "現在も判断が確定していない / conflictが未解決"
~~~

`validation` / `observation` / `experiment` はdecision statusと同じ軸ではなく、decisionを支持・反証するevidence relationとして扱う方向を基本とする。

必要なら設計段階でstatus名を調整する。

## Current normative surface

current normative files / sectionsは、現在有効なknowledgeを明確に示す。

重要:

- superseded knowledgeをsubjectsから削除する必要はない。
- ただしsuperseded knowledgeをcurrent ruleと同じ見え方で置かない。
- 大きな旧modelは `*_HISTORY.md` 等のnon-current semantic areaへ整理できる。
- current file内にhistorical contextを置く場合も、明示的な `Superseded` / `Rejected` / `Historical` 等のlabelを必要とする。

現在の `Sxxx_HISTORY.md` patternは維持しつつ、その責務をformalizeする候補とする。

## HISTORY responsibility

`*_HISTORY.md` はraw recordsのコピーではない。

責務:

~~~text
records
  exhaustive source history

HISTORY
  non-current semantic knowledge / meaningful transition

current subject files
  current effective knowledge + current unresolved state
~~~

HISTORYに整理する候補:

- superseded model
- rejected design
- obsolete terminology
- transition rationale
- current modelの理解に価値があるpast semantic state

raw logや全source本文をHISTORYへコピーしない。

## Unresolved knowledge

`unresolved` は「不要」でも「history」でもない。

現在の事実として「まだ決まっていない」ことをcurrent subject側で明示できる必要がある。

例:

~~~text
Current effective:
  A

Unresolved:
  B/Cのどちらへ将来移行するかは未決定

Historical / rejected details:
  HISTORY / source recordsへtrace
~~~

AIはunresolvedなproposalをcurrent decisionへ勝手に昇格しない。

## Decision Lineage

Decision Lineageはknowledgeを削除するためではなく、**subjects内でeffective statusを正しく評価するため**に使う。

relation候補:

~~~yaml
relations:
  adopts:     "proposalをcurrent decisionとして採用する"
  supersedes: "以前のeffective decision/modelを置換する"
  refines:    "既存decisionを維持しつつ詳細化する"
  corrects:   "既存knowledgeの誤り・scopeを訂正する"
  rejects:    "proposal / candidateを不採用とする"
  validates:  "decision / behaviorをevidenceで確認する"
~~~

最終relation setは設計時に最小化する。

## Important constraint — newer date does not automatically win

単純なdate-only LWWにはしない。

~~~text
newer record
≠ automatically current authority
~~~

新しいrecordがproposal / experiment / investigationである可能性がある。

current evaluationを変えるには、adoption / rejection / correction / supersede等の意味的relationshipを確認する。

## Semantic scope

decision relationはscopeを持つ。

例:

~~~text
general rule A

later Project-X-specific rule B
~~~

BはAのglobal supersedeではない。

初期implementationでは複雑なtaxonomyを作らず、人間/AIが識別可能な自由記述scopeから開始する候補:

~~~yaml
scope: "repository role model"
~~~

## Record immutability and lineage direction

existing old recordsへretroactively `superseded: true` を大量付与するmigrationは行わない。

基本方向:

~~~text
old record
  untouched

later decision record
  declares relation to old record
~~~

例:

~~~yaml
decision_lineage:
  event: "adoption"
  scope: "repository role model"
  supersedes:
    - "../2026-09-21-old-model/"
~~~

record自身に `status: current` は保存しない。current/superseded等は後続decisionで変化し得るため、immutable recordへ可変な現在評価を書かない。recordはその時点のeventを保存し、現在評価はsubjectsがlineageから解決する。

具体schemaは設計時に最小化する。

## Subject disposition — silent deletionを防ぐ

recordからsubjectへ反映するとき、「採用する/捨てる」の二択にしない。

reusableなsemantic informationには、少なくとも次のdispositionを与える。

~~~yaml
subject_disposition:
  current:
    "current effective knowledgeとしてcurrent subject surfaceへ反映"
  non_current:
    "superseded/rejected等としてHISTORY / explicit non-current areaへ反映"
  unresolved:
    "未解決であること自体をcurrent subject surfaceへ反映"
  evidence_only:
    "raw result / provenance / execution log等。意味の根拠としてrecordsへ保持し、subject本文へraw複製しない"
  represented:
    "同じsemantic meaningが既存subjectに既に表現されている。必要に応じtraceabilityだけ追加"
~~~

このdispositionは「AIが不要情報を削る」ためではなく、**meaningful informationがどこへ保持されたかを説明可能にするため**のaccounting ruleである。

重要なsemantic claimを分類せず黙って落とさない。

## Subject traceability

単純なSources一覧は維持できるが、複数世代のdecisionがある場合はauthority relationを表現できるようにする。

例:

~~~text
Decision lineage

Current:
- record C

Superseded:
- record A
  superseded by C

Rejected:
- record B

Supporting validation:
- record D
~~~

全subject fileへこの形式を強制しない。複数世代やconflictがある場合に使う。

## Conflict resolution

同じscopeに複数のadopted/current candidateが存在し、relationが解決されていない場合:

~~~text
DO NOT:
  newest dateを自動採用
  両方を無評価でcurrentとして併記

DO:
  unresolved conflictとしてsubjectsへ明示
  必要なら第0情報源で判断
  新recordでdecision relationを確定
~~~

fail-closedを基本とする。

## Desired Artifact semantics

Artifact v2はsubjects全体を配布するものではない。

~~~text
subjects
  current
  superseded
  rejected
  unresolved
  validation/evidence
       ↓ projection review
artifacts
  current effective guidance
  + runtimeに必要なcurrent unresolved constraint
  + current誤読を防ぐnegative guard
~~~

通常Artifactへ落とす:

- superseded modelの完全説明
- rejected proposalの詳細
- historical transition detail
- provenance / lineage bookkeeping

ただし現在の判断を理解するために不可欠ならcurrent guidanceとして必要部分を投影する。

## Candidate system change

主対象:

~~~text
documents/knowledge/system/KNOWLEDGE_MODEL.md
documents/knowledge/system/RECORD_MODEL.md
documents/knowledge/system/SUBJECT_MODEL.md
documents/knowledge/system/TRACEABILITY_MODEL.md
documents/knowledge/system/ARTIFACT_MODEL.md
documents/project/KNOWLEDGE_UPDATE_WORKFLOW.md
~~~

新規model候補:

~~~text
documents/knowledge/system/DECISION_LINEAGE_MODEL.md
~~~

推奨方向:

- Decision Lineageを独立system modelとして持つ。
- SUBJECT_MODELはsemantic completeness / effective status placementを所有。
- TRACEABILITY_MODELはsource + lineage relationの追跡方法を所有。
- RECORD_MODELはoptional lineage metadataを許可するが、raw source本文とは分離する。
- ARTIFACT_MODELはcurrent-effective projection gateを所有。

## Incremental adoption

全existing records / subjectsを一括migrationしない。

段階導入:

1. system contractを先に確定する。
2. 新しいdecision recordからlineage metadataを利用可能にする。
3. conflict / old-new混在が見つかったsubjectからstatus整理する。
4. existing raw recordsは原則変更しない。
5. Artifact更新時にcurrent effective statusを確認する。

代表fixtureとして今回の:

~~~text
parent/child hierarchy
→ Project Repository / Component Repository
~~~

を利用する。

このcaseにはcurrent / superseded / history / Artifact projectionが揃っている。

## Regression validation direction

単純なword banだけにしない。

検証すべきinvariant:

~~~text
records:
  old model preserved

subjects:
  old model preserved as superseded/non-current
  new model explicitly current
  relation is resolvable

artifacts:
  new model used as runtime guidance
  old model appears only as needed negative guard
~~~

## Non-goals

- recordsをcurrent conclusionへ書き換えること。
- superseded/rejected semantic knowledgeをsubjectsから自動削除すること。
- AIに『不要情報』を自由判断させること。
- 全recordを一括でrelationship graphへmigrationすること。
- date-only latest-wins。
- Artifactへ全history / provenanceを配布すること。
- AI runtimeへDecision Lineage graph全体を毎回読ませること。

## Expected design output before implementation

- Subject semantic completenessのformal definition
- subject disposition / promotion accounting rule
- effective status model
- current / HISTORY / unresolved placement rules
- minimal Decision Lineage relations/schema
- scope resolution rule
- traceability presentation
- Artifact current-effective projection gate
- incremental migration strategy
- regression validation strategy

Implementation approved on 2026-10-03.

Work Identity:

~~~text
docs/knowledge-effective-status-lineage
~~~