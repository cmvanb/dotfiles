---
name: worktree
description: Run new branch work in its own git worktree with `wt` (worktrunk), from creation through removal. Invoke with /worktree before work on a new branch starts.
disable-model-invocation: true
---

# Worktree

Do the work for a new branch in its own git worktree.
You own the worktree from creation to removal.
For each `wt` command, `wt <command> --help` gives the full reference.

## Create the worktree

1. Record the path of the main checkout.
2. Name the branch by the rules of the `git` skill.
3. Create the branch and its worktree:

   ```bash
   wt switch --create <branch> --no-cd --format json
   ```

   The branch starts from the default branch.
   To start from another branch, add `--base <branch>`.
   The agent shell cannot follow a `wt` directory change, so `--no-cd`
   keeps it in place.
4. Read `path` from the JSON output.
5. If the harness can move the session to another directory, move it to
   `path`.
   Otherwise, run every command with `path` as its working directory.

## Work in the worktree

- The invocation of this skill approves writes inside `path`.
- Read and write only inside `path`.
  Leave the main checkout unchanged.
- Commit and push by the rules of the `git` skill.
- Run `wt list` to see the state of each worktree.

## Remove the worktree

Remove the worktree when the default branch contains the work, or when the
user abandons it.
If the work ends with an open pull request, keep the worktree and report its
path and branch.

1. Stop every process that you started in the worktree.
2. Move the session back to the main checkout.
3. Remove the worktree:

   ```bash
   wt remove <branch> --foreground
   ```

   `wt` deletes the branch only when the default branch contains its
   changes. Squash merges count.
4. Run `wt list` and confirm that the worktree is gone.

To merge locally without a pull request, get explicit approval first.
Then move the session back to the main checkout and run
`wt -C <path> merge`.
It rebases the branch onto the default branch, fast-forwards the default
branch, and removes the worktree.

> [!CAUTION]
> If `wt remove` refuses, report the reason and wait.
> `--force` deletes uncommitted changes and `-D` deletes unmerged commits.
> Use them only with explicit approval.
