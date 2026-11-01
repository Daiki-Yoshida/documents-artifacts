# RuleClass Work review — 2026-11-01

## Source event and scope

- Work: `feat/rule-class-contract`; Issue #219; PR #220.
- User message (current conversation, no persistent message URL; manually
  transcribed from visible chat, exact byte-level equivalence not established):
  ~~~~text
  Ai行動テストは実践で行いたい。　なので、mainにマージできる品質かあなた自身でチェックしてもらえない？
  ~~~~
- Follow-up message (same source/boundary):
  ~~~~text
  続けて
  ~~~~
- These messages authorize continued review of the branch and defer artificial
  fresh-agent behavior evaluation; they do not automatically approve a merge.

## Findings and corrections

1. Existing `tests/test-knowledge-integrity.sh` retained the previous
   `FORMAT_AND_GIT.md` prose literal. The new RC1 wording made the
   assertion necessarily fail; updated the assertion to validate the new
   RC1 contract (commit `70088e88327d8fd3ee99d9f25fe4adc0f3f5c74f`).
2. The runtime Work Identity gate omitted valid prior Owner delegation while
   canonical guidance included it. Aligned both canonical and runtime,
   preserving explicit confirmation as the normal path (commits
   `70088e88327d8fd3ee99d9f25fe4adc0f3f5c74f`,
   `e40a258b222a4c3bc53b254e9e4b1775a28354c6`).
3. Python test fixtures produced untracked `__pycache__` after
   `make verify`. Reproduced in a disposable Git checkout and fixed
   with project-local fixture `.gitignore` entries (commit
   `4b6b67b87ff53ea9342c675b4ae717219aae2ba6`).
4. The fresh-adoption fixture README itself mentioned Work Identity,
   compromising blind discovery of the Artifact RC3 contract. Removed
   the hint and added an integrity assertion that the three Project entry
   surfaces do not leak the answer (commit
   `eedb4de9c34ff656cef0a72238b212331b0e48c1`).

## Verification actually performed

- Existing `test-knowledge-integrity.sh` assertions against changed source
  strings: **20/20 PASS**, inspected using a static in-memory checker on
  the current GitHub files; not a shell-suite invocation.
- Nine changed Artifact Markdown files: **55 inline file references**,
  **0 unresolved** relative to GitHub's complete 42-file Artifact tree.
  This checks modified-file references, not all 42 files' reachability.
- The two Python fixtures, reproduced from the checked-in source in
  disposable local directories: initial `make verify` **EXPECTED FAIL**,
  corrected function **PASS** for both cases. Original function Git blob:
  `823b4a29e6e9cc42e677ef0053521ad933a21442`.
- A disposable local Git checkout produced untracked
  `src/__pycache__/` and `tests/__pycache__/` without ignore; adding
  `__pycache__/` and `*.py[cod]` eliminated the untracked changes.
- Original Issue #219 body and RC adoption comment persisted in the
  new source record were compared with current connector reads:
  both **exact string equality**.

## Evidence limitations and remaining gate

- `bash tests/test-artifacts.sh`: NOT RUN.
- `bash tests/test-knowledge-integrity.sh`: NOT RUN.
- `bash tests/test-agent-harness.sh`: NOT RUN.
- Fresh independent AI runs and actual consuming-Project field behavior:
  NOT RUN (the latter intentionally deferred per Owner).
- The available local container had no full repository checkout and
  could not resolve github.com for a clone/archive. No GitHub Actions,
  paid runner, external deployment, or target Project sync was performed.

This record distinguishes the review's evidence from an executable full
suite or an AI behavior PASS. Keep PR/main integration as a separate
Owner/VCS decision.
