# Engineering Change Lifecycle

Read this for the default flow of an engineering change.

## Flow

```text
understand intent / required outcome
        ↓
scan current context and boundaries
        ↓
route design/risk questions to the owning guidance
        ↓
establish / reuse a confirmed Work Identity (RC3 for Artifact-adopting implementation)
        ↓
confirm other owner-specific gates when required
        ↓
implement within agreed scope
        ↓
verify contract + requested outcome
        ↓
report
```

Scale the depth of each phase to blast radius. A one-line private fix should not require a full architecture exercise; a public contract, persistent data, external dependency, or module-boundary change deserves broader analysis.

## Before implementation

Know at least:

- the observable outcome the user needs;
- the responsibility/boundary being changed;
- whether a public contract is affected;
- whether destructive/operational risk exists;
- whether project-local rules constrain the change.

**RC3:** When a project adopting this Artifact pack is about to undertake concrete implementation, route to `../project/WORK_IDENTITY.md`. Reuse an already confirmed Work Identity or satisfy the new-Work confirmation gate before implementation. Exploration and design discussion alone do not create a new Work. This requirement is independent of whether a worktree or separate repository branch is needed.

Use the specialized artifact for the answer:
- boundary/contract design → `../design/INDEX.md`
- code realization → `../implementation/INDEX.md`
- destructive risk → `../safety/INDEX.md`
- execution environment → `../execution/INDEX.md`
- project/work identity → `../project/INDEX.md`
- documentation → `../documentation/INDEX.md`

## Implement

Proceed with internal changes that do not require confirmation once enough context is known.

Do not treat workflow convenience as authorization to bypass an owner-specific confirmation rule.

## Verify and report

Before calling the work done:

1. verify implementation against its contract;
2. verify the requested observable outcome;
3. disclose anything not verified;
4. report remaining in-scope work and public/data/operational impact.

For detail, read `VERIFICATION_AND_DONE.md`.
