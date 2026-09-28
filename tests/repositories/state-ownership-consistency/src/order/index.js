'use strict';

// Public entry for the order slice. Composition injects the owners.
const { createPlaceOrder } = require('./application/place-order');

module.exports = { createPlaceOrder };
