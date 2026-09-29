'use strict';

const test = require('node:test');
const assert = require('node:assert/strict');
const { quoteCart } = require('../src/checkout');

test('quoteCart composes subtotal - discount + tax', () => {
  const q = quoteCart({ subtotalCents: 1000, discountCents: 150, taxCents: 85 });
  assert.equal(q.totalCents, 935);
  assert.equal(q.display, '$9.35');
});

test('quoteCart handles zero-valued parts', () => {
  const q = quoteCart({ subtotalCents: 500, discountCents: 0, taxCents: 0 });
  assert.equal(q.totalCents, 500);
  assert.equal(q.display, '$5.00');
});
