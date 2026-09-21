# Engineering Operating Model

```yaml
document_type: "canonical_knowledge"
authority: "canonical_source"
audience: ["ai_agents", "human_maintainers"]
scope: "cross-cutting engineering behavior"
artifact_projection: "derived"
```

This document owns the engineering rules that apply across code, documentation, development environments, and active Work. Domain-specific documents may specialize these rules, but should not redefine them.

## 1. Authority and Precedence

Use the most specific applicable authority.

```text
explicit user instruction
  ↓
target-project local rules and constraints
  ↓
canonical reusable knowledge in this repository
  ↓
tool/framework defaults and conventions
```

When a target project intentionally differs from reusable guidance, follow the project rule and report the conflict when it matters. Do not silently rewrite project policy to match generic guidance.

## 2. Accuracy Before Compression

The primary goal of engineering knowledge is correct action.

```yaml
priority:
  1: "accuracy and semantic completeness"
  2: "clear ownership and routing"
  3: "progressive disclosure"
  4: "token and reading efficiency"
```

Do not remove load-bearing constraints merely to shorten a document. Reduce context cost by improving ownership, concept locality, and routing.

## 3. One Semantic Owner

Every reusable rule or concept should have one semantic owner.

- Other documents may mention it briefly when necessary.
- A brief restatement must not become a second independent specification.
- Cross-references should point to the semantic owner.
- If two documents can evolve independently and create conflicting meanings, the ownership model is wrong.

Filesystem location, publication format, and artifact packaging do not define semantic ownership.

## 4. Contracts and Observable Guarantees

Treat important boundaries as contracts.

```text
Contract = Signature / Shape + Semantics / Behavior + Constraints
```

Constraints may include side effects, failure behavior, resource limits, determinism, data guarantees, compatibility, or lifecycle guarantees.

The implementation may change behind a stable contract. The more freedom or complexity exists behind a boundary, the more complete the observable contract must be.

This principle applies recursively from functions and classes through modules, libraries, services, applications, command interfaces, and development-environment operations.

## 5. Safety and Scope

Prefer the narrowest operation that satisfies the requested outcome.

```yaml
safety:
  observe_before_mutate: true
  preserve_existing_state: true
  fail_closed_on_ambiguity: true
  destructive_scope: "explicit and narrow"
  force_operations: "exceptional, never routine"
```

Do not broaden a local problem into global cleanup, repository-wide refactoring, host mutation, or destructive repair without a concrete need.

The safest correct path should also be the easiest routine path.

## 6. Proportionality

Scale analysis, abstraction, verification, and confirmation to blast radius.

Small internal changes should not require ceremony designed for published contracts. Published or destructive changes should not be treated like private refactors.

Consider:

- number and importance of affected callers;
- public or persisted compatibility;
- cross-repository impact;
- irreversible side effects;
- mutable shared state;
- operational risk;
- cost of an incorrect assumption.

## 7. Confirmation Boundary

Use a four-level semantic model across engineering work.

```yaml
L0_observational_or_internal:
  examples:
    - "read-only inspection"
    - "private helper refactor"
    - "tests or documentation clarification with no semantic expansion"
  action: "proceed"

L1_local_additive:
  examples:
    - "contained internal contract"
    - "non-destructive diagnostic or helper"
    - "local implementation improvement within owned scope"
  action: "proceed and report"

L2_structural_or_compatible_public:
  examples:
    - "compatible public capability"
    - "new stable command"
    - "new project/repository/document structure clearly implied by the task"
  action: "proceed when clearly implied; report explicitly"

L3_breaking_destructive_or_host_mutating:
  examples:
    - "published breaking contract"
    - "persistent data migration with destructive risk"
    - "branch/history destruction"
    - "force removal"
    - "global host mutation or cleanup"
  action: "require explicit authorization unless the user already requested that exact effect"
```

The effective level is determined by semantics, not by a harmless-looking command name.

## 8. Brownfield Rule

Reusable knowledge governs new or modified work; it is not a mandate to rewrite an existing project.

