'use strict';

// Runtime resource policy check. Deterministic: no wall-clock timing,
// no random values. Verifies semantic properties of the project-owned
// resource policy, not a specific Compose wiring.
const assert = require('node:assert');
const { defaultRuntime, workRuntime } = require('./resource-identity');

let failed = false;
function check(name, fn) {
  try {
    fn();
    console.log(`resource-check: PASS — ${name}`);
  } catch (e) {
    console.error(`resource-check: FAIL — ${name}: ${e.message}`);
    failed = true;
  }
}

// --- default runtime / existing resource policy ---

const d1 = defaultRuntime();
const d2 = defaultRuntime();

check('default runtime descriptor is deterministic', () =>
  assert.deepStrictEqual(d1, d2));

check('default runtime exposes the required resources', () => {
  for (const key of ['image', 'cacheVolume', 'dbVolume', 'hostPort', 'network']) {
    assert.ok(d1[key] !== undefined && d1[key] !== '', `missing ${key}`);
  }
});

check('default host port is a usable integer', () =>
  assert.ok(
    Number.isInteger(d1.hostPort) && d1.hostPort >= 1024 && d1.hostPort <= 65535,
    `got ${d1.hostPort}`,
  ));

// --- parallel Work runtime scoping ---

const WORK = 'feat/schema-preview';
const OTHER = 'feat/other-work';

let w;
try {
  w = workRuntime(WORK);
} catch (e) {
  w = e;
}

check('parallel Work runtime is supported', () => {
  if (w instanceof Error) {
    throw new Error(`not implemented: ${w.message}`);
  }
});

if (!(w instanceof Error)) {
  const w2 = workRuntime(WORK);
  const o = workRuntime(OTHER);

  check('work runtime resources are deterministic for the same Work', () =>
    assert.deepStrictEqual(w, w2));

  check('work resources are derived from the confirmed Work identity', () => {
    assert.strictEqual(w.work, WORK, 'descriptor must carry the confirmed Work identity');
    assert.notStrictEqual(w.dbVolume, o.dbVolume, 'different Work must not share db volume');
    assert.notStrictEqual(w.hostPort, o.hostPort, 'different Work must not share host port');
  });

  check('toolchain image is project-scoped (shared across runtimes)', () =>
    assert.strictEqual(w.image, d1.image));

  check('package cache is project-scoped (shared across runtimes)', () =>
    assert.strictEqual(w.cacheVolume, d1.cacheVolume));

  check('mutable DB state is isolated per runtime', () =>
    assert.notStrictEqual(w.dbVolume, d1.dbVolume));

  check('work host port does not collide with the default runtime', () => {
    assert.ok(
      Number.isInteger(w.hostPort) && w.hostPort >= 1024 && w.hostPort <= 65535,
      `invalid port ${w.hostPort}`,
    );
    assert.notStrictEqual(w.hostPort, d1.hostPort);
  });

  check('default runtime remains usable alongside work runtime', () =>
    assert.deepStrictEqual(defaultRuntime(), d1));
}

process.exit(failed ? 1 : 0);
