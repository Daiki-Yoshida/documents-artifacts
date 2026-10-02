#!/bin/sh
set -eu

fail() {
  printf 'FAIL: %s\n' "$*" >&2
  exit 1
}

ROOT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd -P)"
ACTION="${1:-}"
INPUT_DIR="${2:-}"

[ -n "$ACTION" ] || fail "operation is required"
[ -n "$INPUT_DIR" ] || fail "DIR target is required"

case "$INPUT_DIR" in
  /*) fail "absolute DIR is not supported: $INPUT_DIR" ;;
esac
case "/$INPUT_DIR/" in
  */../*) fail "DIR traversal is not supported: $INPUT_DIR" ;;
esac

TARGET_DIR="$(CDPATH= cd -- "$ROOT_DIR/$INPUT_DIR" 2>/dev/null && pwd -P)"   || fail "target directory does not exist: $INPUT_DIR"

case "$TARGET_DIR/" in
  "$ROOT_DIR/"*) ;;
  *) fail "target directory resolves outside Project Root: $INPUT_DIR" ;;
esac

[ -f "$TARGET_DIR/.project-component" ]   || fail "target is not a supported project component: $INPUT_DIR"
[ -f "$TARGET_DIR/config/pathfinding-limit.txt" ]   || fail "component pathfinding limit missing: $INPUT_DIR"
[ -x "$TARGET_DIR/scripts/check-pathfinding.sh" ]   || fail "component self-check missing: $INPUT_DIR"

REQUIRED="$(tr -d '[:space:]' < "$ROOT_DIR/config/pathfinding-required.txt")"
ACTUAL="$(tr -d '[:space:]' < "$TARGET_DIR/config/pathfinding-limit.txt")"
STATE_DIR="$TARGET_DIR/.project-runtime"
INSTALL_MARKER="$STATE_DIR/dev-install.ok"

run_local_check() {
  "$TARGET_DIR/scripts/check-pathfinding.sh"
}

check_project_target() {
  [ "$ACTUAL" = "$REQUIRED" ]     || fail "component pathfinding limit $ACTUAL does not match Project target $REQUIRED"
}

require_install_state() {
  [ -f "$INSTALL_MARKER" ]     || fail "project dev-install state missing for target: $INPUT_DIR"
}

case "$ACTION" in
  install)
    mkdir -p "$STATE_DIR"
    printf 'project-root=%s\ntarget=%s\n' "$ROOT_DIR" "$INPUT_DIR" > "$INSTALL_MARKER"
    printf 'Installed project development state for %s\n' "$INPUT_DIR"
    ;;
  test)
    run_local_check
    check_project_target
    require_install_state
    printf 'Project test PASS for %s (pathfinding=%s)\n' "$INPUT_DIR" "$ACTUAL"
    ;;
  verify)
    run_local_check
    check_project_target
    require_install_state
    printf 'Project verify PASS for %s (pathfinding=%s)\n' "$INPUT_DIR" "$ACTUAL"
    ;;
  *)
    fail "unknown operation: $ACTION"
    ;;
esac
