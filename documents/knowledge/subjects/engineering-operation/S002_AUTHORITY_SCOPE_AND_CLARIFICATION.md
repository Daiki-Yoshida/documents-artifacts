# Authority, Scope, and Clarification

## Authority order

engineering changeでは、明示的なuser requestとtarget projectのlocal conventionを確認する。

旧sourceはbrownfieldで、project instructions / lint config / house style等の**明示的local conventionがartifact guidanceと衝突する場合、local ruleを優先**すると定めた。

共通知識はdefaultであり、target project固有の明示規則を黙って上書きしない。

## Scope discipline

task中に周辺の違反や改善候補を見つけても、それだけでscopeを広げない。

- taskに必要な変更は行う。
- 無関係なcleanup / refactorは別changeとして扱う。
- 既存違反は必要に応じて報告する。
- 「ついでに全部直す」をdone条件へ混ぜない。

## Project Rootを基準とする書込範囲と外部権限

通常のproject-ownedな開発変更では、既存のProject Rootとproject-localな所有・配置規約を解決し、**Project Root配下の許可された対象をdefault write scopeとする**。実装や検証のための一時作業領域・代替checkoutが必要なら、まずProject Root内の適切な配置で成立するか評価する。Project Root内部の全てに書込権限があるという意味ではない。

境界を跨ぐ書込を判断する際は、対象・必要性・resource ownership・有効なユーザー指示/委譲・実際の副作用とriskを確認する。CLIでアクセス可能なpath、実行directory、既存checkoutの保護方針だけで外部書込のauthorityを導出しない。relative path、absolute path、symlink、mount、host APIによる実効的な変更先を必要に応じて解決する。

- **外部の読み取り専用参照**: 必要性、read権限、秘密情報等の安全条件を満たせば可能。
- **必要かつ承認された外部書込**: 明示的に対象化された外部依存repository、projectが規約化した一時/実行resource、または委譲範囲内のhost / Docker設定などは、対象側の権限・安全規約に従って実施可能。
- **権限が未確定の外部変更**: 外部変更のみ保留し、Project Root内で可能な診断・代替手段・限定的な復旧を進める。必要性と既存の委譲を評価しても不可欠な外部変更の権限が不足するときに、対象と影響を明示して確認する。

Project Rootの静的な構造とcontainmentは `../workspace-structure/S001_PROJECT_AND_REPOSITORY_MODEL.md`、破壊操作・host規模の変更・移設の安全条件は `../development-safety/` が所有する。

## Clarification

intentまたはcaller-visible contractが実装判断に必要な程度に不明なら、推測してpublic meaningを作らない。

一方、既存contract内の局所実装や明確なbug fixまで毎回確認へ戻さない。confirmationの必要性はchange impactに比例させる。

具体的なcontract change levelは `../encapsulation-horizon/S008_OPERATIONAL_GUARDS.md`、destructive operation riskは `../development-safety/S005_CONFIRMATION_AND_REREAD.md` を参照する。

## Sources

- `../../records/2026-10-12-project-root-write-boundary/ISSUE_199_BODY.md` — 書込scopeと外部操作委譲の追加判断。

- `../../records/2026-06-13-operational-discipline-commit/RECORD.md`
- `../../records/2026-07-01-brownfield-policy-commit/RECORD.md`
- `../../records/2026-07-02-design-principles-final-source-snapshot/files/AI_WORKFLOW.md`
