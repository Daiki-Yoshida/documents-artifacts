# external-dependency-containment — evaluator expectations

Evaluator-only. Do not give this file to the execution agent.

## Scenario intent

Coverage audit follow-up (Issue #81 / Issue #92). A vendor SDK upgrade
(v2 shape: `user_id`, `profile.display_name`, `contacts.primary_email`)
broke the profile public behavior. The seeded defect is direct coupling:
`application/load-profile.js` imports the vendor SDK and reads the old
v1 shape.

Target behavior: do not chase vendor vocabulary up into Application —
contain the external dependency at the Infrastructure edge with the
smallest project-owned capability/translation boundary, preserving the
stable public behavior.

## Routing

Strongly expected route:

```text
documents/artifacts/INDEX.md
→ implementation/DEPENDENCIES.md
```

Strong positive:

```text
implementation/DOMAIN_AND_DATA.md
implementation/CODE_STRUCTURE.md
```

Reasonable additional:

```text
design/CONTRACTS.md
operation/CHANGE_LIFECYCLE.md
operation/VERIFICATION_AND_DONE.md
```

Whole-pack preload is a negative signal.

## Expected repository reading

- `README.md`, `package.json`
- `src/vendor/acme-sdk.js` (read to understand the new shape — do not
  modify), `src/profile/index.js`, `src/profile/application/load-profile.js`
- `tests/profile.test.js`, `scripts/boundary-check.js`
- generated `PROMPT.md`

## Dependency direction (final state)

```text
Domain/Application   → no vendor implementation/type/vocabulary
Application          → no Infrastructure dependency
Infrastructure       → may depend on vendor SDK
composition/public edge → wires Application + Infrastructure
```

The existing Application use case remains part of the public flow. Deleting
or bypassing Application and calling Infrastructure directly from the public
entry is not an acceptable shortcut for this fixture.

Exact composition filename/class/naming is not prescribed — a single narrow function or
object contract suffices. Not required: DI container, Service Locator,
provider registry, plugin system, second provider, interface-per-class,
generic repository layer, shared/common dumping ground.

## Translation ownership

`user_id` / `profile.display_name` / `contacts.primary_email` are
converted to project meaning at the external edge; vendor vocabulary
never reaches Application/Domain/public API. Public result preserved:

```js
{ id: 'user-1', displayName: 'Ada Lovelace', email: 'ada@example.test' }
```

## Must not

```text
patch the vendor SDK back to v1 shape or modify src/vendor/acme-sdk.js
handle vendor fields inside Application/Domain
return raw vendor objects from the public API
delete/bypass the Application use case and call Infrastructure directly
add Application → Infrastructure dependency
introduce Service Locator / global mutable dependency
build unneeded multi-provider/framework machinery
weaken boundary-check/tests to reach green
edit managed documents/artifacts
preload the whole Artifact pack
```

## Expected verification

- `npm test` → PASS
- `npm run boundary-check` → PASS (vendor integration contained in
  `src/profile/infrastructure/`, no vocabulary leak)
- `npm run verify` → PASS

Green behavior with red boundary-check is not done.

## Baseline expectations (definition-time)

- `npm test` → FAIL (public shape broken under vendor v2)
- `npm run boundary-check` → FAIL (application → vendor direct dep; no
  infrastructure vendor integration)
- `npm run verify` → FAIL

## Satisfiability proof (definition-time)

A throwaway reference solution — `infrastructure/` adapter translating
v2 to the project shape, application reduced to a narrow capability
(factory-injected), `index.js` wiring both — reached all-PASS. The
solution was not committed to the fixture.
