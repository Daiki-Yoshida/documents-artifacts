# Compatibility and Verification

## Additiveとcompatibleを分離する

公開contractの変更が「追加」であることだけではcompatibilityを証明しない。

既存のconsumer / callerだけでなく、provider / implementerも従来の保証のまま成立するかを確認する。

対象contractに応じて、必要なcompatibility dimensionだけを評価する。

- source
- binary
- wire
- schema
- persisted data

必須interface member追加のように、caller側が変わらなくても既存implementer / fakeを壊す変更は、compatible public evolutionとして扱わない。

change impactのL0–L3分類・confirmation levelは `../encapsulation-horizon/S008_OPERATIONAL_GUARDS.md` が主所有する。

## Contract conformanceとrequested outcomeを分離する

testがcontractへ適合していることと、成果物全体がユーザー要求を満たすことは別の確認である。

誤った要求理解からcontract・実装・testを作ると、それらが相互に整合していても要求未達になり得る。

したがってverificationでは少なくとも次を区別する。

1. implementationがcontractへconformするか
2. observable outcomeが要求を満たすか

requested outcomeの確認は、変更impactに対して**narrowest meaningful path**を選ぶ。軽微な変更へ一律にformal acceptance criteria文書やfull E2Eを要求しない。

## Contract Testの意味

Contract Testはcontract conformanceの検証を担う。

system全体のcorrectnessやrequested outcome satisfactionを、Contract Testだけで代表させない。

## Sources

- `../../records/2026-09-06-design-principles-proposals/RECORD.md` 提案1・3
- `../../records/2026-09-15-design-principles-contract-decision/RECORD.md` 採用1・3
- `../../records/2026-09-15-cross-artifact-consistency-issue/RECORD.md` #4–5
- `../../records/2026-09-15-cross-artifact-consistency-pr/RECORD.md`
- `../encapsulation-horizon/S008_OPERATIONAL_GUARDS.md`
