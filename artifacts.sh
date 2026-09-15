#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
SOURCE_ROOT="${SCRIPT_DIR}/artifacts"
DEST_REL="documents/artifacts"

TARGET=""
NON_INTERACTIVE=0
LIST_ONLY=0
MODULE_ARGS=()
REMOVE_ARGS=()

usage() {
  cat <<'USAGE'
Usage:
  ./artifacts.sh [options]

Install or update selected artifact modules into a target project's
`documents/artifacts/` directory. Removal is always explicit.

Options:
  --target PATH          Target project root. Defaults to the current directory.
  --modules LIST         Modules to install/update (comma-separated names or "all").
  --remove LIST          Modules to remove explicitly (comma-separated names).
  --non-interactive      Never prompt. Missing required choices are errors.
  --list                 List available modules and exit.
  -h, --help             Show this help.

Examples:
  ./artifacts.sh
  ./artifacts.sh --target ../my-project --modules design-principles,documentation-strategy --non-interactive
  ./artifacts.sh --target ../my-project --modules all --non-interactive
  ./artifacts.sh --target ../my-project --remove development-environment-strategy --non-interactive
USAGE
}

fail() {
  printf 'Error: %s\n' "$*" >&2
  exit 1
}

[[ -d "$SOURCE_ROOT" ]] || fail "artifact source directory not found: $SOURCE_ROOT"

mapfile -t AVAILABLE_MODULES < <(
  find "$SOURCE_ROOT" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | LC_ALL=C sort
)

