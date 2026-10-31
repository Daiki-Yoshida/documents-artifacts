# Scope, Authority, and Clarification

Read this when deciding what the task authorizes, whether surrounding cleanup belongs in scope, or whether a question must be clarified.

## Authority order

Respect explicit user intent and explicit target-project rules.

Apply the RuleClass semantics in the root `../INDEX.md`: **RC3** contracts bind when their conditions apply, **RC2** choices are defaults with reasoned alternatives, and **RC1** details belong to the Project. Respect explicit user intent and project-local rules that specialize these contracts. If an explicit local policy truly conflicts with an applicable RC3 contract, surface that decision to the Owner instead of silently treating the requirement as optional or overwriting the local policy.

## Scope discipline

When nearby problems are discovered:

- make changes required for the requested outcome;
- do not silently expand into unrelated cleanup/refactoring;
- report relevant surrounding violations when useful;
- treat broader cleanup as a separate change unless it is necessary for correctness/safety.

"While I am here" is not a scope argument.

## Local write boundary

For ordinary project-owned changes, resolve the Management Root Repository's Project Root and use authorized locations within it. When alternate checkout or scratch space is needed, first evaluate a project-contained location according to `../project/WORKSPACE.md`.

Before writing outside that boundary, resolve the effective target, purpose, necessity, ownership, user/project authorization, and side effects. Paths, directory selectors, and tool access are not authorization on their own.

Task-relevant, permitted read-only inspection outside the Project Root is allowed. Explicitly authorized changes to external dependencies, project-declared resources, or host/Docker configuration may proceed within their delegated scope and applicable safety gates. A managed external test root is valid when isolation requires it.

If a necessary external write lacks authorization, continue safe in-scope diagnosis or an internal alternative where possible; seek confirmation only for the remaining unauthorized effect. Structural relocation and destructive/host operations must follow `../safety/INDEX.md`.

## Clarification

Clarify when ambiguity would force you to invent caller-visible meaning, public contract, destructive scope, or another high-impact decision.

Do **not** stop for every ordinary implementation choice inside an established contract.

Confirmation effort should scale with impact.

Route specialized confirmation:
- public contract impact → `../design/CONTRACTS.md`
- destructive/reset/delete/recovery → `../safety/INDEX.md`
- documentation authority/structure → `../documentation/INDEX.md`
