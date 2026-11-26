---
name: forgejo
description: Drive Forgejo from the CLI with `fj` and the REST API v1. Covers authentication, pull requests, retargeting, issues, inline reviews, and Actions. Use when a git remote points at a Forgejo instance such as codeberg.org, or when working with Forgejo PRs, issues, or Actions.
---

# Forgejo

Use `fj` for repository, pull request, issue, and Actions commands.
Use the REST API at `https://<host>/api/v1` for structured JSON queries,
PR retargeting, and inline review comments, because `fj` omits them.

## Set up

Verify CLI authentication before other calls:

```bash
fj auth list
fj whoami
```

Add an instance interactively with `fj auth login -H <host>` or pipe a
token to `fj auth add-token -H <host>`.

For REST API calls, check `FORGEJO_TOKEN` in the environment first.
If unset, run through `mise exec --` so the project environment loads
`.secrets/` from `mise.local.toml`.
Send the token with `Authorization: token $FORGEJO_TOKEN`.

`fj` resolves the host and repository from the current git remote.
Pass `-H <host>`, `-R <remote>`, or `-r <owner>/<repo>` to target another
host or repository.

## Pull requests

Format PR descriptions and comments with the `platform-markdown` skill.
Always pass `--body` or `--body-file <file>` to `fj pr create`,
`fj pr comment`, and `fj issue create`, because omitting both opens an
editor.
Write temporary body files under `/tmp/opencode` and remove them after
use.

Prefix the PR title with `WIP: ` to mark a pull request as a draft.

```bash
BODY=$(mktemp -p /tmp/opencode)
trap 'rm -f "$BODY"' EXIT
cat > "$BODY" <<'EOF'
Body text.
EOF

fj pr create "<title>" --base <branch> --head <branch> --body-file "$BODY"
```

Common operations:

```bash
fj pr search
fj pr view <id> body
fj pr view <id> comments
fj pr view <id> diff
fj pr status <id>
fj pr status <id> --wait
fj pr edit <id> title "<title>"
fj pr comment <id> --body-file "$BODY"
fj pr merge <id> --method squash --delete
```

`fj pr depend` and `fj pr block` manage issue dependencies directly.

> [!CAUTION]
> Always retarget a pull request through the REST API.
> `fj pr edit` has no base-branch subcommand, and closing and recreating a
> pull request destroys reviews, comments, and history.

Retarget a pull request:

```bash
jq -n --arg base "<branch>" '{base: $base}' \
  | curl -sS -X PATCH \
    -H "Authorization: token $FORGEJO_TOKEN" \
    -H "Content-Type: application/json" \
    -d @- \
    "https://<host>/api/v1/repos/<owner>/<repo>/pulls/<id>" | jq '{number, base: .base.ref}'
```

## Issues and Actions

```bash
fj issue search
fj issue create "<title>" --body-file "$BODY"
fj issue view <id> comments
fj issue edit <id> labels
fj actions tasks
fj actions dispatch <workflow> <ref>
```

If a repository disables blank issues, pass `--template <name>` to
`fj issue create` after listing templates with `fj issue templates`.

## Reviews and REST API

`fj pr review` only lists reviews and requests reviewers.
Use the REST API to read structured PR metadata or post inline comments.

Read PR metadata:

```bash
curl -sS -H "Authorization: token $FORGEJO_TOKEN" \
  "https://<host>/api/v1/repos/<owner>/<repo>/pulls/<id>" \
  | jq '{number, title, base: .base.ref, head: .head.ref, sha: .head.sha, mergeable, draft}'
```

Post a neutral batch of inline review comments with `event` set to
`COMMENT`.
Use `new_position` for lines on the PR head and `old_position` for removed
lines.

```bash
jq -n --arg sha "<head-sha>" '{
  commit_id: $sha,
  event: "COMMENT",
  comments: [
    {path: "src/file.ts", new_position: 42, body: "Comment text."}
  ]
}' | curl -sS -X POST \
  -H "Authorization: token $FORGEJO_TOKEN" \
  -H "Content-Type: application/json" \
  -d @- \
  "https://<host>/api/v1/repos/<owner>/<repo>/pulls/<id>/reviews" | jq
```

Pass `page` and `limit` query parameters on paginated list endpoints.
Every Forgejo instance serves its OpenAPI schema at
`https://<host>/swagger.v1.json`.
