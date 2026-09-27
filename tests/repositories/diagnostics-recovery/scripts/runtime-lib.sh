# Shared helpers for the runtime scripts. POSIX sh; source me.
# shellcheck shell=sh

RUNTIME_ROOT='.runtime'
SHARED_CACHE_MARKER="$RUNTIME_ROOT/shared/package-cache.keep"
PERSISTENT_DB_MARKER="$RUNTIME_ROOT/persistent/dev-db.keep"
PORTS_CONF='config/work-ports.conf'

die() { printf '%s\n' "$*" >&2; exit 1; }

work_slug() {
  printf '%s' "$1" \
    | tr '[:upper:]' '[:lower:]' \
    | sed -e 's/[^a-z0-9][^a-z0-9]*/-/g' -e 's/^-//' -e 's/-$//'
}

# require_work <WORK> -> echoes slug; exits if unknown.
require_work() {
  work=$1
  [ -n "$work" ] || die "WORK=<type>/<name> is required, e.g. WORK=feat/export"
  slug=$(work_slug "$work")
  [ -n "$slug" ] || die "WORK '$work' has no usable slug"
  grep -qE "^${slug}=" "$PORTS_CONF" \
    || die "no configured port for Work '$work' (slug '$slug') in $PORTS_CONF"
  printf '%s\n' "$slug"
}

# expected_port <slug> -> echoes port.
expected_port() {
  sed -n "s/^$1=//p" "$PORTS_CONF" | tr -d '[:space:]'
}

work_dir() { printf '%s\n' "$RUNTIME_ROOT/work/$1"; }
