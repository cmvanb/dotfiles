---
name: code-review
description: Review a teammate's pull request end to end. Detects the code host from the git remote, loads gh or az, reads the PR and its linked tickets, runs a tiered review built on pstack skills, summarizes every finding, and posts brief human comments only after explicit approval. Use when the user asks to review a PR, shares a PR link or number, or says "code review", "look at this PR", or "review #123".
---

# Code review

Review another author's pull request.
The process follows Google's engineering practices.
Findings are given Conventional Comments labels.

## Ground rules

- Post nothing without explicit approval.
- Never vote. Never approve, reject, or set "wait for author".
- Leave the user's branch and working tree untouched.
- Write scratch files and worktrees under `/tmp/agents/code-review/`.

## Pstack skills

These skills hide from the skill tool.
Read each `SKILL.md` and its `references/` from
`$XDG_CONFIG_HOME/agents/skills/<name>/` when a step names it.

| Skill | Use |
| --- | --- |
| `why` | Ticket and PR intent |
| `blast-radius` | Breakage outside the diff, proven by running code |
| `interrogate` | Multi-model adversarial review |
| `unslop` | Strip AI tells from drafted comments |

Pstack assumes Cursor's `Task` tool.
Map it to the subagent tool: `subagent_type` becomes `agent: general`,
`model` passes through, and `readonly` becomes an instruction to write
nothing.
Skip `~/.cursor/rules/pstack-models.mdc`. The panel below replaces it.

## Interrogate panel

| Reviewer | Model |
| --- | --- |
| A | `anthropic/claude-opus-5-5` |
| B | `openrouter/openai/gpt-6.1-sol` |
| C | `openrouter/moonshotai/kimi-k2.7-code` |

If a model fails to resolve, pick the closest available model of the same
family with the `models` tool and report the swap.

## Steps

### 1. Load the provider

Read `git remote get-url origin`.

| Remote host | Adapter | CLI |
| --- | --- | --- |
| `github.com` | `references/providers/github.md` | `gh` |
| `dev.azure.com`, `*.visualstudio.com` | `references/providers/azure-devops.md` | `az` |

Read only the matching adapter.
Run `command -v <cli>`.
If the CLI is missing, offer the install command from the adapter.
If the user declines, set **suggestion mode**: read data through `git` and
deliver draft comments for the user to post.

### 2. Gather context

Use the adapter to collect:

- PR title, description, author, source and target branches
- Linked tickets with their acceptance criteria
- Existing review threads, to avoid duplicate comments
- CI status

Fetch the PR head and create a worktree:

```bash
git worktree add --detach /tmp/agents/code-review/pr-<id> <head-sha>
```

Diff with `git diff <target>...<head>` inside the worktree.
Remove the worktree when the review ends.

### 3. State the intent

Run `why` step 2 for the anchor.
Write one paragraph: the problem, the ticket's acceptance criteria, and the
approach the author chose.
If the PR lacks a ticket and a clear description, record that as a finding.

### 4. Size the review

Count changed lines.
Exclude lockfiles, vendored code, and generated files.

| Tier | Lines | Passes |
| --- | --- | --- |
| S | under 100 | Checklist |
| M | 100 to 499 | Checklist, `blast-radius` |
| L | 500 or more | Checklist, `blast-radius`, `interrogate` |

Raise the tier one step when the diff touches auth, crypto, secrets,
concurrency, data migrations, or a public API.
State the tier and the reason.

### 5. Review

Run the passes for the tier in parallel where they are independent.

- **Checklist.** Walk `references/checklist.md` against every changed line.
- **Blast radius.** Follow `blast-radius` in the worktree. Prove the safety
  fact by running code.
- **Interrogate.** Follow `interrogate` with the panel above. Feed it the
  intent from step 3.

Verify each finding against the code before keeping it.
Cite `file:line` on the PR head.

### 6. Judge

Merge duplicates across passes.
Sort each finding into the `interrogate` buckets: act on, consider, noted,
dismissed.
Label it with a Conventional Comments label and decoration, such as
`issue (blocking)` or `suggestion (non-blocking)`.
Drop findings that repeat an open thread.

### 7. Report

Summarize exhaustively. Use this structure:

```markdown
## <PR title> (#<id>)

**Intent.** <paragraph from step 3>
**Tier.** <tier and reason>
**Ticket fit.** <each acceptance criterion: met, partly met, or missed>
**CI.** <status>

### Act on
- `issue (blocking)` `path:line`: <finding, evidence, source pass>

### Consider
### Noted
### Dismissed
### Verified safe
<blast-radius safety fact and its proof level>

### What works well
```

Every finding appears here, including those that get no comment.

### 8. Draft comments

Draft comments only for **act on** findings and the **consider** findings
worth the author's time.
Follow [Comment style](#comment-style), then run `unslop` over the batch.

Present every draft up front:

```markdown
1. `src/auth/session.ts:42`
   > Move the token check before the cache read so expired tokens miss
   > the cache.
2. `src/auth/session.ts:88`
   > ...
```

Ask which to post.
Accept "all", "none", numbers, or edits.
Apply edits and show the changed drafts again before posting.

### 9. Post

In suggestion mode, stop here. The drafts are the deliverable.

Otherwise post only the approved comments through the adapter.
Read the threads back and report the links.

## Comment style

Posted comments read like a busy senior engineer wrote them.

- Use a human tone and style.
- One or two sentences.
- State a clear request. Prefer "Move X before Y." over "Should X go
  before Y?".
- Ask a question only when the answer is unknown to you.
- Skip labels, severity markers, headings, and bullet lists.
- Skip praise padding, hedges, and restating the code.
- Explain the reason only when the request is surprising without it, in
  one clause.
- Add a code suggestion when the fix is a few lines.
