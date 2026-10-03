# Subject Model

`subjects/` は、recordsを根拠として、責務範囲・概念・domain knowledgeごとに整理し、**semantic completenessと現在のeffective statusを表現する**日本語knowledgeを置く層である。

## 目的

recordsは情報保存には強いが、量が増えるほど横断的な理解が難しくなる。

subjectsは、原文を単に並べるのではなく、保持している情報を意味構造に沿って整理する。

同時に、同一scopeの複数世代knowledgeを無評価で平坦化せず、Decision Lineageを根拠にcurrent / superseded / rejected / unresolvedを区別する。

```text
records
  ↓ 情報を失わない根拠
subjects
  ↓ 整理された第1情報源
artifacts
  ↓ 圧縮された第2情報源
```

## Directory

```text
subjects/
└─ <subject>/
   ├─ INDEX.md
   └─ <responsibility>.md
```

例:

```text
subjects/work-identity/
subjects/encapsulation-horizon/
```

subject directoryはtopic tagではなく、独立して理解・保守する価値のある知識対象を表す。

## File naming

subject内の整理済み本文fileには、公式な構造順・推奨読書順を表す `SNNN_` prefixを付ける。

```text
subjects/<subject>/
├─ INDEX.md
├─ S001_<NAME>.md
├─ S002_<NAME>.md
└─ ...
```

規則:

- `INDEX.md` はsubject本文のsectionではなく入口なので番号を付けない。
- `S001`, `S002`, ... はsubject内の公式な構造・推奨読書順を表す。
- 3桁zero paddingを使用する。
- 番号は恒久IDではない。subject構造を大きく再編した場合は、Git historyを利用して必要に応じてrenameしてよい。
- 将来挿入用の空き番号を確保する目的で10刻みにはしない。
- file名の意味部分は責務を表す大文字snake caseを基本とする。

例:

```text
INDEX.md
S001_CORE_PRINCIPLE.md
S002_RESPONSIBILITY_AND_HORIZON.md
S003_HARDENING_POLICY.md
```

## Subjectの粒度

subjectは単なるカテゴリやumbrellaではなく、**その名前を主語にして独立した概念・責務・制約・lifecycleを説明できる知識領域**とする。

複数の異なる責務を「関連しているから」という理由だけで1subjectへ集約しない。

兆候:

- subject名が広すぎて、内部file間で主語が変わる。
- 別subjectとownership境界が何度も衝突する。
- safety / execution / structure / lifecycleなど異なる判断軸が同居する。
- 新情報を追加するとき「どこに置くか」を毎回例外判断する必要がある。

この状態になったsubjectは、より明確な責務へ分解する。

例として、旧 `development-environment` umbrellaは次へ分解された。

```text
workspace-structure
development-execution
development-safety
work-identity
```

`development-environment` という語自体はこれらを総称する人間向けカテゴリとして使用できるが、独立したsubject authorityは持たせない。

## 分割基準

subject内部はWHY/HOW/WHERE/FLOWのような一律のfacetでは分けない。

その知識対象自身の責務・概念構造・lifecycleに沿って分ける。

例えばWork Identityであれば、必要に応じて次のような責務に分割できる。

- identity model
- Work Root
- Work Documents
- repository / branch relation
- worktree materialization
- resource ownership
- completion

実際のfile分割は情報量と責務境界に応じて決める。

## Semantic completeness

subjectsのcompleteはrecordsのsource completenessとは異なる。

```text
records
  = 原文・event・evidenceのsource completeness

subjects
  = reusableな意味・判断・制約・反論・評価関係のsemantic completeness
```

subjectsはrecordsを逐語再掲する必要はない。

一方、superseded / rejected / obsoleteだからという理由だけでreusable semantic knowledgeを削除しない。

## Effective status

subjectsでは少なくとも次を区別できるようにする。

```yaml
current: "現在有効なknowledge / decision / constraint"
superseded: "以前は有効だったが後続decisionにより置換された"
rejected: "proposal / candidateだったが明示的に不採用となった"
unresolved: "現在も判断・scope conflictが解決されていない"
```

