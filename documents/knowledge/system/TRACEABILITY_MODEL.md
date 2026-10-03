# Traceability Model

subjectsで整理された情報は、必要なときrecordsへ戻って検証できなければならない。

## 原則

```text
subject knowledge
  ↓
source record
  ↓
第0情報源
```

traceabilityは「subjectを信用しない」ためではなく、整理・統合の過程で意味が変わっていないことと、current / non-current評価の根拠を検証可能にするために持つ。

## Source reference

subject documentには、整理に使用したrecordを追跡できる参照を持たせる。

最低限、file単位で次のようなsource一覧を持てる。

```yaml
sources:
  - "../../records/YYYY-MM-DD-example/"
  - "../../records/YYYY-MM-DD-another-example/"
```

1つのfileが多数の独立した論点を持つ場合、必要に応じてsection単位でsourceを示してよい。

すべてのsentenceへsource markerを付ける必要はない。

## 主張とsourceの関係

subjectに記述する内容は、次のいずれかとして説明可能である必要がある。

- recordに明示された情報
- 複数recordの関係から直接読み取れる情報
- record内で明示された採用・却下・訂正
- 構造整理のための非意味的な再配置

新しい判断が必要なら、subject編集だけで成立させない。

先に第0情報源として議論・判断を行い、それをrecordへ保存したうえでsubjectへ反映する。

## Decision Lineage traceability

複数世代のdecisionが同じsemantic scopeに存在する場合、単純なSources一覧だけでは全sourceが同格に見えやすい。

次の場合はDecision Lineageを明示する:

- current / supersededの区別がsource一覧だけでは不明瞭
- conflictを後続decisionで解決した
- rejected proposalがcurrent modelと混同され得る
- Artifact projectionがどのgenerationをcurrentとして使うかに依存する

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

すべてのsubject fileへこのsectionを強制しない。

relationの意味・scope・resolutionは `DECISION_LINEAGE_MODEL.md` が所有する。

## Conflict

subjectとrecordsに意味差が見つかった場合:

1. 関連recordsを確認する。
2. 後続recordによるadoption / supersede / correction / rejection / refinementとscopeを確認する。
3. current / superseded / rejected / unresolvedの評価を解決する。
4. subjectの整理・status表示ミスならsubjectを修正する。
5. relationで解決できない場合はunresolvedとして明示し、第0情報源で判断して新recordを追加する。
6. 過去recordを現在の結論へ書き換えない。

## Artifactとの関係

artifactsはsubjectsだけでなく、必要に応じてrecordsも参照できる。

ただし通常は整理済みsubjectsを第1入力とし、不明点や細部の検証時にrecordsへ戻る。

artifactから得た要約をsource recordの代わりに使用しない。

## 根拠records

- `../records/2026-09-21-knowledge-record-accuracy/`
- `../records/2026-09-21-records-subjects-model/`
- `../records/2026-10-03-knowledge-effective-status-lineage/`
