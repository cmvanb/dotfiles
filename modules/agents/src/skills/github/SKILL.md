---
name: github
description: Drive GitHub from the CLI with `gh` and `gh stack`. Covers pull requests, stacked PRs, CI checks, issues, reviews, and API calls. Use when a git remote points at github.com, or when working with GitHub PRs, stacks, issues, or Actions.
---

# GitHub

Use `gh` for repository operations, `gh stack` for stacked pull requests,
and `gh api` for endpoints that `gh` omits.

## Set up

Verify authentication before any other call:

```bash
gh auth status
```

If `gh stack` is missing, install the extension:

```bash
gh extension install github/gh-stack
```

`gh` resolves the repository from the current checkout.
Pass `-R <owner>/<repo>` to target another repository.

## Pull requests

Format PR descriptions and comments with the `platform-markdown` skill.
Pass bodies through `--body-file -` with a quoted heredoc `'EOF'` so shell
expansion leaves `$` and backticks intact.

```bash
gh pr create --base <branch> --title "<title>" --body-file - <<'EOF'
Body text.
EOF
```

Common operations:

```bash
gh pr view <id> --json number,url,title,body,state,isDraft,baseRefName,headRefName,statusCheckRollup
gh pr edit <id> --base <branch>
gh pr edit <id> --title "<title>" --body-file - <<'EOF'
Updated body.
EOF
gh pr ready <id>
gh pr checks <id> --required
```

> [!CAUTION]
> Always retarget a pull request with `gh pr edit <id> --base <branch>`.
> Closing and recreating a pull request destroys reviews, comments, and
> history.

Inspect failed Actions runs directly:

```bash
gh run view <run-id> --log-failed
```

## Stacked PRs

Use `gh stack` whenever building or managing stacked pull requests.

| Task | Command |
| --- | --- |
| Start a stack from trunk or existing branches | `gh stack init [b1 b2 ...]` |
| Start a stack from a custom trunk | `gh stack init --base <branch> [b1 ...]` |
| Add a layer on top of the stack | `gh stack add [branch]` |
| Inspect stack branches and PR status | `gh stack view --short` or `gh stack view --json` |
| Fetch, cascade-rebase, atomic-push, and link PRs | `gh stack sync` |
| Prune local branches for merged PRs | `gh stack sync --prune` |
| Resolve cascading rebase conflicts | `gh stack rebase` |
| Continue or abort a conflicted rebase | `gh stack rebase --continue` or `gh stack rebase --abort` |
| Push active branches atomically | `gh stack push` |
| Create or update stacked PRs non-interactively | `gh stack submit --auto --open` |
| Link branches or PRs without local tracking | `gh stack link <b1> <b2> ...` |
| Append branches or PRs to an existing stack | `gh stack link <stack-number> <branch-or-pr> ...` |
| Merge a stack atomically | `gh stack merge [<stack-number-or-pr>] --yes --squash` |
| Remove stack tracking | `gh stack unstack [<stack-number>]` |

`gh stack submit` opens an interactive editor by default.
In non-interactive shells, pass `--auto` to skip the editor and `--open`
to mark PRs ready for review, because `--auto` creates drafts by default.
Update each PR title and body afterward with `gh pr edit`.

When stack branches live in separate worktrees, manage them with `wt` and
connect them on GitHub with `gh stack link` in bottom-to-top order.

`gh stack checkout` opens a picker when called without arguments.
Pass an explicit stack number, PR number, PR URL, or branch name in
non-interactive shells.

## Reviews and API

`gh api` fills `{owner}`, `{repo}`, and `{branch}` from the current
repository.
Prefer `--json` and `--jq` so command output stays compact and structured.

Read inline review threads:

```bash
gh api repos/{owner}/{repo}/pulls/<id>/comments --paginate \
  --jq '.[] | {path, line, user: .user.login, body}'
```

Post a neutral batch of inline comments with `event` set to `COMMENT`.
Each `line` must fall inside a diff hunk on the PR head.
Post out-of-hunk notes with `gh pr comment <id> --body-file -`.

```bash
jq -n --arg sha "<headRefOid>" '{
  commit_id: $sha,
  event: "COMMENT",
  comments: [
    {path: "src/file.ts", line: 42, side: "RIGHT", body: "Comment text."}
  ]
}' | gh api repos/{owner}/{repo}/pulls/<id>/reviews --method POST --input -
```

Use `gh api graphql` for operations the REST API omits, such as resolving
review threads or querying project fields:

```bash
gh api graphql -f query='query { viewer { login } }'
```
