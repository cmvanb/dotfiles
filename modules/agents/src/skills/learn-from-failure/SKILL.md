---
name: learn-from-failure
description: Encode the lesson of an agent failure at the right level of the agent context hierarchy, with the smallest clean edit. Invoke with /learn-from-failure and a description of what went wrong.
disable-model-invocation: true
---

# Learn from failure

Turn one failure into one durable fix in the agent context.
Every rule costs context in each session that loads it.
A bloated or conflicting rule does more harm than a missing one.

## Understand the failure

1. Read the operator's description and the session history in context.
2. State the failure in one sentence: what you did, and what you should
   have done.
3. If the failure or the expected behavior is unclear, ask the operator.
   Wait for the answer before you continue.

## Find the root cause

Read every instruction file that was loaded at the failure point.
Classify the cause and pick the matching fix:

| Cause | Fix |
|---|---|
| No rule covers the case | Add a rule |
| A rule is ambiguous | Rewrite the rule |
| Two rules conflict | Keep one rule and delete the other |
| The rule exists, but its file did not load | Fix the skill trigger or description |
| The rule loaded, but you ignored it | Sharpen the rule or move it to the point of decision |
| The failure is a one-off with no general lesson | Change nothing and report why |

A failure can have more than one cause.
Fix each cause.

Prefer a script, lint, or config over prose when it enforces the rule
everywhere the failure can recur.

## Generalize the lesson

- Write the rule for the class of failure, not for this instance.
- Remove names, paths, and details specific to this session, unless the
  rule belongs to one project.
- Confirm that the rule prevents this failure and holds in every context
  that loads its file.

## Pick the level

The Memory section of the global `AGENTS.md` defines the levels.
Pick the narrowest level that loads in every context where the failure can
recur:

- **Global `AGENTS.md`**: the failure can recur in any project and any
  task.
  Every session loads this file, so it costs the most.
- **Skill**: the failure belongs to one domain, tool, or task type.
  Prefer an existing skill.
  A new skill needs a trigger in the Skills section of the global
  `AGENTS.md`, or a manual invocation.
- **Project `AGENTS.md` or `.agents/` file**: the failure belongs to one
  repository.

## Write the edit

1. Search every level for rules that cover the same ground.
   `<project>` is the root of the repository where the failure occurred:

   ```bash
   rg --follow -il --no-messages '<key term>' ~/.config/agents \
       <project>/AGENTS.md <project>/.agents
   ```

2. Amend an existing rule before you add a new one.
3. Delete each rule that the new rule duplicates.
4. Resolve each conflict with rules at the same level and at other levels.
5. Match the voice, format, and section structure of the target file.
6. Keep the diff to the fewest words that carry the rule.
7. If the target path is a symlink, edit the file it resolves to.

Show the proposed diff to the operator.
Apply a global or skill edit only after the operator approves it.

## Verify

1. Reread each edited file in full.
2. Repeat the search and confirm that the lesson exists in one place.
3. Replay the failure point with the edited context.
   Confirm that the rule leads to the correct action.

**Reply:** the failure, its cause, the chosen level and why the other
levels are wrong, and the final diff.
