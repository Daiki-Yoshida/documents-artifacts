'use strict';

// Project-owned runtime resource policy (see README "Runtime resources").
// Project tooling derives resource names/ports from this module instead
// of hardcoding them per command.
//
// Scopes:
//  - 'default': the default runtime.
//  - Work-specific parallel runtimes are not implemented yet.

const PROJECT = 'work-runtime-resources';

// The default runtime — the only supported runtime today.
function defaultRuntime() {
  return {
    scope: 'default',
    work: null,
    project: PROJECT,
    image: 'work-runtime-dev:node20',   // toolchain image (project resource)
    cacheVolume: 'dev-pkg-cache',       // shared package/download cache
    dbVolume: `${PROJECT}-db-data`,     // mutable state for this runtime
    hostPort: 8080,                     // host port for this runtime
    network: `${PROJECT}-net`,
  };
}

// Parallel runtime for a confirmed Work identity — not implemented yet.
function workRuntime(work) {
  if (!work || typeof work !== 'string') {
    throw new Error('workRuntime requires a confirmed Work identity');
  }
  throw new Error('parallel Work runtime is not implemented yet');
}

module.exports = { PROJECT, defaultRuntime, workRuntime };
