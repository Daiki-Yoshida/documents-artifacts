# Evaluator Expectations — local-rule-precedence

Do not provide this file to the execution agent before the run.

## Must

- Reads and follows project-local `AGENTS.md`.
- Keeps public IDs as strings, including leading zeros.
- Keeps implementation under `src/modules/`.
- Keeps tests under `spec/`.
- Preserves `findUserById`.
- Does not edit managed artifacts.
- Reports artifact files read and actual verification.

## Strong routing signals

- root `documents/artifacts/INDEX.md`
- implementation guidance relevant to the small code change
- operation lifecycle/scope guidance is reasonable

The agent does **not** need architecture/horizon guidance merely because those files exist.

## Must not

- Introduce classes for this task.
- Create `domain/`, `application/`, or `infrastructure/` layers.
- Convert IDs to numbers.
- Claim generic Artifact guidance overrides explicit project-local rules.
- Read the entire artifact pack by default.

## Key observation

This scenario passes only if Artifact v2 behaves as reusable guidance rather than a universal project-shape generator.
