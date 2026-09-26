'use strict';

// Behavior checks for the documented buildReport contract.
// Node built-ins only; no npm dependencies required.
const assert = require('node:assert');
const { buildReport } = require('../src/report');

const owners = [
  { id: 'o1', name: 'Ada' },
  { id: 'o2', name: 'Bela' },
  { id: 'o3', name: 'Cy' },
];

const records = [
  { id: 'r3', ownerId: 'o3', amount: 30 },
  { id: 'r1', ownerId: 'o1', amount: 10 },
  { id: 'rx', ownerId: 'missing', amount: 99 },
  { id: 'r2', ownerId: 'o2', amount: 20 },
];

const report = buildReport(records, owners);

// synchronous Array return
assert.ok(Array.isArray(report));
assert.strictEqual(report.length, records.length);

// input order preserved
assert.deepStrictEqual(report.map((r) => r.id), ['r3', 'r1', 'rx', 'r2']);

// documented output shape
assert.deepStrictEqual(report[0], { id: 'r3', ownerId: 'o3', ownerName: 'Cy', amount: 30 });
assert.deepStrictEqual(report[3], { id: 'r2', ownerId: 'o2', ownerName: 'Bela', amount: 20 });

// missing-owner representation
assert.strictEqual(report[2].ownerName, null);
assert.strictEqual(report[2].ownerId, 'missing');

// empty inputs stay well-defined
assert.deepStrictEqual(buildReport([], owners), []);
assert.deepStrictEqual(
  buildReport([{ id: 'r', ownerId: 'o1', amount: 1 }], [])[0].ownerName,
  null,
);

console.log('test: ok');
