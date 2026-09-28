'use strict';

// Semantic consistency check — dependency-free, no algorithm pinning.
// Asserts coordination shape, not a specific strategy.
const fs = require('node:fs');
const path = require('node:path');

const ROOT = path.resolve(__dirname, '..');
let failed = false;
const pass = (m) => console.log(`consistency-check: PASS — ${m}`);
const fail = (m) => { console.log(`consistency-check: FAIL — ${m}`); failed = true; };

const app = fs.readFileSync(
  path.join(ROOT, 'src/order/application/place-order.js'), 'utf8');
const index = fs.readFileSync(
  path.join(ROOT, 'src/order/index.js'), 'utf8');

// 1. Application coordinates both owners via the injected public surface.
if (/orderStore\./.test(app) && /paymentGateway\./.test(app)) {
  pass('application coordinates both injected owners');
} else {
  fail('application must coordinate orderStore and paymentGateway');
}

// 2. Application does not own mutable state itself.
if (!/new\s+(Map|Set|WeakMap)\s*\(|\.state\s*=/.test(app)) {
  pass('application owns no mutable order/payment state');
} else {
  fail('application declares its own mutable state storage');
}

// 3. Explicit consistency handling on failure: either a compensating
//    write back to the order owner, a gateway reversal, or failure-aware
//    ordering — at least one recovery signal must exist in the flow.
const setStatusCalls = (app.match(/orderStore\.setStatus\(/g) || []).length;
const gatewayReversal = /paymentGateway\.(void|release|cancel)\(/.test(app);
const failureBranch = /if\s*\(!.*\.ok\)/.test(app);
if ((setStatusCalls >= 2 || gatewayReversal) && failureBranch) {
  pass('failure path has explicit consistency handling');
} else {
  fail('failure path lacks consistency handling (compensation/reversal/guarded ordering)');
}

// 4. Public contract surface unchanged: index exposes createPlaceOrder.
if (/module\.exports\s*=\s*\{\s*createPlaceOrder\s*\}/.test(index)
    || /exports\.createPlaceOrder/.test(index)) {
  pass('public entry exposes createPlaceOrder');
} else {
  fail('public entry does not expose createPlaceOrder');
}

if (failed) process.exit(1);
console.log('consistency-check: PASS — coordination shape consistent');
