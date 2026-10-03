## Issue comment 5965280136

## Design revision — adopted direction

User proposal adopted with refinement.

Previous direction:

```text
records = full history
subjects = current effective view only
artifacts = runtime projection
```

was rejected because allowing subjects to discard superseded semantic knowledge creates a new risk: an AI may decide that information is "obsolete" or "unnecessary" and remove knowledge that should remain semantically preserved.

Revised direction:

```text
records
  = source completeness
  = what actually happened / immutable evidence

subjects
  = semantic completeness + current evaluation
  = preserve organized semantic knowledge
  = explicitly distinguish current / superseded / rejected / unresolved

artifacts
  = current runtime projection
  = optimize current-effective guidance for AI consumption
```

Key rule:

> subjects do not discard preserved semantic knowledge; they resolve and expose its effective status.

Decision Lineage remains useful, but its role is now classification/evaluation rather than deletion/filtering.

This revision preserves the existing knowledge-first principle while addressing the failure mode seen in the parent/child hierarchy → Project Repository / Component Repository migration.

---

## Issue comment 5965284582

## Recommended design proposal

### 1. Keep the existing three layers, strengthen their contracts

```text
records
  source completeness

subjects
  semantic completeness + effective-status evaluation

artifacts
  current-effective runtime projection
```

No large directory redesign is required.

### 2. Formalize Subject placement

Current subject files (`S001_...`, `S002_...`, etc.):

- hold current effective knowledge;
- may state current unresolved decisions explicitly;
- must not present superseded/rejected knowledge as unqualified current guidance.

`*_HISTORY.md`:

- remains inside subjects, so semantic knowledge is not discarded;
- owns substantial superseded/rejected/obsolete semantic models and meaningful transitions;
- is not a raw-record archive.

Small historical context may remain in a current file only when explicitly labeled as non-current and routed to HISTORY/source where appropriate.

### 3. Separate status from evidence

Proposed effective-status axis:

```text
current
superseded
rejected
unresolved
```

Proposal/experiment/validation are not all the same kind of state.

Evidence relations such as validation should remain relations/evidence rather than being conflated with current authority.

### 4. Add DECISION_LINEAGE_MODEL.md

Recommended ownership:

```text
RECORD_MODEL
  raw/source preservation + optional metadata boundary

DECISION_LINEAGE_MODEL
  semantic scope + relation resolution + conflict behavior

SUBJECT_MODEL
  semantic completeness + placement/current-vs-history rules

TRACEABILITY_MODEL
  source and decision-lineage presentation

ARTIFACT_MODEL
  current-effective projection gate
```

Minimal relation candidates:

```text
adopts
supersedes
refines
corrects
rejects
validates
```

Keep the schema small and optional.

### 5. Later record declares lineage

Do not rewrite old source records.

```text
old record
  unchanged

later decision record
  declares scope/status/relation to old record
```

Free-text scope is sufficient initially.

### 6. Fail closed on unresolved authority

If two decisions in the same scope appear current and no relation resolves them:

- do not choose by date;
- do not merge both as current;
- mark the conflict/unresolved state in subjects;
- obtain a new decision and record it.

### 7. Artifact projection gate

Artifact projection should primarily consume:

- current effective subject knowledge;
- current unresolved constraints that affect runtime decisions;
- current negative guards needed to prevent known misreadings.

It should normally omit full superseded/rejected/history detail while preserving that detail in subjects/records.

### 8. Incremental adoption

No full migration of all records.

Recommended phases:

1. update knowledge-system contracts;
2. use the parent/child → Project/Component case as the reference fixture;
3. add deterministic regression guards around that fixture;
4. audit other subjects for multiple-generation knowledge;
5. repair only identified conflicts;
6. reproject Artifact v2 where current evaluation changes.

### 9. Key safety invariant

```text
Information may move between current and non-current semantic areas,
but semantic knowledge must not disappear from subjects merely because
it is no longer current.
```

This preserves the original Subject philosophy while making current authority explicit.

---

## Issue comment 5965365533

## Final design proposal v1 — ready for approval

This comment freezes the recommended contract before implementation.

### A. Three independent completeness goals

```text
records
  source completeness

subjects
  semantic completeness + effective-status resolution

artifacts
  runtime relevance / current-effective projection
```

These are deliberately different guarantees.

### B. Subject default semantics

For a subject:

- ordinary `S001_...`, `S002_...` current-surface prose is presumed **current** unless explicitly labeled otherwise;
- `unresolved` belongs on the current surface because "this is not decided yet" is itself a current fact;
- substantial `superseded` / `rejected` semantic models belong in `*_HISTORY.md`;
- a current file may mention non-current knowledge only when the status is explicit and the mention is useful to understand or guard current behavior;
- unqualified old/new coexistence is invalid.

Recommended labels for newly added/touched non-current sections:

```text
Superseded
Rejected
Historical context
```

Existing HISTORY content is migrated incrementally, not rewritten wholesale.

### C. Effective-status vocabulary

Core subject evaluation states:

```text
current
superseded
rejected
unresolved
```

Do not add `validated` as an effective status. Validation is evidence.

Likewise, "deprecated but still supported" is current knowledge describing a deprecation policy; it does not require a fifth lineage status.

### D. Immutable record event model

