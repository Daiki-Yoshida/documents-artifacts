'use strict';

// Project-owned runtime resource policy (see README "Runtime resources").
// Project tooling derives resource names/ports from this module instead
// of hardcoding them per command.
//
// Scopes:
//  - 'default': the default runtime.
//  - 'work':    a parallel runtime for one confirmed Work identity.
//
// Resource scoping (see README "Runtime resources"):
//  - image and package cache are project-scoped and shared by every
//    runtime — the image carries only the toolchain (source is
//    bind-mounted), and downloads are identical for any consumer;
//  - db volume, host port, network and container namespace are
//    per-runtime: Work runtimes must not share mutable state or collide
//    on the host port with the default runtime.
//
// Work-scoped identities derive deterministically from
//   project + confirmed Work identity + resource role.

const PROJECT = 'work-runtime-lifecycle';

// The default runtime.
function defaultRuntime() {
  return {
    scope: 'default',
    work: null,
    project: PROJECT,
    composeProject: null,
    image: 'work-runtime-dev:node20',   // toolchain image (project resource)
    cacheVolume: `${PROJECT}-pkg-cache`, // shared package/download cache
    dbVolume: `${PROJECT}-db-data`,     // mutable state for this runtime
    hostPort: 8080,                     // host port for this runtime
    network: `${PROJECT}-net`,
  };
}

// POSIX cksum (CRC32, 0x04C11DB7 non-reflected, length appended) over the
// Work identity — identical to `printf '%s' "$work" | cksum` on the host,
// so host tooling and this module derive the same port.
const CK_TABLE = (() => {
  const t = new Uint32Array(256);
  for (let i = 0; i < 256; i++) {
    let c = i << 24;
    for (let j = 0; j < 8; j++) {
      c = (c & 0x80000000) ? ((c << 1) ^ 0x04c11db7) >>> 0 : (c << 1) >>> 0;
    }
    t[i] = c;
  }
  return t;
})();

function cksum(str) {
  const buf = Buffer.from(str, 'utf8');
  let crc = 0;
  const upd = (b) => {
    crc = (((crc << 8) >>> 0) ^ CK_TABLE[((crc >>> 24) ^ b) & 0xff]) >>> 0;
  };
  for (const b of buf) upd(b);
  let n = buf.length;
  while (n !== 0) {
    upd(n & 0xff);
    n = Math.floor(n / 256);
  }
  return ~crc >>> 0;
}

// Compose-safe slug for a confirmed Work identity:
// lowercase, runs of non [a-z0-9] collapsed to '-', edges trimmed.
function workSlug(work) {
  return work
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-+|-+$/g, '');
}

// Parallel runtime for a confirmed Work identity.
function workRuntime(work) {
  if (!work || typeof work !== 'string' || workSlug(work) === '') {
    throw new Error('workRuntime requires a confirmed Work identity');
  }
  const composeProject = `wrr-${workSlug(work)}`;
  return {
    scope: 'work',
    work,
    project: PROJECT,
    composeProject,
    image: 'work-runtime-dev:node20',        // shared toolchain image
    cacheVolume: `${PROJECT}-pkg-cache`,     // shared package/download cache
    dbVolume: `${composeProject}-db-data`,   // Work-scoped mutable state
    hostPort: 8100 + (cksum(work) % 900),    // Work-derived, no default collision
    network: `${composeProject}-net`,
    container: `${composeProject}-app-1`,
  };
}

module.exports = { PROJECT, defaultRuntime, workRuntime, workSlug, cksum };
