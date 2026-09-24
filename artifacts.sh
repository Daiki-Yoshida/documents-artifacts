#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "$BASH_SOURCE")" && pwd -P)"
SOURCE_ROOT="$SCRIPT_DIR/artifacts"
DEST_REL="documents/artifacts"

TARGET=""
ACTION="sync"
ACTION_EXPLICIT=0
NON_INTERACTIVE=0
LIST_ONLY=0

usage() {
  cat <<'USAGE'
Usage:
  ./artifacts.sh [options]

Sync the complete managed Artifact v2 pack into a target project's
`documents/artifacts/` directory. The installed directory is a derived snapshot
owned by this distribution; project-specific overrides belong outside it.

Options:
  --target PATH       Target project root. Defaults to the current directory.
  --sync              Sync/update the complete pack (default action).
  --remove            Remove the complete installed pack explicitly.
  --non-interactive   Never prompt.
  --list              List files in the source pack and exit.
  -h, --help          Show this help.

Examples:
  ./artifacts.sh
  ./artifacts.sh --target ../my-project --non-interactive
  ./artifacts.sh --target ../my-project --sync --non-interactive
  ./artifacts.sh --target ../my-project --remove --non-interactive
USAGE
}

fail() {
  printf 'Error: %s\n' "$*" >&2
  exit 1
}

set_action() {
  local requested="$1"
  if ((ACTION_EXPLICIT == 1)) && [[ "$ACTION" != "$requested" ]]; then
    fail "choose only one action: --sync or --remove"
  fi
  ACTION="$requested"
  ACTION_EXPLICIT=1
}

[[ -d "$SOURCE_ROOT" ]] || fail "artifact source directory not found: $SOURCE_ROOT"
[[ -f "$SOURCE_ROOT/INDEX.md" ]] || fail "artifact root INDEX.md not found: $SOURCE_ROOT/INDEX.md"

if find "$SOURCE_ROOT" -type l -print -quit | grep -q .; then
  fail "artifact source pack must not contain symlinks"
fi

while (($# > 0)); do
  case "$1" in
    --target)
      (($# >= 2)) || fail "--target requires a path"
      TARGET="$2"
      shift 2
      ;;
    --sync)
      set_action sync
      shift
      ;;
    --remove)
      set_action remove
      shift
      ;;
    --non-interactive)
      NON_INTERACTIVE=1
      shift
      ;;
    --list)
      LIST_ONLY=1
      shift
      ;;
    --modules|--modules=*)
      fail "--modules was removed in Artifact v2; the distribution unit is the complete pack"
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      fail "unknown argument: $1"
      ;;
  esac
done

if ((LIST_ONLY == 1)); then
  find "$SOURCE_ROOT" -type f -printf '%P\n' | LC_ALL=C sort
  exit 0
fi

if [[ -z "$TARGET" ]]; then
  if ((NON_INTERACTIVE == 1)); then
    TARGET="$PWD"
  else
    printf 'Target project [%s]: ' "$PWD"
    IFS= read -r input_target
    TARGET="$input_target"
    [[ -n "$TARGET" ]] || TARGET="$PWD"
  fi
fi

[[ -d "$TARGET" ]] || fail "target project does not exist or is not a directory: $TARGET"
TARGET="$(cd -- "$TARGET" && pwd -P)"
[[ "$TARGET" != "/" ]] || fail "refusing to use filesystem root as target"

DOCS_ROOT="$TARGET/documents"
DEST_ROOT="$TARGET/$DEST_REL"

[[ ! -L "$DOCS_ROOT" ]] || fail "refusing to operate through a symlinked documents path"
[[ ! -L "$DEST_ROOT" ]] || fail "refusing to operate on a symlinked artifacts path"

if [[ "$ACTION" == "remove" ]]; then
  if ((NON_INTERACTIVE == 0)); then
    printf 'Remove the complete managed artifact pack from %s? [y/N]: ' "$DEST_ROOT"
    IFS= read -r confirm
    case "$confirm" in
      y|Y|yes|YES) ;;
      *)
        printf 'Removal cancelled.\n'
        exit 0
        ;;
    esac
  fi

  if [[ -d "$DEST_ROOT" ]]; then
    rm -rf -- "$DEST_ROOT"
    printf 'Removed managed artifact pack: %s\n' "$DEST_ROOT"
  elif [[ -e "$DEST_ROOT" ]]; then
    fail "destination exists and is not a directory: $DEST_ROOT"
  else
    printf 'Artifact pack absent: %s\n' "$DEST_ROOT"
  fi
  exit 0
fi

if ((NON_INTERACTIVE == 0)); then
  printf 'Sync the complete managed artifact pack to %s? [Y/n]: ' "$DEST_ROOT"
  IFS= read -r confirm
  case "$confirm" in
    n|N|no|NO)
      printf 'Sync cancelled.\n'
      exit 0
      ;;
  esac
fi

mkdir -p -- "$DOCS_ROOT"
[[ ! -L "$DOCS_ROOT" ]] || fail "documents path became a symlink: $DOCS_ROOT"

TEMP_DIR="$(mktemp -d "$DOCS_ROOT/.artifacts.new.XXXXXX")"
BACKUP_DIR=""

cleanup_temp() {
  if [[ -n "$TEMP_DIR" && -d "$TEMP_DIR" ]]; then
    rm -rf -- "$TEMP_DIR"
  fi
}
trap cleanup_temp EXIT

if ! cp -a -- "$SOURCE_ROOT/." "$TEMP_DIR/"; then
  fail "failed to stage artifact pack"
fi

if [[ -e "$DEST_ROOT" ]]; then
  [[ -d "$DEST_ROOT" ]] || fail "destination exists and is not a directory: $DEST_ROOT"
  BACKUP_DIR="$DOCS_ROOT/.artifacts.old.$$"
  [[ ! -e "$BACKUP_DIR" ]] || fail "temporary backup path already exists: $BACKUP_DIR"
  mv -- "$DEST_ROOT" "$BACKUP_DIR"
fi

if mv -- "$TEMP_DIR" "$DEST_ROOT"; then
  TEMP_DIR=""
  if [[ -n "$BACKUP_DIR" ]]; then
    rm -rf -- "$BACKUP_DIR"
  fi
else
  if [[ -n "$BACKUP_DIR" && -d "$BACKUP_DIR" && ! -e "$DEST_ROOT" ]]; then
    mv -- "$BACKUP_DIR" "$DEST_ROOT"
  fi
  fail "failed to install artifact pack"
fi

printf 'Synced managed Artifact v2 pack: %s\n' "$DEST_ROOT"
printf 'Review the target repository with Git, then commit the artifact changes there.\n'
