'use strict';

// Unit-level checks. Node built-ins only; no npm dependencies required.
const assert = require('node:assert');
const { SERVICE_NAME, API_VERSION, describe } = require('../src/app');

assert.strictEqual(SERVICE_NAME, 'docker-ci-app');
assert.strictEqual(API_VERSION, 'v1');
assert.strictEqual(describe(), 'docker-ci-app (v1)');

console.log('test: ok');
