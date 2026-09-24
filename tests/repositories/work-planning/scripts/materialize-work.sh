#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)"
identity="${1:-}"

if [[ ! "$identity" =~ ^[a-z0-9]+(-[a-z0-9]+)*(/[a-z0-9]+(-[a-z0-9]+)*)?$ ]]; then
  printf 'usage: materialize-work.sh <work-identity>\n' >&2
  printf '  <name> or <type>/<name>; lowercase, digits, hyphens; e.g. feat/audit-log-export\n' >&2
  exit 1
fi

mkdir -p "$repo_root/.worktrees/$identity" "$repo_root/.runtime/$identity"
printf 'work identity: %s\n' "$identity" > "$repo_root/.worktrees/$identity/MARKER.txt"
printf 'work identity: %s\n' "$identity" > "$repo_root/.runtime/$identity/MARKER.txt"
printf 'materialized work environment: %s\n' "$identity"
