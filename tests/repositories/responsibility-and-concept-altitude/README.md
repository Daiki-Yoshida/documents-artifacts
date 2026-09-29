# Responsibility and Concept Altitude

Small checkout project.

## Project facts

- `quoteCart` public behavior is stable and must stay stable.
- The money-like value responsibility is: currency amount, amount
  invariant, arithmetic, rendering.
- Checkout pricing policy (subtotal / discount / tax composition) is a
  **separate** responsibility from the money-like value.
- Checkout is currently the **only** consumer of the money-like value.
- There is no second consumer today.
- There is no shared domain package today.
- Future reuse is possible but is **not** a current requirement.
- `make verify` is the final verification gate.
