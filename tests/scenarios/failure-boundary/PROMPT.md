# Task

Add a public async `reserveItem(sku)` capability to this repository.

Requirements:

- `sku` is always a valid non-empty string for this task. Behavior for inputs outside that domain is not part of this task.
- A successful reservation returns the project's standard successful outcome carrying the created reservation.
- An out-of-stock item must be distinguishable to callers as an expected business failure.
- A vendor timeout or unavailability must not expose the vendor's exception type as public meaning.
- The capability must remain asynchronous.
- Add meaningful tests and run the verification available in the repository.
- Do not add validation, frameworks, or abstractions that are not required.

Before changing code, use the installed reusable guidance starting from:

```text
documents/artifacts/INDEX.md
```

Read only the artifact files needed for this task.

Do not edit `documents/artifacts/`.

In the final report, include the exact artifact files you actually read and the verification actually run.
