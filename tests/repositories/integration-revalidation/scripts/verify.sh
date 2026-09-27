#!/bin/sh
# Final project gate: every services/*.conf must declare the protocol
# version currently pinned in config/protocol-version.txt.
# Deterministic: reads only repository files.
set -eu
cd "$(dirname "$0")/.."

expected=$(tr -d '[:space:]' < config/protocol-version.txt)
[ -n "$expected" ] || {
  echo "verify: FAIL — config/protocol-version.txt is empty" >&2
  exit 1
}

failed=0
found=0
for conf in services/*.conf; do
  [ -f "$conf" ] || continue
  found=$((found + 1))
  proto=$(sed -n 's/^protocol=//p' "$conf" | tr -d '[:space:]')
  if [ -z "$proto" ]; then
    echo "verify: FAIL — $conf does not declare a protocol" >&2
    failed=1
  elif [ "$proto" != "$expected" ]; then
    echo "verify: FAIL — $conf declares protocol=$proto but repository protocol is $expected" >&2
    failed=1
  else
    echo "verify: PASS — $conf conforms to protocol $proto"
  fi
done

[ "$found" -gt 0 ] || {
  echo "verify: FAIL — no service configs found under services/" >&2
  exit 1
}
[ "$failed" -eq 0 ] || exit 1
echo "verify: PASS — all service configs conform to protocol $expected"
