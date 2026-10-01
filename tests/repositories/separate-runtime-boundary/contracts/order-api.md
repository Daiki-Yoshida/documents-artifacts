# Order API — published wire contract

`GET /orders` returns a JSON array of order objects.

| Field | Type | Notes |
|---|---|---|
| `id` | string | stable order id |
| `status` | string | `new` / `paid` / `shipped` |

Both deployables evolve this contract together. The contract — not
another runtime's internals — defines what crosses the wire.
