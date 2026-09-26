# Performance Reporting Sample

Small dependency-free Node module for owner report generation.

## Public API

`src/report.js` exports the already-published synchronous function:

```js
buildReport(records, owners) -> Array
```

Contract relied upon by existing callers:

- synchronous: returns an `Array` immediately (no Promise/iterator/stream);
- preserves input `records` order in the output;
- each output entry has shape `{ id, ownerId, ownerName, amount }`;
- when no owner matches a record's `ownerId`, `ownerName` is `null`;
- input invariants: `ownerId` values in `owners` are unique.

## Verification

- `npm test` — behavior checks for the contract above.
- `npm run perf-check` — deterministic structural performance check on the
  owner lookup work; it instruments the owners collection to count element
  reads and enforces a documented access budget. It is not a wall-clock
  timing test and does not depend on machine speed.
- `npm run verify` — final verification gate: behavior tests + perf-check.