- Respect explicit target-project conventions.
- Do not silently fix unrelated violations.
- Record relevant debt when useful.
- Treat cleanup of existing violations as its own change.
- Prevent "violation hunting" from expanding task scope.
- Preserve working behavior unless the requested outcome requires change.

## 9. Evidence and Validation

Completion requires evidence for both:

1. **contract conformance** — the implementation obeys the applicable boundary rules;
2. **requested outcome** — the user-visible or operational result actually works.

Use the narrowest meaningful validation first, then widen when the affected boundary requires it.

A passing unit or contract test does not prove a user-visible outcome if the real path crosses additional boundaries. Conversely, full E2E testing is unnecessary for a purely private change when narrower evidence is sufficient.

Every project should define one canonical final-validation path for the state it considers ready.

Never claim completion after a failed validation without clearly reporting the failure.

## 10. Git as History, Not a Parallel Database

Use Git for change history, comparison, rollback, and historical recovery.

Do not create a second archive or history database merely to preserve information already committed to Git.

Operational registries are justified only when they represent live state Git does not own. Do not duplicate live Git worktree, branch, or document-history state into a custom registry without a concrete requirement.

## 11. Progressive Disclosure

Always-on instructions should be small and routing-oriented.

Detailed knowledge should be loaded by concept or task.

```text
small entry point
  ↓
relevant canonical concept
  ↓
task-specific procedure / project-specific detail
```

Avoid both extremes:

- one giant document that must be read for every task;
- many tiny documents with overlapping ownership and costly navigation.

Split by semantic concern and lifecycle, not by arbitrary file-size thresholds.

## 12. Project-Specific Knowledge Wins

Reusable knowledge cannot know every runtime, domain, legal constraint, provider, or team policy.

Target projects should own:

- concrete commands and supported versions;
- exact repository/component mappings;
- production credentials and provider configuration;
- domain vocabulary and business rules;
- local exceptions and compatibility constraints;
- release and approval policy.

Reusable knowledge owns the general model and invariants.

## 13. Agent Operational Defaults

For AI coding-agent work, the legacy reusable guidance defines these defaults unless more specific user/project rules override them:

```yaml
reporting:
  thinking_and_interim: "English"
  final_report: "use the user's language"
  content: "state what changed, why, and any impact on a public contract"

testing:
  when: "run relevant tests after implementation and before declaring completion"
  gate: "contract evidence and requested-outcome evidence must support the completion claim"
  scope: "start with the narrowest meaningful validation and widen as the boundary requires"

version_control:
  commit: "do not commit or push unless the user asks"
  branch: "if committing while on the default branch, create/use an appropriate non-default branch first"
  confirmation: "after changes and the final report, ask whether to commit when commit intent has not already been provided"

clarification:
  rule: "if intent or the contract is unclear, stop and ask before implementing the uncertain effect"
```

Specific agent platforms or projects may override these operational defaults.

### Approach questions

When a user asks how to approach a design problem rather than asking directly for implementation:

1. explain materially different approaches;
2. compare relevant trade-offs such as complexity, performance, maintainability, compatibility, and risk;
3. recommend an approach based on the applicable engineering principles.

Do not jump straight to code when the user's actual need is decision support.

## 14. Reporting Discipline

When work changes a meaningful contract or structure, report:

- what changed;
- why it changed;
- what boundary or lifecycle is affected;
- what was validated;
- what remains uncertain or intentionally unchanged.

Do not bury important behavioral changes inside implementation detail.

## 15. Common Misreadings

- "one semantic owner" does not mean a term may appear only once; it means only one location defines its meaning.
- "accuracy first" does not mean load everything; it means route without deleting necessary information.
- "fail closed" does not mean ask for confirmation for every safe operation.
- "brownfield" does not mean preserve bad design forever; it means change it deliberately and within scope.
- "contract" does not mean interface keyword or class-heavy design.
- "safety" does not justify slow, repetitive manual procedures that can be encoded into a safe command.
