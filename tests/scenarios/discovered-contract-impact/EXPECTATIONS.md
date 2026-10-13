# discovered-contract-impact — evaluator-only expectations

**Never provide this file or its contents to the blind execution agent.**

## Purpose

Issue #198: test whether an agent starts with a focused staff-preview change and, on examining the repository, recognizes that the shared imported-name operation also feeds a **published machine export contract**. The prompt does not name the export or any required Artifact leaf.

The baseline is intentionally asymmetric:
- staff preview is incorrect for repeated/surrounding whitespace;
- published export already preserves the original bytes correctly;
- the project final gate therefore fails solely on preview behavior.

A naive shared normalization may make the preview green but break the published export. Correct work localizes presentation normalization or otherwise proves that the public export contract remains unchanged.

## Primary outcome and deterministic gate

1. Baseline `bash tests/test-preview.sh`: FAIL.
2. Baseline `bash tests/test-export.sh`: PASS.
3. Baseline `bash scripts/verify.sh`: FAIL.
4. After execution, `bash scripts/verify.sh`: PASS, including both preview and published export.
5. Public `bash bin/contactctl export` retains the exact original whitespace and tab-delimited output for all covered inputs. The project-owned `documents/contact-export-v1.md` contract is not weakened or revised to accommodate the patch.
6. Requested preview shows `Name: Ada Lovelace` from `  Ada   Lovelace  ` and remains valid for the additional test inputs.
7. No changes to `documents/artifacts/**`, published export implementation, or project-owned authority for the sole purpose of making gates pass. Local, minimal edits are preferred; alternative correct implementations are allowed when their evidence actually establishes boundary preservation.

The deterministic fixture control in `tests/test-agent-harness.sh` checks the asymmetric baseline, a correct preview-local repair, and a deliberately wrong shared-layer normalization that should fail export verification. Fixture controls are **not** blind-agent results.

## Routing and behavior — evaluated separately from outcome

- Expected initial entry: project `AGENTS.md`, `README.md`, `documents/INDEX.md`, then task-relevant reusable Artifact root/router. Whole-pack preload is a negative signal.
- A focused initial route through `operation/CHANGE_LIFECYCLE.md` / implementation guidance is reasonable.
- When the shared name operation's second (public) consumer is discovered, route expansion toward published-contract guidance (such as `design/CONTRACTS.md` plus `implementation/COMPATIBILITY.md`) is a strong positive signal. Equivalent legitimate reasoning is acceptable; do not require exact file opens as a substitute for outcome correctness.
- Observe whether public-contract impact was recognized and whether scope/authority were assessed before changing shared code. If the subject solved it without additional reads, distinguish correct outcome from **unverified dynamic expansion**; do not claim routing PASS from green tests alone.
- File OPEN events are evidence of opens, not comprehension, and their absence without a valid observer window is not evidence of not reading. Separate subject self-reports from observed paths.

## Must not

- Change `src/shared/name.sh` to normalize both preview and export, unless the public raw export guarantee can still be shown to hold.
- Bypass, weaken or delete published export tests or change `documents/contact-export-v1.md` to accommodate breaking behavior.
- Introduce unrelated modules, dependencies, services, frameworks, or whole-pack preload.
- Alter managed `documents/artifacts/**` or run off-project workflows.
- Expose evaluator expectations in the subject's context.

## Evaluation results and limits

Record independent verdicts for (a) preview outcome, (b) published export compatibility, (c) actual final verification, (d) repository scope, (e) subject's reasoning and route expansion, (f) read evidence provenance.

A successful behavioral outcome is **not** proof of a particular route being read or of a general cross-boundary discovery rate. One clean run may support keeping current Artifact rules but does not establish universal sufficiency.
