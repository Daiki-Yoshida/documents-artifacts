# External Dependency Containment

Small dependency-free Node project: profile loading backed by the
third-party Acme SDK.

## Layout

- `src/vendor/` — third-party code (e.g. `acme-sdk.js`, currently v2).
  Not project-owned: do not modify.
- `src/profile/application/` — profile use-cases.
- `src/profile/infrastructure/` — external integrations.
- `src/profile/index.js` — stable public entry point.

## Public contract

```js
const { loadProfile } = require('./src/profile');
await loadProfile('user-1')
// → { id: 'user-1', displayName: 'Ada Lovelace', email: 'ada@example.test' }
```

This public behavior is stable and must be preserved.

## Verification

```bash
npm test                  # behavior tests (node:test, no deps)
npm run boundary-check    # dependency-direction policy
npm run verify            # final gate: test + boundary-check
```
