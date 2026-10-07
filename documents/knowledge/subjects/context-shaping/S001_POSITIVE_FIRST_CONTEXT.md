# Context Shaping — Positive-first Context

特定の目的へconsumerを導くcontextは、必要なmodel・判断・手順を直接表現することを基本とする。

## Purpose-directed context

ここでいうcontextは、consumerが理解・判断・行動に利用する説明・指示・前提・例などの情報である。

対象はfileに限らない。

- documentation
- Issue / PR
- TASK_SPEC
- review
- handoff
- agent instruction
- chat / explanation

consumerはAIでもhumanでもよい。

contextへ何を含めるかは、媒体の種類ではなく**その説明箇所の目的**から決める。

## Positive-first principle

> consumerの目的に必要なmodel・判断・手順を直接記述し、それを正しく適用するためのcondition・exception・rationale・constraintを添える。alternativeへの言及は、その目的を満たすために必要な範囲へ限定する。

基本形:

```text
target / purpose
  → meaning / responsibility / state / procedure
  → conditions / exceptions / necessary rationale
  → constraints needed for decision or safety
```

Positive-firstは「肯定文を使う」という意味ではない。
採用対象・必要な判断材料を説明の中心に置くという原則である。

## Presentation order is not the rule

Positive-firstは文章順序の固定ruleではない。

- current modelを最初に書いた後で不要なalternativeを長く展開すれば、context shapingは改善されていない。
- 緊急のwarningや重要なprohibitionを先に置くことには、目的上の価値があり得る。
- normative strengthを肯定表現へ無理に変換しない。

判断対象は「どちらを先に書いたか」ではなく、consumerの目的に対して各情報が必要な役割を持つかである。

## Unresolved decisions

Positive-firstを成立させるために未決定事項へ結論を発明しない。

採用案が未確定なら、次を直接示す。

- 検討目的
- 確認済みcondition
- 比較すべきcandidate
- unresolved point
- 決定に必要なevidence

探索・比較そのものが目的なら、candidateは必要なcontextである。

## Granularity

context shapingはdocument全体だけでなく、section / paragraph / explanation fragment単位で評価できる。

同じparagraphに必要なguardと不要なalternative詳述が同居する場合、guardを残し、不要な部分だけを整理する。

## Sources

- `../../records/2026-10-07-generalized-nal-proposal/`
- `../../records/2026-10-07-generalized-nal-adoption/`
