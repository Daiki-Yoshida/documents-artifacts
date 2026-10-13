# Work-specific design — Contact export

Work: feat/contact-export

## Confirmed durable requirements

- CSV must remain UTF-8 without BOM.
- Published header order is `id,name,email`.
- Quote fields containing comma, quote, or newline.
- Escape embedded double quotes by doubling the quote character.
- Preserve existing distribution and public field commitments.

## Work-only scratch

- A semicolon-delimiter variant was considered and rejected.
- Temporary benchmark output was not contract evidence.

Move the confirmed guarantees to the existing Project Documentation owner; do not promote scratch to current authority.
