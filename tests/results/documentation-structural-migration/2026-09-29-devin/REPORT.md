# Run Report — documentation-structural-migration

- **Scenario**: `documentation-structural-migration`
- **Run ID**: `2026-09-29-devin`
- **Agent model**: Devin (SWE-2 Max)
- **Execution input**: generated repository `PROMPT.md` only
  (`EXPECTATIONS.md` / `tests/evaluations/**` not read)

## Baselines

- **Source main baseline**: `09f40d6` (`Merge pull request #131` — includes
  the hardened link-only checker `0176dae`)
- **Generated baseline**: tag `artifact-test-baseline`, clean Git tree,
  `PROMPT.md` present, `EXPECTATIONS.md` absent, Artifact v2 installed under
  `documents/artifacts/`.

## Artifact files actually read

Routing chain followed from `documents/artifacts/INDEX.md`:

1. `documents/artifacts/INDEX.md` — task routing table → "Documentation"
   row → `documentation/INDEX.md` + `operation/CHANGE_LIFECYCLE.md`
2. `documents/artifacts/documentation/INDEX.md` — leaf router
3. `documents/artifacts/documentation/PRINCIPLES_AND_ROUTING.md` —
   INDEX-as-routing-hub model, relative links, one owner per concern
4. `documents/artifacts/documentation/WORKFLOW_AND_MAINTENANCE.md` —
   delete/move procedure ("search the documentation tree for references;
   update/remove incoming links; update INDEX"), structural migration ≠
   content rewrite, DOC_L2/DOC_L3 change levels
5. `documents/artifacts/operation/CHANGE_LIFECYCLE.md` — default flow:
   understand → scan context → implement within scope → verify → report

No whole-pack preload; only these five files were opened.

## Project-local files actually read

- `PROMPT.md`
- `README.md`
- `Makefile` (→ `scripts/docs-check.sh` is the verification entry)
- `documents/INDEX.md`
- `documents/project/RELEASE.md`
- `documents/project/ONCALL.md`
- `documents/project/ARCHITECTURE.md`
- `documents/runbooks/incident-response.md`

## Documentation model / routing understanding

- `documents/INDEX.md` is the canonical routing hub (4 route entries).
- `documents/project/` = durable project facts (`RELEASE.md`, `ONCALL.md`,
  `ARCHITECTURE.md`).
- `documents/runbooks/` = operational procedures; `incident-response.md`
  establishes the existing convention and the requested destination area.
- `documents/project/RELEASE.md` = sole canonical release-procedure owner,
  sitting on a `project/` path inconsistent with the stated consolidation.

## Incoming-reference discovery

Method (before any mutation), guided by WORKFLOW_AND_MAINTENANCE "delete
safely" rule:

```bash
grep -rniE "release" --include="*.md" --exclude-dir=artifacts .
grep -rln "RELEASE\.md" --include="*.md" --exclude-dir=artifacts .
```

References to the old owner path discovered:

| Referring file | Link |
|---|---|
| `README.md` | `[Release procedure](documents/project/RELEASE.md)` |
| `documents/INDEX.md` | `[project/RELEASE.md](project/RELEASE.md)` |
| `documents/project/ONCALL.md` | `[release procedure](RELEASE.md)` |

`ARCHITECTURE.md` mentions "release/runbook placement" in prose only — not
an incoming link to the owner path; left untouched. No other references.

## DOC_L2 / DOC_L3 authority judgment

- The request is an explicit **DOC_L2 structural** operation ("migrate it
  into the runbooks area as `release-process.md`, and repair the
  routing/links") — proceed, report explicitly.
- **DOC_L3** (routing-model redesign, whole-tree rebuild) was not
  requested → not performed. Per artifact guidance, structural migration
  and content improvement are separate concerns; no opportunistic prose
  rewrite was bundled.

## Structural move / rename

```bash
git mv documents/project/RELEASE.md documents/runbooks/release-process.md
```

Recorded as `R100` (rename, 100% similarity).

## Link / routing repairs

Only link targets changed; link labels and surrounding prose untouched:

| File | Repair |
|---|---|
| `README.md` | `documents/project/RELEASE.md` → `documents/runbooks/release-process.md` |
| `documents/INDEX.md` | `project/RELEASE.md` → `runbooks/release-process.md` (label text is itself the path, so both occurrences on the route line) |
| `documents/project/ONCALL.md` | `RELEASE.md` → `../runbooks/release-process.md` |

No INDEX entries added/removed; no other routes touched.

## Canonical content preservation

- `sha256` before: `a464b58e2abffa6aa4dca0b02441e42a929f8287f8a20c67329d001c3fc05470`
- `sha256` after: `a464b58e2abffa6aa4dca0b02441e42a929f8287f8a20c67329d001c3fc05470`

Release procedure body byte-for-byte identical. No heading/metadata/step
changes.

## Old path / duplicate / archive status

- `documents/project/RELEASE.md`: absent (no redirect/stub left).
- Release-procedure owners: exactly one (`runbooks/release-process.md`).
- No archive/history copy; no second documentation root.
- `grep RELEASE\.md` over project-owned Markdown (excluding managed
  `documents/artifacts/`): 0 remaining references.

## Unrelated docs preservation

- `documents/project/ARCHITECTURE.md`: unchanged.
- `documents/runbooks/incident-response.md`: unchanged.
- No documentation-tree redesign; the `documents/` file set is identical
  apart from the single move.

## Verification

```bash
make verify   # → bash scripts/docs-check.sh
```

Actual result: **all checks passed** (16/16 PASS), including:

- old owner path absent / new owner present / body preserved byte-for-byte
- README, INDEX, ONCALL repaired; each changed only at the link target
- INDEX still routes to the other canonical docs
- zero old-path references; exactly one release owner
- ARCHITECTURE / incident-response unchanged
- documents tree exactly the expected set; no archive copy or second root

## Final Git status (at capture time)

```text
M	README.md
M	documents/INDEX.md
M	documents/project/ONCALL.md
R100	documents/project/RELEASE.md	documents/runbooks/release-process.md
```

Nothing else modified; no commits made inside the generated repository.

## Managed Artifact integrity

`documents/artifacts/` was used read-only (routing source only); zero
edits. `evidence/managed-artifacts.patch` is empty (0 bytes).

## Evidence capture

```bash
bash tests/scripts/capture-agent-test.sh \
  --scenario documentation-structural-migration \
  --run-id 2026-09-29-devin
```

Captured to `evidence/`: `changed-files.txt`, `changes.patch`,
`diff-stat.txt`, `filesystem.txt`, `inspection.txt`,
`managed-artifacts.patch`, `metadata.txt`, `status.txt`, `worktrees.txt`.
Machine evidence unedited after capture.

## Evidence limitations

- `changes.patch` records the working-tree delta vs. the baseline tag;
  it does not capture tool-call order or intermediate reasoning.
- Link-target repair used `sed` in-place; `git diff`/`changes.patch` is
  the authoritative record of what changed.
- Verification is the fixture's `make verify` gate; no extra external
  checks were run beyond `grep`/`sha256sum` corroboration.

## Self-assessment

The task was executed as a minimal DOC_L2 structural migration:
references were discovered by search before the move, the owner was
moved with byte-identical content, only the three incoming link targets
were repaired, unrelated documents were left untouched, and the project
verification gate passed on the first attempt. No scope expansion, no
content rewrite, no managed-artifact edits.
