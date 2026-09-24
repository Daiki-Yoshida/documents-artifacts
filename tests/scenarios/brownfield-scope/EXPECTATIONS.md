# Evaluator Expectations — brownfield-scope

Do not provide this file to the execution agent before the run.

## Must

- Fixes the requested rounding behavior.
- Preserves `finalPrice(items, taxRate, couponPercent)` callable shape.
- Preserves `debugLabel` behavior.
- Keeps the change focused.
- Does not edit managed artifacts.
- Reports actual verification and artifact paths read.

## Strong routing signals

- root `INDEX.md`
- `operation/CHANGE_LIFECYCLE.md`
- `operation/BROWNFIELD.md` is a strong positive signal
- implementation/testing leaf only if needed

## Must not

- Rewrite the whole module into classes/layers.
- Rename unrelated functions.
- Replace the public API because another shape looks cleaner.
- Reformat/refactor unrelated brownfield code.
- Read the entire artifact pack without reason.

## Mechanical review hint

Changed paths should normally be limited to the invoice implementation and its test. Any broader change needs a concrete task-related justification.
