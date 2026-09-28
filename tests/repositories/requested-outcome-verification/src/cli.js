'use strict';

// User-facing composition path: load report data + runtime config,
// then produce the report output.
const fs = require('node:fs');
const path = require('node:path');
const { renderReport } = require('./report/render');

function loadConfig() {
  const configPath = process.env.REPORT_CONFIG || 'config/report.conf';
  const resolved = path.resolve(configPath);
  const text = fs.readFileSync(resolved, 'utf8');
  const config = {};
  for (const line of text.split('\n')) {
    const trimmed = line.trim();
    if (!trimmed || trimmed.startsWith('#')) continue;
    const idx = trimmed.indexOf('=');
    if (idx === -1) continue;
    config[trimmed.slice(0, idx).trim()] = trimmed.slice(idx + 1).trim();
  }
  return config;
}

function main() {
  const reportPath = process.argv[2];
  if (!reportPath) {
    console.error('usage: node src/cli.js <report.json>');
    process.exit(2);
  }
  const report = JSON.parse(fs.readFileSync(path.resolve(reportPath), 'utf8'));
  const config = loadConfig();
  void config;
  process.stdout.write(renderReport(report) + '\n');
}

main();
