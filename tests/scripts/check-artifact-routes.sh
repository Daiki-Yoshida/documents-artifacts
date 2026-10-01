#!/usr/bin/env bash
# check-artifact-routes.sh — validate advertised runtime path references
# and transitive reachability from the pack root INDEX.md.
#
# Reference syntax (supported, documented):
#   Advertised runtime references are inline-backtick tokens naming a
#   Markdown file that resolves inside the pack relative to the
#   containing file's directory:
#     `category/FILE.md`   (pack-root-relative, used by the root INDEX)
#     `../category/FILE.md` (sibling-category reference inside subdirs)
#     `FILE.md`            (same-directory reference)
#   Only tokens ending in `.md` (fragment stripped first) are route
#   candidates — prose like `input/output` is never a route.
#   Fenced code blocks are excluded: ``` examples are documentation,
#   not advertised routes.
#   Project-owned / external example tokens are NOT runtime edges:
#     - `documents/...` / `docs-jp/...`     (project documentation space)
#     - bare `AGENTS.md` / `CLAUDE.md` / `GEMINI.md` / `README.md`
#       (project entry-point filenames — the exemption applies ONLY to
#       bare tokens: a directory-prefixed `implementation/README.md` is
#       an advertised runtime path, exempt or broken by resolution)
#   Any other .md token that fails to resolve to a real file inside the
#   pack is a BROKEN advertised route — this is the regression target.
#   Optional `#fragment` anchors are stripped before classification;
#   anchor validity is not checked (none are currently advertised).
#
# Reachability: every pack .md file must be reachable from INDEX.md via
# advertised edges. Cycles are fine (visited set terminates traversal).
# This is mechanical validity only — it does not establish meaningful
# routing, actual reads, or comprehension.
#
# Usage: check-artifact-routes.sh <pack-dir>   (pack-dir = artifacts/)
set -euo pipefail

PACK="$(realpath -m -- "${1:?usage: check-artifact-routes.sh <pack-dir>}")"
ROOT="$PACK/INDEX.md"
fail() { printf 'FAIL: %s\n' "$*" >&2; exit 1; }

[[ -f "$ROOT" ]] || fail "pack root INDEX.md missing: $PACK"

is_external_example() {
    local t="$1"
    [[ "$t" == documents/* || "$t" == docs-jp/* ]] && return 0
    # entry-point names exempt only as bare tokens — a directory-prefixed
    # `implementation/README.md` is an advertised runtime path
    if [[ "$t" != */* ]]; then
        case "$t" in
            AGENTS.md|CLAUDE.md|GEMINI.md|README.md) return 0 ;;
        esac
    fi
    return 1
}

declare -A EDGES=()
declare -A ISFILE=()
broken=0
refs=0
examples=0

while IFS= read -r f; do
    rel="${f#"$PACK"/}"
    ISFILE["$rel"]=1
done < <(find "$PACK" -name '*.md' -type f | sort)

for f in "${!ISFILE[@]}"; do
    file="$PACK/$f"
    fdir="$(dirname -- "$f")"
    while IFS= read -r raw; do
        tok="${raw#\`}"; tok="${tok%\`}"
        # candidate path tokens: no whitespace and `.md`-suffixed after
        # fragment normalization — slash prose and non-file tokens are
        # never routes
        [[ "$tok" == *[[:space:]]* ]] && continue
        t="${tok%%#*}"
        [[ "$t" == *.md ]] || continue
        resolved="$(realpath -m -- "$PACK/$fdir/$t")"
        res_rel="$(realpath -m --relative-to "$PACK" "$resolved")"
        if [[ "$res_rel" == ..* || "$res_rel" == /* \
                || ! -f "$PACK/$res_rel" ]]; then
            # not a resolvable pack file — allowed only as a declared
            # project-owned example token
            if is_external_example "$t"; then
                examples=$((examples + 1))
                continue
            fi
            refs=$((refs + 1))
            if [[ "$res_rel" == ..* || "$res_rel" == /* ]]; then
                printf 'BROKEN: %s -> %s resolves outside pack\n' \
                    "$f" "$tok" >&2
            else
                printf 'BROKEN: %s -> %s has no target file\n' \
                    "$f" "$tok" >&2
            fi
            broken=$((broken + 1))
            continue
        fi
        refs=$((refs + 1))
        EDGES["$f"]="${EDGES[$f]:-} $res_rel"
    done < <(awk '/```/{f=!f; next} !f' "$file" \
        | grep -oE '`[^`]+`' || true)
done

[[ "$broken" -eq 0 ]] || fail "$broken broken advertised route(s)"

# Transitive reachability from INDEX.md (BFS; cycles terminate via SEEN)
declare -A SEEN=()
queue=("INDEX.md")
SEEN["INDEX.md"]=1
while ((${#queue[@]})); do
    cur="${queue[0]}"
    queue=("${queue[@]:1}")
    for tgt in ${EDGES[$cur]:-}; do
        [[ -n "${SEEN[$tgt]:-}" ]] && continue
        SEEN["$tgt"]=1
        queue+=("$tgt")
    done
done

unreachable=0
for f in "${!ISFILE[@]}"; do
    [[ -n "${SEEN[$f]:-}" ]] && continue
    printf 'UNREACHABLE: %s (no advertised route from INDEX.md)\n' "$f" >&2
    unreachable=$((unreachable + 1))
done
[[ "$unreachable" -eq 0 ]] || fail "$unreachable unreachable file(s)"

printf 'route check: %d advertised refs, %d files, %d reachable, %d example tokens skipped\n' \
    "$refs" "${#ISFILE[@]}" "${#SEEN[@]}" "$examples"
