'use strict';

const test = require('node:test');
const assert = require('node:assert/strict');
const { listReservations } = require('../src/reservations');

test('listReservations returns the standard ok outcome', async () => {
  const result = await listReservations();
  assert.equal(result.status, 'ok');
  assert.deepEqual(result.value, []);
});
