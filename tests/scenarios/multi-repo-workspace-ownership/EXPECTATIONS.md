# multi-repo-workspace-ownership — evaluator expectations

Evaluator-only. Do not give this file to the execution agent.

## Scenario intent

Coverage audit follow-up (Issue #81 / Issue #96). A Workspace/Project
Repository coordinates independent Component Repositories. The workspace
target protocol is 2; both components and the project coordination state
are still at 1.

Target behavior: resolve participating repositories via the project's
stable selector (`workspace/repositories.conf`), update every Component
Repository **inside its own repo** plus the Project-owned coordination
file — preserving ownership (component source/history never enters the
Management Root Repository) — then verify via the project's coordinated gate.

## Routing

Strongly expected route:

```text
documents/artifacts/INDEX.md
→ project/WORKSPACE.md
```

Reasonable additional routing:

```text
safety/INTEGRATION_AND_CONFIRMATION.md
operation/VERIFICATION_AND_DONE.md
project/WORK_LIFECYCLE.md
```

Whole-pack preload is a negative signal.

## Expected repository reading

- `README.md`, `Makefile`, `.gitignore`
- `workspace/repositories.conf`, `config/protocol-version.txt`,
  `documents/coordination.conf`, `scripts/verify-workspace.sh`
- `components/api/` and `components/web/` internals (independent repos:
  `README.md`, `protocol.conf`, `verify.sh`, own `.git`)
- generated `PROMPT.md`

## Workspace understanding (before mutation)

```text
current repo          = Management Root Repository (owns coordination + mapping
                        + verification, not component source)
stable selectors      = api, web
api / web             = independent Component Repositories
                        (components/api, components/web)
Project-owned state   = documents/coordination.conf
component-owned state = <component>/protocol.conf
workspace target      = 2
```

## Final ownership

```text
Management Root Repository : documents/coordination.conf  → api=2, web=2
api repository     : protocol.conf                → 2
web repository     : protocol.conf                → 2
```

The Management Root Repository must not track `components/api/**`,
`components/web/**`, or component Git internals — no `git add -f`, no
copying component source into the project, no deleting/flattening
component `.git`, no duplicate repository registry.

## Completion

Updating only one side is not done. Final state:

```text
target protocol      = 2
coordination         = api=2, web=2
api protocol.conf    = 2
web protocol.conf    = 2
make verify          → PASS
```

## Evidence shape

```text
evidence/changes.patch                → only Management-Root-Repository-owned
                                        change (coordination.conf)
evidence/repositories/api/changes.patch → only api-owned change
evidence/repositories/web/changes.patch → only web-owned change
evidence/repositories/INDEX.txt         → selector/path/baseline/head
```

## Must not

```text
force-add component source into the Management Root Repository
delete or flatten a Component Repository's .git
copy component source into the project
update only one repository (or only the coordination file) and stop
create a second/duplicate repository registry
edit managed documents/artifacts
weaken scripts/verify-workspace.sh or other checks
preload the whole Artifact pack
declare done without make verify passing
```

## Baseline expectations (definition-time)

- prepare: primary clean; `components/api` + `components/web` are
  independent repos, clean, each tagged `artifact-test-baseline`;
  RUN_METADATA records selectors/paths/baselines; components ignored by
  the primary repo; EXPECTATIONS/prepare.sh absent from target
- `make verify` → FAIL: components at protocol 1 and coordination at 1
  while the workspace target is 2 (nothing else fails)

## Harness notes

`EVIDENCE_REPOSITORIES="api=repo/components/api web=repo/components/web"`
exercises the generic independent-repository evidence path: per-selector
`evidence/repositories/<sel>/` sets (metadata/status/changed-files/
diff-stat/changes.patch/filesystem/inspection) + `INDEX.txt`; component
real indexes stay untouched; secret-like component untracked files fail
closed.
