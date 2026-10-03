#!/bin/sh
set -eu

REPOSITORY="Daiki-Yoshida/documents-artifacts"
REF="main"
ARCHIVE_URL="https://github.com/$REPOSITORY/archive/refs/heads/$REF.tar.gz"
TARGET="$(pwd -P)"
DOCUMENTS="$TARGET/documents"
TMP_DIR=""

log_info() {
  printf '[INFO] %s / %s\n' "$1" "$2"
}

log_ok() {
  printf '[OK] %s / %s\n' "$1" "$2"
}

log_error() {
  printf '[ERROR] %s / %s\n' "$1" "$2" >&2
}

fail() {
  log_error "$1" "$2"
  exit 1
}

cleanup() {
  if [ -n "$TMP_DIR" ] && [ -d "$TMP_DIR" ]; then
    rm -rf -- "$TMP_DIR"
  fi
}

trap cleanup 0
trap 'exit 129' HUP
trap 'exit 130' INT
trap 'exit 143' TERM

require_command() {
  command -v "$1" >/dev/null 2>&1 \
    || fail "$1 コマンドが必要です。" "$1 is required."
}

validate_documents() {
  if [ -L "$DOCUMENTS" ]; then
    fail "./documents/ がsymlinkです。処理を中止します。" \
      "./documents/ is a symlink. Aborting."
  fi

  if [ ! -e "$DOCUMENTS" ]; then
    fail "./documents/ フォルダがありません。Project Rootで実行してください。" \
      "./documents/ directory was not found. Run this command from the Project Root."
  fi

  if [ ! -d "$DOCUMENTS" ]; then
    fail "./documents/ がディレクトリではありません。処理を中止します。" \
      "./documents/ is not a directory. Aborting."
  fi
}

[ "$TARGET" != "/" ] \
  || fail "filesystem rootでは実行できません。Project Rootで実行してください。" \
    "Refusing to run from the filesystem root. Run this command from the Project Root."

validate_documents

require_command curl
require_command tar
require_command mktemp
require_command bash

log_info "Project Rootを確認しました: $TARGET" "Project Root detected: $TARGET"

if [ -d "$DOCUMENTS/artifacts" ]; then
  log_info "既存のArtifact v2を更新します。" "Updating the existing Artifact v2 pack."
else
  log_info "Artifact v2を新規配置します。" "Installing Artifact v2."
fi

TMP_DIR="$(mktemp -d "${TMPDIR:-/tmp}/documents-artifacts-install.XXXXXX")" \
  || fail "一時ディレクトリを作成できませんでした。" \
    "Failed to create a temporary directory."

ARCHIVE="$TMP_DIR/source.tar.gz"

log_info "配布元を取得しています。" "Fetching distribution source."
if ! curl -fsSL "$ARCHIVE_URL" -o "$ARCHIVE"; then
  fail "配布元の取得に失敗しました。既存のArtifactは変更されていません。" \
    "Failed to fetch the distribution source. Existing artifacts were not changed."
fi

if ! tar -xzf "$ARCHIVE" -C "$TMP_DIR"; then
  fail "配布元の展開に失敗しました。既存のArtifactは変更されていません。" \
    "Failed to extract the distribution source. Existing artifacts were not changed."
fi

SOURCE="$TMP_DIR/documents-artifacts-$REF"

[ -f "$SOURCE/artifacts.sh" ] \
  || fail "配布元にartifacts.shがありません。" \
    "The distribution source does not contain artifacts.sh."
[ -f "$SOURCE/artifacts/INDEX.md" ] \
  || fail "配布元にArtifact v2 packがありません。" \
    "The distribution source does not contain the Artifact v2 pack."

# The target may have changed while the source was being downloaded.
# Re-check the adoption boundary before the managed sync can begin.
validate_documents

SYNC_STDOUT="$TMP_DIR/sync.stdout"
SYNC_STDERR="$TMP_DIR/sync.stderr"

log_info "Artifact v2を同期しています。" "Syncing Artifact v2."
if ! bash "$SOURCE/artifacts.sh" \
    --target "$TARGET" \
    --non-interactive \
    >"$SYNC_STDOUT" 2>"$SYNC_STDERR"; then
  log_error "Artifact v2の同期に失敗しました。" "Failed to sync Artifact v2."

  if [ -s "$SYNC_STDERR" ]; then
    while IFS= read -r line; do
      printf '[DETAIL/詳細] %s\n' "$line" >&2
    done < "$SYNC_STDERR"
  elif [ -s "$SYNC_STDOUT" ]; then
    while IFS= read -r line; do
      printf '[DETAIL/詳細] %s\n' "$line" >&2
    done < "$SYNC_STDOUT"
  fi

  exit 1
fi

log_ok "Artifact v2を同期しました: $DOCUMENTS/artifacts" \
  "Artifact v2 synced successfully: $DOCUMENTS/artifacts"
log_info "Gitで変更内容を確認してから、Project側でcommitしてください。" \
  "Review the changes with Git, then commit them in the target project."
