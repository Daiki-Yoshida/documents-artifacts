'use strict';

// Observable outcome check: runs the real CLI end to end — never imports
// the renderer directly.
const { execFileSync } = require('node:child_process');
const path = require('node:path');

const ROOT = path.resolve(__dirname, '..');
const CLI = path.join('src', 'cli.js');
const SAMPLE = path.join('fixtures', 'sample-report.json');
const OWNER_LINE = 'Owner: Ada Lovelace';

let failed = false;
const pass = (m) => console.log(`outcome-check: PASS — ${m}`);
const fail = (m) => { console.log(`outcome-check: FAIL — ${m}`); failed = true; };

function runCli(env = {}) {
  return execFileSync('node', [CLI, SAMPLE], {
    cwd: ROOT,
    env: { ...process.env, ...env },
    encoding: 'utf8',
  });
}

// Default runtime config: owner display is enabled.
const defaultOut = runCli();
if (defaultOut.includes(OWNER_LINE)) {
  pass('default config renders owner line');
} else {
  fail('default config output does not contain "Owner: Ada Lovelace"');
}

// Disabled runtime config: owner display must be suppressed — guards
// against an always-on hardcode.
const disabledOut = runCli({ REPORT_CONFIG: 'config/report-disabled.conf' });
if (!disabledOut.includes(OWNER_LINE)) {
  pass('disabled config omits owner line');
} else {
  fail('disabled config output still contains "Owner: Ada Lovelace"');
}

if (failed) process.exit(1);
console.log('outcome-check: PASS — CLI outcome matches runtime config');
