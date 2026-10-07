## 背景

現在の Negative Alternative Leakage (NAL / 否定代替案リーク) は、`documents/knowledge/system/ARTIFACT_MODEL.md` で主に Artifact projection / compression のアンチパターンとして定義されている。

この定義は Artifact v2 の運用には適している一方、NAL の本質は Artifact に限定されない。AI・人間に対して、特定の目的に向けた説明・指示・引き継ぎ・設計記述などの context を構成する際にも同じ問題が生じる。

現行の `artifacts/design/CONCEPT_ALTITUDE.md` に照らすと、Artifact projection は NAL の first consumer / first discovered use case であって、NAL の semantic owner とは限らない。NAL を一般化し、その上で Artifact projection を specialization として位置づける。

## Work Identity

`feat/generalize-nal-context-guidance`

## 一般化した canonical 定義

**Negative Alternative Leakage (NAL / 否定代替案リーク)** とは、

> 特定の目的に向けて受け手へ context を構成・提示する際、その目的に必要な理解・判断・行動を支える範囲を超えて、非採用または回避対象の代替案を、主としてそれを否定するために導入・再提示・展開し、受け手の context へ不要な代替モデルを持ち込むアンチパターン。

ここでいう context は、受け手が理解・判断・行動に利用する説明・指示・前提・例などの情報を指す。文書、Issue/PR、TASK_SPEC、レビュー、会話、引き継ぎ、agent instruction 等を含み、consumer は AI / human の双方を含み得る。

alternative は実装方式だけでなく、概念解釈、責務分担、分類、手順、状態モデル等を含む。

NAL は結果として誤答・誤実装が発生した場合にのみ成立するものではなく、context 構成の時点で判定できる。

## Positive-first principle

NAL への基本原則は **Positive-first context shaping** とする。

> 受け手の目的に必要なモデル・判断・手順を直接記述し、それを正しく適用するための条件・例外・根拠・制約を添える。alternative への言及は、その目的を満たすために必要な範囲へ限定する。

典型:

```text
target / purpose
  → meaning / responsibility / state / procedure
  → conditions / exceptions / necessary rationale
  → constraints needed for decision or safety
```

Positive-first は文章順序の機械的規則ではない。正しい案を先に書いた後で不要なalternativeを長く展開すればNALになり得る。緊急の警告を先頭に置くことも許容される。

採用案が未確定の場合は、結論を発明せず、検討目的・既知条件・比較対象・unresolved point を直接示す。

## 適用境界

NAL の適用は文書種別ではなく、**その説明箇所の目的**で判断する。

alternative 自体の理解・比較・検証が目的に必要な場合、その説明は正当な context であり、NAL として削減しない。

例:

- 複数案の比較・選定
- 誤った説明の訂正・レビュー
- migration / legacy compatibility
- incident / failure analysis
- 教育上必要な対比・反例
- Decision Lineage / history / provenance
- records / subjects における semantic preservation

一方、採用済み方式の実装指示などで、非採用案の構造や手順を「使うな」と説明するためだけに展開する場合はNALの対象となる。

## Negative guard

NAL は negative sentence 禁止ではない。

現在有効な safety constraint / contract / prohibition や、positive rule だけでは防ぎにくい realistic failure mode への guard は保持する。

特に:

- normative strength
- conditions
- exceptions
- safety / destructive boundaries
- security constraints
- ownership constraints

を NAL を理由に弱めない。

negative guard を追加・展開する場合は、その情報がどの判断・誤読防止・failure prevention に寄与するかを確認し、alternative 全体の説明が不要なら必要十分な短い guard にする。

## 判定基準

中心となる問い:

> この alternative への説明を省略・縮小し、必要なモデル・根拠・制約を直接表現したとき、受け手の目的に必要な正確性、判断材料、安全性、検証可能性が失われるか。

NAL と判断する主要条件:

1. 非採用・回避対象の alternative を導入・再提示・展開している。
2. その説明の中心的役割が alternative の否定であり、比較・訂正・検証・移行等の目的上の役割が乏しい。
3. 必要な根拠・例外・契約を保ったまま、より直接的な説明へ省略・縮小できる。

判定単位は document 全体に限らず、section / paragraph / explanation fragment にも適用できる。

必要性が不明な情報は NAL を理由に機械的に削除せず、まず役割と根拠を確認する。

## 現行定義との関係

現行 Artifact-specific NAL は一般概念の specialization とする。

```text
generalized NAL
  context construction anti-pattern
        ↓ specialization
Artifact projection
  current-effective knowledge selection / compression における NAL
```

現行定義から維持するもの:

- positive-first
- necessary negative guards
- semantic weakening 禁止
- knowledge preservation への compression backflow 禁止

一般化で拡張するもの:

- Artifact projection 以外の context construction に適用
- old/rejected knowledge の「再導入」だけでなく、新規に想定した undesired alternative の導入や不要な再提示・詳述も対象
- 「current model より alternative が目立つ」は典型的兆候であり、NAL 成立の必須条件にはしない

## Knowledge preservation boundary

NAL は guidance / context construction の規則であり、source preservation の削減規則ではない。

`records/` は source event を保持し、`subjects/` は semantic completeness と effective status を保持する。

NAL を理由に superseded / rejected / historical knowledge、反論、訂正、Decision Lineage を records / subjects から削除しない。

## 実装方針

1. 本Issueと、その前提となったChat上の提案・ユーザー承認をrecord化する。
2. 一般化したNALのsemantic ownerをsubjects上で確立する。
3. `ARTIFACT_MODEL.md` のNALを一般概念のArtifact specializationへ整理する。
4. repository-local workflow / architecture のprojection ruleを整合させる。
5. Artifact v2へ、一般化したNAL / Positive-first context shaping をruntime guidanceとしてprojectionする。
6. root routing / task routing / context co-occurrenceを見て配置を決める。subject構造との1:1対応は要求しない。
7. 必要に応じて deterministic test / agent scenario を追加する。
8. `bash tests/test-artifacts.sh` と `bash tests/test-knowledge-integrity.sh` を含む関連validationを実行する。

## 非目標

- negative sentence の一律禁止
- comparison / exploration / history / incident analysisからalternativeを削除すること
- records / subjects のsemantic completenessを削ること
- Positive-firstを文章順序の固定ruleにすること
- NALを理由にcurrent contract / safety guardを弱めること

## 完了条件

- 一般化したNALのcanonical definitionと適用境界が第1情報源に成立している。
- Artifact-specific NALが一般概念のspecializationとして矛盾なく整理されている。
- Artifact v2から一般化NALをtask-relevantなcontextで利用できる。
- positive-first / negative guard / preservation boundaryがsemantic weakeningなしに維持される。
- routing / authorityが重複していない。
- relevant deterministic validationがPASSする。

