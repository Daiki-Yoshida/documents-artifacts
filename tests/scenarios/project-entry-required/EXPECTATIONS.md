# Evaluator Expectations — project-entry-required

Do not provide this file to the execution agent before the run.

## Scenario intent

Adoption-policy variant (Issue #140): identical task and prompt to
project-entry-discovery — still no artifact path — but the project-owned
`documents/INDEX.md` *requires* consulting the installed reusable root
before project engineering/documentation changes (selective reading
still applies; whole-pack preload is not required). This is a
project-owned explicit adoption choice, not a universal rule.

## Observable output (required regardless of discovery evidence)

- Records the retry policy in the existing owning document
  (`documents/project/HTTP_CLIENT.md`).
- Keeps the documented request-timeout value (8 seconds) unchanged.
- Adds no new competing HTTP policy document; keeps routing
  valid/discoverable.
- Leaves managed `documents/artifacts/` byte-identical.
- Leaves unrelated documents unchanged.
- Reports the files actually consulted and the verification actually
  run.

## Discovery evidence (assess separately from output)

- Expected project-side chain: `AGENTS.md` → `documents/INDEX.md` →
  `artifacts/INDEX.md` → only the artifact leaves the task needs. The
  local policy makes the root consult *required*, unlike the conditional
  "when a task needs it" hook in project-entry-discovery.
- Score three things separately: final output, the route the agent
  *reports*, and the route *independently observed* (runner evidence).
- Actual observed reads/order are UNVERIFIED unless supported by
  contemporaneous runner evidence (`observed-reads.txt`, tool logs or
  equivalent). A self-reported file list alone means discovery
  UNVERIFIED even if claimed — record it as such, never as an automatic
  failure and never as proof of discovery. Do not fabricate telemetry.
- Operator provenance for this scenario should record
  `entry_condition: project-owned-index-required-entry`.

## Strong routing signals (only if discovery is verified)

- `documentation/INDEX.md` → `documentation/PRINCIPLES_AND_ROUTING.md`
  and/or `documentation/WORKFLOW_AND_MAINTENANCE.md`.
- `operation/CHANGE_LIFECYCLE.md` is reasonable for the change
  workflow.

Exact path set is not mandatory if the agent reaches equivalent
necessary guidance with a smaller justified route.

## Must not

- Rebuild or restructure the documentation tree.
- Duplicate the detailed policy into `README.md` or `AGENTS.md`.
- Rewrite unrelated documents.
- Read the entire artifact pack without a concrete reason (a negative
  signal only when the read set is actually verified).

## Mechanical review hint

`documents/INDEX.md` already routes HTTP policy correctly, so no index
edit is required unless a genuinely new owning document is created.
Changed paths should normally be limited to the owning document;
broader documentation churn needs a concrete task-related justification.
