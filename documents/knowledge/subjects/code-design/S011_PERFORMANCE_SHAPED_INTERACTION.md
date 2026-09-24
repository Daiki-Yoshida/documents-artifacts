# Performance-Shaped Interaction

performanceを理由に、推測だけで公開contractを変更しない。

一方、caller / product / systemが依存するperformance requirementが実際にload-bearingで、既存interaction shapeそのものが要求達成を妨げる場合、contract shapeの再設計を候補にできる。

## Gate

順序:

1. performance requirementが実際にload-bearingか確認する。
2. representative measurementまたはdefensible structural boundを根拠にする。
3. まず既存contractを維持したinternal optimizationを検討する。
4. interaction shape自体がlimiting constraintの場合だけcontract redesignを候補にする。
5. semantic capability / ownership boundaryを可能な限り維持する。
6. 既存published contractを進化させる場合は通常のcompatibility ruleへ従う。
7. redesign後に要求を満たすか検証する。

「遅そう」という推測だけではgateを通さない。

## Interaction shapeになり得るもの

sourceで明示された候補:

- batch
- streaming
- pagination
- async
- cancellation
- backpressure

これらをperformance一般の推奨patternとして採用するのではない。load-bearing requirementとevidenceによってcurrent interaction shapeが制約と示された場合に限る。

buffer ownership / cache layout / pooling等の内部mechanismは、caller-visible guaranteeとして必要でない限り内部へ保持する。

## Contract completenessとの接続

latency / throughput / memory / bounded work等をcallerが実際に保証として依存する場合、それは単なるinternal implementation detailではない。

resource guaranteeをcontractへ含める原理は `../encapsulation-horizon/S005_CONTRACT_COMPLETENESS.md` を参照する。

## Sources

- `../../records/2026-09-06-design-principles-proposals/RECORD.md` 提案4
- `../../records/2026-09-15-design-principles-contract-decision/RECORD.md`（当初保留）
- `../../records/2026-09-15-performance-redesign-hold/RECORD.md`
- `../../records/2026-09-20-performance-contract-evolution/RECORD.md`（後続実装）
- `../encapsulation-horizon/S005_CONTRACT_COMPLETENESS.md`
