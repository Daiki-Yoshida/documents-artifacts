# State Ownership Consistency

Order placement coordinates two independent state owners.

## Ownership

- `OrderStore` owns order status (mutable order state).
- `PaymentGateway` owns payment authorization state.
- `placeOrder` is one business outcome; the application layer coordinates
  it across both owners.

The owners do **not** share a single atomic transaction — each keeps its
own state and history internally. Callers inspect owner state only via
the owners' public surface.

## Public contract

```js
const placeOrder = createPlaceOrder({ orderStore, paymentGateway });
const result = await placeOrder(orderId); // { ok: true } | { ok: false, code }
```

## Verification

```bash
npm test              # outcome invariants
npm run consistency-check
make verify           # final project gate
```
