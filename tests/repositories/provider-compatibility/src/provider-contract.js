'use strict';

// The published Provider contract. External/third-party implementers
// build providers against this surface; do not evolve it casually.
const PROVIDER_CONTRACT = Object.freeze({
  name: 'Provider',
  required: Object.freeze(['send']),
  optional: Object.freeze([]),
});

function validateProvider(provider) {
  const missing = PROVIDER_CONTRACT.required.filter(
    (member) => typeof provider[member] !== 'function',
  );
  return { valid: missing.length === 0, missing };
}

module.exports = { PROVIDER_CONTRACT, validateProvider };
