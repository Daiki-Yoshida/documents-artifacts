'use strict';

// Stable public entry point for profile access.
// Public behavior contract:
//   await loadProfile('user-1')
//   → { id, displayName, email }

const { loadProfile } = require('./application/load-profile');

module.exports = { loadProfile };
