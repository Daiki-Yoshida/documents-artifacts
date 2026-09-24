# Artifact v2 Promotion Validation

```yaml
document_type: "repository_local_promotion_validation"
date: "2026-09-24"
branch: "feat/artifact-v2-promotion"
content_promotion_commit: "08785223b2200cf6548b11202c0477c112202aa1"
distribution_migration_commit: "728ea48a3c40eb6bbab58721eeb46aca883613af"
main_base: "7bc486da868fd1c6d2553ab225ae18b965b1a30c"
```

## Structural validation

GitHub tree/API comparison:

```yaml
reviewed_candidate_files: 41
formal_artifact_files: 41
candidate_to_artifact_blob_mismatch: 0
legacy_runtime_artifact_files: 0
temporary_candidate_files_remaining: 0
artifact_script_mode: "100755"
artifact_test_mode: "100755"
knowledge_test_mode: "100755"
branch_vs_main:
  ahead: 2
  behind: 0
```

The promotion itself was byte-preserving: each reviewed candidate blob was reused at the corresponding `artifacts/` path.

## Distribution behavior validation

Because the environment could not clone GitHub, the branch `artifacts.sh` and `tests/test-artifacts.sh` content were reproduced in a temporary local directory and executed.

Executed:

```bash
bash -n artifacts.sh
bash -n tests/test-artifacts.sh
bash tests/test-artifacts.sh
```

Result:

```text
PASS: artifacts.sh Artifact v2 whole-pack sync/remove
```

Behavior covered by that test:

- initial whole-pack sync;
- exact replacement on update;
- stale file removal;
- legacy module removal inside the managed target root;
- preservation of project-owned sibling documentation;
- `--list` output;
- legacy `--modules` rejection;
- conflicting `--sync --remove` rejection;
- symlinked destination rejection;
- explicit whole-pack removal;
- symlinked source-pack rejection.

## Full repository validation limitation

Attempted:

```bash
git clone --depth 1 --branch feat/artifact-v2-promotion \
  https://github.com/Daiki-Yoshida/documents-artifacts.git
```

The execution environment failed before checkout:

```text
fatal: unable to access 'https://github.com/Daiki-Yoshida/documents-artifacts.git/':
Could not resolve host: github.com
```

Therefore:

```yaml
bash_n_tests_test_knowledge_integrity: "not executed against a real checkout"
tests_test_knowledge_integrity: "not executed"
reason: "execution environment DNS could not resolve github.com"
do_not_claim: "knowledge-integrity PASS"
```

The GitHub connector was used separately to verify the final branch tree, file modes, candidate/artifact blob identity, and absence of legacy runtime modules.

## CI

No `.github/workflows/` files are present in the branch, so there is no repository CI workflow that can substitute for the unavailable full-checkout execution in this environment.

## Promotion verdict

Artifact v2 content promotion and whole-pack distribution behavior are validated to the extent available in this environment.

The only unexecuted gate is the full repository `tests/test-knowledge-integrity.sh` run. This limitation must remain visible until a normal checkout environment runs it successfully.
