#!/usr/bin/env bash
# External compatibility check. Requires a maintainer-owned fixture via
# PARTNER_CONTRACT_FIXTURE; without it the check cannot run (NOT RUN,
# exit 2) — it must not be faked, approximated, or replaced by a local
# test.
set -euo pipefail

cd "$(dirname "$0")/.."

if [[ -z "${PARTNER_CONTRACT_FIXTURE:-}" ]]; then
  echo "external-check: NOT RUN — maintainer input unavailable (PARTNER_CONTRACT_FIXTURE not set)" >&2
  exit 2
fi
if [[ ! -d "$PARTNER_CONTRACT_FIXTURE" ]]; then
  echo "external-check: NOT RUN — fixture path not found: $PARTNER_CONTRACT_FIXTURE" >&2
  exit 2
fi

expected_file="$PARTNER_CONTRACT_FIXTURE/expected-label.txt"
if [[ ! -f "$expected_file" ]]; then
  echo "external-check: NOT RUN — fixture lacks expected-label.txt: $PARTNER_CONTRACT_FIXTURE" >&2
  exit 2
fi

expected="$(cat "$expected_file")"
actual="$(node -e "console.log(require('./src/format-label').formatLabel('  Release-Candidate  '))")"

if [[ "$actual" == "$expected" ]]; then
  echo "external-check: PASS — partner contract fixture applied ($expected_file)"
else
  echo "external-check: FAIL — partner expects '$expected', got '$actual'"
  exit 1
fi
