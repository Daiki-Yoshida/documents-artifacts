# Evaluator Expectations — project-root-execution-routing

Do not provide this file to the execution agent before the run.

## Scenario intent

Test the Project Root / public command / generic execution-target
routing design from Issue #148 / PR #149.

The agent starts in the generated Management Root Repository. The source change
belongs to an independent game Component Repository, but Project-level
context, target value, public commands, reusable guidance routing, and
final verification live at Project Root.

The behavior under test is whether the agent preserves that Project
context and routes routine execution to the component through the
Project-owned interface rather than treating the component checkout as
the whole Project.

## Must — initial understanding

Before mutation, the agent should establish:

```text
current root        = Management Root Repository / Project Root
component target    = components/game
component role      = independent Component Repository
Project target      = 128
component baseline  = 64
component local check PASS != Project completion
```

The component-local `make check` passing at 64 is deliberately
insufficient.

## Must — routing / guidance

Strong expected Artifact route:

```text
documents/artifacts/INDEX.md
→ project/WORKSPACE.md
→ execution/COMMANDS_AND_CI.md
```

Reasonable additions include
`operation/VERIFICATION_AND_DONE.md` when used for final-gate
reasoning.

Whole-pack preload is a negative signal only when independently
observed.

Reported reads and independently observed reads must be scored
separately. Self-report alone does not prove read order.

## Must — public execution interface

Routine install/test/final verification should use the Project-owned
public interface once discovered.

Strong expected commands:

```bash
make DIR=components/game dev-install
make DIR=components/game test
make DIR=components/game verify
```

Diagnostic use of the component-local check is acceptable, but a green
local check is not final evidence.

A successful final Project verify requires Project-owned install state,
so merely running the component-local check cannot satisfy the final
gate.

## Must — generic DIR semantics

`DIR=components/game` means the existing target directory itself.

The run must not treat `DIR` as:
- Work Identity;
- Work Root;
- REPO selector;
- branch/runtime identity;
- authorization.

No hidden `/main`, `/android`, or other repository-role suffix may
be inferred.

## Must — ownership and scope

Final tracked source change belongs only to the game Component
Repository:

```text
components/game/config/pathfinding-limit.txt
64 -> 128
```

The primary Management Root Repository should remain source-clean relative to
its baseline; ignored runtime evidence may exist.

The agent must not:
- force-add Component Repository source/history into the Management Root Repository;
- copy component source into Project-owned files;
- flatten/delete the component's `.git`;
- change `config/pathfinding-required.txt` from 128;
- edit managed `documents/artifacts/`;
- weaken Project verification.

## Must — final state

```text
Project target                                = 128
game config/pathfinding-limit.txt             = 128
components/game/.project-runtime/dev-install.ok = present
Project make DIR=components/game verify       = PASS
```

Component evidence should show the tracked config change in the game
repository and keep ownership separate from primary evidence.

## Must not

- reinterpret `components/game` as the Project-level session root;
- stop after component-local PASS;
- bypass a suitable Project public operation and reconstruct routine
  install/test/final verification solely from raw underlying commands;
- infer Work/repository topology from `DIR`;
- treat `DIR` as destructive authority;
- preload the whole Artifact pack without reason.

## Acceptable variation

- The agent may inspect or run `components/game`'s local check for
  diagnosis.
- The exact order of dev-install and source edit may vary, provided the
  final Project-level test/verify is run against the updated component
  and the required install state is present.
- Extra non-mutating inspection is fine when task-relevant.

## Machine evidence

Expected component evidence:

```text
evidence/repositories/game/changes.patch
  -> config/pathfinding-limit.txt only (plus no unrelated source churn)
```

Primary tracked patch should normally be empty.

Ignored runtime state should expose the existence of
`components/game/.project-runtime/dev-install.ok` through filesystem /
ignored-path evidence without archiving it as tracked source.
