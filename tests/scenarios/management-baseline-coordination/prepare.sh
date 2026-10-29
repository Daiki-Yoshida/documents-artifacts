#!/usr/bin/env bash
set -euo pipefail
[[ -n "${TARGET:-}" && -d "$TARGET/.git" ]] || { echo 'TARGET must be generated Management Root repo' >&2; exit 1; }
game="$TARGET/game"
mkdir -p "$game"
printf '# Independent Component\n' > "$game/README.md"
git -C "$game" init -q -b main
git -C "$game" config user.name "documents-artifacts test"
git -C "$game" config user.email "documents-artifacts-test@example.invalid"
git -C "$game" add -A
git -C "$game" commit -qm 'test: component baseline'
git -C "$game" switch -qc feat/combat-revision
printf 'component implementation is in progress\n' > "$game/COMBAT.md"
git -C "$game" add -A
git -C "$game" commit -qm 'test: component Work branch'
origin="$TARGET/../origin.git"
git init --bare -q "$origin"
git -C "$TARGET" remote add origin "$origin"
git -C "$TARGET" push -q origin main
cat > "$origin/hooks/pre-receive" <<'HOOK'
#!/usr/bin/env bash
set -euo pipefail
log="$(git rev-parse --git-dir)/unauthorized-push-attempts.log"
while read -r old new ref; do printf '%s %s %s\n' "$old" "$new" "$ref" >> "$log"; done
printf 'remote changes are not authorized for this run\n' >&2
exit 1
HOOK
chmod +x "$origin/hooks/pre-receive"
rm -f "$origin/unauthorized-push-attempts.log"
