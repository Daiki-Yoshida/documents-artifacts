# Documentation Structural Migration Project

Small docs-only project.

- Canonical routing hub: `documents/INDEX.md`
- Durable project facts: `documents/project/`
- Operational procedures: `documents/runbooks/` (the established runbook
  convention, e.g. `incident-response.md`)

Release work follows the
[Release procedure](documents/project/RELEASE.md).

## Verification

```bash
make verify    # documentation structure gate
```
