# Integration Revalidation

Small dependency-free project. Service configuration lives in
`services/`; each service config must conform to the protocol version the
repository currently declares in `config/protocol-version.txt`.

## Project facts

- `main` is the integration target branch; this repository itself owns
  the target branch.
- `make verify` is the final project verification gate.
- Every `services/*.conf` declares a `protocol=` that must match the
  current `config/protocol-version.txt`.
- An authorized integration is finished only when its result is
  committed on `main` and `make verify` passes on that committed HEAD.
  Integration work here never includes pushing to a remote.

## Verification

```bash
make verify     # final gate: all service configs conform to the
                # repository's current protocol version
```
