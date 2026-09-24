'use strict';

const test = require('node:test');
const assert = require('node:assert/strict');
const { finalPrice, debugLabel } = require('../src/invoice');

test('keeps public helper behavior', () => {
  assert.equal(debugLabel([{ name: 'A', quantity: 2 }]), 'A:2;');
});

test('returns a two-decimal currency amount', () => {
  assert.equal(finalPrice([{ name: 'A', price: 10.01, quantity: 1 }], 0.1, 0), 11.01);
});
