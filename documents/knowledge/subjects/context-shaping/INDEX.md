# Context Shaping

目的を持つ説明・指示・レビュー・引き継ぎ等で、consumerが必要な理解・判断・行動へ到達できるようcontextを構成する原則を扱う。

このsubjectは文書形式や会話形式そのものではなく、**何をconsumer contextへ入れるか**というsemantic responsibilityを所有する。

## Routing

- purposeに必要なmodelを直接伝えるPositive-first原則 → `S001_POSITIVE_FIRST_CONTEXT.md`
- Negative Alternative Leakage (NAL) の定義・成立条件 → `S002_NEGATIVE_ALTERNATIVE_LEAKAGE.md`
- alternativeが必要な場面、negative guard、knowledge preservation境界 → `S003_APPLICABILITY_AND_GUARDS.md`

## Responsibility boundary

context-shapingは、採用判断そのものを決定するauthorityではない。

- 何がcurrent / adopted / unresolvedかは、そのdomainのdecision / evidence / authorityで決める。
- context-shapingは、その状態をconsumerの目的に必要な形で提示する。
- NALを理由にsource evidenceやsemantic historyを削除しない。
- document structure / routingはdocumentation、software designは該当design subject、knowledge preservationはknowledge systemが所有する。

## Decision lineage — generalized Negative Alternative Leakage

Current:
- `../../records/2026-10-07-generalized-nal-adoption/`
  - NALをArtifact projection固有から、purpose-directed context construction全般へ一般化。
  - Positive-first、必要なnegative guard、semantic weakening禁止、preservation boundaryを維持。

Refined predecessor:
- `../../records/2026-10-04-negative-alternative-leakage/`
  - Artifact projection / compressionにおけるNALは、一般概念のspecializationとして引き続き有効。

Proposal:
- `../../records/2026-10-07-generalized-nal-proposal/`

Implementation coordination:
- `../../records/2026-10-07-generalized-nal-issue/`
