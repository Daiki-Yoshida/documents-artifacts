# Contact CLI

This small Bash-only project provides a staff-facing contact-name preview and a machine-consumed batch export. Neither operation requires external services, runtimes or package installation.

Run from the repository root:

```bash
bash bin/contactctl preview '  Ada   Lovelace  '
bash bin/contactctl export '  Ada   Lovelace  '
```

The entry point for project-owned contracts and verification is `documents/INDEX.md`. The preview is intended for staff readability; the export is a published format consumed by another system.

## Verification

```bash
bash tests/test-preview.sh
bash tests/test-export.sh
bash scripts/verify.sh
```

`bash scripts/verify.sh` is the project's complete final gate. Use no external network or dependency installation.
