'use strict';

// Boundary check: semantic dependency-direction and vocabulary-leak
// inspection for the profile module. Deterministic static analysis over
// project source — no execution, no timestamps.
//
// Contract:
//   - application/ and domain/ must not depend on the vendor SDK or on
//     infrastructure;
//   - vendor SDK may only be referenced inside vendor/ or
//     profile/infrastructure/;
//   - vendor v2 vocabulary (user_id / display_name / primary_email)
//     must not leak into application/ or domain/;
//   - infrastructure/ must actually contain the vendor integration;
//   - the Application use case must remain in the public flow, with a
//     composition-side source wiring Application to Infrastructure rather
//     than bypassing/deleting Application as a shortcut.

const fs = require('node:fs');
const path = require('node:path');

const SRC = path.join(__dirname, '..', 'src');
const INFRA_DIR = path.join(SRC, 'profile', 'infrastructure');
const VENDOR_TERMS = ['user_id', 'display_name', 'primary_email'];

function* walk(dir) {
  for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
    const p = path.join(dir, entry.name);
    if (entry.isDirectory()) yield* walk(p);
    else if (entry.isFile() && p.endsWith('.js')) yield p;
  }
}

function layerOf(file) {
  const rel = path.relative(SRC, file).split(path.sep);
  for (const seg of rel) {
    if (seg === 'application') return 'application';
    if (seg === 'domain') return 'domain';
    if (seg === 'infrastructure') return 'infrastructure';
    if (seg === 'vendor') return 'vendor';
  }
  return 'other';
}

const DEP_RE = /require\(\s*['"`]([^'"`]+)['"`]\s*\)|from\s+['"`]([^'"`]+)['"`]/g;

let failed = 0;
const pass = (m) => console.log(`boundary-check: PASS — ${m}`);
const fail = (m) => { console.log(`boundary-check: FAIL — ${m}`); failed = 1; };

const isVendorSpec = (s) => /vendor\//.test(s) || /acme-sdk/.test(s);
const isInfraSpec = (s) => /infrastructure\//.test(s);
const isApplicationSpec = (s) => /application\//.test(s);

const infraVendorRefs = [];
const compositionWiring = [];
const seen = { application: 0, domain: 0, infrastructure: 0 };

for (const file of walk(SRC)) {
  const layer = layerOf(file);
  if (layer in seen) seen[layer] += 1;
  const text = fs.readFileSync(file, 'utf8');
  const rel = path.relative(process.cwd(), file);

  const specs = [];
  for (const m of text.matchAll(DEP_RE)) specs.push(m[1] || m[2]);

  const vendorDeps = specs.filter(isVendorSpec);
  const infraDeps = specs.filter(isInfraSpec);

  if ((layer === 'application' || layer === 'domain')) {
    for (const term of VENDOR_TERMS) {
      if (text.includes(term)) {
        fail(`${rel} leaks vendor v2 vocabulary '${term}' into ${layer}`);
      }
    }
    if (vendorDeps.length) {
      fail(`${rel} (${layer}) depends directly on vendor SDK: ${vendorDeps.join(', ')}`);
    }
    if (infraDeps.length) {
      fail(`${rel} (${layer}) depends on infrastructure: ${infraDeps.join(', ')}`);
    }
  }

  if (vendorDeps.length && layer !== 'vendor' && layer !== 'infrastructure') {
    fail(`${rel} references vendor SDK outside vendor/infrastructure boundary`);
  }

  if (layer === 'infrastructure' && vendorDeps.length) {
    infraVendorRefs.push(rel);
  }

  // Composition may live in index.js or another profile-local source.
  // Do not prescribe a filename/class/DI idiom; only require that some
  // source outside the inner layers wires Application + Infrastructure.
  if (layer === 'other' && file.includes(path.join('src', 'profile'))) {
    const hasApp = specs.some(isApplicationSpec);
    const hasInfra = specs.some(isInfraSpec);
    if (hasApp && hasInfra) compositionWiring.push(rel);
  }
}

if (seen.application === 0) {
  fail('profile Application use case is missing; do not bypass/delete it to contain the vendor');
}

if (seen.infrastructure === 0) {
  fail('no infrastructure implementation under src/profile/infrastructure/');
} else if (infraVendorRefs.length === 0) {
  fail('infrastructure exists but contains no vendor SDK integration');
} else {
  pass(`vendor integration contained in infrastructure: ${infraVendorRefs.join(', ')}`);
}

if (compositionWiring.length === 0) {
  fail('no profile composition source wires Application to Infrastructure');
} else {
  pass(`Application/Infrastructure wired at composition edge: ${compositionWiring.join(', ')}`);
}

if (!failed) {
  pass('application/domain free of vendor dependency and vendor vocabulary');
  pass('dependency direction conforms to boundary policy');
}
process.exit(failed);
