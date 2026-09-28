#!/bin/sh
# Final coordinated gate for the workspace. Deterministic: reads only
# repository files and Git state — no network, no timestamps.
set -eu
cd "$(dirname "$0")/.."

failed=0
pass() { printf 'verify: PASS — %s\n' "$1"; }
fail() { printf 'verify: FAIL — %s\n' "$1" >&2; failed=1; }

# 1. workspace target protocol
target=$(tr -d '[:space:]' < config/protocol-version.txt)
[ -n "$target" ] || {
  echo "verify: FAIL — config/protocol-version.txt is empty" >&2
  exit 1
}
printf 'verify: workspace target protocol = %s\n' "$target"

# 2-7. resolve every selector declared in the workspace mapping
found=0
while IFS='=' read -r sel rel; do
  case "$sel" in ''|\#*) continue ;; esac
  sel=$(printf '%s' "$sel" | tr -d '[:space:]')
  rel=$(printf '%s' "$rel" | tr -d '[:space:]')
  [ -n "$sel" ] && [ -n "$rel" ] || continue
  found=$((found + 1))

  # independent Component Repository
  if [ -d "$rel/.git" ] && git -C "$rel" rev-parse -q --verify HEAD >/dev/null 2>&1; then
    pass "component '$sel' is an independent Git repository at $rel"
  else
    fail "component '$sel' is not an independent Git repository at $rel"
    continue
  fi

  # ownership: the Project Repository must not track component source
  if [ -n "$(git ls-files -- "$rel" "$rel/")" ]; then
    fail "project repository tracks component source under $rel"
  else
    pass "component '$sel' source is not tracked by the project repository"
  fi

  # component protocol conforms to the workspace target
  proto=$(tr -d '[:space:]' < "$rel/protocol.conf" 2>/dev/null || true)
  if [ "$proto" = "$target" ]; then
    pass "component '$sel' protocol = $proto"
  else
    fail "component '$sel' protocol is '${proto:-missing}', workspace target is $target"
  fi

  # project coordination state records the component at target level
  coord=$(sed -n "s/^${sel}=//p" documents/coordination.conf | tr -d '[:space:]')
  if [ "$coord" = "$target" ]; then
    pass "coordination records $sel=$coord"
  else
    fail "coordination records $sel='${coord:-missing}', expected $target"
  fi
done < workspace/repositories.conf

[ "$found" -gt 0 ] || {
  echo "verify: FAIL — no components declared in workspace/repositories.conf" >&2
  exit 1
}
[ "$failed" -eq 0 ] || exit 1
printf 'verify: PASS — all components conform to workspace protocol %s\n' "$target"
