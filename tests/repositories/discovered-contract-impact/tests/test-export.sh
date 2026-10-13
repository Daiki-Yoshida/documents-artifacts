#!/usr/bin/env bash
set -euo pipefail
repo_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)"

check() {
  local input="$1" expected="$2" actual
  actual="$(bash "$repo_root/bin/contactctl" export "$input")"
  if [[ "$actual" != "$expected" ]]; then
    printf 'FAIL published export: expected <%q> but got <%q>\n' "$expected" "$actual" >&2
    exit 1
  fi
}
check '  Ada   Lovelace  ' $'contact\t  Ada   Lovelace  '
check 'Marie  Curie' $'contact\tMarie  Curie'
check 'NoExtra' $'contact\tNoExtra'
printf 'PASS: published export compatibility\n'
