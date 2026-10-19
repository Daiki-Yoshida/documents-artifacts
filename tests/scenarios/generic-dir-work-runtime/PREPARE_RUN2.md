# PREPARE_RUN2 — generic-dir-work-runtime second blind run

**Audience: the preparation agent and the evaluator only.**

This file is an operator prompt for preparing and conducting the second
blind run of scenario `generic-dir-work-runtime` (Issue #209). It is not
agent task input. Keep it, `EXPECTATIONS.md`, and everything derived
from them away from the blind execution agent.

The blind task prompt remains `PROMPT.md` in this directory. Do not edit
`PROMPT.md`, `EXPECTATIONS.md`, `scenario.conf`, `prepare.sh`, the
fixture `tests/repositories/work-runtime-resources/`, or any Artifact
file as part of this preparation.

## 1. Roles and session boundaries

| Role | Session | Starting point |
|---|---|---|
| Preparation agent (you) | this session | `documents-artifacts` Project Root: `/home/fuyur/projects/personal/docs/documents-artifacts` |
| Blind execution agent | a separate, fresh session | the generated `<RUN_ROOT>/generic-dir-work-runtime/repo/` |
| Evaluator | a separate session | `documents-artifacts` Project Root |

Hard requirements:

- The blind execution agent must be a fresh agent that does **not**
  already know the `documents-artifacts` Knowledge, Issue #209, its
  review discussion, or the first run's outcome. Never reuse an agent
  that has seen them.
- The only information the blind agent may receive is: the generated
  repository root path and the task in the generated `PROMPT.md`
  (copied by `prepare-agent-test.sh` into the run root).
- The blind agent must **never** receive: `EXPECTATIONS.md`, this file,
  Issue #209 review content, the fact that the first run adopted a
  `WORK=`-style selector, any `DIR=` usage example, the evaluation
  judgment, or the preparation agent's notes.
- Inside the generated repository, its own Project Documentation and
  the installed Artifact pack remain normally referenceable — that is
  the intended guidance channel.
- Judging the run outcome belongs to the evaluator, not to you.

## 2. Preconditions — verify the first-run record exists

The first run (`2026-10-15-run1`) was judged **INVALID /
NOT_EVALUATED**: the generated repository was prepared from a source
HEAD that still shipped the old Artifact blob. Its machine evidence
must already be persisted on branch `test/generic-dir-work-runtime`.

Verify before doing anything else:

```bash
cd /home/fuyur/projects/personal/docs/documents-artifacts
git fetch origin
git ls-tree -r origin/test/generic-dir-work-runtime --name-only | \
  grep '^tests/results/generic-dir-work-runtime/2026-10-15-run1/evidence/'
```

All 9 evidence files must be listed. If they are missing, **stop** and
report; do not proceed and do not recreate evidence.

## 3. Source HEAD gate

Preparation must run from a source HEAD that has the new-Artifact
integration commit as an ancestor:

```text
d7396d514781678750296245dc4908070dee80d6
```

As of this writing, `test/generic-dir-work-runtime` is based on the old
main and does **not** contain that commit. Integrate safely, keeping
both the scenario files and the first-run evidence:

```bash
cd /home/fuyur/projects/personal/docs/documents-artifacts
git switch test/generic-dir-work-runtime
git status --short            # must be clean; do not proceed over dirty state
git merge-base --is-ancestor d7396d514781678750296245dc4908070dee80d6 HEAD \
  || git merge origin/main    # regular merge commit only
```

Rules:

- Use a regular `git merge`. Do **not** rebase + force-push,
  `reset --hard`, or recreate the branch — the scenario definition and
  the run1 evidence must survive.
- Re-run the merge-base check afterwards; it must now succeed.
- If the merge has conflicts, resolve them conservatively (keep the
  scenario files, fixture, and evidence intact) or stop and report.

Then verify the distributed Artifact content — both the tree at the
branch HEAD and the actual working-tree file that `artifacts.sh` will
copy:

```bash
git ls-tree HEAD -- artifacts/execution/COMMANDS_AND_CI.md
git hash-object artifacts/execution/COMMANDS_AND_CI.md
# both must print blob 7f1fccb5ba8a8586a4af47cd541387cf0974de5f
```

Record the resulting `git rev-parse HEAD` as `SOURCE_HEAD`.

## 4. Fresh run root — complete isolation from run1

Run1 used the default run root `/tmp/documents-artifacts-agent-tests-1000`
and is dismantled. Use a distinct run root for run2; the harness
requires an absolute path outside the source repository:

```bash
export ARTIFACT_TEST_RUNS_ROOT=/tmp/documents-artifacts-agent-tests-1000-run2
# must not already exist:
test ! -e "$ARTIFACT_TEST_RUNS_ROOT/generic-dir-work-runtime" || { \
  echo "run root collides"; exit 1; }
```

Any equivalent absolute path outside the repository is acceptable, but
it must be distinguishable from run1's root. Never pass `--force` to
`prepare-agent-test.sh`, and never reuse or delete run1's root.

## 5. Docker resource isolation — inspect, do not touch

Before preparing, inspect existing Docker state. The generated repo
directory is named `repo`, so its default Compose project name is
`repo`; the fixture's named resources use the
`work-runtime-resources-*` prefix, and run1's implementation derived
Work-scoped names under the same prefix. Leftovers from run1 or from
other projects may exist.

```bash
docker compose ls --all 2>/dev/null || true
docker ps -a --format '{{.Names}} {{.Image}} {{.Status}} {{.Ports}}'
docker volume ls
docker network ls
docker ps -a --filter 'label=com.docker.compose.project=repo'
docker volume ls --filter 'name=work-runtime'
docker network ls --filter 'name=work-runtime'
docker ps -a --format '{{.Names}} {{.Ports}}' | grep -E '(:| )8080|18[0-9]{3}|19[0-9]{3}' || true
```

- If compose project `repo`, `work-runtime-resources*` volumes or
  networks, or host-port bindings (notably `8080` and the
  `18000`–`19999` Work range) already exist, **report them** in the
  preparation record. Do not reuse them, and do **not** delete,
  stop, or prune them — cleanup is a separate decision for the project
  owner.
- If the existing state would collide with the run2 environment,
  pause and report rather than improvising.
- Save the inspection output into the run-level record (see §8).
- Docker-first holds: do not install host Node/npm or other host
  toolchain substitutes. No container needs to run for this
  preparation step itself.

## 6. Prepare the run — then gate on the Artifact SHA

```bash
cd /home/fuyur/projects/personal/docs/documents-artifacts
ARTIFACT_TEST_RUNS_ROOT=/tmp/documents-artifacts-agent-tests-1000-run2 \
  bash tests/scripts/prepare-agent-test.sh \
  --scenario generic-dir-work-runtime
```

Then run **all** of these checks. Every one must pass before the blind
agent may be launched:

```bash
SRC=/home/fuyur/projects/personal/docs/documents-artifacts
RUN=/tmp/documents-artifacts-agent-tests-1000-run2/generic-dir-work-runtime
EXPECT=7f1fccb5ba8a8586a4af47cd541387cf0974de5f

# (a) source-side artifact at the recorded source HEAD
git -C "$SRC" ls-tree \
  "$(grep '^source_repo_head: ' "$RUN/RUN_METADATA.txt" | cut -d' ' -f2)" \
  -- artifacts/execution/COMMANDS_AND_CI.md | grep "$EXPECT"

# (b) the file actually present in the generated repo
git -C "$RUN/repo" hash-object \
  documents/artifacts/execution/COMMANDS_AND_CI.md | grep "$EXPECT"

# (c) the blob recorded at the generated repo's baseline tag
git -C "$RUN/repo" ls-tree artifact-test-baseline -- \
  documents/artifacts/execution/COMMANDS_AND_CI.md | grep "$EXPECT"

# (d) RUN_METADATA consistency
grep '^source_repo_head: ' "$RUN/RUN_METADATA.txt"   # == SOURCE_HEAD from §3
grep '^baseline_sha: '    "$RUN/RUN_METADATA.txt"   # == rev-parse artifact-test-baseline
git -C "$RUN/repo" rev-parse artifact-test-baseline

# (e) the recorded source HEAD contains the new-Artifact commit
git -C "$SRC" merge-base --is-ancestor \
  d7396d514781678750296245dc4908070dee80d6 \
  "$(grep '^source_repo_head: ' "$RUN/RUN_METADATA.txt" | cut -d' ' -f2)"
```

If **any** check fails: stop, do not start the blind run, and
investigate the distribution path (`artifacts.sh` →
`documents/artifacts/`). Do not rewrite SHAs, relax the expected value,
or hand-edit files inside the generated repository to force a match.

## 7. Launch the blind run

Only after every gate above passes:

- Start a fresh blind execution agent session whose working directory
  is `$RUN/repo`, with the task given by `$RUN/PROMPT.md` only.
- Record the real start/finish UTC times and the agent's model and
  runtime into `$RUN/RUN_PROVENANCE.txt` — uncomment only the keys you
  actually know (`model` is required if any key is given; never
  reconstruct values afterwards).
- If independent read observation is feasible, start
  `tests/scripts/observe-file-opens.py` at the run root before the
  agent launches, per `documents/project/AGENT_ARTIFACT_TEST_HARNESS.md`;
  it is optional and Linux-only.
- Save raw outputs of verification commands you or the agent run under
  `$RUN/verification/` (flat regular files only).
- Do not influence the agent's design; its self-reported results and
  the machine evidence are recorded separately.

## 8. Capture evidence after the run

After the blind agent finishes (and before the run root is removed):

```bash
RUN_ID="$(date -u +%F)-run2"   # must differ from 2026-10-15-run1; lowercase/digits/hyphens
bash tests/scripts/capture-agent-test.sh \
  --scenario generic-dir-work-runtime --run-id "$RUN_ID"
```

- The agent-authored `REPORT.md` belongs at
  `tests/results/generic-dir-work-runtime/<run-id>/REPORT.md`, verbatim
  — if the agent produced none, record it absent; never write one
  afterwards on its behalf. The same rule applies to observed-read
  records.
- Commit the captured results on `test/generic-dir-work-runtime` in a
  dedicated commit and push normally (no force-push).

## 9. Prohibitions (summary)

```text
no rebase/force-push/reset --hard on test/generic-dir-work-runtime
no --force to prepare-agent-test.sh; no reuse of run1's run root
no blind launch before every Artifact SHA gate passes
no rewriting SHAs, loosening expectations, or editing the generated repo
no EXPECTATIONS.md / PREPARE_RUN2.md / Issue #209 content / DIR= hints /
   run1 outcome / prep notes to the blind agent
no deleting or reusing other projects' or run1's Docker resources
no host Node/npm installation
no edits to PROMPT.md, EXPECTATIONS.md, scenario.conf, prepare.sh,
   fixture, or artifacts
no backfilling REPORT.md or read-observation records after the fact
no evaluation judgment by the preparation agent — that is the evaluator's role
```

## 10. Preparation record — report back

Report at minimum:

- `SOURCE_HEAD` actually used and confirmation it contains `d7396d5`
- result of each Artifact SHA gate check in §6, verbatim
- the run root path and run-id used
- Docker inspection summary (existing `repo` project / volumes /
  networks / port bindings found, if any) and what was left untouched
- confirmation that every gate passed before the blind launch, or the
  exact failing check and investigation result
- the captured evidence paths and the results commit SHA once pushed
