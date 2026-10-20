# Azure DevOps adapter

Load the `azure-devops` skill first.
It owns authentication, coordinates, `az devops invoke`, and thread status
codes.
This file adds only the review verbs.

## Install

```bash
sudo pacman -S azure-cli
az extension add --name azure-devops
```

## Read the PR

```bash
az repos pr show --org "$ORG" --id <id> \
  --query '{title:title, description:description, author:createdBy.displayName, source:sourceRefName, target:targetRefName, head:lastMergeSourceCommit.commitId, url:url}'
```

## Read linked tickets

```bash
az repos pr work-item list --org "$ORG" --id <id> --query '[].id' -o tsv
az boards work-item show --org "$ORG" --id <wi> \
  --fields System.Title,System.Description,Microsoft.VSTS.Common.AcceptanceCriteria
```

## Read CI status

```bash
az repos pr policy list --org "$ORG" --id <id> \
  --query '[].{policy:configuration.type.displayName, status:status}' -o table
```

## Read existing threads

Follow `azure-devops`
[Read threads](../../../azure-devops/SKILL.md#read-threads).
Skip threads whose `isDeleted` is true and system threads without
`threadContext`.

## Fetch the head

```bash
git fetch origin <sourceRefName>
```

## Post comments

Post one thread per approved comment with status `1` (active).
Follow `azure-devops`
[Post a comment](../../../azure-devops/SKILL.md#post-a-comment),
and add `threadContext` to anchor the comment to a line:

```python
json.dump({
    'comments': [{'parentCommentId': 0,
                  'content': os.environ['BODY'],
                  'commentType': 1}],
    'status': 1,
    'threadContext': {
        'filePath': '/src/a.ts',
        'rightFileStart': {'line': 42, 'offset': 1},
        'rightFileEnd': {'line': 42, 'offset': 1},
    },
}, open(os.environ['REQ'], 'w'))
```

`filePath` starts with `/`.
Omit `threadContext` for a comment on the whole PR.

Never call `az repos pr set-vote`.

## Read back

Read the threads again and report
`<pr-url>?discussionId=<thread-id>` for each new thread.
