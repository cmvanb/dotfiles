---
name: azure-devops
description: Drive Azure DevOps from the CLI. Covers pull requests, comments, retargeting, authentication failures, and the SDK escape hatch for APIs the CLI omits. Use when a git remote points at dev.azure.com or visualstudio.com, or when az repos, az devops, or az pipelines is needed.
---

# Azure DevOps

Use `az repos`, `az devops`, and the Python SDK that the `azure-devops`
extension ships.

## Set up

### Install the extension

```bash
az extension add --name azure-devops
```

### Override the configured defaults

The stored defaults often name another project.

```bash
az devops configure --list
```

Pass `--org` and `--project` on every call. Do not rely on the defaults.

### Collect the coordinates

```bash
ORG=https://dev.azure.com/<organization>/
PROJECT=<project>
REPO=<repo-name>
REPO_ID=$(az repos show --org "$ORG" --project "$PROJECT" --repository "$REPO" --query id -o tsv)
PROJECT_ID=$(az devops project show --org "$ORG" --project "$PROJECT" --query id -o tsv)
```

Route parameters need the GUID. The name works only for `az repos`.

## Authentication

### Diagnose a failure

Run the command first. If it fails, match the symptom.

| Symptom | Cause | Fix |
| --- | --- | --- |
| 403 on every `az repos` command | No credential | Run `az login`, then `az devops login` |
| 403 "identity has not been materialized" | The AAD identity has never opened the web UI | Sign in to the organization in a browser once, or use a PAT |
| Works in `az repos`, fails in `curl` | Different credential | Stop using `curl` |

### Know which credential is in use

The extension tries the `az login` token first.
If that token fails, it falls back to a PAT from `az devops login`.

The fallback is silent. `az repos` can work while raw REST calls fail.

### Do not hand-build REST calls

A token from `az account get-access-token` fails as a bearer token and as a
basic-auth password. `curl` and `az rest` both fail this way.

Use `az devops invoke` or the SDK.

### Supply a PAT without the prompt

```bash
export AZURE_DEVOPS_EXT_PAT=<token>
```

Create the token at `<ORG>_usersSettings/tokens` with scope
**Code (read, write, and manage)**.

## Pull requests

### Run the common commands

```bash
az repos pr list --org "$ORG" --project "$PROJECT" --repository "$REPO" --status active
az repos pr show --org "$ORG" --id <id>
az repos pr update --org "$ORG" --id <id> --status abandoned
az repos pr set-vote --org "$ORG" --id <id> --vote approve
```

### Target the parent in a stack

Each child targets its parent. Only the root targets the trunk.

### Write the description

Build the description in a shell variable with a quoted heredoc.
Do not create a file in the repository.

```bash
DESC=$(cat <<'EOF'
Context, changes, and tests.

- Markdown works here.
EOF
)

az repos pr create --org "$ORG" --project "$PROJECT" --repository "$REPO" \
  --source-branch <child> --target-branch <parent> \
  --title "<title>" --description "$DESC" \
  --query pullRequestId -o tsv
```

Quote the marker as `'EOF'`.
Without the quotes the shell expands `$` and backticks in the description.

Newlines, blank lines, tables, and callouts all survive.

### Read a description back

```bash
az repos pr show --org "$ORG" --id <id> --query description -o tsv
```

The output round-trips without loss. Use it as a backup before an update.

## Retarget a pull request

> [!CAUTION]
> Never abandon and recreate a pull request to change its target.
> Comments, votes, and history are lost.

### Why the CLI cannot do it

`az repos pr update` has no target-branch option.

`az devops invoke` cannot reach the route either.
Three routes share the name `pullRequests`, and it always resolves the
project-level one, which is GET-only.

### Use the SDK

