'use strict';

// Existing provider implementation, vendored to represent third-party
// implementers that satisfy the published contract.
function createLegacyProvider() {
  return {
    send(message) {
      return { delivered: true, message };
    },
  };
}

module.exports = { createLegacyProvider };
