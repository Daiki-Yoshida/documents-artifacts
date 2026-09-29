'use strict';

const { CheckoutMoney } = require('../domain/checkout-money');

// Pricing composition: subtotal - discount + tax.
function quoteCart({ subtotalCents, discountCents, taxCents }) {
  const subtotal = new CheckoutMoney(subtotalCents);
  const discount = new CheckoutMoney(discountCents);
  const tax = new CheckoutMoney(taxCents);

  const total = subtotal.subtract(discount).add(tax);
  return { totalCents: total.cents, display: total.toDisplay() };
}

module.exports = { quoteCart };
