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

## When to establish it — RC3

Do not create Work Identity for every early idea or exploratory discussion.

**RC3:** Projects adopting this Artifact pack use a Work Identity for concrete implementation. Reuse the current confirmed Work if one already owns the requested change; otherwise establish a new Work Identity as implementation begins. A new chat or agent session is not a reason to create a second Work.

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

**RC3:** Use a human-readable identity expressing the goal. **RC1:** The project determines the concrete Work/branch name and repository selector conventions.

## Work Root

The standard Work Root shape is:

```text
<project-root>/.worktrees/<work-type>/<work-name>/
├─ documents/
└─ <repository-selector>/
```

Use the same conceptual shape for single- and multi-repository projects.

Do not introduce a parallel `.work/<identity>/` root merely to duplicate this Work Root. External systems may own state outside the filesystem when appropriate.

## Work Root is not the session root

The Work Root is the physical area that groups Work Documents and participating repository worktrees. It is **not** the Project-level AI development session root.

Keep this distinction:

```text
Agent Session Root = Project Root
Work Root          = .worktrees/<work-type>/<work-name>/
```

Start from Project Root, resolve the Work and participating repositories there, then operate on the selected repository worktree.

A repository-specific worktree may be the command target without becoming the Project context root. Generic command-target routing is covered by `../execution/COMMANDS_AND_CI.md`.

## Work Documents

```text
.worktrees/<work-type>/<work-name>/documents/
```

is formal work-specific knowledge for active design, investigation, decisions, migration plans, and verification—not a throwaway temp folder.

Project Documentation describes the current canonical project state; Work Documents describe the active change.

Work Documents are tracked by the Management Root Repository. Routine active-Work documents and project coordination updates belong on its project-defined **baseline branch** (often `main`), through the authorized VCS workflow.

Choose repository-specific Work branches for actual implementation changes: Component source in its Component repository; Management Root tooling, behavior, or contracts when separate development/review is needed. The shared Work Identity does not require a branch in every participating repository.

Baseline publication does not itself authorize commit/push/merge. If publication is not authorized, preserve the Work context in an authorized Management Root working state and report baseline publication as pending.

Reconcile durable conclusions into Project Documentation when the Work completes.

## Work Records — lightweight development journal

While a confirmed Work is active, preserve its important progress, decisions and reasons, problems, verified results, and unresolved matters as a lightweight journal under:

```text
<project-root>/.worktrees/<work-type>/<work-name>/documents/records/
```

The Management Root Repository owns these tracked documents. One Markdown file may cover a meaningful work interval or session and multiple decisions; use short entries, optional evidence links, and conflict-free filenames when multiple writers participate. Do not require a verbatim chat transcript, exhaustive tool log, rigid template, or fixed schedule.

Write checkpoints at meaningful progress boundaries (significant decisions, discoveries, resolution, verification, handoff or interruption). For unusually long uninterrupted work, preserve a brief current progress / unresolved-state checkpoint before context is lost. File update, Git commit, push and baseline publication are distinct operations with separate authority; see `../operation/VERSION_CONTROL_AND_REPORTING.md`.

Work completion and archive transfer are described in `WORK_LIFECYCLE.md`. Do not create Work Identity solely for exploratory discussion that precedes a concrete Work; record meaningful early decisions through an authorized existing Issue or Project Documentation path.

## Repository participation

A base Work may span multiple repositories. Each repository maps deterministically from:

```text
Work Identity + repository selector
```

to its branch/worktree identity.

A repository selector is a stable project-local repository identity, **not a Git branch name**. A selector named `main` does not imply that the repository's baseline branch is also named `main`.

Do not make filesystem paths or random run IDs the primary work identity.
