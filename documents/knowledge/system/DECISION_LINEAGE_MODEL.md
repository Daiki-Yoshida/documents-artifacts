# Decision Lineage Model

Decision Lineageは、recordsに保存された複数世代のdecision / proposal / evidenceの関係を解決し、subjectsで各knowledgeの**現在のeffective status**を正しく表現するためのsystem modelである。

このmodelはknowledgeを削除するためのfilterではない。

```text
records
  source event / immutable evidence
       ↓
Decision Lineage
  relation / scope / conflict resolution
       ↓
subjects
  semantic completeness
  + effective-status resolution
       ↓
artifacts
  current-effective runtime projection
```

## 1. 基本原則

### Preservation and current authority are separate axes

情報を保存することと、現在有効なauthorityとして扱うことを分離する。

- recordsは「何が起きたか」を保持する。
- Decision Lineageはdecision間の関係を解決する。
- subjectsはsemantic knowledgeを捨てず、現在評価を明示する。
- artifactsはcurrent effective knowledgeをruntime向けにprojectionする。

### Date is not authority

recordの日付はevent順序を示すが、authorityを自動決定しない。

```text
newer record
!= automatically current
```

新しいrecordがproposal / experiment / investigation / rejected ideaである可能性があるため、current evaluationは意味的relationで解決する。

## 2. Record event

recordはそのsource event時点で何が起きたかを表す。

record自身へ、将来変化し得る現在評価を固定しない。

禁止例:

```yaml
current: true
superseded: true
```

代わりに、必要な後続recordがeventとrelationを宣言できる。

```yaml
decision_lineage:
  event: "adoption"
  scope: "repository role model"

  adopts:
    - "../proposal-record/"

  supersedes:
    - "../older-decision-record/"
```

metadataはraw source本文とは別に置く。既存old recordを後からcurrent conclusionへ書き換えない。

## 3. Event type

初期contractで使用するevent type:

```yaml
event:
  proposal: "案・candidateを提示したsource event"
  adoption: "proposal / candidate / decisionを採用したsource event"
  rejection: "proposal / candidateを明示的に不採用としたsource event"
  correction: "既存knowledgeの誤り・scopeを訂正したsource event"
  validation: "decision / claimを検証したsource event"
  observation: "判断を伴わない観測・調査・実験結果"
```

event typeだけでcurrent statusを決めない。relation / scope /後続decisionを合わせて解決する。

## 4. Relation

初期contractで使用するrelation:

### adopts

proposal / candidateを採用decisionへ昇格する。

```text
proposal A
   ↓ adopts
adoption B
```

### supersedes

同じsemantic scopeの以前のeffective decision / modelを置換する。

置換されたsemantic knowledgeはsubjectsから削除せず、supersededとして保持する。

### refines

既存decisionのcompatibleな意味を維持しつつ、detail / condition / explanationを追加・明確化する。

refinesは以前のmeaning全体をnon-currentにしない。

### corrects

既存knowledgeの誤った部分・scopeを訂正する。

訂正対象外のmeaningは自動でsupersedeしない。

### rejects

proposal / candidateを明示的に不採用にする。

### validates

decision / claimへsupporting evidenceを与える。

validatesだけではeffective statusをcurrentへ変更しない。

## 5. Semantic scope

relationは何についてのdecisionかを識別できるscopeを持つ。

初期contractではfree-textを許可する。

```yaml
scope: "repository role model"
```

固定taxonomyを必須化しない。

rules:

- narrower / project-specific decisionはgeneral decisionを自動でglobal supersedeしない。
- 異なるscopeなら複数decisionが同時にcurrentであり得る。
- scope overlapが曖昧なら推測で解決しない。
- scope ambiguityは `unresolved` として扱う。

## 6. Subject effective status

effective statusはimmutable record metadataではなく、subjectsがDecision Lineageから解決する**現在評価**である。

すべての歴史的fact / raw evidenceへstatus labelを強制しない。effective statusを明示的に解決すべき主対象は、現在のauthority・規範・設計判断・constraintとして誤読され得るsemantic knowledge、および複数世代が存在するknowledgeである。

