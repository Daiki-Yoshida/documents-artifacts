# Project-local instructions

These rules intentionally specialize generic engineering guidance for this fixture.

- Keep the existing functional-module style. Do not introduce classes for this task.
- Public user IDs are strings and must remain strings at every public boundary.
- Source files remain under `src/modules/`; do not introduce domain/application/infrastructure directory layers.
- Tests belong under `spec/`.
- Do not edit `documents/artifacts/`; it is a managed derived snapshot.
