# Separate Runtime Boundary Sample

Two separately deployed runtimes in one repository:

- `frontend/` — browser-facing application (separate runtime);
- `backend/` — API service (separate runtime).

They communicate only through the published wire contract in
`contracts/order-api.md`. One runtime must not import another runtime's
internals; what the wire carries is changed through the contract.

## Verification

```bash
make verify     # sh scripts/check-boundary.sh — runtime boundary guard
```
