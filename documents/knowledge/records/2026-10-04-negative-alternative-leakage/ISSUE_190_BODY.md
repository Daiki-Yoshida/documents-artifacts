## 背景

Artifact v2 は、`documents/knowledge/subjects/` の semantic completeness をそのまま複製するのではなく、AI runtime向けに current-effective knowledge を選択し、context圧縮・不要情報削減・routing最適化を行う第2情報源である。

今回、Project / Component repository guidance の実運用で、旧・非推奨・不要な代替モデルを「それを否定するため」にArtifactへ持ち込んだ結果、current positive modelよりもalternative側が目立ち、AIの推論空間を不要に広げる問題が観測された。

典型形:

~~~text
本来:
  Bがcurrent/recommended。
  Xを行えばBになる。

anti-pattern:
  Aは推奨されない。
  Aとはこういうもの。
  YをするとAになる。
  Aを使うな。
  ちなみにBを推奨する。
~~~

この問題を、Artifact projection / compressionに固有のアンチパターンとして明文化する。

## 名称

**Negative Alternative Leakage (NAL)**  
日本語: **否定代替案リーク**

### 定義

情報を圧縮・投影してconsumer向けcontextを作る際、本来は削減対象である旧案・不採用案・望ましくない代替モデルを、「それを否定する説明」のためにruntime contextへ再導入し、current positive modelよりも不要なalternativeを目立たせてしまうアンチパターン。

重要:

- 「否定文そのもの」が問題なのではない。
- current safety constraintや、positive ruleだけでは防げないrealistic failure modeへのnegative guardは必要になり得る。
- 問題は、**projection/compressionで落とせるnon-current / undesired alternativeを、否定説明のためだけに再導入すること**。
- positive current modelだけで十分にagentを正しく導ける場合は、それを直接記述する。

## 適用境界

NALは **projection / compression / runtime guidanceのアンチパターン** であり、knowledge preservationのアンチパターンではない。

~~~text
records
  source completeness
        ↓
subjects
  semantic completeness
  + current / superseded / rejected / unresolved
        ↓
artifact projection / compression
        ↓
artifacts
  runtime relevance / small relevant context
~~~

### subjectsでは旧案・否定・historyを保持してよい

`documents/knowledge/subjects/` は情報削減層ではない。

subjectsでは:

- current knowledge
- superseded knowledge
- rejected proposals
- unresolved conflicts
- meaningful historical model
- 否定・訂正・反論・Decision Lineage

を、semantic completenessのために保持することが正しい。

NALを理由にsubjectsからnon-current semantic knowledgeを削除してはならない。

### Compression ruleを上流へ逆流させない

Artifact向け削減規則をrecords / subjectsへ誤適用し、

> 「NALだから旧案・否定情報をsubjectsから消す」

と判断すること自体も別の誤りである。

必要であれば、この逆流を **Compression Backflow** 等の名称でguardとして整理することを検討する。ただし本Issueの主目的はNALの定義とprojection規則への反映である。

## Positive-first projection principle

Artifact projectionでは、可能な場合:

~~~text
current positive model
  → expected state / role / procedure
  → necessary condition / exception
~~~

を直接記述する。

避けるべき形:

~~~text
obsolete / rejected / undesired alternative
  → alternativeの詳細説明
  → alternativeの否定
  → 最後にcurrent model
~~~

### 例

Bad:

~~~text
Do not use model A.
Model A means ...
Do not arrange the workspace like A.
Use model B instead.
~~~

Better:

~~~text
Use model B.

Its roles are:
...

Its filesystem layout is:
...
~~~

### Negative guardを残してよい条件

negative guardをArtifactへ残す場合、少なくとも次を確認する:

- その禁止対象が現実的なruntime failure modeである。
- positive current ruleだけでは十分に防げない。
- alternativeの説明を持ち込むcontext costより、guardのdecision valueが高い。
- obsolete model全体を説明しなくてもguardを短く表現できるなら、短いguardだけを残す。

current safety contractそのものがnegative formであるものはNALではない。

例:

- uncommitted worktreeを破棄しない
- secretを出力しない
- incompatible writable worktree間でbranchを共有しない

## 現行modelとの関係

既存 `documents/knowledge/system/ARTIFACT_MODEL.md` には:

- complete superseded / rejected semantic modelは通常projectionしない
- history / provenance / obsolete alternativesは圧縮可能
- runtimeに必要なnegative guardは残せる

という原則がある。

一方で現在は、

> old modelを禁止するnegative guardがcurrent ruleならprojectionできる

という条件が比較的広く、negative guardがpositive current modelよりruntime contextを占有するケースを十分に防げていない。

NALはこの境界を明確化するための追加原則として扱う。

## 想定変更箇所

canonical / system:

~~~text
documents/knowledge/system/ARTIFACT_MODEL.md
documents/knowledge/system/SUBJECT_MODEL.md   # compression ruleの逆流防止guardのみ
~~~

repository-local workflow:

~~~text
documents/project/KNOWLEDGE_UPDATE_WORKFLOW.md
documents/project/ARTIFACT_ARCHITECTURE_V2.md
~~~

必要に応じて:

~~~text
documents/knowledge/system/DECISION_LINEAGE_MODEL.md
tests/test-knowledge-integrity.sh
tests/test-agent-harness.sh
tests/scenarios/<projection-focused-scenario>/
~~~

Artifact runtime pack自体へNALというmeta-conceptを配布する必要性は別途判断する。
NALは主にArtifactを**生成・保守する側のprojection rule**であり、target projectの通常agentへ無条件配布するengineering ruleではない。

## 実装方針

1. このIssue/議論を第0情報源としてrecord化する。
2. Artifact ModelへNALをprojection/compression anti-patternとして定義する。
3. Subject Modelへ「Artifact compression ruleをsemantic preservation層へ逆流させない」boundaryを明示する。
4. Knowledge Update Workflowへpositive-first projection reviewを追加する。
5. negative guardのprojection条件を明確化する。
6. 必要なdeterministic guard / agent scenarioを追加する。
7. 既存Artifact v2をNAL観点で別途監査するかは、このIssueの実装結果を見て判断する。

## 非目標

- subjectsからsuperseded / rejected / historical knowledgeを削除すること
- negative sentenceを一律禁止すること
- safety / destructive-operation等のcurrent negative contractを削除すること
- Artifactを単なるpositive-only文書へ変えること
- 今回観測された個別のProject / Component repository問題をこのIssueだけで修正すること

個別問題は別Issueで扱う。

## 完了条件

- NALの定義と適用境界がcanonicalなsystem knowledgeに記録されている。
- subjectsのsemantic completenessとNALが矛盾しないことが明文化されている。
- Artifact projection時にpositive current modelを優先し、不要なalternativeを否定説明のためだけに再導入しない判断規則がある。
- negative guardを残す条件が説明可能になっている。
- compression ruleをsubjects/recordsへ逆適用しないguardがある。
- 必要なvalidation / regression guardが追加されている。

