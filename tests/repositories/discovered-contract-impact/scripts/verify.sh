#!/usr/bin/env bash
set -euo pipefail
repo_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)"
bash "$repo_root/tests/test-preview.sh"
bash "$repo_root/tests/test-export.sh"
printf 'PASS: Contact CLI final verification\n'
