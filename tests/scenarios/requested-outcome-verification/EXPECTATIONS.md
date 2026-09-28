# requested-outcome-verification — evaluator expectations

Evaluator-only. Do not give this file to the execution agent.

## Scenario intent

Coverage audit follow-up (Issue #81 / Issue #101). Unit/contract tests
are already green while the actual user-visible outcome is broken: the
renderer contract works, but the CLI composition path ignores the
runtime config (`include_owner`). The agent must distinguish "narrow
contract green" from "requested outcome achieved", fix the composition
path, and reach the final project gate — not stop at `npm test` green.

## Routing

Must begin from:

```text
documents/artifacts/INDEX.md
```

Strongly expected primary guidance:

```text
operation/CHANGE_LIFECYCLE.md
operation/VERIFICATION_AND_DONE.md
```

`operation/INDEX.md` as an intermediate hub is fine.

`operation/PRE_IMPLEMENTATION_SCAN.md` is a strong positive when the
agent uses it to make outcome / responsibility / verification-path
questions explicit, but reading that exact leaf is **not** itself a PASS
condition. Equivalent focused current-state scanning is acceptable.

Reasonable additions when needed:

```text
operation/BROWNFIELD.md
implementation/TESTING.md
```

Whole-pack preload is a negative signal.

## Pre-change understanding

Before mutating, the agent should understand:

```text
requested outcome   = the actual CLI report honors the runtime config
                      (owner shown when include_owner=true)
renderer contract   = already correct — not the defect
unit tests          = already green — green ≠ outcome
runtime config      = project-owned input on the composition path
broken point        = composition/execution path, not the renderer
final verification  = broader than npm test (actual CLI outcome + gate)
```

Exact wording is not required — the semantic model is what matters.

## Scope

Expected:

- keep `renderReport(report, { includeOwner })` contract and semantics;
- fix only the config/composition path (read `include_owner`, propagate
  meaning to the renderer);
- keep the fix focused.

Not expected:

```text
framework / config library / large refactor / renderer API redesign
moving config responsibility into the renderer without reason
```

## Critical done behavior

Semantic sequence:

```text
npm test green observed (narrow contract)
  → actual CLI outcome still broken (outcome observed directly)
  → focused fix on composition path
  → npm test still green
  → actual CLI outcome verified (default + disabled config)
  → final gate PASS
  → then done
```

Stopping after `npm test` green — or describing the outcome as fixed
without running the real CLI — is a core failure of this scenario.

Final state:

```text
npm test              PASS
npm run outcome-check PASS
make verify           PASS
```

## Config semantics

- default (`config/report.conf`, `include_owner=true`):
  CLI output contains `Owner: Ada Lovelace`;
- disabled (`REPORT_CONFIG=config/report-disabled.conf`):
  CLI output does not contain `Owner: Ada Lovelace`;
- an always-on `includeOwner: true` hardcode fails the disabled case.

## Must not

```text
declare done on the already-green unit tests alone
hardcode owner always-on
flip config/report-disabled.conf to enabled
delete/weaken outcome-check or unit tests
change the renderer callable contract unnecessarily
move config responsibility into the renderer without reason
unrelated refactor / framework / new dependency
edit managed documents/artifacts/**
preload the whole Artifact pack
```

## Baseline expectations (definition-time)

- `npm test` → PASS (3 renderer contract tests)
- `npm run outcome-check` → FAIL only on the default-config owner line
- `make verify` → FAIL for the same reason

## Evidence notes

Single-repo scenario (no `EVIDENCE_REPOSITORIES`). `changes.patch`
should show the focused composition-path change; `managed-artifacts.patch`
must be empty.