((${#AVAILABLE_MODULES[@]} > 0)) || fail "no artifact modules found under $SOURCE_ROOT"

is_available_module() {
  local candidate="$1"
  local module
  for module in "${AVAILABLE_MODULES[@]}"; do
    [[ "$module" == "$candidate" ]] && return 0
  done
  return 1
}

parse_list() {
  local value="$1"
  local -n out_ref="$2"
  local item
  local -a raw=()

  IFS=',' read -r -a raw <<< "$value"
  for item in "${raw[@]}"; do
    item="${item#"${item%%[![:space:]]*}"}"
    item="${item%"${item##*[![:space:]]}"}"
    [[ -n "$item" ]] || continue
    out_ref+=("$item")
  done
}

resolve_modules() {
  local -n input_ref="$1"
  local -n output_ref="$2"
  local allow_all="$3"
  local item
  local module
  local seen

  for item in "${input_ref[@]}"; do
    if [[ "$item" == "all" ]]; then
      [[ "$allow_all" == "1" ]] || fail "'all' is not valid for removal; list modules explicitly"
      for module in "${AVAILABLE_MODULES[@]}"; do
        seen=0
        for existing in "${output_ref[@]}"; do
          [[ "$existing" == "$module" ]] && seen=1 && break
        done
        ((seen == 1)) || output_ref+=("$module")
      done
      continue
    fi

    if [[ "$item" =~ ^[0-9]+$ ]]; then
      local index=$((item - 1))
      ((index >= 0 && index < ${#AVAILABLE_MODULES[@]})) || fail "module number out of range: $item"
      item="${AVAILABLE_MODULES[$index]}"
    fi

    is_available_module "$item" || fail "unknown module: $item"

    seen=0
    for module in "${output_ref[@]}"; do
      [[ "$module" == "$item" ]] && seen=1 && break
    done
    ((seen == 1)) || output_ref+=("$item")
  done
}

while (($# > 0)); do
  case "$1" in
    --target)
      (($# >= 2)) || fail "--target requires a path"
      TARGET="$2"
      shift 2
      ;;
    --target=*)
      TARGET="${1#*=}"
      shift
      ;;
    --modules)
      (($# >= 2)) || fail "--modules requires a list"
      parse_list "$2" MODULE_ARGS
      shift 2
      ;;
    --modules=*)
      parse_list "${1#*=}" MODULE_ARGS
      shift
      ;;
    --remove)
      (($# >= 2)) || fail "--remove requires a list"
      parse_list "$2" REMOVE_ARGS
      shift 2
      ;;
    --remove=*)
      parse_list "${1#*=}" REMOVE_ARGS
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
  printf '%s\n' "${AVAILABLE_MODULES[@]}"
  exit 0
fi

if [[ -z "$TARGET" ]]; then
  if ((NON_INTERACTIVE == 1)); then
    TARGET="$PWD"
  else
    printf 'Target project [%s]: ' "$PWD"
    IFS= read -r input_target
    TARGET="${input_target:-$PWD}"
  fi
fi

[[ -d "$TARGET" ]] || fail "target project does not exist or is not a directory: $TARGET"
TARGET="$(cd -- "$TARGET" && pwd -P)"
[[ "$TARGET" != "/" ]] || fail "refusing to use filesystem root as target"

DEST_ROOT="${TARGET}/${DEST_REL}"

if [[ -L "${TARGET}/documents" ]] || [[ -L "$DEST_ROOT" ]]; then
  fail "refusing to operate through a symlinked documents/artifacts path"
fi

if ((NON_INTERACTIVE == 0)); then
  printf '\nAvailable artifact modules:\n'
  for i in "${!AVAILABLE_MODULES[@]}"; do
    module="${AVAILABLE_MODULES[$i]}"
    status="not installed"
    [[ -d "${DEST_ROOT}/${module}" ]] && status="installed"
    printf '  %d) %-36s [%s]\n' "$((i + 1))" "$module" "$status"
  done

  if ((${#MODULE_ARGS[@]} == 0)); then
    printf '\nInstall/update modules (numbers or names, comma-separated; "all" allowed; blank = none): '
    IFS= read -r selection
    [[ -n "$selection" ]] && parse_list "$selection" MODULE_ARGS
  fi

  if ((${#REMOVE_ARGS[@]} == 0)); then
    printf 'Remove modules explicitly (numbers or names, comma-separated; blank = none): '
    IFS= read -r removal
    [[ -n "$removal" ]] && parse_list "$removal" REMOVE_ARGS
  fi
fi

if ((NON_INTERACTIVE == 1)) && ((${#MODULE_ARGS[@]} == 0)) && ((${#REMOVE_ARGS[@]} == 0)); then
  fail "non-interactive mode requires --modules and/or --remove"
fi

INSTALL_MODULES=()
REMOVE_MODULES=()
resolve_modules MODULE_ARGS INSTALL_MODULES 1
resolve_modules REMOVE_ARGS REMOVE_MODULES 0

for install_module in "${INSTALL_MODULES[@]}"; do
  for remove_module in "${REMOVE_MODULES[@]}"; do
    [[ "$install_module" != "$remove_module" ]] || fail "module cannot be installed/updated and removed in the same run: $install_module"
  done
done

if ((${#INSTALL_MODULES[@]} == 0)) && ((${#REMOVE_MODULES[@]} == 0)); then
  printf 'No changes selected.\n'
  exit 0
fi

mkdir -p -- "$DEST_ROOT"
[[ ! -L "$DEST_ROOT" ]] || fail "destination root became a symlink: $DEST_ROOT"

sync_module() {
  local module="$1"
  local source_dir="${SOURCE_ROOT}/${module}"
  local dest_dir="${DEST_ROOT}/${module}"
  local temp_dir
  local backup_dir=""

  [[ -d "$source_dir" ]] || fail "source module missing: $module"
  [[ ! -L "$dest_dir" ]] || fail "refusing to replace symlinked module path: $dest_dir"

  temp_dir="$(mktemp -d "${DEST_ROOT}/.${module}.new.XXXXXX")"
  cp -a -- "${source_dir}/." "$temp_dir/"

  if [[ -e "$dest_dir" ]]; then
    [[ -d "$dest_dir" ]] || {
      rm -rf -- "$temp_dir"
      fail "destination exists and is not a directory: $dest_dir"
    }
    backup_dir="${DEST_ROOT}/.${module}.old.$$"
    [[ ! -e "$backup_dir" ]] || {
      rm -rf -- "$temp_dir"
      fail "temporary backup path already exists: $backup_dir"
    }
    mv -- "$dest_dir" "$backup_dir"
  fi

  if mv -- "$temp_dir" "$dest_dir"; then
    [[ -z "$backup_dir" ]] || rm -rf -- "$backup_dir"
  else
    [[ -z "$backup_dir" ]] || mv -- "$backup_dir" "$dest_dir"
    rm -rf -- "$temp_dir"
    fail "failed to install module: $module"
  fi

  printf 'Synced:  %s\n' "$module"
}

remove_module() {
  local module="$1"
  local dest_dir="${DEST_ROOT}/${module}"

  [[ ! -L "$dest_dir" ]] || fail "refusing to remove symlinked module path: $dest_dir"

  if [[ -d "$dest_dir" ]]; then
    rm -rf -- "$dest_dir"
    printf 'Removed: %s\n' "$module"
  elif [[ -e "$dest_dir" ]]; then
    fail "destination exists and is not a directory: $dest_dir"
  else
    printf 'Absent:  %s (nothing to remove)\n' "$module"
  fi
}

for module in "${INSTALL_MODULES[@]}"; do
  sync_module "$module"
done

if ((${#REMOVE_MODULES[@]} > 0)) && ((NON_INTERACTIVE == 0)); then
  printf '\nAbout to remove explicitly selected modules: %s\n' "${REMOVE_MODULES[*]}"
  printf 'Continue? [y/N]: '
  IFS= read -r confirm
  case "$confirm" in
    y|Y|yes|YES) ;;
    *) printf 'Removal cancelled.\n'; REMOVE_MODULES=() ;;
  esac
fi

for module in "${REMOVE_MODULES[@]}"; do
  remove_module "$module"
done

printf '\nDone. Review the target repository with Git, then commit the artifact changes there.\n'
