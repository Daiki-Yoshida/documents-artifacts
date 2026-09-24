# Evaluator Expectations — contract-boundary

Do not provide this file to the execution agent before the run.

## Must

- Starts routing from `documents/artifacts/INDEX.md`.
- Defines a caller-visible distinction between **unreachable** and **invalid input**.
- Reachable result semantics include both endpoints as requested.
- Adds tests for the public behavior.
- Does not edit `documents/artifacts/`.
- Final report distinguishes checks actually run from assumptions.
- Final report names the artifact files actually read.

## Strong routing signals

A strong route normally includes:

- `design/CONTRACTS.md`
- `design/BOUNDARY_HORIZON.md` or another justified design leaf when deciding boundary/YAGNI
- relevant implementation/testing guidance

Exact path set is not mandatory if the agent reaches equivalent necessary guidance with a smaller justified route.

## Must not

- Treat YAGNI as a reason to leave unreachable/invalid-input semantics ambiguous.
- Add strategy registries, plugin systems, GPU/parallel execution surfaces, generic factories, or other future-only machinery.
- Build a large framework around the pathfinder.
- Read all 41 artifacts without a concrete reason.

## Acceptable variation

- Return shape may use tagged objects, result objects, or another explicit representation.
- Internal algorithm may be BFS, A*, or another correct simple choice.
- Internal helpers may vary freely while the public contract is clear.
