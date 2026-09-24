# Design Priority

design decisionが競合するとき、旧reference原本は次の優先順位を定義している。

1. boundaryとcontractの明確性
2. external interfaceの安定性
3. changeの局所性
4. side effectの明示性
5. internal elegance / purity

## Interpretation

内部実装を美しくするために、1〜4を犠牲にしない。

特定paradigmの美しさ、class hierarchy、inheritance depth等を、boundary / contract / change localityより上位の目的にしない。

このpriorityは「内部品質が不要」という意味ではない。conflictした場合の優先順を示す。

## AIによるcode changeへの適用

同じreference原本はAI向けに次を要求している。

- contractを保護する
- implementationをreplaceableとみなす
- couplingを減らす変更を優先する
- optimizationのためにinternal detailをcontractへ漏らさない
- internal rewriteよりboundary-preserving refactorを優先する

これはengineering workflow全体のspecではなく、**code design decisionのinterpretation rule**としてこのsubjectで扱う。

commit / push / reporting / task scope等の作業規律はこの文書の責務ではない。

## Sources

- `../../records/2026-06-13-design-principles-reference-snapshot/files/documents/reference/PROGRAMMING_PARADIGM.md` §8–9
