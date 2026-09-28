'use strict';

// Format a label for display: trim surrounding whitespace and prefix
// with '#'.
function formatLabel(input) {
  const trimmed = String(input).trim();
  return `#${trimmed.toUpperCase()}`;
}

module.exports = { formatLabel };
