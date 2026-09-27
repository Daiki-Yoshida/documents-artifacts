#!/bin/sh
# Lifecycle identity propagation check. Deterministic: inspects the
# printed recipes (`make -n`, dry-run) of every work-* lifecycle command.
# No Docker daemon, no wall-clock timing, no random values.
#
# Contract under test: every lifecycle operation for a confirmed Work
# identity must resolve the same Work-scoped resource configuration
# (compose project, DB volume, network, host port) that
# scripts/resource-identity.js derives — teardown/cleanup must not fall
# back to default or shared project resources, and must not blanket-
# purge volumes.
set -u
cd "$(dirname "$0")/.."

WORK='feat/schema-preview'

slug=$(printf '%s' "$WORK" | tr '[:upper:]' '[:lower:]' | sed -e 's/[^a-z0-9][^a-z0-9]*/-/g' -e 's/^-//' -e 's/-$//')
exp_project="wrr-$slug"
exp_db="$exp_project-db-data"
exp_net="$exp_project-net"
exp_port=$((8100 + $(printf '%s' "$WORK" | cksum | awk '{print $1}') % 900))

# Default/shared project resources that Work ops must never resolve.
def_db='work-runtime-lifecycle-db-data'
def_net='work-runtime-lifecycle-net'
shared_cache='work-runtime-lifecycle-pkg-cache'

failed=0
pass() { printf 'lifecycle-check: PASS — %s\n' "$1"; }
fail() { printf 'lifecycle-check: FAIL — %s\n' "$1" >&2; failed=1; }

# True if $1 (a compose command line) resolves the expected Work-scoped
# configuration, either via env assignments on the line or via an
# --env-file whose contents carry them.
resolves_work_config() {
  line=$1
  envfile=$(printf '%s\n' "$line" | grep -oE -- '--env-file[=[:space:]]+[^[:space:]]+' | awk '{print $NF}')
  for tok in "DB_VOLUME_NAME=$exp_db" "RUNTIME_NETWORK_NAME=$exp_net" "APP_HOST_PORT=$exp_port"; do
    case "$line" in
      *"$tok"*) continue ;;
    esac
    if [ -n "$envfile" ] && [ -f "$envfile" ] && grep -qF "$tok" "$envfile"; then
      continue
    fi
    return 1
  done
  case "$line" in
    *"-p $exp_project"* | *"--project-name $exp_project"* | *"COMPOSE_PROJECT_NAME=$exp_project"*) ;;
    *) return 1 ;;
  esac
  return 0
}

ops='up status config verify down cleanup'

for op in $ops; do
  target="work-$op"
  out=$(make -n "$target" "WORK=$WORK" 2>/dev/null) || {
    fail "$target does not exist or fails for WORK=$WORK"
    continue
  }
  compose_lines=$(printf '%s\n' "$out" | grep -E 'docker[ -]compose' || true)
  if [ -z "$compose_lines" ]; then
    fail "$target runs no compose command"
    continue
  fi

  bad=0
  while IFS= read -r line; do
    resolves_work_config "$line" || bad=1
  done <<EOF
$compose_lines
EOF

  if [ "$bad" -eq 1 ]; then
    fail "$target does not resolve the Work-scoped configuration ($exp_project / $exp_db / $exp_net / port $exp_port)"
  else
    pass "$target resolves the Work-scoped configuration"
  fi

  # No lifecycle op may target default or shared project resources.
  if printf '%s\n' "$out" | grep -qE "$def_db|$def_net|$shared_cache"; then
    fail "$target resolves a default/shared project resource name"
  fi

  # No blanket volume purge in any lifecycle op.
  if printf '%s\n' "$compose_lines" | grep -E '(^|[[:space:]])(down|rm)([[:space:]])' | grep -qE -- '(-v([[:space:]]|$)|--volumes)'; then
    fail "$target uses a blanket volume purge (-v/--volumes); removal must target only Work-scoped volumes"
  fi
done

# work-cleanup must visibly remove the Work-scoped mutable volume.
cleanup_out=$(make -n work-cleanup "WORK=$WORK" 2>/dev/null || true)
if printf '%s\n' "$cleanup_out" | grep -qE "volume[[:space:]]+rm.*$exp_db"; then
  pass "work-cleanup removes only the Work-scoped volume"
else
  fail "work-cleanup does not visibly remove the Work-scoped volume $exp_db"
fi

# Default runtime commands must not resolve Work-scoped configuration.
default_out=$( (make -n up; make -n down) 2>/dev/null || true)
if printf '%s\n' "$default_out" | grep -qE "wrr-|DB_VOLUME_NAME|RUNTIME_NETWORK_NAME"; then
  fail "default runtime commands resolve Work-scoped configuration"
else
  pass "default runtime commands do not target Work-scoped resources"
fi

exit "$failed"
