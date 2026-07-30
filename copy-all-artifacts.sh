#!/bin/bash
#
# copy-all-artifacts.sh
#
# Copy the exported artifacts from all three bundled projects into a target
# directory in one shot. Each project's artifacts are placed under a
# subdirectory named after the project, so that files with the same name
# (e.g. INDEX.md) do not collide.
#
# Usage:
#   ./copy-all-artifacts.sh [destination_dir]
#
# If no destination is given, the current working directory is used.
#
# Layout produced at the destination:
#   <destination>/
#     design-principles/                  (*.md from its artifacts/)
#     documentation-strategy/             (*.md from its artifacts/)
#     development-environment-strategy/   (*.md from its artifacts/)
#
# The three source projects are expected to live as siblings of this script,
# each with its own artifacts/ directory. They are managed by their own git
# repositories and are intentionally ignored by the parent repository.

set -euo pipefail

# Get the directory where the script is stored
SOURCE_DIR="$(dirname "$(realpath "$0")")"
DEST_DIR="${1:-$(pwd)}"

# Bundled projects and their artifacts subdirectories
PROJECTS=(
  "design-principles"
  "documentation-strategy"
  "development-environment-strategy"
)

mkdir -p "$DEST_DIR"

copied=0
missing=0

for project in "${PROJECTS[@]}"; do
  artifacts_dir="$SOURCE_DIR/$project/artifacts"

  if [ ! -d "$artifacts_dir" ]; then
    echo "WARN: $project: artifacts/ not found at $artifacts_dir (skipped)" >&2
    missing=$((missing + 1))
    continue
  fi

  project_dest="$DEST_DIR/$project"
  mkdir -p "$project_dest"

  # Copy all top-level markdown artifacts into the project subdirectory
  find "$artifacts_dir" -maxdepth 1 -name "*.md" -exec cp {} "$project_dest" \;

  count=$(find "$artifacts_dir" -maxdepth 1 -name "*.md" | wc -l | tr -d ' ')
  echo "OK: $project -> $project_dest ($count files)"
  copied=$((copied + 1))
done

echo
echo "Done: $copied project(s) copied to $DEST_DIR"
if [ "$missing" -gt 0 ]; then
  echo "WARN: $missing project(s) skipped due to missing artifacts/" >&2
  exit 1
fi
