# Development Workflow

The repository root is the Project Root for development in this Project.

Project-owned routine operations are exposed through the root `Makefile`. When an operation targets an existing Component Repository checkout, pass its directory through the named `DIR` parameter.

Supported component workflow:

```bash
make DIR=<component-directory> dev-install
make DIR=<component-directory> test
make DIR=<component-directory> verify
```

Relative `DIR` values are resolved from Project Root and represent the supplied directory itself. They do not imply a Work Identity, repository selector, branch, runtime identity, or hidden path suffix.

The final Project verification compares component state with the Project-required target in `config/pathfinding-required.txt`.

Component-local checks validate component-local invariants only and do not replace Project verification.
