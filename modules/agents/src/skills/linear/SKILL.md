---
name: linear
description: Drive Linear from the GraphQL API or MCP. Covers authentication, branch naming, PR-to-issue linking, link verification, issue ordering, and mutations. Use when working with Linear issues, projects, or Linear-integrated GitHub pull requests.
---

# Linear

Use the Linear MCP when connected in the session.
Use the Linear GraphQL API at `https://api.linear.app/graphql` when the
MCP is absent or omits a field such as `branchName`, `attachments`, or
sort order fields.

## Authentication

Check the environment before asking the user for a key:

```bash
env | grep '^LINEAR_API_KEY='
```

If `LINEAR_API_KEY` is unset, run through `mise exec --` so the project
environment loads `.secrets/` from `mise.local.toml`.
Check `.agents/DEVENV.md` for workspace details and team keys when present.

Pass a personal API key directly in the `Authorization` header without a
`Bearer` prefix.

## Query and mutate

Build every GraphQL request body with `jq -n` and pipe it to `curl -d @-`
so quotes and multiline markdown stay valid JSON.

Linear returns HTTP 200 even when GraphQL validation fails.
Inspect `.errors` on every response and confirm `.data.<mutation>.success`
equals `true` after every mutation.

`issue(id:)` accepts either the human identifier such as `ENG-42` or a
UUID.
Mutations such as `issueCreate` and `issueUpdate` require UUIDs for
`teamId`, `stateId`, `parentId`, `assigneeId`, and `labelIds`.
Query team states or labels first to resolve those UUIDs.

Format issue descriptions and comments with the `platform-markdown` skill.

## Link a pull request to an issue

Name the branch with the `branchName` of the issue it resolves.
This rule replaces the branch name rule of the `git` skill.
Linear links the pull request to that issue and moves it to Done on merge.

```bash
jq -n --arg id "<ISSUE-ID>" '{
  query: "query($id: String!) { issue(id: $id) { branchName } }",
  variables: {id: $id}
}' | curl -sS https://api.linear.app/graphql \
  -H "Content-Type: application/json" \
  -H "Authorization: $LINEAR_API_KEY" \
  -d @- | jq -r '.data.issue.branchName'
```

Link additional issues in the pull request description with magic words:

- Use `Closes <ID>` or `Fixes <ID>` to complete another issue on merge.
- Use `Part of <ID>` for an issue the PR advances without completing.
- Use `Related to <ID>` for an issue the PR mentions while keeping its
  status unchanged.
- Put a magic word before every ID that must link, because Linear ignores
  bare IDs in descriptions.

To link an open pull request to more issues, edit its description.
The edit triggers a fresh webhook to Linear.

## Verify a link

Confirm that the issue lists the pull request URL in `attachments`:

```bash
jq -n --arg id "<ISSUE-ID>" '{
  query: "query($id: String!) { issue(id: $id) { attachments { nodes { url } } } }",
  variables: {id: $id}
}' | curl -sS https://api.linear.app/graphql \
  -H "Content-Type: application/json" \
  -H "Authorization: $LINEAR_API_KEY" \
  -d @- | jq '.data.issue.attachments.nodes[].url'
```

Linear also posts a linkback comment on the pull request.

## Order issues

Linear stores a separate order value for each view:

| Field | View |
| --- | --- |
| `sortOrder` | Backlog and manual views |
| `subIssueSortOrder` | Sub-issue list of the parent |
| `prioritySortOrder` | Views sorted by priority |

Set the same numeric value in every sort field with `issueUpdate`.
Linear can adjust a value that collides with another issue.
Read back every sort field after the update and confirm the final order.

```bash
jq -n --arg id "<ISSUE-ID>" --argjson order 100 '{
  query: "mutation($id: String!, $order: Float!) { issueUpdate(id: $id, input: { sortOrder: $order, subIssueSortOrder: $order, prioritySortOrder: $order }) { success issue { sortOrder subIssueSortOrder prioritySortOrder } } }",
  variables: {id: $id, order: $order}
}' | curl -sS https://api.linear.app/graphql \
  -H "Content-Type: application/json" \
  -H "Authorization: $LINEAR_API_KEY" \
  -d @- | jq
```
