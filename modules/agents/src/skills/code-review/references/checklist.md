# Review checklist

Based on Google's engineering practices,
"What to look for in a code review".

Approve-worthy means the change improves overall code health,
even when it is imperfect.
Seek better code, not perfect code.

## Design

- The change belongs in this codebase and in this layer.
- Its parts interact sensibly with each other and with the system.
- Now is the right time for it.

## Functionality

- The code does what the author and the ticket intend.
- Edge cases, error paths, and empty or invalid input behave correctly.
- Concurrency is free of races and deadlocks.
- User-facing changes behave correctly for the user.

## Complexity

- A reader understands each line, function, and class quickly.
- The change solves today's problem, without speculative generality.
- Each new abstraction earns its keep.

## Tests

- Tests cover the changed behavior, including failure cases.
- Tests fail when the code breaks.
- Tests stay simple and maintainable.

## Security

- Input from outside the process is validated at the boundary.
- Secrets stay out of code, logs, and errors.
- Authorization checks guard every new entry point.
- Queries, shell calls, and rendered output resist injection.

## Naming

- Names say what a thing is or does, at a length that fits its scope.

## Comments

- Comments explain why, not what.
- Removed code carries no leftover comments or TODOs without a ticket.

## Style and consistency

- The change follows the project's style guide and surrounding patterns.
- Pure style preferences stay out of findings.

## Documentation

- READMEs, API docs, and changelogs change with the behavior.
- Deleted or deprecated code takes its docs with it.

## Every line

- Read every human-written line.
- Skim generated files and data blobs.

## Context

- Read the whole file around each hunk.
- Judge the change against the system, not the hunk alone.

## Good things

- Record what the author did well for the chat summary.
