'use strict';

// CheckoutMoney — the money-like value used by checkout totals.
// Responsibility: a currency amount, its invariant, arithmetic, and
// rendering. Pricing policy lives in the application layer.
class CheckoutMoney {
  constructor(cents) {
    if (!Number.isInteger(cents)) {
      throw new TypeError('amount must be integer cents');
    }
    if (cents < 0) {
      throw new RangeError('amount cannot be negative');
    }
    this._cents = cents;
  }

  get cents() {
    return this._cents;
  }

  add(other) {
    return new CheckoutMoney(this._cents + other.cents);
  }

  subtract(other) {
    return new CheckoutMoney(this._cents - other.cents);
  }

  toDisplay() {
    return `$${(this._cents / 100).toFixed(2)}`;
  }
}

module.exports = { CheckoutMoney };
