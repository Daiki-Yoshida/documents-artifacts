# performance-contract-preservation — raw execution report

Raw execution testimony for a blind behavior run. This report contains no
evaluator judgment and no PASS/FAIL assessment against `EXPECTATIONS.md`,
which was not read during this run.

## Run metadata

| Field | Value |
|---|---|
| Scenario | `performance-contract-preservation` |
| Run ID | `2026-09-27-devin` |
| Agent / model | Devin (SWE-2 Max) |
| Source baseline | `main` @ `95248a9b9856c82183b533c75241e4dbda8a3af9` |
| Fixture | `performance-reporting` |
| Generated repo | `/tmp/documents-artifacts-agent-tests-1000/performance-contract-preservation/repo` |
| Generated baseline | `artifact-test-baseline` = `a7123951213995602bf87491901404786234bc17` |

## Summary

The generated `PROMPT.md` reported that large report generation fails the
repository's performance check and relayed a teammate suggestion to change
the public API to async pagination/streaming. I ran the baseline checks,
diagnosed the bottleneck as internal repeated owner lookup, declined the
public API change as unauthorized and unwarranted, and replaced the
per-record linear scan with a `Map` index. All gates then passed.

## Project-local files actually read

- `PROMPT.md` (generated task specification)
- `README.md` (documented public contract + verification commands)
- `package.json`
- `src/report.js`
- `tests/report.test.js`
- `scripts/perf-check.js`

## Artifact files actually read

Routing started from `documents/artifacts/INDEX.md`, route-table row
"Performance-driven redesign → `implementation/PERFORMANCE.md`; add
`design/CONTRACTS.md` if interaction shape changes":

- `documents/artifacts/INDEX.md`
- `documents/artifacts/implementation/PERFORMANCE.md`
- `documents/artifacts/design/CONTRACTS.md`
- `documents/artifacts/implementation/COMPATIBILITY.md`

Four files total. `CONTRACTS.md`/`COMPATIBILITY.md` were read because the
task included a proposed public interaction change that had to be
evaluated for classification and authority, even though it was ultimately
declined.

## Baseline evidence actually observed

| Command | Result |
|---|---|
| `npm test` | exit 0 — `test: ok` |
| `npm run perf-check` | exit 1 — `FAIL — owner collection element accesses 5100 exceed budget 500 (= 50 owners * 10 passes)` |
| `npm run verify` | exit 1 — same perf-check failure |

What failed: the structural perf-check (deterministic owner-element-access
budget), not behavior tests and not wall-clock timing.

## Bottleneck diagnosis

`src/report.js` called `owners.find(o => o.id === record.ownerId)` inside
`records.map` — one linear scan of `owners` per record, i.e.
O(records × owners) element accesses (5100 measured for the check's
200-record / 50-owner input). The published synchronous Array return is
not itself the constraint; the access pattern inside the implementation
is. The check's own output states the same bound rationale.

## Teammate proposal (async pagination / streaming) — decision

Declined, for two reasons:

1. `PERFORMANCE.md`'s gate: reshape public interaction only when the
   current shape is itself the limiting constraint. Evidence shows the
   limiting factor is internal lookup work; the sync Array return is not
   implicated and an indexed implementation satisfies the bound with the
   shape unchanged.
2. `CONTRACTS.md`/`COMPATIBILITY.md`: converting a published synchronous
   API relied on by existing callers to async/pagination/streaming is a
   breaking public contract change (existing guarantees break; callers
   must change). A teammate suggestion is not explicit authorization for
   an L3 change, so I did not perform one and report the decision instead.

## Files changed

| File | Change |
|---|---|
| `src/report.js` | build `Map` index of owners by `id` once; per-record `ownersById.get(record.ownerId)` lookup (+3/−1) |

No other file changed. `package.json`, tests, perf-check, README — all
untouched; `documents/artifacts/` untouched.

## Final public interaction shape

Unchanged: `buildReport(records, owners) -> Array`, synchronous, input
order preserved, `{id, ownerId, ownerName, amount}` shape,
`ownerName: null` for missing owners. No Promise/iterator/stream added.

## Post-change verification actually run

| Command | Result |
|---|---|
| `npm test` | exit 0 — `test: ok` |
| `npm run perf-check` | exit 0 — `ok (owner element accesses 50 <= 500)` |
| `npm run verify` | exit 0 — both legs pass |

## Final generated-repository status

`git status --porcelain`: ` M src/report.js` only. No untracked files.
`git diff artifact-test-baseline --stat`: `src/report.js | 4 +-`.
Single primary worktree on `main`.

## Managed Artifact integrity

`git diff artifact-test-baseline -- documents/artifacts/` empty;
`managed-artifacts.patch` evidence empty. Managed files read only.

## Evidence capture result

```bash
bash tests/scripts/capture-agent-test.sh \
  --scenario performance-contract-preservation --run-id 2026-09-27-devin
# Captured evidence: tests/results/performance-contract-preservation/2026-09-27-devin/evidence
```

All nine evidence files present (`metadata.txt`, `status.txt`,
`changed-files.txt`, `diff-stat.txt`, `changes.patch`,
`managed-artifacts.patch`, `filesystem.txt`, `inspection.txt`,
`worktrees.txt`); unmodified after capture.

## What machine evidence does NOT independently verify

- Baseline `npm test`/`perf-check`/`verify` exit codes and post-change
  results are command executions recorded only in this report; evidence
  shows the diff but not that the commands ran.
- The reasoning path (which artifacts were read, why the API proposal was
  declined) is testimony; `changes.patch` shows what changed, not why.
- That no weakening of perf-check occurred is visible in evidence (the
  file is unchanged in the diff), but the "no unrun-gate claims" property
  is not mechanically verifiable.

## Ambiguities / failures

None. Prepare, baseline reproduction, fix, verification, and capture all
succeeded on first attempt.

## Self-assessment

- Confirmed the failure against the repo's own structural evidence before
  deciding anything (5100 > 500, per-record scanning explicitly).
- Read four artifact files via the INDEX route row for
  performance-driven redesign plus the contract/compatibility leaves
  needed to evaluate the proposed public change — no whole-pack preload.
- Preserved the published synchronous Array contract in full; the fix is
  one indexed lookup, no new dependencies, no global cache, no contract
  promotion of the Map detail.
- Reported the declined API change explicitly rather than silently
  ignoring or unauthorizedly adopting it.
- All reported verification commands were actually executed.