core status:

```yaml
current:
  "現在有効なknowledge / decision / constraint"

superseded:
  "以前は有効だったが後続decisionにより置換された"

rejected:
  "proposal / candidateだったが明示的に不採用となった"

unresolved:
  "現在も判断・scope conflictが解決されていない"
```

validation / experiment / observationはeffective statusではなくevidence/event軸である。

deprecated-but-supportedのような状態は、current knowledgeがdeprecation policyを記述しているものとして扱える。新statusを安易に増やさない。

## 7. Resolution procedure

subjectで現在評価を決めるとき:

1. relevantなsemantic claimを特定する。
2. claimのscopeを確認する。
3. related recordsのevent / relationを確認する。
4. adoption / rejection / supersede / correction / refinementを解決する。
5. reusable semantic meaningをsubjectsへ保持する。
6. current / superseded / rejected / unresolvedを明示する。
7. validation等のevidence relationを必要に応じてtraceする。

### Fail closed

同じscopeで複数のcurrent candidateが存在し、relationで解決できない場合:

禁止:

- newest dateを自動採用する。
- 両方を無評価のcurrent ruleとして併記する。
- 一方を「古そう」「不要そう」と判断して削除する。

必要:

- `unresolved` としてsubject current surfaceへ明示する。
- 必要なら第0情報源で判断する。
- 新しいrecordでrelationを確定する。

## 8. Subject disposition accounting

recordからsubjectsへ反映するmeaningful informationは、黙って落とさずdispositionを説明可能にする。

```yaml
current:
  "current effective knowledgeとしてcurrent subject surfaceへ反映"

non_current:
  "superseded / rejected等としてHISTORYまたは明示的non-current areaへ反映"

unresolved:
  "未解決であること自体をcurrent subject surfaceへ反映"

routed:
  "別subjectがsemantic ownerであり、そこへ反映"

represented:
  "同じsemantic meaningが既存subjectに既に表現されている"

evidence_only:
  "raw evidence / provenance / execution log等。recordsへ保持し、subject本文へraw複製しない"
```

`evidence_only` はreusable semantic claimを隠すために使わない。

meaningかevidenceだけか判断できない場合、勝手に削らず、preserve / route / unresolvedのいずれかで扱う。

## 9. HISTORYとの関係

`*_HISTORY.md` はsubjectsの一部であり、semantic completenessの一部を担う。

主に次を整理できる:

- superseded semantic model
- rejected design
- obsolete terminology
- meaningful transition
- current model理解に価値があるnon-current knowledge

HISTORYはraw record archiveではない。source本文・raw logの完全保存はrecordsが所有する。

## 10. Traceability trigger

すべてのsubject fileにDecision Lineage sectionを強制しない。

次の場合に明示する:

- 同一scopeに複数世代のdecisionがある。
- current / supersededの区別がsource一覧だけでは不明瞭。
- conflictを後続decisionで解決した。
- Artifact projectionがどのgenerationをcurrentとして使うかに依存する。

例:

```text
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
```

presentation detailは `TRACEABILITY_MODEL.md` が所有する。

## 11. Artifact projectionとの関係

Artifact projectionは、subjectsのstatusを無視して全knowledgeを平坦化しない。

主入力:

- current effective knowledge
- runtime判断へ必要なunresolved constraint
- current misreadingを防ぐnegative guard

通常projectionしない:

- complete superseded model
- rejected proposal detail
- lineage bookkeeping
- historical provenance

old modelへのnegative guard自体がcurrent ruleならprojectionできる。

## 12. Incremental adoption

既存records / subjects全体を一括migrationしない。

- 新しいdecisionからoptional lineage metadataを使える。
- conflict / multiple-generation混在を見つけたsubjectからstatusを整理する。
- 既存record本文は原則変更しない。
- 既存HISTORYを一括で書き換えない。
- Artifact更新時はcurrent effective statusを確認する。

reference fixtureとして、2026-10-03のparent/child hierarchy → Project Repository / Component Repository収束を使用する。

## Sources

- `../records/2026-10-03-knowledge-effective-status-lineage/`
