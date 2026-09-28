'use strict';

// placeOrder coordinates one business outcome across two independent
// state owners. The owners do not share a single atomic transaction.
function createPlaceOrder({ orderStore, paymentGateway }) {
  return async function placeOrder(orderId) {
    const saved = orderStore.setStatus(orderId, 'confirmed');
    if (!saved.ok) {
      return { ok: false, code: 'order_save_failed' };
    }
    const auth = await paymentGateway.authorize(orderId);
    if (!auth.ok) {
      return { ok: false, code: 'payment_declined' };
    }
    return { ok: true };
  };
}

module.exports = { createPlaceOrder };
