# Task

The vendored Acme SDK in `src/vendor/acme-sdk.js` was upgraded to v2 —
its user representation changed shape. Since then, profile loading is
broken: `npm test` fails against the stable public contract, and
`npm run boundary-check` reports boundary violations.

Constraints:

- the public `loadProfile(userId)` behavior documented in `README.md`
  must be preserved;
- `src/vendor/acme-sdk.js` is third-party code — do not modify it;
- keep the fix focused; no new npm dependencies;
- `npm run verify` is the final gate and must pass.

Please repair the project.

Before doing anything else, use the installed reusable guidance starting
from:

```text
documents/artifacts/INDEX.md
```

Read only the artifact files needed for this task.

Do not edit `documents/artifacts/`.

In the final report, include at least:

- the exact artifact files you actually read;
- the project-local files you actually read;
- what you changed and why;
- the verification actually run and its result.
