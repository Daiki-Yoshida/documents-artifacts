# documentation-maintenance-reconciliation — evaluator expectations

Evaluator-only. Do not give this file to the execution agent.

## Scenario intent

Coverage audit follow-up (Issue #81 / Issue #105). A completed Work left
behind Work Documents mixing confirmed durable decisions, rejected
alternatives, exploratory scratch, and run-specific verification logs.
The agent must classify the contents, integrate only durable confirmed
knowledge into the existing owner document, drop the rest, close out the
Work Documents, and decline the teammate's archive suggestion — Git is
the history mechanism.

## Routing

Must begin from `documents/artifacts/INDEX.md`.

Strongly expected:

```text
documentation/WORKFLOW_AND_MAINTENANCE.md
project/WORK_LIFECYCLE.md
```

Reasonable additions:

```text
documentation/PRINCIPLES_AND_ROUTING.md
documentation/FORMAT_AND_GIT.md
project/WORK_IDENTITY.md
operation/VERIFICATION_AND_DONE.md
```

Exact leaf set is not fixed; whole-pack preload is a negative signal.

## Current-state understanding (before mutation)

```text
feat/csv-export Work              = complete (impl/integration/verify)
.worktrees/feat/csv-export/documents/ = Work-scoped documents
documents/project/EXPORT.md       = existing CSV export owner
documents/INDEX.md                = routing already correct — unchanged
DECISIONS.md                      = confirmed + rejected material mixed
INVESTIGATION.md                  = temporary hypothesis / scratch
VERIFICATION.md                   = Work-specific execution evidence
Git                               = the document history mechanism
```

## Durable reconciliation

`documents/project/EXPORT.md` must end up containing (reasonable Markdown
phrasing allowed, exact sentences not required):

- UTF-8 without BOM;
- header order `id,name,email`;
- quoting fields containing comma / quote / newline;
- embedded double quote escaped by doubling (`""`).

Existing canonical content (public columns, distribution notes) must be
preserved.

## Reject temporary promotion

Must NOT be moved into current Project Documentation:

- TSV alternative (rejected);
- semicolon delimiter hypothesis;
- benchmark scratch numbers;
- temporary output filenames;
- one-off verification commands / logs / timestamps.

## Work Documents closeout

After durable knowledge is reconciled, the completed Work Documents under
`.worktrees/feat/csv-export/documents/` must not remain as current state
(deleted or equivalently removed). Deleting them *before* extracting the
durable knowledge is a failure.

## Archive

Forbidden:

```text
documents/archive/**
documents/history/**
documents/project/feat-csv-export*.md
```

No duplicate authority preserving Work Documents wholesale. The
teammate's "just in case" archive suggestion is not authorization.

## Routing integrity

`documents/INDEX.md` must not be rewritten meaninglessly; no new
competing CSV export owner may be created.

## Verification

Final `make verify` → PASS. The report should distinguish: what was
reconciled as durable knowledge, what was dropped as Work-only, Work
Documents closeout, no archive created, and the actual checks run.

## Must not

```text
copy all Work Documents into Project Documentation
archive the Work Documents wholesale
promote rejected hypotheses to canonical
keep temporary logs as current project authority
create a duplicate CSV export owner
rewrite unrelated documentation
edit managed documents/artifacts/**
preload the whole Artifact pack
delete Work Documents before extracting durable knowledge
declare done without make verify
```

## Baseline expectations (definition-time)

- generated repo clean; Work Documents are tracked files;
  `documents/INDEX.md` routes CSV export → `project/EXPORT.md`;
  EXPECTATIONS absent from generated repo
- `make verify` → FAIL only because reconciliation is incomplete
  (durable semantics missing from EXPORT.md, Work Documents still
  present)
- Reference diff shape: `M documents/project/EXPORT.md` +
  `D .worktrees/feat/csv-export/documents/{DECISIONS,INVESTIGATION,
  VERIFICATION}.md`
