'use strict';

const test = require('node:test');
const assert = require('node:assert/strict');
const { SERVICE_NAME, API_VERSION, describe } = require('../src/check');

test('service exposes stable identity', () => {
  assert.equal(SERVICE_NAME, 'brownfield-adoption-app');
  assert.equal(API_VERSION, 'v1');
  assert.equal(describe(), 'brownfield-adoption-app (v1)');
});
