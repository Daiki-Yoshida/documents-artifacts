'use strict';

const test = require('node:test');
const assert = require('node:assert/strict');
const { loadProfile } = require('../src/profile');

test('loadProfile returns the stable public profile shape', async () => {
  const profile = await loadProfile('user-1');
  assert.deepEqual(profile, {
    id: 'user-1',
    displayName: 'Ada Lovelace',
    email: 'ada@example.test',
  });
});
