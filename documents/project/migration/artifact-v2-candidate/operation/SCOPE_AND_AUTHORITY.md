# Scope, Authority, and Clarification

Read this when deciding what the task authorizes, whether surrounding cleanup belongs in scope, or whether a question must be clarified.

## Authority order

Respect explicit user intent and explicit target-project rules.

Reusable artifact guidance is a default. If project instructions, lint/configuration, architecture rules, or a deliberate local convention conflict with it, recognize the conflict and follow the more specific project rule unless the user asks to change that rule.

## Scope discipline

When nearby problems are discovered:

- make changes required for the requested outcome;
- do not silently expand into unrelated cleanup/refactoring;
- report relevant surrounding violations when useful;
- treat broader cleanup as a separate change unless it is necessary for correctness/safety.

"While I am here" is not a scope argument.

## Clarification

Clarify when ambiguity would force you to invent caller-visible meaning, public contract, destructive scope, or another high-impact decision.

Do **not** stop for every ordinary implementation choice inside an established contract.

Confirmation effort should scale with impact.

Route specialized confirmation:
- public contract impact → `../design/CONTRACTS.md`
- destructive/reset/delete/recovery → `../safety/INDEX.md`
- documentation authority/structure → `../documentation/INDEX.md`
