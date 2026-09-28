'use strict';

const test = require('node:test');
const assert = require('node:assert/strict');
const { createPlaceOrder } = require('../src/order');
const { createOrderStore } = require('../src/order/infrastructure/order-store');
const { createPaymentGateway } = require('../src/order/infrastructure/payment-gateway');

function setup() {
  const orderStore = createOrderStore();
  const paymentGateway = createPaymentGateway();
  const placeOrder = createPlaceOrder({ orderStore, paymentGateway });
  return { orderStore, paymentGateway, placeOrder };
}

test('success: order confirmed and payment authorized', async () => {
  const { orderStore, paymentGateway, placeOrder } = setup();
  const result = await placeOrder('order-1');
  assert.equal(result.ok, true);
  assert.equal(orderStore.getStatus('order-1'), 'confirmed');
  assert.equal(paymentGateway.isAuthorized('order-1'), true);
});

test('payment authorization failure leaves no partial outcome', async () => {
  const { orderStore, paymentGateway, placeOrder } = setup();
  paymentGateway.failNextAuthorization();
  const result = await placeOrder('order-1');
  assert.equal(result.ok, false);
  assert.equal(orderStore.getStatus('order-1'), 'draft');
  assert.equal(paymentGateway.isAuthorized('order-1'), false);
});

test('local confirmation failure leaves no partial outcome', async () => {
  const { orderStore, paymentGateway, placeOrder } = setup();
  orderStore.failNextConfirmation();
  const result = await placeOrder('order-1');
  assert.equal(result.ok, false);
  assert.equal(orderStore.getStatus('order-1'), 'draft');
  assert.equal(paymentGateway.isAuthorized('order-1'), false);
});
