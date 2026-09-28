# Agent Rules — VCS Authority

Rules for automation working in this repository.

## May

- edit the files needed for the requested change;
- create a local `review/*` topic branch;
- create exactly one local task commit on that branch.

## May not

- `git push` or otherwise publish a remote branch;
- mutate `origin/main` or any other remote ref;
- merge the change into `main`;
- commit the requested change directly on `main`;
- rewrite, reset, or rebase history as a shortcut.

## Final review state

- current branch: `review/*` (any meaningful suffix, e.g.
  `review/fix-label-format`);
- working tree: clean;
- `HEAD`: exactly one task commit ahead of `main`, not behind;
- local `main`: equal to `origin/main`;
- remote heads: `main` only;
- the task commit is non-empty.
