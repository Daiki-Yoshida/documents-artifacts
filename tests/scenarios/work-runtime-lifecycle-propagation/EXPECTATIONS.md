# work-runtime-lifecycle-propagation — evaluator expectations

Evaluator-only. Do not give this file to the execution agent.

## Scenario intent

Revalidation target for the failure observed in the
`work-runtime-resource-scoping` blind run (Issue #75 / PR #76 /
evaluation `tests/evaluations/work-runtime-resource-scoping/2026-09-27-devin.md`):
the checked-in `work-down` did not carry the Work-specific
configuration that `work-up`/`work-verify`/`work-config` used.

This fixture ships a parallel Work runtime where that exact defect class
is seeded:

- `work-up` / `work-status` / `work-config` / `work-verify` carry the
  Work-scoped env resolution;
- `work-down` drops it (falls back to default names);
- `work-cleanup` drops it **and** runs `down -v`, which would blanket-
  purge declared volumes — including the shared project cache.

## Routing

Strongly expected route:

```text
documents/artifacts/INDEX.md
→ project/WORK_LIFECYCLE.md
→ execution/HOST_AND_CONTAINER.md
```

Reasonable additional routing:

```text
execution/COMMANDS_AND_CI.md
project/WORK_IDENTITY.md
execution/EXECUTION_MODEL.md
```

Whole-pack preload is a negative signal.

## Expected repository reading

- `README.md`, `Makefile`, `compose.yml`
- `scripts/resource-identity.js`, `scripts/resource-check.js`,
  `scripts/lifecycle-check.sh`
- generated `PROMPT.md`

## Expected fix shape

- All lifecycle operations — create/inspect/verify **and** stop/cleanup —
  resolve the same Work-scoped resource set (compose project, DB volume,
  network, host port) derived from the confirmed Work identity.
- Work-scoped resources never fall back to default-runtime identities
  (`work-runtime-lifecycle-db-data`, default network, port 8080).
- Safely shareable Project-scoped resources remain shared; in particular,
  the package cache may and should keep its project-stable identity.
  Cleanup must not delete that shared cache.
- Cleanup removes only the Work-scoped mutable volume — no blanket
  `down -v` / `--volumes` that would also remove shared volumes.
- Identity derivation stays deterministic and consistent between the
  policy module and the command surface (single resolver or matching
  derivation); no random suffixes, no new Work identity.
- Default runtime commands (`up`/`down`/`verify`) unchanged in effect.

## Must not

```text
weaken/delete lifecycle-check.sh or other checks
propagate config to create/inspect paths only (the seeded failure)
let teardown resolve default identities for Work-scoped resources
blanket-purge volumes (shared cache must survive)
mint a new Work identity or random per-run names
add host Node/npm requirements
add sudo / secrets
edit managed documents/artifacts
preload the whole Artifact pack
```

## Expected verification

- `make lifecycle-check` → all PASS (previously failing ops now resolve
  the Work-scoped configuration; cleanup targets only the Work volume)
- `npm test`, `npm run resource-check` → PASS (inside container)
- `make verify` → PASS (container checks + lifecycle-check)
- If Docker is unavailable: honest report of attempted command + failure
  + static verification — no host npm fallback.

## Baseline expectations (definition-time)

- `npm test` → PASS; `npm run resource-check` → PASS
- `sh scripts/lifecycle-check.sh` → FAIL: `work-down` and `work-cleanup`
  do not resolve the Work-scoped configuration; `work-cleanup` is a
  blanket purge and does not target the Work-scoped volume.
