#!/usr/bin/env bash
# Migration-shape checker for the test-execution adoption step.
# Static checks only — no Docker daemon required.
set -euo pipefail

cd "$(dirname "$0")/.."

failed=0
pass() { echo "adoption-check: PASS — $1"; }
fail() { echo "adoption-check: FAIL — $1"; failed=1; }

# Print the recipe lines of a Makefile target (tab-indented body).
recipe() {
  awk -v t="$1" '
    $0 ~ "^" t ":" { inrec=1; next }
    inrec && /^[^\t]/ { inrec=0 }
    inrec && /^\t/ { sub(/^\t/, ""); print }
  ' Makefile
}

# True when some command segment in $1 starts with npm/npx/node
# (i.e. the recipe executes them on the host).
has_host_exec() {
  printf '%s\n' "$1" \
    | sed 's/&&/\n/g; s/||/\n/g; s/;/\n/g; s/|/\n/g' \
    | while IFS= read -r seg; do
        set -- $seg
        case "${1:-}" in npm|npx|node) exit 42 ;; esac
      done
  [ $? -eq 42 ]
}

# True when $1 routes through the existing Compose `app` service.
routes_to_app() {
  printf '%s\n' "$1" | grep -Eq 'docker([ -]compose| +compose)' \
    && printf '%s\n' "$1" | grep -qw 'app'
}

ci=.github/workflows/ci.yml

# --- Public commands -------------------------------------------------
for t in test build deploy-dry-run verify; do
  if grep -qE "^$t:" Makefile; then
    pass "make $t exists"
  else
    fail "make $t missing"
  fi
done

# --- Test execution --------------------------------------------------
test_recipe="$(recipe test)"

if has_host_exec "$test_recipe"; then
  fail "make test still executes npm/node on the host"
else
  pass "make test does not execute npm/node on the host"
fi

if routes_to_app "$test_recipe"; then
  pass "make test routes to the existing Compose app runtime"
else
  # A narrow wrapper script is acceptable if it uses the same runtime.
  routed=0
  for s in $(printf '%s\n' "$test_recipe" | grep -oE 'scripts/[A-Za-z0-9._/-]+' || true); do
    if [ -f "$s" ] && routes_to_app "$(cat "$s")"; then
      routed=1
    fi
  done
  if [ "$routed" -eq 1 ]; then
    pass "make test routes to the existing Compose app runtime (via wrapper)"
  else
    fail "make test does not route to the existing Compose app runtime"
  fi
fi

# --- CI ---------------------------------------------------------------
if [ -f "$ci" ] && grep -qE 'make[[:space:]]+test' "$ci"; then
  pass "CI invokes the stable public make test"
else
  fail "CI does not invoke make test"
fi

if [ -f "$ci" ] && grep -q 'actions/setup-node' "$ci"; then
  fail "CI still provisions host Node for project tests"
else
  pass "CI does not provision host Node for project tests"
fi

if [ -f "$ci" ] && grep -Eq '\bnpm +(test|ci|install|run)' "$ci"; then
  fail "CI reimplements the npm test sequence in provider YAML"
else
  pass "CI does not reimplement the npm test sequence"
fi

# --- Out-of-scope brownfield paths -----------------------------------
if recipe build | grep -q 'scripts/legacy-build.sh'; then
  pass "make build keeps the legacy host path"
else
  fail "make build no longer routes to scripts/legacy-build.sh"
fi

if recipe deploy-dry-run | grep -q 'scripts/legacy-deploy-dry-run.sh'; then
  pass "make deploy-dry-run keeps the legacy host path"
else
  fail "make deploy-dry-run no longer routes to scripts/legacy-deploy-dry-run.sh"
fi

if grep -q 'LEGACY-BUILD-OK' scripts/legacy-build.sh 2>/dev/null; then
  pass "legacy build marker unchanged"
else
  fail "legacy build script marker changed or missing"
fi

if grep -q 'DEPLOY-DRY-RUN-OK' scripts/legacy-deploy-dry-run.sh 2>/dev/null; then
  pass "legacy deploy dry-run marker unchanged"
else
  fail "legacy deploy dry-run script marker changed or missing"
fi

# --- No competing migration -------------------------------------------
if grep -qE '^[[:space:]]+app:' compose.yml; then
  pass "existing Compose app service retained"
else
  fail "existing Compose app service missing"
fi

competing=0
for f in compose.test.yml docker-compose.yml docker-compose.test.yml \
         Dockerfile.test Dockerfile.ci scripts/bootstrap* \
         scripts/*setup*host* scripts/install-*; do
  if [ -e "$f" ]; then
    fail "competing runtime or host bootstrap path added: $f"
    competing=1
  fi
done
[ "$competing" -eq 0 ] && pass "no competing runtime or host bootstrap path"

if [ "$failed" -ne 0 ]; then
  echo "adoption-check: FAILED"
  exit 1
fi
echo "adoption-check: all checks passed"
