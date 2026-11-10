# A-2 — Preliminary record audit findings (NOT a completed audit)

Baseline main: `7ad8bb4f948359633003a47fa6bfcc8d6853ddb6`; working branch record inventory: `14fdd210d96011536d28e1e0de856800871672ef`.

**Progress:** inventory of 204 record payload files established. Full text review so far 8; targeted scan 4. All unreviewed entries are explicitly listed in [A2_RECORDS_COVERAGE.md](A2_RECORDS_COVERAGE.md).

## F01 — A current correction to concept generality (supported)

**A-1 candidate:** P03. `2026-09-15-design-principles-contract-decision/RECORD.md` explicitly records the proposal “Concept Altitude and semantic identity” as **adopted with corrections**: removal of a feature name is a neutrality signal, not proof of a shared contract; check invariants, failure meaning and lifecycle. This supports the narrower interpretation in old `encapsulation-horizon/S004_CONCEPT_ALTITUDE.md`.

**Audit state:** primary PR-body snapshot reviewed; further owner-message context and subsequent records remain to be checked.

## F02 — YAGNI: investigate the strength and scope of Owner intent

**A-1 candidates:** P01 / P04 / P05. `2026-09-24-yagni-encapsulation-horizon-decision/RECORD.md` preserves Owner messages strongly rejecting **cost-only** YAGNI for contracts and hardening, even describing YAGNI as potentially an anti-pattern in AI-heavy development.

The old `S003_HARDENING_POLICY.md` / `S004_CONCEPT_ALTITUDE.md` instead state a *qualified* asymmetry: current selected contract guarantees are not cut merely because creation is costly, while speculative internal machinery may be deferred. These may be a compatible refinement, but the apparent difference in normative strength must be traced across later approvals before treating P04 as Owner's enacted philosophy.

**Status:** Potential meaning drift / refinement **unresolved**, not a proven contradiction. No subject text changed.

## F03 — Strong contract is not maximal overconstraint (needs full source review)

Old `encapsulation-horizon/S005_CONTRACT_COMPLETENESS.md` distinguishes explicit required semantics from incidental observable implementation properties. `2026-09-24-strong-contract-explicit-not-maximal/RECORD.md` has a matching adopted rule in the inspected passages, but the full long source has only been scanned, not comprehensively reviewed.

**Status:** Supporting evidence located; complete event interpretation pending.

## F04 — Generalized NAL adoption is traceable; proposal payload outstanding

Read `2026-10-07-generalized-nal-adoption/RECORD.md` and `USER_APPROVAL.md` (Owner's short acceptance) and `2026-10-07-generalized-nal-proposal/RECORD.md`. The adoption metadata points to a separate proposal payload `CHAT_PROPOSAL.md` which has **not** been reviewed yet.

Old context-shaping subjects describe NAL/Positive-first as general human/AI context shaping, not just Artifact v2. The content and historical distinction remain tentative until proposal body and other relevant records are checked.

## F05 — Old source snapshots are not automatically current authority

Read `2026-09-21-docs-jp-snapshot/MANIFEST.md` and scanned selected old philosophy payloads. The manifest states that its original docs text and historical authority wording are preserved **as a snapshot**, not as a current decision.

In particular, an old documentation philosophy describes selective file routing, whereas recent Owner direction rejects relying on selective reading for the full Dev-Philosophy. The historical text must not override new decisions or dictate Stage 3.

**Status:** Historical-vs-current caution verified at manifest level; full snapshot audit remains outstanding.

## F06 — RC/Work Identity applicability must not expand accidentally

`2026-10-31-rule-class-adoption/RECORD.md` states RC1–RC3 and Work Identity's RC3 applicability for concrete implementation work in projects adopting Artifact v2. It explicitly says the candidate classification list was **not** adopted wholesale.

The old `work-identity/S001_IDENTITY_MODEL.md` contains a potential broad principle “work identity is meaning-based”; whether to elevate that meaning to Dev-Philosophy is an **A-3 Owner decision**. The implementation-scoped RC3 details should not silently become a universal philosophical rule.

## Do not conclude yet

- No full-record coverage or final completeness claim.
- No full legacy-subject coverage either.
- No enactment of Dev-Philosophy and no A-4 taxonomy.
- No modification to the original records or the provisional subjects surface.
