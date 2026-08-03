#!/bin/bash
#
# copy-all-artifacts.sh
#
# Synchronize the exported Markdown artifacts from all bundled projects into a
# target directory. Files previously distributed by this script are tracked in
# a destination manifest, allowing obsolete distributed files to be removed
# without deleting destination-owned files.
#
# Usage:
#   ./copy-all-artifacts.sh [destination_dir]
#
# If no destination is given, the current working directory is used.

set -euo pipefail

SOURCE_DIR="$(dirname "$(realpath "$0")")"
DEST_DIR="${1:-$(pwd)}"
MANIFEST_NAME=".documents-artifacts-manifest"
PROJECTS=(
  "design-principles"
  "documentation-strategy"
  "development-environment-strategy"
)

TEMP_DIR="$(mktemp -d)"
MANIFEST_STAGE=""
cleanup() {
  rm -rf "$TEMP_DIR"
  if [ -n "$MANIFEST_STAGE" ]; then
    rm -f "$MANIFEST_STAGE"
  fi
}
trap cleanup EXIT

CURRENT_MANIFEST="$TEMP_DIR/current-manifest"
PREVIOUS_MANIFEST="$TEMP_DIR/previous-manifest"
STALE_MANIFEST="$TEMP_DIR/stale-manifest"
: > "$CURRENT_MANIFEST"
: > "$PREVIOUS_MANIFEST"

fail() {
  echo "ERROR: $*" >&2
  exit 1
}

