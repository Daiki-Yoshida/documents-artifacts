'use strict';

function finalPrice(items, taxRate, couponPercent) {
  var subtotal = 0;
  for (var i = 0; i < items.length; i++) {
    subtotal = subtotal + items[i].price * items[i].quantity;
  }

  // Existing unrelated style/structure is intentionally imperfect.
  var discounted = subtotal - subtotal * (couponPercent / 100);
  var taxed = discounted + discounted * taxRate;

  // BUG: floating point result leaks fractions of a cent.
  return taxed;
}

function debugLabel(items) {
  var s = '';
  for (var i = 0; i < items.length; i++) {
    s += items[i].name + ':' + items[i].quantity + ';';
  }
  return s;
}

module.exports = { finalPrice, debugLabel };
