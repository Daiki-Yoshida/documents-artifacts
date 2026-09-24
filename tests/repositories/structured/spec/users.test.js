'use strict';

const test = require('node:test');
const assert = require('node:assert/strict');
const { findUserById } = require('../src/modules/users');

test('preserves leading zero in public ID', () => {
  assert.equal(findUserById('001').name, 'Ada');
});