A record describes what happened at that source event, never its forever-current status.

Minimal optional metadata:

```yaml
decision_lineage:
  event: "proposal | adoption | rejection | correction | validation | observation"
  scope: "free-text semantic scope"

  adopts:
    - "../proposal-record/"
  supersedes:
    - "../older-decision-record/"
  refines:
    - "../existing-decision-record/"
  corrects:
    - "../incorrect-or-partially-incorrect-record/"
  rejects:
    - "../proposal-record/"
  validates:
    - "../decision-or-claim-record/"
```

Only relevant keys need to exist.

No `current: true` / `superseded: true` is written into an old immutable record.

### E. Relation semantics

- `adopts`: makes the referenced proposal/candidate an adopted decision at this event.
- `supersedes`: replaces the referenced effective model/decision for the stated scope.
- `refines`: keeps compatible earlier meaning and adds/clarifies detail.
- `corrects`: replaces only the incorrect portion/scope; unaffected earlier meaning remains.
- `rejects`: explicitly rejects a proposal/candidate.
- `validates`: supplies evidence; does not change effective status by itself.

A decision event may both adopt a proposal and supersede an older decision.

### F. Scope rule

Scope is initially free text.

Do not build a global scope taxonomy yet.

Rules:

- a narrower/project-specific decision does not automatically supersede a general decision;
- both can remain current in different contexts;
- ambiguous overlap is `unresolved`, not latest-wins;
- date orders events but never decides authority by itself.

### G. Resolution rule

To determine subject status:

1. identify relevant semantic claims and their scope;
2. inspect adoption/rejection/correction/supersede/refine relations;
3. preserve all reusable semantic meaning in subjects;
4. classify its current evaluation;
5. if competing claims remain without a resolving relation, mark unresolved.

`current` is therefore a derived subject evaluation, not immutable record metadata.

### H. Subject disposition accounting

When promoting a record into subjects, every meaningful item must have an explainable disposition:

```text
current
  -> current subject surface

non_current
  -> HISTORY / explicit non-current section
     with superseded/rejected classification

unresolved
  -> current subject surface, explicitly unresolved

routed
  -> another owning subject

represented
  -> semantic meaning already exists; avoid duplicate prose

evidence_only
  -> raw evidence/provenance/log remains in records
     and is traceable; may not hide reusable semantic claims
```

If uncertain whether something is merely evidence or reusable semantic knowledge, do not silently classify it as evidence-only; preserve/reroute it or mark the issue unresolved.

### I. HISTORY contract

`*_HISTORY.md` is part of subjects and therefore part of semantic completeness.

It is not a raw archive.

It owns:

- superseded semantic models;
- rejected designs where reusable understanding remains valuable;
- obsolete terminology/model explanations;
- meaningful transitions from old to current.

Records remain the exhaustive raw source.

### J. Traceability trigger

A dedicated `Decision lineage` section is not mandatory everywhere.

Use it when:

- multiple generations exist in the same semantic scope;
- current vs superseded status is not obvious;
- a conflict was resolved;
- Artifact projection depends on which generation is current.

Example:

```text
Decision lineage

Current:
- record C

Superseded:
- record A
  superseded by C

Rejected:
- record B

Supporting validation:
- record D
```

### K. Artifact projection gate

Artifact v2 primarily projects:

- current effective knowledge;
- unresolved constraints only when an AI must know them to avoid an unsafe/incorrect assumption;
- current negative guards needed to prevent known misreadings.

Artifact v2 normally omits:

- complete superseded models;
- rejected proposal detail;
- lineage bookkeeping;
- provenance/history detail.

A statement such as "do not use the old parent/child model" is current guidance and may be projected even though the old model itself is non-current.

### L. Conflict behavior

Same-scope ambiguity fails closed.

Never:

- choose by newest date alone;
- silently merge competing rules as both current;
- delete one because it seems obsolete.

Instead:

- expose `unresolved` in subjects;
- obtain a new source decision if needed;
- add a later record that resolves the relation.

### M. Incremental migration

No repository-wide historical rewrite.

Implementation order:

1. add/update system contracts;
2. add Decision Lineage model;
3. update repository-local Knowledge Update Workflow;
4. create a new implementation/design source record for Issue #171 and this discussion;
5. use parent/child → Project/Component as the first reference fixture;
6. add regression guards for source/current/history/artifact separation;
7. audit other subjects incrementally for multi-generation conflicts;
8. repair only identified conflicts and reproject affected Artifacts.

### N. Proposed implementation ownership

Recommended system ownership:

```text
KNOWLEDGE_MODEL
  three-layer relationship / completeness goals

RECORD_MODEL
  immutable source + optional event metadata boundary

DECISION_LINEAGE_MODEL (new)
  event relations / scope / resolution / fail-closed conflicts

SUBJECT_MODEL
  semantic completeness / effective status / current-vs-history placement

TRACEABILITY_MODEL
  source + lineage presentation

ARTIFACT_MODEL
  current-effective projection gate

KNOWLEDGE_UPDATE_WORKFLOW
  operational promotion/disposition procedure
```

### O. Proposed implementation Work Identity

When implementation is explicitly approved:

```text
docs/knowledge-effective-status-lineage
```

No implementation branch or system-file edit should begin before that approval.