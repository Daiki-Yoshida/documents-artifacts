## Purpose

Implement the targeted remediation identified by effective-status audit Issue #174.

No current semantic conflict or Artifact defect was found. The goal is to make already-correct multi-generation knowledge explicitly conform to the new Decision Lineage contract.

Work Identity:

~~~text
docs/subject-effective-status-lineage
~~~

Base main:

~~~text
00f14b3530fbcf5c8fec99523f39eb5278265f78
~~~

## Audit source

Issue #174 audit result comment:

~~~text
issuecomment-5965548867
~~~

## Targeted files

~~~text
documents/knowledge/subjects/encapsulation-horizon/
  S004_CONCEPT_ALTITUDE.md
  S008_OPERATIONAL_GUARDS.md

documents/knowledge/subjects/code-design/
  S009_TESTING_AND_RUNTIME.md
  S011_PERFORMANCE_SHAPED_INTERACTION.md
  S012_DESIGN_PRIORITY.md

documents/knowledge/subjects/engineering-operation/
  INDEX.md

documents/knowledge/subjects/development-safety/
  INDEX.md

documents/knowledge/subjects/work-identity/
  S005_WORKTREE_MATERIALIZATION.md
  S007_VALIDATION.md

tests/test-knowledge-integrity.sh
~~~

Only touch additional files if required for traceability/integrity.

## Required semantics

### Encapsulation Horizon

S004:
- identify the current semantic-identity rule;
- identify the older one-sentence/generalization interpretation as superseded;
- preserve old source/history.

S008:
- identify current compatible-public-evolution semantics;
- identify old additive=L2 example as superseded;
- preserve source.

### Code Design

S009:
- current: contract conformance != requested outcome verification;
- superseded: Contract Test as correctness/completion interpretation.

S011:
- current: performance-shaped contract evolution only with load-bearing requirement + evidence;
- represent proposal -> hold -> later adoption/implementation lineage;
- do not present old hold as current unresolved.

S012:
- current Mistake Prevention Priority is interpreted with later failure/compatibility decisions;
- preserve old source priority as predecessor semantics.

### Engineering Operation

INDEX:
- current verification lifecycle includes requested outcome, not Contract Tests PASS alone;
- old completion interpretation is superseded;
- fixed reporting-language rule remains historical/non-current.

### Development Safety

INDEX:
- current subject responsibility is the separated safety role plus later terminology/ownership corrections;
- predecessor development-environment umbrella is non-current and routed to existing history/raw records;
- do not create a new HISTORY file unless a safety-specific semantic model cannot be preserved/routed otherwise.

### Work Identity

S005:
- preserve detailed experiments/candidates;
- explicitly distinguish candidate experiments from adopted Materialization Contract.

S007:
- preserve validation evidence;
- explicitly trace initial reference implementation -> discovered upstream defect -> correction -> revalidation/current evidence;
- validation is evidence, not effective status.

## Preservation rules

- Do not delete semantic knowledge.
- Do not move all old evidence to HISTORY just because it predates the current decision.
- Do not rewrite old records.
- Do not add broad date-based authority rules.
- Do not change Artifact semantics unless the lineage review exposes a real projection defect.

## Regression guards

Add deterministic guards that verify the targeted lineage distinctions without global word bans.

At minimum cover:

- Concept Altitude current vs superseded interpretation;
- Contract L2 current vs additive predecessor;
- Contract conformance vs requested outcome;
- performance proposal/hold/current lineage;
- Work Identity materialization adoption lineage;
- Worktree reference validation defect/fix/revalidation lineage;
- engineering-operation current/superseded completion semantics;
- development-safety predecessor/current responsibility routing.

## Validation

~~~bash
bash -n tests/test-knowledge-integrity.sh
bash tests/test-knowledge-integrity.sh
bash tests/test-artifacts.sh
bash tests/test-agent-harness.sh
~~~

Independent validation before merge.

## Non-goals

- broad rewrite of all subjects;
- Artifact architecture change;
- records migration;
- introduction of a global lineage graph;
- deletion of historical or evidence content.
