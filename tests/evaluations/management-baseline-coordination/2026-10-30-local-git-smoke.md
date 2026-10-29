# Issue #216 — Local Git-state smoke (not an independent agent run)

- Date: 2026-10-30 (JST)
- Initial source: documents-artifacts main `6d099edd4574e72fa179127de56145a0ccffe1f7`
- Target: `management-baseline-coordination` fixture and `tests/scripts/test-management-baseline-smoke.sh`
- Runtime: Linux, Git 2.47.3, GNU Bash 5.2.37; disposable local repositories, no network
- Agent model/effort/telemetry: **NOT APPLICABLE / NOT RUN**

## Executed checks

Actual `git init`, `git commit`, `git branch`, `git ls-tree`, and `git status` operations were executed. The authored smoke script was run twice with the same results:

```text
PASS: baseline Work Documents commit; Component unchanged; no Management branch or remote mutation
PASS: ref-specific tracking and checkout status coexist
```

For the coordination case, prepared fixture `make verify` initially failed as expected (checkpoint pending). After one locally authorized commit of the Work Document on Management `main`, the gate passed. The Management branch set remained `main` only; the Component stayed on `feat/combat-revision` with unchanged HEAD; Management `origin/main` remained unchanged; and the only Management change was the tracked Work Document.

For the Git state-coordinate case, a Work Document path was tracked on the Work branch (one tree entry), absent from `main` (zero entries), and simultaneously reported as `??` in the local `main` checkout. These are compatible Git observations, not missing history.

## Limits and next measurement

**This is a deterministic Git-state and fixture smoke, not an AI-agent blind behavioral test.** The local operator run exercised the actual fixture files with a minimal installed-guidance excerpt, not the repository's full Artifact v2 pack. The GitHub blob SHAs of the fixture `AGENTS.md`, `Makefile`, verification script, prepare hook and smoke script were checked against the locally executed files and matched.

Full repository suites `tests/test-artifacts.sh`, `tests/test-knowledge-integrity.sh` and `tests/test-agent-harness.sh`: **NOT RUN** in this execution container, which does not have a clone of the complete repository or outbound GitHub access.

Fresh independent agent, observed Artifact reads, agent decision trace and comparative before/after runs: **NOT RUN / UNVERIFIED**. The scenario supplies `PROMPT.md`, evaluator-only `EXPECTATIONS.md`, config, hook, and independent Component evidence capture for a later fresh-agent run. This smoke must not be retroactively labeled an agent PASS.

The test fixture has project-local authorization for one local baseline commit; it creates no generic entitlement to push or merge another project's baseline.
