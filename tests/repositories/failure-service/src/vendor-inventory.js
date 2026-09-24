'use strict';

// Simulated vendor SDK client. Vendor-specific error types are owned here.

class VendorTimeoutError extends Error {
  constructor(message) {
    super(message);
    this.name = 'VendorTimeoutError';
    this.code = 'VENDOR_TIMEOUT';
  }
}

const inventory = new Map([
  ['SKU-100', { available: true, stock: 5 }],
  ['SKU-000', { available: false, stock: 0 }],
]);

function delay() {
  return new Promise((resolve) => setTimeout(resolve, 1));
}

// Resolves to { sku, available, stock }.
// Rejects with VendorTimeoutError when the vendor service does not answer
// (fixture behavior: sku 'SKU-TIMEOUT' always times out).
async function getStockLevel(sku) {
  await delay();
  if (sku === 'SKU-TIMEOUT') {
    throw new VendorTimeoutError('vendor inventory request timed out');
  }
  const row = inventory.get(sku);
  if (!row) {
    return { sku, available: false, stock: 0 };
  }
  return { sku, available: row.available, stock: row.stock };
}

module.exports = { getStockLevel, VendorTimeoutError };
