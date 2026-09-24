# Failure, Async, and Contract Semantics

## Contractはsignatureだけではない

code-level contractは必要に応じて次を含む。

- signature / shape
- observable semantics
- side effects
- failure semantics
- load-bearing resource / performance bound
- determinism / ordering
- data / persistence guarantee
- lifecycle / cancellation / concurrency guarantee

ただしload-bearingな情報だけを記述する。method名の言い換えや推測のperformance注釈を増やすことはcontract completenessではない。

boundary completenessの原理自体は `../encapsulation-horizon/S005_CONTRACT_COMPLETENESS.md` が主owner。

## Expected failure

callerが通常のbusiness flowとして扱う失敗は、projectが標準化している `Result / Either / Outcome` 等の明示的表現を優先する。

- success/failureだけをbooleanやnullへ押し込まない。
- expected business ruleを通常exception control flowへしない。
- projectに標準typeがあるなら再利用する。

標準typeがない場合はproject conventionとdependency policyを確認する。旧sourceはminimal project-owned Resultのbootstrapを許容していたが、project-local ruleがあればそちらを優先する。

## System failure

DB outage / configuration failure / resource exhaustion等、通常のbusiness deviationではないsystem failureはexception等で表現できる。

Resultを使うことは、すべてのexceptionを禁止する意味ではない。

## Boundary translation

Infrastructure固有のtechnical exceptionをApplication/Domainへそのまま漏らさない。

- Infrastructure boundaryで捕捉する。
- project-owned / domain-meaningful failureへ翻訳する。
- 診断用causeは保持できる。
- transport/vendor detailはpublic meaningにしない。

## Async / concurrency

非同期性やthread-safetyがcaller-visibleならcontractで明示する。

- async operationをsync facadeで隠さない。
- long-running/IOにはcancellation mechanismを検討する。
- thread-safe / caller-confined / single-threaded等、必要なexpectationを明示する。
- scheduling primitiveをDomain contractへ漏らさない。
- mutable stateをboundary間で共有するならownership / synchronization / immutabilityを明示する。
- ownership外のboundaryを跨いでsync blockingでasyncを止めない。

language/runtimeにより具体syntaxは異なるため、Task / Promise / suspend等を規範の本体にしない。

## Sources

- `../../records/2026-01-31-bounded-contracts-refinement-source/files/CODING_STANDARDS.md`
- `../../records/2026-07-02-design-principles-final-source-snapshot/files/CODING_STANDARDS.md`
- `../../records/2026-09-15-cross-artifact-consistency-issue/RECORD.md`
- `../../records/2026-09-15-cross-artifact-consistency-pr/RECORD.md`
