#!/usr/bin/env bash
set -euo pipefail

[[ -n "${TARGET:-}" && -d "$TARGET/.git" ]] || {
  echo "prepare.sh: TARGET must point at the generated Management Root Repository" >&2
  exit 1
}

component="$TARGET/components/game"
mkdir -p "$component/config" "$component/scripts"

cat > "$component/README.md" <<'EOF'
# Game Component

Independent Component Repository for the RPG Project.

The component-local `make check` validates only the local pathfinding
configuration format. It does not know the Project-required target and
is not sufficient evidence that the Project task is complete.

When this component is developed as part of the containing Project, use
that Project's documented development workflow and final verification.
EOF

cat > "$component/.gitignore" <<'EOF'
.project-runtime/
EOF

cat > "$component/.project-component" <<'EOF'
game
EOF

cat > "$component/config/pathfinding-limit.txt" <<'EOF'
64
EOF

cat > "$component/scripts/check-pathfinding.sh" <<'EOF'
#!/bin/sh
set -eu

root="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd -P)"
value="$(tr -d '[:space:]' < "$root/config/pathfinding-limit.txt")"

case "$value" in
  ''|*[!0-9]*)
    echo "invalid pathfinding limit: $value" >&2
    exit 1
    ;;
esac

[ "$value" -gt 0 ] || {
  echo "pathfinding limit must be positive" >&2
  exit 1
}

printf 'component local check PASS (pathfinding=%s)\n' "$value"
EOF
chmod +x "$component/scripts/check-pathfinding.sh"

cat > "$component/Makefile" <<'EOF'
.PHONY: check

check:
	@sh scripts/check-pathfinding.sh
EOF

git -C "$component" init -q -b main
git -C "$component" config user.name "documents-artifacts test"
git -C "$component" config user.email "documents-artifacts-test@example.invalid"
git -C "$component" add -A
git -C "$component" commit -qm "test: game component baseline"
