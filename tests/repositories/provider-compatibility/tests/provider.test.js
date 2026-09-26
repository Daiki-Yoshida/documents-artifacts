'use strict';

// Behavior checks for provider/gateway interaction.
// Node built-ins only; no npm dependencies required.
const assert = require('node:assert');
const { PROVIDER_CONTRACT } = require('../src/provider-contract');
const { createLegacyProvider } = require('../src/legacy-provider');
const { createGateway } = require('../src/gateway');

// consumer path uses send()
const provider = createLegacyProvider();
const gateway = createGateway(provider);
assert.deepStrictEqual(gateway.notify('hello'), {
  delivered: true,
  message: 'hello',
});

// published contract surface
assert.deepStrictEqual([...PROVIDER_CONTRACT.required], ['send']);
assert.strictEqual(typeof provider.send, 'function');

console.log('test: ok');
