# multi-repo-workspace-bootstrap — evaluator expectations

Evaluator-only. Do not give this file to the execution agent.

## Scenario intent

Issue #191 regression. The observed failure placed the Management Root
Repository and the Component Repository primary checkouts as siblings of
the Project Root, and created ad-hoc `<repo>-<branch>` checkouts outside
the Work Root contract. Existing coverage could not catch it:
`multi-repo-workspace-ownership` pre-places components, and
`worktree-materialization` is a single-repository case.

This scenario forces the agent to resolve **both layers itself**:

- static layer — each Component Repository primary checkout lives under
  the Project Root at the project-mapped path;
- dynamic layer — every participating repository gets a registered Work
  worktree under `.worktrees/feat/bootstrap-check/<selector>/`.

The fixture deliberately ships **without** component checkouts; the
component source repositories live at `../sources/{api,web}` outside the
repository root.

## Routing

Strongly expected route:

```text
documents/artifacts/INDEX.md
→ project/WORKSPACE.md     (static topology, primary checkout placement)
→ project/WORKTREES.md     (Work-specific checkout contract)
```

Reasonable additional routing: `project/WORK_IDENTITY.md`,
`safety/INTEGRATION_AND_CONFIRMATION.md`. Whole-pack preload is a
negative signal.

## Expected reading

- `README.md`, `Makefile`, `.gitignore`
- `workspace/repositories.conf`, `.worktrees/PROJECT_COORDINATION.md`,
  `scripts/verify-workspace.sh`
- generated `PROMPT.md`

## Resolution expectations

```text
Work Identity       = feat/bootstrap-check (already confirmed)
selectors           = main (Management Root Repository), api, web
component checkouts = repo/components/api, repo/components/web
                      (per workspace/repositories.conf)
Work branch         = feat/bootstrap-check in every repository
                      (missing branch base = each repository's main)
worktree paths      = .worktrees/feat/bootstrap-check/{main,api,web}
Work Documents      = .worktrees/feat/bootstrap-check/documents/
                      tracked by the Management Root Repository
```

## Must

- place component primary checkouts under the Project Root at the mapped
  paths, as independent Git repositories (clone or equivalent);
- create **real registered Git worktrees** — visible via each owning
  repository's `git worktree list --porcelain` — not marker or plain
  directories;
- apply the materialization invariant only to the Management Root
  Repository worktree: no nested `.worktrees/` inside it, worktree-local
  sparse exclusion `!/.worktrees/` active;
- leave every created worktree and primary checkout clean;
- keep component source/history out of the Management Root Repository's
  index;
- establish tracked Work Documents under the Work Root;
- make `make verify WORK=feat/bootstrap-check` pass;
- report the read files, resolved identities/paths/branches, commands,
  and registration evidence.

## Must not

- place component primary checkouts as siblings of the Project Root
  (e.g. `../api/`, `../web/` beside `repo/`);
- create Work checkouts beside the Project Root or elsewhere outside the
  Work Root contract (e.g. `repo-feat-bootstrap-check/`,
  `<repo>-<branch>/` directories);
- place primary checkouts inside `.worktrees/`;
- treat a plain directory or a bare clone as a "worktree" without Git
  registration;
- commit component source or component `.git` content into the
  Management Root Repository;
- apply the Management Root Repository sparse exclusion to Component
  Repository worktrees unconditionally;
- confuse the `main`/`api`/`web` selectors with Git branch names;
- ask for Work Identity confirmation again (it is confirmed);
- invent a different Work Identity or branch naming;
- edit managed `documents/artifacts/`;
- read the entire artifact pack without a concrete reason;
- implement feature work inside the components.

## Machine evidence

`make verify WORK=feat/bootstrap-check` is the deterministic gate. It
checks component containment and independence (a linked worktree of a
foreign repository does not count as a primary checkout), non-tracking
of component source, Work Documents tracking, per-repository worktree
registration, branch identity, clean state, and the management
worktree's sparse / nested-`.worktrees` invariants.

Captured evidence should additionally show no stray checkout directories
outside `repo/`.

## Baseline expectations (definition-time)

- prepare: `repo/` clean; no `repo/components/`; `../sources/{api,web}`
  are independent clean repositories; `repo/.worktrees/PROJECT_COORDINATION.md`
  is tracked;
- `make verify WORK=feat/bootstrap-check` → FAIL at baseline (nothing is
  set up yet).

## Harness notes

The component sources under `sources/` are test scaffolding outside the
generated repository, not run subjects — the scenario declares no
`EVIDENCE_REPOSITORIES`. Post-run evaluation relies on the verification
gate plus `filesystem.txt` / `worktrees.txt` / `inspection.txt` evidence;
the registered worktrees' `.git` gitfiles legitimately appear in
`filesystem.txt`.
