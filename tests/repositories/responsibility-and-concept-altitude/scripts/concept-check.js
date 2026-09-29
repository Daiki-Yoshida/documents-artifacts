'use strict';

// Concept-altitude check — semantic, dependency-free.
// Asserts concept identity/placement/responsibility, not names or syntax.
const fs = require('node:fs');
const path = require('node:path');

const ROOT = path.resolve(__dirname, '..');
const SRC = path.join(ROOT, 'src');

let failed = false;
const pass = (m) => console.log(`concept-check: PASS — ${m}`);
const fail = (m) => { console.log(`concept-check: FAIL — ${m}`); failed = true; };

function walk(dir) {
  const out = [];
  if (!fs.existsSync(dir)) return out;
  for (const e of fs.readdirSync(dir, { withFileTypes: true })) {
    const p = path.join(dir, e.name);
    if (e.isDirectory()) out.push(...walk(p));
    else if (e.isFile() && e.name.endsWith('.js')) out.push(p);
  }
  return out;
}

const files = walk(SRC).map((p) => ({
  rel: path.relative(SRC, p).split(path.sep).join('/'),
  content: fs.readFileSync(p, 'utf8'),
}));
const checkoutFiles = files.filter((f) => f.rel.startsWith('checkout/'));

// 1. The monetary concept must no longer carry first-consumer semantics.
const featureScopedMoney = /\b(?:Checkout|Cart|Order)(?:Money|Amount|MonetaryAmount)\b|(?:checkout|cart|order)[-_](?:money|amount|monetary[-_]?amount)/i;
const polluted = files.filter(
  (f) => featureScopedMoney.test(f.content)
      || featureScopedMoney.test(path.basename(f.rel)));
if (polluted.length === 0) {
  pass('money concept uses consumer-neutral semantics');
} else {
  fail(`consumer-scoped monetary identifier still present: ${polluted.map((f) => f.rel).join(', ')}`);
}

// Monetary concept signals: cents amount + arithmetic + rendering +
// invariant enforcement. Neutral names are not pinned.
const MONEY = [
  /\bcents\b/,
  /\b(add|plus)\b/,
  /\b(subtract|minus)\b/,
  /(\$|display|format|render)/i,
  /\b(throw|Error|assert)\b/,
];
const POLICY = /subtotal|discount|tax|quote/i;
const isMoney = (f) => MONEY.every((re) => re.test(f.content));
const moneyFiles = checkoutFiles.filter(isMoney);
const cleanMoney = moneyFiles.filter((f) => !POLICY.test(f.content));

// 2. The monetary concept still lives inside checkout.
if (cleanMoney.length >= 1) {
  pass(`monetary concept remains inside src/checkout (${cleanMoney.map((f) => f.rel).join(', ')})`);
} else {
  fail('no monetary concept file under src/checkout/');
}

// 3. The monetary concept did not absorb pricing policy.
if (moneyFiles.some((f) => POLICY.test(f.content))) {
  fail('money concept absorbs checkout pricing policy (subtotal/discount/tax/quote)');
} else {
  pass('money concept has no pricing-policy responsibility');
}

// 4. No project-wide shared extraction was created.
const shared = ['shared', 'common', 'core', 'global']
  .filter((d) => fs.existsSync(path.join(SRC, d)));
if (shared.length === 0) {
  pass('no shared/common/core/global extraction');
} else {
  fail(`speculative shared extraction created: ${shared.join(', ')}`);
}

// 5. Public surface: quoteCart exposed; internal money concept not.
let index;
try {
  index = require(path.join(SRC, 'checkout'));
} catch {
  index = null;
}
const keys = index ? Object.keys(index) : [];
if (index && typeof index.quoteCart === 'function' && !keys.some((k) => /money|amount/i.test(k))) {
  pass('checkout public surface exposes quoteCart only');
} else {
  fail('checkout public surface broken or exports the money concept');
}

// 5b. Public behavior contract is intact.
try {
  const q = index.quoteCart({ subtotalCents: 1000, discountCents: 150, taxCents: 85 });
  if (q.totalCents === 935 && q.display === '$9.35') {
    pass('quoteCart public behavior preserved');
  } else {
    fail(`quoteCart returned unexpected result: ${JSON.stringify(q)}`);
  }
} catch {
  fail('quoteCart could not be invoked');
}

// 6. Pricing composition ownership stays outside the money concept.
const moneySet = new Set(moneyFiles.map((f) => f.rel));
const composed = checkoutFiles.filter(
  (f) => !moneySet.has(f.rel)
      && /subtotal/i.test(f.content)
      && /discount/i.test(f.content)
      && /tax/i.test(f.content));
if (composed.length >= 1) {
  pass(`pricing composition owned outside the money concept (${composed.map((f) => f.rel).join(', ')})`);
} else {
  fail('pricing composition (subtotal/discount/tax) not owned by a non-money file');
}

// 7. No speculative machinery.
const machinery = files.filter(
  (f) => /\b(factory|registry|plugin|interface)\b/i.test(f.content)
      || /\b(factory|registry|plugin|interface)\b/i.test(f.rel));
if (machinery.length === 0) {
  pass('no speculative factory/registry/plugin/interface machinery');
} else {
  fail(`speculative machinery added: ${machinery.map((f) => f.rel).join(', ')}`);
}

if (failed) {
  console.log('concept-check: FAILED');
  process.exit(1);
}
console.log('concept-check: all checks passed');
