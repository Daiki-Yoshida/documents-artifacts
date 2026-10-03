## Purpose

Apply the newly merged Knowledge System effective-status / Decision Lineage contract across all 8 canonical subjects and identify places where multiple generations of semantic knowledge are still presented without a resolved current/non-current status.

This is a **read-only audit first**. Do not modify canonical subjects until findings are durably recorded in this Issue.

Base main:

~~~text
00f14b3530fbcf5c8fec99523f39eb5278265f78
~~~

Audit Work Identity:

~~~text
audit/subject-effective-status
~~~

## Canonical contract

~~~text
records
  = source completeness

subjects
  = semantic completeness + effective-status resolution

artifacts
  = current-effective runtime projection
~~~

Subjects must preserve reusable semantic knowledge while distinguishing:

~~~text
current
superseded
rejected
unresolved
~~~

Do not use newest-date-wins.
Do not delete old semantic knowledge merely because it is non-current.
Do not require every historical fact/evidence item to have an effective status.

## Subjects in scope

~~~text
encapsulation-horizon
code-design
engineering-operation
documentation
workspace-structure
development-execution
development-safety
work-identity
~~~

## Audit questions

For each subject:

1. Is ordinary current-surface prose actually current?
2. Are old/new generations coexisting without explicit status?
3. Are superseded/rejected semantic models still written as unqualified current guidance?
4. Is HISTORY correctly used for non-current semantic knowledge rather than raw source archiving?
5. Are there unresolved conflicts that should be explicit?
6. Are source/record lists flattening multiple generations into equal authority?
7. Does the INDEX correctly route current vs HISTORY/non-current knowledge?
8. Would Artifact projection from the current subject select the correct generation?
9. Are negative guards current guidance rather than accidental resurrection of old models?

## Audit method

- Read all current subject INDEX files.
- Read all S*.md current and HISTORY files.
- Inspect related source records when old/new generations are indicated.
- Use dates only for event ordering, never as authority by themselves.
- Classify findings as:
  - PASS — current/non-current distinction is already safe;
  - NEEDS_LINEAGE — semantic generations exist but status/lineage is not explicit enough;
  - CURRENT_CONFLICT — incompatible rules both appear current or authority is unresolved;
  - HISTORY_PLACEMENT — non-current semantic knowledge should be moved/labeled without deletion;
  - TRACEABILITY — source relation is too flat to determine authority;
  - ARTIFACT_RISK — subject ambiguity could project stale runtime guidance.

## Important preservation rule

Do not remove historical semantic knowledge during the audit.

If a later implementation is needed, preserve old meaning in HISTORY / explicit non-current areas and add Decision Lineage where useful.

## Expected audit output

- per-subject finding summary;
- exact file/section references for each issue;
- cross-subject patterns;
- prioritized remediation plan;
- explicit statement whether a broad migration is needed or only targeted fixes;
- proposal for implementation Work Identity if remediation is needed.

No subject edits in the audit phase.
