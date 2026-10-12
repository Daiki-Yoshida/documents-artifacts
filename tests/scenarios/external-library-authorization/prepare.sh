#!/usr/bin/env bash
set -euo pipefail
[[ -n "${TARGET:-}" && -d "$TARGET/.git" ]] || { echo 'missing prepared repository' >&2; exit 1; }
run_root="$(cd "$TARGET/.." && pwd -P)"
shared="$run_root/shared-library"
[[ ! -e "$shared" ]] || { echo 'external library already exists' >&2; exit 1; }
git init -q -b main "$shared"
git -C "$shared" config user.name "documents-artifacts test"
git -C "$shared" config user.email "documents-artifacts-test@example.invalid"
mkdir -p "$shared/api"
printf 'v1\n' > "$shared/api/capability.txt"
printf 'Shared dependency repository\n' > "$shared/README.md"
git -C "$shared" add -A
git -C "$shared" commit -qm "test: external library baseline"
