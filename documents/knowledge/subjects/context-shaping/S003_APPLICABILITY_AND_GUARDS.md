# Context Shaping — Applicability and Guards

NALの目的はalternativeを消すことではなく、consumerの目的に必要なcontextと不要なcontextを分離することである。

## Alternatives that belong in context

alternative自体の理解・比較・検証が目的に必要なら、その説明は正当なcontextである。

代表例:

- candidate間のcomparison / selection
- 誤説明のcorrection / review
- migration / legacy compatibility
- incident / failure analysis
- 教育上必要なcontrast / counterexample
- Decision Lineage / history / provenance
- records / subjectsにおけるsemantic preservation

文書種別ではなく、その説明箇所でconsumerが何を理解・判断する必要があるかを基準にする。

同じalternativeでも、採用済み方式の実装指示では不要で、migrationでは識別・変換条件として必要になり得る。

## Negative guards

NALはnegative sentence禁止ではない。

現在有効なcontract / prohibition / safety constraint、またはpositive ruleだけでは防ぎにくいrealistic failure modeへのguardは保持する。

NALを理由に次を弱めない。

- normative strength
- precondition / postcondition
- exception
- destructive / safety boundary
- security constraint
- ownership constraint

必須のprohibitionは、その禁止自体がcurrent guidanceである。
その周囲にalternative modelの詳細説明が必要かは別に判断する。

補助的なnegative guardを追加・展開する場合は:

- 防ぎたいmisreading / failureが具体的か
- direct ruleだけでは不足するか
- guardがdecision valueを持つか
- alternative全体ではなく必要十分な短いguardで足りないか

を確認する。

## Knowledge preservation boundary

context shapingは、何をconsumerへ提示するかを扱う。
source preservationやsemantic completenessを削る規則ではない。

`records/` はsource eventを保持し、`subjects/` はcurrent / superseded / rejected / unresolvedを含むsemantic knowledgeとDecision Lineageを保持する。

個別のguidanceからnon-current alternativeを省略できることは、そのknowledgeをrecords / subjectsから削除する根拠にならない。

またNALは、unresolved conflictや不都合なevidenceを隠すための基準ではない。
採否・確実性・未解決状態を維持したうえでcontextを構成する。

## Sources

- `../../records/2026-10-07-generalized-nal-proposal/`
- `../../records/2026-10-07-generalized-nal-adoption/`
- `../../records/2026-10-04-negative-alternative-leakage/`
