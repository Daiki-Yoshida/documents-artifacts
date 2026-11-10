# A-1 — Rough philosophy candidates (NOT adopted)

**Phase:** A-1 initial extraction (incomplete). **All candidates below are tentative semantic hypotheses**, not Dev-Philosophy enacted by the Owner, nor a proposed final taxonomy. IDs P01–P11 are audit handles only, not future subject IDs or a decision order.

Source corpus pinned to original `main@7ad8bb4f948359633003a47fa6bfcc8d6853ddb6`. Evidence paths below resolve under `documents/knowledge/subjects/` on that commit. This report derives from **31/70 files read**. Direct records checks described in A-2 are separate and only partial.

| Rough ID | Candidate meaning (not yet owner-approved) | Primary observed old-subject evidence | Review cautions |
| --- | --- | --- | --- |
| **P01** | Boundary contracts are strict and stable where exposed; enclosed implementation may change freely *only to the extent that the contract contains observable leakage*. | `encapsulation-horizon/S001_CORE_PRINCIPLE.md` §§1,4; `S005_CONTRACT_COMPLETENESS.md` §7; `code-design/S002_IMPLEMENTATION_FREEDOM_AND_SIDE_EFFECTS.md` | Not a claim that internals may be incorrect or violate resource/data guarantees. |
| **P02** | A hard boundary is chosen at a responsibility/meaning altitude and evolves with responsibility maturity; hardening all scales is not the goal. Stability and seam cost qualify hardening. | `encapsulation-horizon/S001_CORE_PRINCIPLE.md` §§2–4; `S002_RESPONSIBILITY_AND_HORIZON.md` §5; `S003_HARDENING_POLICY.md` §6; `S006_EVOLUTION_AND_GRADUATION.md` §8 | The “AND test” is a warning, not a mechanical split command; module is a prior, not a floor. |
| **P03** | Concept meaning should be modeled at the altitude appropriate to that meaning rather than owned by its first consumer. Neutral naming is distinct from a proven shared contract and from physical placement. | `encapsulation-horizon/S004_CONCEPT_ALTITUDE.md` §6.7 | The one-sentence test is only a neutrality signal; check later correction and record adoption. |
| **P04** | YAGNI should suppress speculative public surface and internal machinery, not erase guarantees required by a *selected* responsibility simply because defining them costs effort. | `encapsulation-horizon/S003_HARDENING_POLICY.md` §§6,6.5; `S004_CONCEPT_ALTITUDE.md` §6.8; `S005_CONTRACT_COMPLETENESS.md` | Key open issue: earlier Owner record appears more restrictive about YAGNI for internal hardening; investigate full decision history before wording as philosophy. |
| **P05** | Strong contracts are explicit and sufficiently complete, not maximally restrictive: incidental behavior of the current implementation does not automatically become a public guarantee. | `encapsulation-horizon/S005_CONTRACT_COMPLETENESS.md` §7 and 2026-09-24 refinement | Must distinguish current responsibility/requirements from incidental implementation properties. |
| **P06** | State and cross-boundary business outcomes require identifiable ownership; side effects are made explicit and contained, rather than assumed eliminable. | `code-design/S002_IMPLEMENTATION_FREEDOM_AND_SIDE_EFFECTS.md`; `S004_STATE_OWNERSHIP_AND_CONSISTENCY.md` | Atomic/retry/compensation mechanisms probably belong in Methodology; do not bake a particular solution into philosophy. |
| **P07** | Design judgments prioritize boundary, contract, compatibility and change locality over a preferred class hierarchy or internal elegance. OO is read in terms of contract/message interactions, not inheritance for its own sake. | `code-design/S001_REALIZATION_MODEL.md`; `S003_INHERITANCE_BOUNDARY.md`; `S012_DESIGN_PRIORITY.md` | Do not turn “inheritance needs a behavioral contract” into blanket “composition only.” Priority order needs record verification. |
| **P08** | Communication/instruction context should express the purpose-relevant model directly and preserve essential conditions; unnecessary negative alternative models can distort judgment (Positive-first / NAL). | `context-shaping/S001_POSITIVE_FIRST_CONTEXT.md`; `S002_NEGATIVE_ALTERNATIVE_LEAKAGE.md`; `S003_APPLICABILITY_AND_GUARDS.md` | The exclusion target is **unnecessary** alternatives, never counterevidence, unresolved status or needed safeguards. Assess whether general philosophy or methodology after Owner review. |
| **P09** | Accuracy and semantic fidelity outrank token economy when preserving development knowledge. | `documentation/S001_PRINCIPLES.md` §核心原則 | This old file also advocates selective routing; do not promote that *delivery mechanism* to new philosophy (Stage 3 and later Owner decisions). |
| **P10** | Safety should be embedded in convenient defaults and clearly owned operations: make the safe action the easy action, while keeping intent/reproducibility visible. | `development-safety/S001_SAFETY_PRINCIPLES.md`; `development-execution/S001_EXECUTION_MODEL.md` | Distinguish the enduring value from Docker-first and other implementation-specific commands. |
| **P11** | Work/resource identity should derive from the meaning of a development goal, not be defined by a Git branch or execution tool. | `work-identity/S001_IDENTITY_MODEL.md`; `engineering-operation/S002_AUTHORITY_SCOPE_AND_CLARIFICATION.md` | Borderline philosophy versus methodology. Work Identity RC3 scope must not be generalized beyond its adopted applicability. |

## Not decided

- Whether these are 11 independent principles, or a smaller set with relationships.
- Which claims are genuinely **Owner's philosophy**, versus reproducible engineering practices / Dev-Methodology.
- Correct semantic scope, priority and exception rules (A-2 record review required).
- Structure, category, names or sequence of `subjects/dev-philosophy/` leaves (only after A-3 consensus / A-4).

## Source corrections to chase in A-2

- `2026-09-15-design-principles-contract-decision`: concept neutrality vs semantic identity; compatibility both sides; cross-boundary ownership.
- `2026-09-24-yagni-encapsulation-horizon-decision`: original Owner intent and cost-only YAGNI.
- `2026-09-24-strong-contract-explicit-not-maximal`: avoid over-promoting incidental guarantees.
- `2026-10-07-generalized-nal-adoption`: general NAL extends beyond Artifact projection.
- `2026-10-31-rule-class-adoption`: preserve applicability scope of Work Identity / RC.

**Next:** finish remaining 39 legacy files, including HISTORY; then use records to validate, challenge and supplement the rough philosophy. No candidate is enacted by this report.
