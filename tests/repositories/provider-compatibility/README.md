# Provider Compatibility Sample

Small dependency-free Node project with a published Provider contract.

## Provider contract

- `src/provider-contract.js` defines the published **Provider contract**;
  external and third-party implementers build providers against it.
- `send(message)` is currently the only **required** member.
- A provider implementing only `send` is valid under the current
  published guarantees.
- Backward compatibility of the published contract is part of this
  project's release contract: existing external providers must remain
  valid across releases unless an explicit migration is agreed.

`src/legacy-provider.js` vendors a provider implementation equivalent to
an existing third-party implementer; it is kept to prove that providers
valid under the published contract stay valid.

## Verification

- `npm test` — behavior checks for gateway/provider interaction.
- `npm run compatibility-check` — verifies every registered provider
  satisfies the contract's required members.
- `npm run verify` — final verification gate: behavior tests +
  compatibility check.
