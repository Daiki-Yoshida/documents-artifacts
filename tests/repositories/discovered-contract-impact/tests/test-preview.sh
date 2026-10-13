#!/usr/bin/env bash
set -euo pipefail
repo_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)"

check() {
  local input="$1" expected="$2" actual
  actual="$(bash "$repo_root/bin/contactctl" preview "$input")"
  if [[ "$actual" != "$expected" ]]; then
    printf 'FAIL preview: expected <%s> but got <%s>\n' "$expected" "$actual" >&2
    exit 1
  fi
}
check '  Ada   Lovelace  ' 'Name: Ada Lovelace'
check 'Marie  Curie' 'Name: Marie Curie'
check 'NoExtra' 'Name: NoExtra'
printf 'PASS: staff preview formatting\n'
