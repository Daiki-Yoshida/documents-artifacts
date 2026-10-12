#!/usr/bin/env bash
set -euo pipefail
root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)"
shared="$root/../shared-library"
[[ -d "$shared/.git" ]] || { echo 'external library is absent' >&2; exit 1; }
[[ "$(cat "$root/config/library-capability.txt")" == "v2" ]] || { echo 'project capability mismatch' >&2; exit 1; }
[[ "$(cat "$shared/api/capability.txt")" == "v2" ]] || { echo 'shared library capability mismatch' >&2; exit 1; }
[[ ! -e "$root/vendor/shared-library" ]] || { echo 'library ownership was flattened' >&2; exit 1; }
echo "Authorized external dependency update: PASS"