```python
# /opt/azure-cli/bin/python retarget.py <pr-id> refs/heads/<branch>
import sys
sys.path.insert(0, "<EXT>")

from azext_devops.dev.common.services import get_connection
from azext_devops.devops_sdk.v6_0.git.models import GitPullRequest

conn = get_connection("https://dev.azure.com/<organization>/")
git = conn.get_client("azext_devops.devops_sdk.v6_0.git.git_client.GitClient")

print(git.update_pull_request(
    GitPullRequest(target_ref_name=sys.argv[2]),
    repository_id="<REPO_ID>",
    pull_request_id=int(sys.argv[1]),
    project="<PROJECT>").target_ref_name)
```

Run it with the Azure CLI interpreter, not the system python.
See [Find the interpreter](#find-the-interpreter).

## Comments

`az repos pr` has no comment command. The resource is `pullRequestThreads`.

### Post a comment

`--in-file` needs a real path. Use `mktemp` and delete it.
Do not write into the repository.

```bash
BODY=$(cat <<'EOF'
Comment text. Markdown works here.
EOF
)

REQ=$(mktemp)
trap 'rm -f "$REQ"' EXIT

BODY="$BODY" REQ="$REQ" python3 -c "
import json, os
json.dump({'comments': [{'parentCommentId': 0,
                         'content': os.environ['BODY'],
                         'commentType': 1}],
           'status': 4}, open(os.environ['REQ'], 'w'))
"

az devops invoke --org "$ORG" --area git --resource pullRequestThreads \
  --route-parameters project="$PROJECT" repositoryId="$REPO_ID" pullRequestId=<id> \
  --http-method POST --in-file "$REQ" --api-version 7.1
```

Export both variables to the `python3` call.
A shell variable alone is not visible to it.

### Read threads

Use `--http-method GET` and no `--in-file`.
Add `threadId=<id>` to read one thread.

### Delete a comment

```bash
az devops invoke --org "$ORG" --area git --resource pullRequestThreadComments \
  --route-parameters project="$PROJECT" repositoryId="$REPO_ID" \
    pullRequestId=<id> threadId=<thread> commentId=1 \
  --http-method DELETE --api-version 7.1
```

### Set the thread status

`1` active, `2` fixed, `3` wontFix, `4` closed, `6` pending.

Use `4` for a note that needs no reply.

## The SDK escape hatch

### Get a client

`get_connection` plus `get_client` reaches every API the CLI omits.

```python
conn.get_client("azext_devops.devops_sdk.v6_0.git.git_client.GitClient")
conn.get_client("azext_devops.devops_sdk.v6_0.work_item_tracking.work_item_tracking_client.WorkItemTrackingClient")
conn.get_client("azext_devops.devops_sdk.v6_0.build.build_client.BuildClient")
```

### Find the extension

```bash
EXT=$(find ~/.azure/cliextensions -maxdepth 1 -name azure-devops)
```

Add it to `sys.path` before importing `azext_devops`.
The interpreter does not see the extension on its own.

### Find the interpreter

```bash
cat "$(command -v az)"
AZPY=$(grep -oE '\S+/python[0-9.]*' "$(command -v az)" | head -1)
```

Verify it's working:

```bash
"$AZPY" -c "import azure.cli; print('ok')"
```

### Read a method signature

```bash
grep -rn "def update_pull_request" \
  "$EXT"/azext_devops/devops_sdk/v6_0/git/git_client_base.py
```

## Gotchas

### Strip the progress line from invoke output

`az devops invoke` prints a line before the JSON.
Slice from the first bracket.

```python
raw = open("/tmp/areas.json").read()
data = json.loads(raw[raw.index("["):])    # or "{" for one object
```

### Treat an auth error as a wrong resource name

A wrong `--resource` returns an auth error, not a routing error.

Check the resource name before you debug the credential.

### Expect routes to share a resource name

`az devops invoke` picks one route and cannot be steered.
It silently drops route parameters that the chosen route does not use.

Read the URL in the error to see which route it took.
If the route you need is unreachable, use the SDK.

### List every area and resource

```bash
az devops invoke --org "$ORG" -o json > /tmp/areas.json
```

Filter on `area`, `resourceName`, and `routeTemplate`.
