# Work Identity

Read this when a concrete implementation effort needs a stable identity across branches, worktrees, runtime state, logs, outputs, or work-specific documents.

## Meaning

A **Work Identity** represents *what the development work is trying to accomplish*.

It owns:

- work-level ownership;
- resource identity;
- lifecycle.

It is above tool-specific identifiers.

```text
User Goal
   ↓
Work Identity
   ├─ branch / optional worktree
   ├─ runtime/test state
   ├─ logs / outputs
   └─ Work Documents
```

Git represents Work Identity where useful; Git does not define it.

## When to establish it

Do not create Work Identity for every early idea or exploratory discussion.

Establish it when the implementation goal has become concrete and the project workflow is moving into implementation.

- AI may propose a Work Identity.
- **Before implementation begins, the user explicitly confirms the Work Identity.**
- Do not rush to create one during an exploratory discussion whose implementation goal is still unclear.

Materialize work-scoped state only after that identity is confirmed.

## Naming

Conceptual form:

```text
<work-type>/<work-name>
```

Examples:

```text
feat/pathfinding
fix/login-timeout
refactor/payment-boundary
```

Use a human-readable name that expresses the goal. Branch naming syntax may specialize this project-locally.

## Work Root

The standard Work Root shape is:

```text
<project-root>/.worktrees/<work-type>/<work-name>/
├─ documents/
└─ <repository-selector>/
```

Use the same conceptual shape for single- and multi-repository projects.

## Work Documents

```text
.worktrees/<work-type>/<work-name>/documents/
```

is formal work-specific knowledge for active design, investigation, decisions, migration plans, and verification—not a throwaway temp folder.

Project Documentation describes the current canonical project state; Work Documents describe the active change.

Work Documents are tracked by the Project Repository according to the project model and should remain visible from the Project Repository's current baseline (normally `main`) while the Work is active. They are not hidden only inside a feature worktree.

Reconcile durable conclusions into Project Documentation when the Work completes.

## Repository participation

A base Work may span multiple repositories. Each repository maps deterministically from:

```text
Work Identity + repository selector
```

to its branch/worktree identity.

Do not make filesystem paths or random run IDs the primary work identity.
