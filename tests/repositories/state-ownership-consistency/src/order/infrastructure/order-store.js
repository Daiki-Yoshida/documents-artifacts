'use strict';

// OrderStore owns order status. Its internal state is private — callers
// see it only through the public surface.
function createOrderStore() {
  const statusById = new Map();
  let failNextConfirmation = false;

  return {
    getStatus(orderId) {
      return statusById.get(orderId) ?? 'draft';
    },

    setStatus(orderId, status) {
      if (failNextConfirmation && status === 'confirmed') {
        failNextConfirmation = false;
        return { ok: false };
      }
      statusById.set(orderId, status);
      return { ok: true };
    },

    // Test/verification hook: inject a one-shot confirmation write failure.
    failNextConfirmation() {
      failNextConfirmation = true;
    },
  };
}

module.exports = { createOrderStore };