validation / observation / experimentはeffective statusではなくevidence / eventとして扱う。

ordinaryな `S001_...` 等のcurrent surfaceは、明示的にnon-currentとlabelしない限りcurrent knowledgeとして読まれる。したがってsuperseded / rejected knowledgeを無labelでcurrent proseへ混在させない。

`unresolved` は「まだ決まっていない」というcurrent factなのでcurrent surfaceへ明示できる。

## Current surfaceとHISTORY

substantialなsuperseded / rejected / obsolete semantic modelは `*_HISTORY.md` 等の明示的non-current areaへ整理できる。

`*_HISTORY.md` はsubjectsの一部であり、semantic completenessの一部を担う。raw record archiveではない。

HISTORYへ置ける代表例:

- superseded semantic model
- rejected design
- obsolete terminology
- meaningful transition
- current model理解に価値があるpast semantic state

current fileへnon-current contextを残す場合は `Superseded` / `Rejected` / `Historical context` 等で明示する。

## Subject disposition

recordからsubjectsへmeaningful informationを反映するとき、「採用する/捨てる」の二択にしない。

```yaml
current: "current subject surfaceへ反映"
non_current: "HISTORY / explicit non-current areaへ反映し、superseded/rejectedを明示"
unresolved: "未解決であることをcurrent subject surfaceへ反映"
routed: "別subjectがsemantic ownerなのでそこへ反映"
represented: "同じsemantic meaningが既存subjectに既に存在"
evidence_only: "raw evidence/provenance/logとしてrecordsへ保持し、subject本文へraw複製しない"
```

重要なsemantic claimを分類せず黙って落とさない。

`evidence_only` かreusable semantic knowledgeか判断できない場合、勝手に削らずpreserve / route / unresolvedとして扱う。

## 情報保存方針

subjectsでは整理のために以下を許可する。

- 関連recordの統合
- 時系列情報の再配置
- 同一概念の近接配置
- 重複説明の整理
- 日本語表現の統一
- headingやfile構造の再設計

ただし目的はcontext圧縮ではない。

禁止・注意:

- token削減のために重要情報を落とす
- semantic meaningを持つsuperseded / rejected knowledgeを「もう使わない」という理由だけで削除する
- 不確定情報を確定事項へ変える
- 「Aが提案された」を「Aがcurrentである」へ変える
- 条件・例外・評価の強さを弱める
- source / Decision Lineageに存在しない結論を追加する
- old/new decisionをeffective status未解決のまま両方currentとして併記する
- 日付が新しいことだけでcurrent authorityを決める

肥大化は許容する。短さより情報完全性と理解可能性を優先する。

## 日本語

subjects本文は日本語を標準とする。

技術用語、固有概念、code、command、API名などは意味精度のため原語を維持してよい。

## Unresolved conflict

同一scopeのcompeting decisionをrelationで解決できない場合、latest-winsやsilent mergeを行わない。

`unresolved` としてcurrent surfaceへ明示し、必要なら第0情報源で新しいdecisionを作成する。

具体的なrelation / scope / resolution procedureは `../../system/DECISION_LINEAGE_MODEL.md` を参照する。

## INDEX.md

各subjectの`INDEX.md` は、そのsubjectに固有の入口として使用する。

含めてよい:

- subjectが扱う範囲
- 内部documentの責務
- 読み順
- 関連subject
- source recordへのtraceability

subject本文の別コピーになるような過剰な要約は避ける。

## Overlap

1つの情報が複数subjectに関係することは許容する。

DRYより意味の完全性を優先する。

ただし同じ規範・定義を複数箇所で独立して更新する状態は避け、主責務を明確にする。

## 根拠records

- `../records/2026-09-21-records-subjects-model/`
- `../records/2026-09-21-knowledge-structure-implementation/`
- `../records/2026-09-22-development-environment-subject-split/`
- `../records/2026-10-03-knowledge-effective-status-lineage/`
