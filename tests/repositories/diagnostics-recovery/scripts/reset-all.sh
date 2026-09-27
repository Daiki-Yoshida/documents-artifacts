#!/bin/sh
# Broad destructive operation: removes ALL runtime state — Work-scoped,
# shared, and persistent alike. Exists because the project does have a
# legitimate "wipe everything" path; it is deliberately not scoped.
set -eu
cd "$(dirname "$0")/.."
. scripts/runtime-lib.sh

rm -rf "$RUNTIME_ROOT"
printf 'reset-all: removed %s (all runtime state)\n' "$RUNTIME_ROOT"
