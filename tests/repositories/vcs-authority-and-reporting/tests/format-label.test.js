'use strict';

const test = require('node:test');
const assert = require('node:assert/strict');
const { formatLabel } = require('../src/format-label');

test('formatLabel trims and prefixes while preserving case', () => {
  assert.equal(formatLabel('  Release-Candidate  '), '#Release-Candidate');
});

test('formatLabel preserves mixed case and inner spacing', () => {
  assert.equal(formatLabel('beta Build'), '#beta Build');
});
