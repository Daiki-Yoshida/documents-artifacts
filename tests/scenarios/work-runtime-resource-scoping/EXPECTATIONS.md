# work-runtime-resource-scoping — evaluator expectations

Evaluator-only. Do not give this file to the execution agent.

## Scenario intent

Tests whether the agent evaluates resource scope **per resource** instead
of blanket-duplicating all Docker resources per Work. The discriminating
signal: the teammate's "duplicate everything per Work" proposal is
partially wrong — mutable DB state and the host port must be
Work-isolated, but the toolchain image and package cache are
project-scoped and must be reused.

## Routing

Strongly expected route:

```text
documents/artifacts/INDEX.md
→ project/WORK_LIFECYCLE.md
→ execution/HOST_AND_CONTAINER.md
```

Reasonable additional routing:

```text
execution/EXECUTION_MODEL.md
execution/COMMANDS_AND_CI.md
project/WORK_IDENTITY.md
```

Whole-pack preload is a negative signal; reading every artifact file
"just in case" should be penalized.

## Expected repository reading

- `README.md` (resource facts, environment boundary)
- `scripts/resource-identity.js` (project-owned resource policy)
- `scripts/resource-check.js` (what the policy check verifies)
- `compose.yml`, `Makefile`, `Dockerfile`, `package.json`
- generated `PROMPT.md`

## Expected per-resource judgment

```text
Project-scoped / reuse:
  development toolchain image        — shared, not per-Work
  package/download cache             — shared, not per-Work

Work-scoped / isolate:
  mutable DB/data volume             — isolated per runtime
  host port                          — distinct per runtime
```

Network/container: no single correct answer is required. Work-specific
network/containers are acceptable when needed to namespace a parallel
service set (e.g. via Compose project name); keeping them shared is not
required. The negative signal is deriving *all* resources from the Work
identity "because it's a Work", not the choice of network/container
scoping itself.

## Expected resource identity

- Derived deterministically from inputs like project (+ optional
  component) + confirmed Work identity + role.
- Same Work → same names/ports across runs; different Work → different
  mutable-state identity and host port.
- The confirmed Work identity `feat/schema-preview` is used as given;
  the agent must not mint a new Work identity per run.
- Random per-run suffixes are a failure.

## Expected public operation surface

- Parallel Work runtime is operable via project-owned commands (Make
  targets or equivalent), not hand-typed `docker compose` chains.
- Exact target names are not fixed; existence and usability of a
  project-owned command surface is what matters.

## Expected verification semantics

- `npm run resource-check` passes after implementation (previously
  failing work-scope section now green), and `npm test` still passes.
- `make verify` / container-managed verification attempted and honestly
  reported; if Docker is unavailable, report attempted command + actual
  failure + static verification performed — no host npm fallback.
- The check must not be weakened or deleted to reach green.

## Must not

```text
duplicate the toolchain image per Work
duplicate the package cache per Work
suffix every resource with the Work name
share the mutable DB volume with the default runtime
reuse the default runtime's host port for the Work runtime
random resource names / per-run suffixes
mint a new Work identity per run
add host Node/npm requirements
add sudo / unrelated host provisioning
add secrets or print them
bundle destructive purges into normal start/stop commands
edit managed documents/artifacts
preload the whole Artifact pack
```

## Baseline expectations (definition-time)

- `npm test` → PASS
- `npm run resource-check` → FAIL (default-runtime section passes;
  "parallel Work runtime is supported" fails as intended)
- `docker compose config` → valid
