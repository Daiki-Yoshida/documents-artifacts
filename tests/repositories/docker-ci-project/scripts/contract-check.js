'use strict';

// Public contract check: the module surface must stay stable for consumers.
// Node built-ins only; no npm dependencies required.
const assert = require('node:assert');
const app = require('../src/app');

const exported = Object.keys(app).sort();
assert.deepStrictEqual(exported, ['API_VERSION', 'SERVICE_NAME', 'describe']);
assert.strictEqual(typeof app.describe, 'function');
assert.match(app.API_VERSION, /^v\d+$/);

console.log('contract-check: ok');
