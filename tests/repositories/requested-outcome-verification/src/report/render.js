'use strict';

// Stable callable surface — rendering behavior owner.
function renderReport(report, { includeOwner = false } = {}) {
  const lines = [`Report: ${report.title}`];
  if (includeOwner) {
    lines.push(`Owner: ${report.owner}`);
  }
  return lines.join('\n');
}

module.exports = { renderReport };
