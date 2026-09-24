# Code Structure

Read this for general code organization after the relevant boundary has already been chosen.

## Realize bounded units, not class taxonomies

Treat software as bounded units interacting through explicit contracts.

Classes, interfaces, objects, functions, packages, and services are mechanisms. The design goal is to hide implementation detail, reduce accidental coupling, and localize change.

Implementation is replaceable while its boundary contract holds.

## Feature/module first

Prefer feature/module as the major code boundary, with technical layers inside when needed.

```text
<feature>/
  domain/
  application/
  infrastructure/
  ui/
```

Small modules may stay flat. Directory count is not the goal.

## Layer responsibilities

**Domain**
- business concepts, invariants, policy;
- no UI/infrastructure/vendor dependencies.

**Application**
- use cases and orchestration;
- owns use-case-specific ports;
- may coordinate authorization, transactions, port calls, mapping;
- does not absorb Domain invariants or technical implementation details.

**Infrastructure**
- DB/HTTP/filesystem/queue and technical implementations;
- implements project-owned contracts/ports;
- translates technical types/errors before they leak inward.

**UI**
- presentation, view state, input/output formatting;
- depends on Application;
- does not push presentation types into Domain/Application.

**Coordinate ≠ own.** A use case may coordinate several responsibilities without taking over their internal decisions.

## Contract placement

Place a contract where its **reason for existence** is owned.

```yaml
domain_contract: "Domain"
use_case_port: "Application"
technical_implementation: "Infrastructure"
```

Do not collect every interface into Domain.

## Public surface

A hardened module normally exposes a small primary public surface; keep the rest internal.

- cross-module access goes through the public surface;
- avoid deep imports into internals;
- infrastructure adapters are usually not public;
- expose only necessary use cases, contracts, boundary DTOs, factories, etc.

Additional public surfaces require a named audience, stability scope, and evolution rule.

## Interior freedom

Inside a correct boundary, procedural, functional, data-oriented, optimized, or low-level code may be used as appropriate.

Internal elegance never outranks boundary clarity, external stability, locality of change, or explicit side effects.
