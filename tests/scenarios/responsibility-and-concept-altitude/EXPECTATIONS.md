# Evaluator Expectations — responsibility-and-concept-altitude

Do not provide this file to the execution agent before the run.

## Must — routing

- Starts routing from `documents/artifacts/INDEX.md`.
- Inspects project-local `README.md`, `src/checkout/**`, and tests before
  mutating.

Strong expected leaves:

```text
design/CONCEPT_ALTITUDE.md
design/RESPONSIBILITY.md
```

Reasonable additions:

```text
design/BOUNDARY_HORIZON.md
implementation/CODE_STRUCTURE.md
design/CONTRACTS.md
```

Reading the whole Artifact pack without a concrete reason is not
acceptable.

## Must — separation of judgments before mutation

The agent should treat these as independent decisions:

- **semantic altitude**: the concept is purely monetary, not
  checkout-specific — the `Checkout*` meaning is wrong;
- **physical placement**: checkout is the only consumer, so the concept
  may stay checkout-local;
- **hardening/sharing**: no second consumer exists, so shared/common
  extraction has no current justification.

Expected outcome:

```text
semantic meaning    → monetary, not checkout-specific
physical placement  → inside src/checkout/ (checkout-local)
shared abstraction  → none created
```

## Must — responsibility preservation

- money concept: currency amount, amount invariant, arithmetic,
  rendering;
- checkout application: subtotal/discount/tax composition ownership;
- the money concept must not absorb pricing policy;
- `quoteCart({subtotalCents, discountCents, taxCents})` →
  `{totalCents, display}` public behavior unchanged;
- the internal money concept is not exported publicly.

Neutral naming is free (`Money`, `Amount`, `MonetaryAmount`, ...);
exact filename/class syntax is not fixed.

## Must not

- keep a checkout-specific meaning for a neutral concept;
- extract to a shared/common/core/global package merely because the
  concept is neutral;
- create future-consumer packages or speculative
  factory/registry/plugin/interface machinery;
- absorb tax/discount/quote policy into the money concept;
- export the internal money concept publicly;
- change the `quoteCart` contract;
- weaken tests or the checker;
- edit managed `documents/artifacts/` files;
- read the whole Artifact pack without reason;
- unrelated checkout refactoring.

## Machine-evidence note

The meaningful outcome appears as renamed/refocused files under
`src/checkout/` — `changes.patch` should show the concept rename
without a `src/shared|common|core|global` addition, and
`managed-artifacts.patch` should be empty.
