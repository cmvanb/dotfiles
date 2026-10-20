# GitHub adapter

`gh api` fills `{owner}` and `{repo}` from the current repository.

## Install

```bash
sudo pacman -S github-cli
gh auth login
```

## Read the PR

```bash
gh pr view <id> --json number,url,title,body,author,baseRefName,headRefName,headRefOid,closingIssuesReferences,statusCheckRollup
```

## Read linked tickets

Use `closingIssuesReferences`, plus `#<n>` and issue URLs in the body.

```bash
gh issue view <n> --json title,body,labels,comments
```

## Read existing threads

```bash
gh api repos/{owner}/{repo}/pulls/<id>/comments --paginate \
  --jq '.[] | {path, line, user: .user.login, body}'
gh pr view <id> --json reviews,comments
```

## Fetch the head

```bash
git fetch origin pull/<id>/head
```

## Post comments

Post one review with `event` set to `COMMENT`.
`COMMENT` is neutral and casts no vote.
Never use `APPROVE` or `REQUEST_CHANGES`.

Build the payload with `jq` to keep quoting safe:

```bash
REQ=$(mktemp -p /tmp/opencode)
trap 'rm -f "$REQ"' EXIT

jq -n --arg sha "<headRefOid>" '{
  commit_id: $sha,
  event: "COMMENT",
  comments: [
    {path: "src/a.ts", line: 42, side: "RIGHT", body: "Move the token check before the cache read."}
  ]
}' > "$REQ"

gh api repos/{owner}/{repo}/pulls/<id>/reviews --method POST --input "$REQ"
```

`line` is the line number in the PR head file.
It must fall inside a diff hunk.
A line outside every hunk returns 422.
Post that comment on the PR conversation instead:

```bash
gh pr comment <id> --body "<comment>"
```

## Read back

```bash
gh api repos/{owner}/{repo}/pulls/<id>/comments --paginate \
  --jq '.[-<n>:][] | .html_url'
```
