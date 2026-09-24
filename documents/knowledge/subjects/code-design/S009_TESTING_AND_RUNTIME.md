# Testing and Runtime Structure

## Testの役割

testはimplementation detailではなく、意味のあるboundaryとobservable outcomeを検証する。

- Unit Test: isolated logic
- Integration Test: component間interaction / real adapter
- Contract Test: implementationがcontractへ適合するか
- E2E / requirement verification: user/product/systemのobservable outcome

## Contract conformance ≠ task correctness

旧sourceにはContract Testをcorrectness全体の定義として扱う強い表現があったが、後続の提案・採用で訂正された。

contract conformanceが成立しても、要求理解そのものが間違っていればtaskは失敗している。

```yaml
verify_contract: "implementationがcontractへ適合する"
verify_requirement: "必要なobservable outcomeが成立する"
rule: "両者を同一視しない"
```

詳細は `S010_COMPATIBILITY_AND_VERIFICATION.md`。

## Test priority

- Domain/Core: correctnessとunit test
- public port/interface: contract test
- Infrastructure adapter: integration/contract test
- Application UseCase: orchestrationとexpected failure
- UI: behaviorの複雑度/criticalityに比例
- private helper: 原則public/module boundary経由。複雑なpure logicなら直接testも可

private implementation detailへ過剰に固定しない。

## Test placement

unit / contract testは原則code ownerの近くへ置く。

contract suiteはcontract ownerの近くへ置き、factory等でimplementationを差し替えて同じsuiteを走らせる。

reusable fakeはtest-support public surfaceになり得る。module内だけならinternal。

cross-module / cross-runtime E2Eはseam全体を検証できる場所へ置く。

## Runtime topology

### Single runtime

UIが同じdeployable/runtimeに属するならfeature module内部のuiとしてApplicationへ依存できる。

### Multiple deployables

SPA + API等、runtimeが分かれる場合はfrontendを独立bounded contextとして扱う。

runtime間のHTTP/RPC DTOはpublished contractであり、frontendがbackend内部のDomain/Application/Infrastructureを直接importしない。

## Composition root

各runtime entrypointがenvironment/bindingを読み、adapterを構築し、use caseへ注入する。

business logicをentrypointへ置かない。

## Sources

- `../../records/2026-07-02-design-principles-final-source-snapshot/files/CODING_STANDARDS.md`
- `../../records/2026-07-02-design-principles-final-source-snapshot/files/PROJECT_STRUCTURE.md`
- `../../records/2026-06-21-project-structure-origin-commit/RECORD.md`
- `../../records/2026-09-06-design-principles-proposals/RECORD.md`
- `../../records/2026-09-15-design-principles-contract-decision/RECORD.md`
- `../../records/2026-09-15-cross-artifact-consistency-issue/RECORD.md`
- `../../records/2026-09-15-cross-artifact-consistency-pr/RECORD.md`
