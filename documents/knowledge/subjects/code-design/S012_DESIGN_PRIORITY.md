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

## Mistake Prevention Priority

旧final sourceは、design choiceの優先順位とは別に、**防ぐべき設計ミスの優先度**を定義している。

現在の後続decisionへ合わせると、次の順で読む。

1. responsibilityを不必要に混在させる。
2. expected business failureを、project標準の明示的failure表現ではなく通常exception / null / boolean等へ押し込む。
3. public contract / DTO / observable behaviorを、既存consumer / providerとのcompatibility確認なしに黙って変更する。
4. external dependencyをDomain/coreや無関係moduleへ拡散させる。
5. 不要なabstractionを増やす。

5も実害のあるmistakeだが、**over-engineering回避を理由に1〜4の必要なboundary / contract / failure semanticsを省略しない**。逆に、意味のないinterfaceや抽象化を「安全のため」と追加しない。

expected failureの現在の規則は `S008_FAILURE_ASYNC_AND_CONTRACTS.md`、public contract compatibilityは `S010_COMPATIBILITY_AND_VERIFICATION.md` が主所有する。この節はそれらを再定義せず、競合時のdesign review優先度だけを扱う。

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
- `../../records/2026-07-02-design-principles-final-source-snapshot/files/DESIGN_PHILOSOPHY.md` — `Design Priority Order` / `Mistake Prevention Priority`
- `S008_FAILURE_ASYNC_AND_CONTRACTS.md`
- `S010_COMPATIBILITY_AND_VERIFICATION.md`
