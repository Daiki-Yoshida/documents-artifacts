# Artifact Model

`artifacts/` は、`documents/knowledge/` に整理された第1情報源を、**様々なprojectのAIが少ないcontextで適切に利用できる形へprojectionした第2情報源**である。

artifactはknowledgeの保存形式ではなく、AIへのdelivery / routing形式である。

## 1. Authority

```text
第0情報源
  ↓
records
  ↓
subjects
  ↓
artifacts
  ↓
target projects
```

意味・評価・authorityに疑義がある場合は常にsubjects / recordsへ戻る。

artifactだけを編集して新しいreusable knowledgeを成立させない。

## 2. SubjectとArtifactの分割原理は異なる

subjectsは**semantic ownership**で正規化する。

artifactsは**AI consumption**で再構成する。

したがって、subject directoryとartifact fileを1対1対応させる必要はない。

```yaml
subjects:
  optimize_for:
    - "意味の完全性"
    - "semantic ownership"
    - "traceability"
    - "保守可能な責務境界"

artifacts:
  optimize_for:
    - "AIのtoken効率"
    - "taskから必要knowledgeへのrouting"
    - "progressive disclosure"
    - "適切な1回あたりcontext量"
    - "projectへそのまま配布できる自己完結性"
```

複数subjectを1 artifactへprojectionしてよい。
1 subjectを複数artifactへ異なる利用文脈でprojectionしてもよい。

ただし、同じ規範を複数artifactが独立authorityとして再定義しない。

## 3. 配布単位と読書単位を分離する

artifact fileがtarget projectに存在すること自体はAI tokenを消費しない。
token costは、AIが実際にcontextへ読み込むfile量で決まる。

したがってartifact architectureでは、**配布物を細かく選択することより、配布後に必要fileだけへ到達できるroutingを優先する。**

原則:

- target projectへは一貫したartifact packを配布できる。
- packの入口は小さいrouting fileとする。
- AIはtaskに必要なfileだけを読む。
- 「念のため全部読む」を通常経路にしない。
- specialized knowledgeは通常taskのcontextへ自動的に入れない。

## 4. Routing-first

artifact packは単一の入口を持つ。

入口の責務:

- artifact packのauthorityを短く説明する。
- project-local instructionとの関係を示す。
- task typeから読むべきfileをrouteする。
- 通常は何を読まなくてよいかも示す。
- 各leaf fileの本文を入口へ複製しない。

leaf artifactは冒頭で、自分を読む条件・扱う判断・関連fileへの追加routingを明示できる。

routing chainは浅く保つ。
通常taskで入口から何段も辿らないと規範へ到達できる構造を避ける。

## 5. Progressive Disclosure

artifactでは、すべてのknowledgeを一度にcontextへ投入しない。

```text
small entrypoint
      ↓
task-relevant primary artifact
      ↓ 必要な場合のみ
specialized / cross-cutting artifact
```

一つのtaskで常時全artifactを読む必要があるなら、file splitまたはroutingに失敗している可能性が高い。

## 6. Projectionで残すもの

artifactへ優先して残す:

- 現在採用されている規範
- 判断条件
- MUST / SHOULD等の強度
- 適用条件と例外
- 誤読しやすいnegative guard
- cross-file routingに必要なownership境界
- AIが実際のchangeで判断するための短いdecision rule

artifactでは通常落としてよい:

- history
- source recovery経緯
- provenanceの詳細
- 過去に却下・置換された案
- 同じ結論へ至る長い議論
- source record一覧
- migration説明
- 結論を変えない反復例

ただし、削除すると現在の規範の意味・条件・例外・強度が変わる情報は圧縮対象にしない。

> **compression は semantic weakening ではない。**

## 7. File granularity — few filesではなくsmall relevant context

artifactのfile数そのものを最小化しない。

最適化対象は**1 taskあたりにAIが読む不要context量**であり、repository上のfile countではない。

artifact fileは「subjectを丸ごと収める容器」ではなく、**1つの判断で同時に必要になるknowledge**をまとめる。

これを `context co-occurrence` として扱う。

```yaml
split_when:
  - "task routingが異なる"
  - "読むタイミングが異なる"
  - "一方だけ必要なtaskが多い"
  - "specialized detailがprimary ruleを圧迫している"
  - "1 fileを読むだけで不要contextが大量に入る"

keep_together_when:
  - "同じ判断でほぼ常に同時に必要になる"
  - "分割すると相互参照だけが増えてrouting chainが深くなる"
  - "片方だけ読んだ場合に規範を誤読しやすい"
```

したがって30〜50 file程度になっても、それぞれが適切にrouteされ通常taskで少数fileしか読まないなら問題ではない。

逆にfile数が少なくても、1 fileへ多くの無関係knowledgeを押し込めて毎回読ませる構造はartifactとして不適切である。

## 8. Self-contained delivery

target projectでは通常 `documents/knowledge/` は存在しない前提でartifactを読めるようにする。

artifact本文は、理解に不可欠な規範をupstream subjectへの参照だけで済ませない。

一方でartifactのmaintenance時には、repository側でどのsubjectsからprojectionしたかを追跡可能にする。

## 9. Project-local context

artifactは再利用可能な共通知識であり、target project固有の事実を発明しない。

project-local rule / architecture / command / documentationが存在する場合、AIはそれをartifactと合わせて解釈する。
artifactがproject固有の選択を固定的に仮定しない。

## 10. 更新

```text
new decision
   ↓
records
   ↓
subjects
   ↓
artifact projection review
   ↓
artifacts
   ↓
target projects
```

artifact更新では、単に旧artifactとの差分を見るのではなく、現在のsubjectsから必要な意味が正しく投影されているかを確認する。

旧artifactはlegacy comparisonとして利用できるが、新artifact architectureのauthorityにはしない。

## Sources

- `../records/2026-09-24-artifact-delivery-routing-redesign/RECORD.md`
- `KNOWLEDGE_MODEL.md`
- `SUBJECT_MODEL.md`
- `TRACEABILITY_MODEL.md`
