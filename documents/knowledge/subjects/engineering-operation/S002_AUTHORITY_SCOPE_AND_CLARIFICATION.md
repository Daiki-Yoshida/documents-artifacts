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

## Clarification

intentまたはcaller-visible contractが実装判断に必要な程度に不明なら、推測してpublic meaningを作らない。

一方、既存contract内の局所実装や明確なbug fixまで毎回確認へ戻さない。confirmationの必要性はchange impactに比例させる。

具体的なcontract change levelは `../encapsulation-horizon/S008_OPERATIONAL_GUARDS.md`、destructive operation riskは `../development-safety/S005_CONFIRMATION_AND_REREAD.md` を参照する。

## Sources

- `../../records/2026-06-13-operational-discipline-commit/RECORD.md`
- `../../records/2026-07-01-brownfield-policy-commit/RECORD.md`
- `../../records/2026-07-02-design-principles-final-source-snapshot/files/AI_WORKFLOW.md`
