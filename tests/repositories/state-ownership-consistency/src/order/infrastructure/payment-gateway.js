'use strict';

// PaymentGateway owns authorization state. Its internal state is
// private — callers see it only through the public surface.
function createPaymentGateway() {
  const authorizedOrders = new Set();
  let failNextAuthorization = false;

  return {
    async authorize(orderId) {
      if (failNextAuthorization) {
        failNextAuthorization = false;
        return { ok: false };
      }
      authorizedOrders.add(orderId);
      return { ok: true };
    },

    async void(orderId) {
      authorizedOrders.delete(orderId);
      return { ok: true };
    },

    isAuthorized(orderId) {
      return authorizedOrders.has(orderId);
    },

    // Test/verification hook: inject a one-shot authorization failure.
    failNextAuthorization() {
      failNextAuthorization = true;
    },
  };
}

module.exports = { createPaymentGateway };
