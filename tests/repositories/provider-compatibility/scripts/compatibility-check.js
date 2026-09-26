'use strict';

// Compatibility check: every provider registered as satisfying the
// published contract must implement all of its required members.
// Node built-ins only; no npm dependencies required.
const { PROVIDER_CONTRACT, validateProvider } = require('../src/provider-contract');
const { createLegacyProvider } = require('../src/legacy-provider');

const REGISTERED_PROVIDERS = [
  { name: 'legacy-provider', provider: createLegacyProvider() },
];

let failed = false;
for (const { name, provider } of REGISTERED_PROVIDERS) {
  const { valid, missing } = validateProvider(provider);
  if (valid) {
    console.log(`compatibility-check: ${name} satisfies required [${PROVIDER_CONTRACT.required.join(', ')}]`);
  } else {
    console.error(
      `compatibility-check: FAIL — ${name} does not satisfy required member(s): ${missing.join(', ')}`,
    );
    failed = true;
  }
}

process.exit(failed ? 1 : 0);
