# Raw execution report — external-dependency-containment

- scenario: `external-dependency-containment`
- run-id: `2026-09-28-devin`
- agent/model: Devin CLI / SWE-2 Max
- source main baseline: `909af0e` (merge of PR #93 — scenario definition,
  incl. composition-wiring checker refinement)
- generated baseline: `artifact-test-baseline` → `1f56790`

## Project-local files read

- `PROMPT.md`, `RUN_METADATA.txt` (run root)
- `README.md`, `package.json`
- `src/vendor/acme-sdk.js`, `src/profile/index.js`,
  `src/profile/application/load-profile.js`
- `tests/profile.test.js`, `scripts/boundary-check.js`
- `src/` file inventory

## Artifact files read

Routed from `documents/artifacts/INDEX.md` (task = dependency/boundary
repair):

- `documents/artifacts/INDEX.md` — route: `Dependency / DI →
  implementation/DEPENDENCIES.md`; `Domain model / DTO / mapping →
  implementation/DOMAIN_AND_DATA.md`
- `documents/artifacts/implementation/INDEX.md`
- `documents/artifacts/implementation/DEPENDENCIES.md`
- `documents/artifacts/implementation/DOMAIN_AND_DATA.md`

## Baseline failures actually observed

- `npm test` → FAIL (1/1): `displayName: undefined` —
  `loadProfile('user-1')` no longer returns the documented public shape
- `npm run boundary-check` → FAIL ×4: application depends directly on
  vendor SDK; vendor referenced outside vendor/infrastructure; no
  infrastructure implementation; no composition source wiring
  Application to Infrastructure

## Why the SDK upgrade reached the inner layer

`application/load-profile.js` imported `../../vendor/acme-sdk` and read
the vendor's representation inline (`raw.userId` / `raw.name` /
`raw.email`). When the vendor moved to the v2 shape
(`user_id` / `profile.display_name` / `contacts.primary_email`), the
use-case broke because vendor vocabulary was embedded in Application —
there was no translation boundary at the edge.

## Files changed

- `src/profile/infrastructure/acme-profile-source.js` (new): the only
  project module that touches the SDK. `fetchProfile(userId)` calls
  `acme.fetchUser` and translates the v2 representation into the
  project shape `{ id, displayName, email }`.
- `src/profile/application/load-profile.js`: reduced to a narrow
  project-owned capability — `createLoadProfile(fetchProfile)` returns
  `loadProfile(userId)`; no vendor or infrastructure imports.
- `src/profile/index.js`: composition root — wires
  `createLoadProfile` to the concrete `fetchProfile`; public export
  `loadProfile` unchanged.
- `src/profile/infrastructure/.gitkeep` removed (real file present).
- `src/vendor/acme-sdk.js`, `tests/`, `scripts/` — untouched.

## Final dependency direction

```text
index.js (composition edge)
  ├─ requires application/createLoadProfile
  └─ requires infrastructure/fetchProfile
application/        → project-owned capability only (fetchProfile fn)
infrastructure/     → vendor SDK + v2→project translation
vendor/             → third-party, unchanged
```

- Vendor access location: `src/profile/infrastructure/` only
- Translation ownership: `acme-profile-source.js` (edge) — v2 terms
  never reach application/public API
- Project-owned capability: `fetchProfile(userId)` function contract
- Composition point: `src/profile/index.js` wires app + infra
- Application use case remains in the public flow (loadProfile runs
  through it)

## Abstractions intentionally not introduced

No DI container, Service Locator, provider registry, plugin system,
second provider, interface-per-class, or generic repository layer —
the task is a single volatile external dependency; per DEPENDENCIES.md
a real boundary warrants a contract mechanism, and a one-function
capability + composition-root wiring is the smallest honest seam. No
Domain layer added — the profile is a lightweight data holder, no
domain invariants to model (per DOMAIN_AND_DATA.md richness guidance).

## Verification commands / actual results

- `npm test` → PASS (1/1, stable public shape preserved)
- `npm run boundary-check` → PASS (4 checks: vendor contained in infra,
  composition wiring present, no vocab leak, direction conforms)
- `npm run verify` → PASS (final gate, both suites)

## Final Git status

Working tree dirty with exactly the intended changes (4 files:
2 modified, 1 added, `.gitkeep` removed); uncommitted — the run's job
was repair, not commit.

## Managed Artifact integrity

`documents/artifacts/` untouched — `managed-artifacts.patch` empty.

## Evidence capture result

`evidence/` contains all nine files; `changed-files.txt`/`diff-stat.txt`/
`changes.patch` record the four-file diff; `managed-artifacts.patch`
empty; `filesystem.txt`/`inspection.txt`/`worktrees.txt` captured.

## Evidence limitations

Machine evidence = repo file diff/status only; `npm`/`make` output is
terminal testimony in this REPORT, not archived machine evidence.

## Self-assessment

Followed INDEX routing to the two directly relevant leaves; diagnosed
the v2-shape break as vendor-coupled application code rather than
patching the vendor (left intact) or spreading v2 terms inward;
contained the SDK behind a minimal infrastructure adapter + narrow
application capability; preserved the documented public contract;
verified via the project's own gate — both behavior and boundary
checks green. No speculative framework machinery added.
