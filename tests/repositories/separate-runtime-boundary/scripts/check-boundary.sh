#!/bin/sh
# Boundary guard: frontend/ is a separate deployable and must not import
# backend internals. Same-runtime imports inside backend/ stay allowed.
set -eu
cd "$(dirname "$0")/.."

if grep -rEn "(from|import|require)[[:space:]]*\(?[[:space:]]*['\"][^'\"]*backend/" frontend/; then
  echo "boundary: FAIL — frontend imports backend internals" >&2
  exit 1
fi
echo "boundary: PASS — frontend uses no backend internals"
