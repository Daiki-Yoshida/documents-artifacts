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
establish / reuse confirmed Work Identity for Artifact-adopting implementation
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

Artifact v2を開発規範として採用するProjectが、exploration / designから**具体的なimplementation effortへ移る直前**には `../work-identity/S001_IDENTITY_MODEL.md` へrouteし、Work Identityを**RC3**として確定済みのものから再利用、または新規確定する。小さな修正であってもWork Identity自体の必要性は変わらない。

- goalがまだ曖昧な相談・調査ではWork Identityを急いで作らない。
- implementation goalが具体化したら、Work Identity候補を明示し、owner subjectが要求するexplicit user confirmationを満たしてからimplementationへ進む。
- internal changeで他のconfirmationが不要でも、このproject-level Work Identity gateをworkflow都合で省略しない。

Artifact v2を採用していないProjectへこの規則だけで制度を新設するものではない。Artifact採用ProjectでWork Identityを不要と判断するには、明示的なOwner例外が必要である。

## 実装

確認不要なinternal changeなら、必要なcontextを確認した上で進行できる。

一方、owner subjectが明示確認を要求する変更を、workflow上の都合で自動承認しない。

## Decision lineage — Work Identity適用範囲

Current:
- `../../records/2026-10-31-rule-class-adoption/` — Artifact v2採用Projectの具象実装作業にWork IdentityをRC3として適用。

Refined predecessor:
- `../../records/2026-10-03-subject-consistency-convergence/` — Work Identity model採用Project内での確認gateを確立した。確認条件そのものを保持しつつ今回共通の適用範囲を拡張。

## Sources

- `../../records/2026-10-03-subject-consistency-convergence/`

- `../../records/2026-01-31-initial-code-design-source/files/AI_WORKFLOW.md`
- `../../records/2026-07-02-design-principles-final-source-snapshot/files/AI_WORKFLOW.md`
- `../../records/2026-06-13-operational-discipline-commit/RECORD.md`
