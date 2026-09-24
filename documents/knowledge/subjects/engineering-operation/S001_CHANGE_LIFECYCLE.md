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
confirm when required
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

## 実装

確認不要なinternal changeなら、必要なcontextを確認した上で進行できる。

一方、owner subjectが明示確認を要求する変更を、workflow上の都合で自動承認しない。

## Sources

- `../../records/2026-01-31-initial-code-design-source/files/AI_WORKFLOW.md`
- `../../records/2026-07-02-design-principles-final-source-snapshot/files/AI_WORKFLOW.md`
- `../../records/2026-06-13-operational-discipline-commit/RECORD.md`
