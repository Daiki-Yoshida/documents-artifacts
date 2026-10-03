# Change Lifecycle

engineering changeは、codeを書く行為だけではなく、要求理解からverificationまでの一連の判断として扱う。

## 基本flow

```text
understand intent / required outcome
        ↓
scan current context and boundaries
        ↓
route design/risk questions to owner
        ↓
establish / confirm Work Identity when required by project model
        ↓
confirm other change-specific gates when required
        ↓
implement within agreed scope
        ↓
verify contract + requested outcome
        ↓
report
```

変更の規模によって各phaseの深さは変わる。one-line fixへfull architecture exerciseを強制せず、public contract / module boundary / external dependency / persistent data等へ触れる場合はscanを広げる。

## Designとimplementationを混同しない

実装前に、少なくとも次を把握する。

- userが必要とするobservable outcome
- 変更対象のresponsibility / boundary
- public contractへ影響するか
- operation riskがあるか
- project-local conventionがあるか

具体的なcode designは `../code-design/`、hardening判断は `../encapsulation-horizon/` へrouteする。

### Implementation移行時のWork Identity gate

projectがWork Identity modelを採用しており、exploration / designから**具体的なimplementation effortへ移る直前**には `../work-identity/S001_IDENTITY_MODEL.md` へrouteする。

- goalがまだ曖昧な相談・調査ではWork Identityを急いで作らない。
- implementation goalが具体化したら、Work Identity候補を明示し、owner subjectが要求するexplicit user confirmationを満たしてからimplementationへ進む。
- internal changeで他のconfirmationが不要でも、このproject-level Work Identity gateをworkflow都合で省略しない。

Work Identityを採用していないprojectへ新しいidentity制度を勝手に導入する規則ではない。

## 実装

確認不要なinternal changeなら、必要なcontextを確認した上で進行できる。

一方、owner subjectが明示確認を要求する変更を、workflow上の都合で自動承認しない。

## Sources

- `../../records/2026-01-31-initial-code-design-source/files/AI_WORKFLOW.md`
- `../../records/2026-07-02-design-principles-final-source-snapshot/files/AI_WORKFLOW.md`
- `../../records/2026-06-13-operational-discipline-commit/RECORD.md`
