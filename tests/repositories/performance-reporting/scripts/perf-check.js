'use strict';

// Deterministic structural performance check (not wall-clock timing).
//
// The owners collection is wrapped in a Proxy that counts numeric-index
// reads (element accesses). A correct implementation should need at most a
// few linear passes over `owners`; repeatedly rescanning it once per
// record exceeds the documented access budget and fails here regardless
// of machine speed.
const assert = require('node:assert');
const { buildReport } = require('../src/report');

const OWNER_COUNT = 50;
const RECORD_COUNT = 200;

// Budget: up to ~10 linear passes over owners. Per-record linear scans
// cost on the order of RECORD_COUNT * OWNER_COUNT accesses (~5100 for the
// baseline), far above the budget; one indexed pass costs ~OWNER_COUNT.
const ACCESS_LIMIT = OWNER_COUNT * 10;

const owners = Array.from({ length: OWNER_COUNT }, (_, i) => ({
  id: `o${i}`,
  name: `Owner ${i}`,
}));
const records = Array.from({ length: RECORD_COUNT }, (_, i) => ({
  id: `r${i}`,
  ownerId: `o${i % OWNER_COUNT}`,
  amount: i,
}));

let ownerAccesses = 0;
const instrumentedOwners = new Proxy(owners, {
  get(target, prop, receiver) {
    if (typeof prop === 'string' && /^\d+$/.test(prop)) {
      ownerAccesses += 1;
    }
    return Reflect.get(target, prop, receiver);
  },
});

const report = buildReport(records, instrumentedOwners);

// The performance fix must preserve behavior on the same input.
assert.strictEqual(report.length, RECORD_COUNT);
assert.deepStrictEqual(report.map((r) => r.id), records.map((r) => r.id));
assert.strictEqual(report[0].ownerName, 'Owner 0');
assert.strictEqual(report[RECORD_COUNT - 1].ownerName, `Owner ${OWNER_COUNT - 1}`);
assert.deepStrictEqual(
  buildReport([{ id: 'rX', ownerId: 'missing', amount: 1 }], owners),
  [{ id: 'rX', ownerId: 'missing', ownerName: null, amount: 1 }],
);

if (ownerAccesses > ACCESS_LIMIT) {
  console.error(
    `perf-check: FAIL — owner collection element accesses ${ownerAccesses} ` +
      `exceed budget ${ACCESS_LIMIT} (= ${OWNER_COUNT} owners * 10 passes). ` +
      'Repeated per-record owner scanning is not allowed; use bounded passes.',
  );
  process.exit(1);
}

console.log(`perf-check: ok (owner element accesses ${ownerAccesses} <= ${ACCESS_LIMIT})`);
