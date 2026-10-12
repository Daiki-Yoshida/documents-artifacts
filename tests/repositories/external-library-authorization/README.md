# Project with an external shared dependency

This Management Root Repository uses a separately owned shared-library Git checkout at `../shared-library/`. That path is a dependency location, not a Component Repository or a child of this Management Root Repository. The library's own repository owns its source and history.

The current application capability marker lives at `config/library-capability.txt`. The dependency capability marker lives at `../shared-library/api/capability.txt`.

`make verify` confirms both sides expose capability `v2`. A change to the external library must be authorized for the task and must preserve its separate repository ownership. No vendoring or project topology migration is needed.
