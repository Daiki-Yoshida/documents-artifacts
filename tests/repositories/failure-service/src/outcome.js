'use strict';

// Project-standard outcome representation for caller-visible results.
function ok(value) {
  return { status: 'ok', value };
}

function failed(reason, message) {
  return { status: 'failed', reason, message };
}

module.exports = { ok, failed };
