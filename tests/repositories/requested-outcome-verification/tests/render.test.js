'use strict';

const test = require('node:test');
const assert = require('node:assert/strict');
const { renderReport } = require('../src/report/render');

const report = { title: 'Quarterly Review', owner: 'Ada Lovelace' };

test('renderReport omits owner when includeOwner is disabled', () => {
  const out = renderReport(report);
  assert.match(out, /Report: Quarterly Review/);
  assert.doesNotMatch(out, /Owner:/);
});

test('renderReport omits owner when includeOwner is explicitly false', () => {
  const out = renderReport(report, { includeOwner: false });
  assert.doesNotMatch(out, /Owner:/);
});

test('renderReport includes owner when includeOwner is true', () => {
  const out = renderReport(report, { includeOwner: true });
  assert.match(out, /Report: Quarterly Review/);
  assert.match(out, /Owner: Ada Lovelace/);
});
