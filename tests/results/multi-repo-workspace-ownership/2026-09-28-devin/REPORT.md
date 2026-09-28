# multi-repo-workspace-ownership — run report

- Scenario: `multi-repo-workspace-ownership`
- Run id: `2026-09-28-devin`
- Agent: Devin (SWE-2 Max)
- Source repository baseline: `main` @ `3ec714a` (merge of PR #97)

## Generated baseline metadata

- Primary baseline (`artifact-test-baseline`): fixture baseline + Artifact
  install commit (HEAD count 2).
- Component baselines from `RUN_METADATA.txt`:
  - `api` → `repo/components/api` @ `3b5c281f222ce316f509654da132523fac44e06b`
  - `web` → `repo/components/web` @ `6e0a1b2eb3be82e140bccc595a52b405de0b23e9`

## Artifact files actually read

1. `documents/artifacts/INDEX.md` — routed "Project / repository
   structure" → `project/WORKSPACE.md`.
2. `documents/artifacts/project/WORKSPACE.md` — Project Repository owns
   project coordination; Component Repositories own their source and Git
   history; resolve repos by stable project-local selector; do not commit
   component source/history as ordinary project files; no duplicate
   registry.
3. `documents/artifacts/operation/VERIFICATION_AND_DONE.md` — verify the
   requested outcome (`make verify`), not just contract conformance.

## Project-local files actually read

`README.md`, `Makefile`, `.gitignore`, `workspace/repositories.conf`,
`config/protocol-version.txt`, `documents/coordination.conf`,
`scripts/verify-workspace.sh`, `components/api/{README.md,protocol.conf,
verify.sh}`, `components/web/{README.md,protocol.conf,verify.sh}`,
component `git log` output.

## Workspace ownership model discovered

- Current repo = **Project Repository** — owns `documents/coordination.conf`,
  `workspace/repositories.conf`, project verification (`make verify`).
- Stable selectors → paths: `api` → `components/api`,
  `web` → `components/web` (independent Git repos, own `.git` + history).
- Component-owned protocol state: `<component>/protocol.conf`.
- Workspace target: `config/protocol-version.txt` = `2`.
- Initial state: components at protocol `1`, coordination `api=1 web=1`.

## Baseline verification observed

`make verify` → FAIL, only the intended protocol mismatch:
`api`/`web` protocol=1 vs target 2, coordination `api=1`/`web=1`.
Independence and non-tracking checks already PASS.

## Changes (ownership-separated)

- **API Component Repository**: `protocol.conf` `1` → `2`, committed in
  the api repo (`chore: adopt workspace protocol 2`) — component state and
  history belong to the component repo.
- **Web Component Repository**: `protocol.conf` `1` → `2`, committed in
  the web repo — same reasoning.
- **Project Repository**: `documents/coordination.conf` `api=1`→`api=2`,
  `web=1`→`web=2`, committed in the project repo (`chore: record
  components at workspace protocol 2`) — coordination state is
  project-owned.

## Ownership workarounds

None. No `git add -f`, no component `.git` removal/flattening, no copying
of component source into the project, no duplicate repository registry.
`components/api` and `components/web` remain ignored by the Project
Repository (`!! components/`).

## Final state and verification

```text
target protocol      = 2
coordination         = api=2, web=2
api protocol.conf    = 2
web protocol.conf    = 2
make verify          → PASS ("all components conform to workspace protocol 2")
```

Git status at capture: primary clean, api clean, web clean (all changes
committed inside each owning repository).

## Managed Artifact integrity

`documents/artifacts/**` untouched; `managed-artifacts.patch` is empty
(0 bytes). Verification script not modified.

## Evidence

9 primary evidence files + `repositories/INDEX.txt` + 7 files each for
`repositories/api/` and `repositories/web/`. Separation confirmed:
primary patch = `documents/coordination.conf` only; api/web patches =
each component's `protocol.conf` only. Primary `filesystem.txt` contains
no `components/*/.git/**` entries.

## Evidence limitations

- Component diffs are captured against the prepare-time baseline tag, so
  the intermediate commit boundary (one commit per repo) is flattened into
  a single baseline→worktree patch.
- `PROMPT.md` at run root and `RUN_METADATA.txt` are outside the repos and
  therefore not part of per-repo diffs.

## Self-assessment

Resolved participating repositories via the project's stable selector
(`workspace/repositories.conf`), not hardcoded paths; identified Project
vs Component ownership before mutating; placed each change in its owning
repository and committed per-repo to keep component history independent;
updated all three repositories (not just one) and reached `make verify`
PASS as the final coordinated gate.
