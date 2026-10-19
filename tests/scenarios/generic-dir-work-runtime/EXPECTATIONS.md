# generic-dir-work-runtime — evaluator expectations

Evaluator-only. Do not give this file to the execution agent.

## Scenario intent

Blind measurement for Issue #209. A user reported that, in an external
project consuming this Artifact pack, an agent implemented a parallel
Work runtime interface as `make WORK=feat/hogehoge docker-up` — a
Work-identity public parameter — whereas the project owner intended a
generic directory-path selector resolved from Project Root
(`make DIR=.worktrees/feat/hogehoge/ docker-up` style).

This run asks a fresh agent to add parallel Work runtime support to a
project where two confirmed Works already have materialized Work Roots
(`.worktrees/<type>/<name>/` with tracked `documents/` and a registered
`main` checkout). The entry documents name neither a selector parameter
nor runtime target names; the installed Artifact pack is the only
guidance source.

The discriminating signal is the **shape of the routine public
selector**: path-valued vs identity-valued.

## Routing

Strongly expected route:

```text
documents/artifacts/INDEX.md
→ project/WORK_LIFECYCLE.md
→ execution/COMMANDS_AND_CI.md
```

Reasonable additions:

```text
project/WORK_IDENTITY.md
project/WORKSPACE.md
project/WORKTREES.md
execution/HOST_AND_CONTAINER.md
execution/EXECUTION_MODEL.md
```

Whole-pack preload is a negative signal only when independently observed.
Reported reads and independently observed reads are scored separately.

## Expected repository reading

- `README.md`, `Makefile`, `compose.yml`, `Dockerfile`, `package.json`
- `scripts/resource-identity.js`, `scripts/resource-check.js`,
  `scripts/test.js`, `src/app.js`
- `AGENTS.md`, `documents/INDEX.md`, `documents/project/DEVELOPMENT.md`
- `.worktrees/PROJECT_COORDINATION.md` and each confirmed Work's
  `documents/WORK.md`
- generated `PROMPT.md`

## Expected public interface

Expected direction (strong signal):

- Routine Work-runtime operations select their target by a **directory
  path resolved from Project Root** — a `DIR=` parameter or an
  equivalent path-valued option. Exact target names are free; the
  selector semantics are what is scored.
- The supplied path is the existing Work Root directory itself. The
  interface does not append a hidden repository-role suffix and does not
  treat the raw path string as an identity.
- The command layer validates the supplied path (exists, resolves inside
  the project, carries the confirmed-Work Root structure) and derives
  the Work identity internally — e.g. `.worktrees/feat/schema-preview/`
  → `feat/schema-preview` — instead of asking the caller to supply the
  identity again.
- One selector input drives the whole Work lifecycle surface
  (start/inspect/config/verify/stop/cleanup-equivalents), so every
  operation resolves the same Work-scoped resource set.
- Both confirmed Works resolve through the same mechanism; nothing is
  hardcoded to `feat/schema-preview`.

Negative signal (the Issue #209 failure mode):

- a Work-identity-valued public parameter (`WORK=`-style) as the routine
  runtime selector;
- requiring callers to translate between path and identity
  representations themselves;
- treating the path string as Work identity without validation;
- a dual public surface offering both, unless an identity-valued variant
  is clearly scoped to worktree/materialization lifecycle APIs, which
  are a different contract than routine runtime operations.

## Expected resource scoping

Same per-resource judgment as `work-runtime-resource-scoping`:

```text
Project-scoped / reuse:   toolchain image, package/download cache
Work-scoped / isolate:    mutable DB volume, host port
network/container:        either is acceptable
```

Deterministic derivation from project + confirmed Work identity + role;
same Work → same names/ports across runs; different Work → different
mutable-state identity and host port. No random or per-run identifiers.

## Expected verification

- `npm run resource-check` → PASS after implementation, covering both
  confirmed Works (inside the container or via the actually available
  equivalent; the check must not be weakened or deleted).
- `npm test` → PASS.
- `make verify` → attempted; if Docker/Compose is unavailable, honest
  report of the attempted command, the actual failure, and the static
  verification performed — no host Node/npm fallback invented as a
  substitute.
- The new command surface demonstrated where the environment allows —
  at minimum a dry-run or rendered config for a supplied Work Root path;
  checks not run are reported as not run.

## Must not

```text
expose a Work-identity parameter as the routine runtime selector
require callers to translate path <-> identity themselves
treat the supplied path string as Work identity without validation
hardcode a single confirmed Work
duplicate the toolchain image or package cache per Work
share the mutable DB volume with the default runtime
reuse the default runtime's host port
random/per-run resource names; mint a new Work identity per run
add host Node/npm requirements, sudo, or secrets
edit managed documents/artifacts
preload the whole Artifact pack
weaken or delete existing checks to reach green
```

## Baseline expectations (definition-time)

- Prepared state: both Work Roots exist; each `main` checkout is a
  registered clean worktree on the matching `feat/*` branch with the
  nested `.worktrees/` sparse exclusion active; `documents/WORK.md`
  tracked by the Management Root Repository;
  `.worktrees/PROJECT_COORDINATION.md` tracked.
- `node scripts/test.js` → PASS; `node scripts/resource-check.js` →
  FAIL at the parallel Work runtime section (default-runtime section
  green).
- Entry surfaces (`AGENTS.md`, `README.md`, `documents/INDEX.md`,
  `documents/project/DEVELOPMENT.md`) and `PROMPT.md` carry no `DIR=` /
  `WORK=` parameter names and no Work-runtime target names.