is_valid_manifest_entry() {
  local entry="$1"
  local remainder

  case "$entry" in
    design-principles/*.md|documentation-strategy/*.md|development-environment-strategy/*.md)
      ;;
    *)
      return 1
      ;;
  esac

  remainder="${entry#*/}"
  [ -n "$remainder" ] && [[ "$remainder" != */* ]] && [ "$remainder" != "." ] && [ "$remainder" != ".." ]
}

# Preflight every source before touching the destination.
for project in "${PROJECTS[@]}"; do
  artifacts_dir="$SOURCE_DIR/$project/artifacts"
  [ -d "$artifacts_dir" ] || fail "$project: artifacts/ not found at $artifacts_dir"

  project_count=0
  while IFS= read -r source_file; do
    [ -r "$source_file" ] || fail "$project: artifact is not readable: $source_file"
    filename="$(basename "$source_file")"
    entry="$project/$filename"
    is_valid_manifest_entry "$entry" || fail "$project: unsupported artifact path: $entry"
    printf '%s\n' "$entry" >> "$CURRENT_MANIFEST"
    project_count=$((project_count + 1))
  done < <(find "$artifacts_dir" -maxdepth 1 -type f -name "*.md" -print | LC_ALL=C sort)

  [ "$project_count" -gt 0 ] || fail "$project: no top-level Markdown artifacts found in $artifacts_dir"
done

LC_ALL=C sort -u -o "$CURRENT_MANIFEST" "$CURRENT_MANIFEST"

if [ -e "$DEST_DIR" ] && [ ! -d "$DEST_DIR" ]; then
  fail "destination exists but is not a directory: $DEST_DIR"
fi
mkdir -p "$DEST_DIR"
[ -w "$DEST_DIR" ] || fail "destination is not writable: $DEST_DIR"

MANIFEST_PATH="$DEST_DIR/$MANIFEST_NAME"
[ ! -L "$MANIFEST_PATH" ] || fail "manifest path must not be a symbolic link: $MANIFEST_PATH"
if [ -e "$MANIFEST_PATH" ]; then
  [ -f "$MANIFEST_PATH" ] || fail "manifest path is not a regular file: $MANIFEST_PATH"
  [ -r "$MANIFEST_PATH" ] || fail "manifest is not readable: $MANIFEST_PATH"

  while IFS= read -r entry || [ -n "$entry" ]; do
    case "$entry" in
      ""|\#*) continue ;;
    esac
    is_valid_manifest_entry "$entry" || fail "manifest contains an unsafe or unsupported path: $entry"
    printf '%s\n' "$entry" >> "$PREVIOUS_MANIFEST"
  done < "$MANIFEST_PATH"
  LC_ALL=C sort -u -o "$PREVIOUS_MANIFEST" "$PREVIOUS_MANIFEST"
else
  echo "INFO: no previous manifest found; existing destination files are preserved during bootstrap."
fi

for project in "${PROJECTS[@]}"; do
  project_dest="$DEST_DIR/$project"
  [ ! -L "$project_dest" ] || fail "managed project directory must not be a symbolic link: $project_dest"
  if [ -e "$project_dest" ] && [ ! -d "$project_dest" ]; then
    fail "managed project path exists but is not a directory: $project_dest"
  fi
  if [ -d "$project_dest" ] && [ ! -w "$project_dest" ]; then
    fail "managed project directory is not writable: $project_dest"
  fi
done

while IFS= read -r entry; do
  project="${entry%%/*}"
  filename="${entry#*/}"
  source_file="$SOURCE_DIR/$project/artifacts/$filename"
  target="$DEST_DIR/$entry"
  [ ! -L "$target" ] || fail "managed target must not be a symbolic link: $target"
  if [ -e "$target" ] && [ ! -f "$target" ]; then
    fail "managed target exists but is not a regular file: $target"
  fi
  if [ -f "$target" ] && ! cmp -s -- "$source_file" "$target" && [ ! -w "$target" ]; then
    fail "managed target requires an update but is not writable: $target"
  fi
done < "$CURRENT_MANIFEST"

comm -23 "$PREVIOUS_MANIFEST" "$CURRENT_MANIFEST" > "$STALE_MANIFEST"
while IFS= read -r entry; do
  [ -n "$entry" ] || continue
  target="$DEST_DIR/$entry"
  [ ! -L "$target" ] || fail "stale managed target must not be a symbolic link: $target"
  if [ -e "$target" ] && [ ! -f "$target" ]; then
    fail "stale managed target exists but is not a regular file: $target"
  fi
done < "$STALE_MANIFEST"

for project in "${PROJECTS[@]}"; do
  mkdir -p "$DEST_DIR/$project"
done

added=0
updated=0
unchanged=0
removed=0

while IFS= read -r entry; do
  project="${entry%%/*}"
  filename="${entry#*/}"
  source_file="$SOURCE_DIR/$project/artifacts/$filename"
  target="$DEST_DIR/$entry"

  if [ ! -e "$target" ]; then
    cp -- "$source_file" "$target"
    added=$((added + 1))
  elif cmp -s -- "$source_file" "$target"; then
    unchanged=$((unchanged + 1))
  else
    cp -- "$source_file" "$target"
    updated=$((updated + 1))
  fi
done < "$CURRENT_MANIFEST"

while IFS= read -r entry; do
  [ -n "$entry" ] || continue
  target="$DEST_DIR/$entry"
  if [ -f "$target" ]; then
    rm -- "$target"
    removed=$((removed + 1))
  fi
done < "$STALE_MANIFEST"

MANIFEST_STAGE="$(mktemp "$DEST_DIR/${MANIFEST_NAME}.tmp.XXXXXX")" \
  || fail "could not create manifest staging file in destination: $DEST_DIR"
{
  echo "# documents-artifacts manifest v1"
  cat "$CURRENT_MANIFEST"
} > "$MANIFEST_STAGE"
mv -f -- "$MANIFEST_STAGE" "$MANIFEST_PATH"
MANIFEST_STAGE=""

for project in "${PROJECTS[@]}"; do
  count=$(grep -c "^$project/" "$CURRENT_MANIFEST" || true)
  echo "OK: $project -> $DEST_DIR/$project ($count managed files)"
done

echo
echo "Done: added=$added updated=$updated unchanged=$unchanged removed=$removed destination=$DEST_DIR"
