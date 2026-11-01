# Authority, Scope, and Clarification

## Authority order

engineering changeでは、明示的なuser requestとtarget projectのlocal conventionを確認する。

旧sourceはbrownfieldで、project instructions / lint config / house style等の**明示的local conventionがartifact guidanceと衝突する場合、local ruleを優先**すると定めた。

共通知識はdefaultであり、target project固有の明示規則を黙って上書きしない。ただしArtifact採用Projectで適用条件を満たすrequired contractを、単に「推奨だから」というAI判断で省略しない。Projectの具体化と、規範そのものの例外を区別する。

## RuleClass（RC）— 規範の拘束力と決定権

current-effectiveな**規則単位**で、次の3種類を適用条件とともに扱う。

| Class | 意味 | 適用時の責務 |
|---|---|---|
| **RC3 — Required** | 選択済みの必須契約 | 条件が成立した場合に守る。AIの便宜や「推奨」解釈で省略しない。 |
| **RC2 — Recommended** | 標準的に選ぶ方式 | 原則採用する。具体的なtask / Project上の理由があれば代替できる。 |
| **RC1 — Project Defined** | 具体的手段・名称・policyの決定権 | Project/Ownerが決める。決定後のproject-local contractには従う。 |

RC1は「重要でない」ではなく、RC3は「関連resourceを全て作れ」ではない。Classと**適用条件・前提・例外・責務**を別々に解決する。契約を守ることと、その実現方法を選ぶことは別の判断である。DOC_Lx / SAFETY_Lx / contract Lxなどの変更影響・確認レベルとも独立する。

明示的Project-local規則はRC1の選択、RC2の具体化、RC3の意味を保った特化で優先する。RC3と本当に衝突する例外・不採用が必要なら、Ownerの明示判断としてscopeと影響を確認・記録する。AIが「未採用」と黙示的に推定したり、Project固有規則を勝手に書き換えたりしない。

単なる分類名の追加は既存の規則の意味を変えない。強度を変える／適用条件を広げるときは、別途Owner判断と根拠を保全する。

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

- `../../records/2026-10-31-rule-class-adoption/` — RC呼称・規範強度の採用およびWork必須化のOwner要望

- `../../records/2026-10-12-project-root-write-boundary/ISSUE_199_BODY.md` — 書込scopeと外部操作委譲の追加判断。

- `../../records/2026-06-13-operational-discipline-commit/RECORD.md`
- `../../records/2026-07-01-brownfield-policy-commit/RECORD.md`
- `../../records/2026-07-02-design-principles-final-source-snapshot/files/AI_WORKFLOW.md`
