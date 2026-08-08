---
name: git
description: Apply git conventions for commits and version control.
---

# Git Skill

## When to Commit

- Never commit without the user's explicit permission.
- Never ask to commit.

## When to Push

- Never push without the user's explicit permission.
- Never ask to push.

## Atomic Commits

- Each commit must represent exactly one logical change.
- Never bundle unrelated changes into one commit.
- Split a refactor from the feature or fix that motivated it.

## Commit Messages

- Single line only.
- Keep commit messages terse, preferably **< 50** chars, always **< 80** chars.
- Use a lowercase prefix followed by a colon and space: `feat:`, `fix:`, `build:`, `chore:`, `ci:`, `docs:`, `style:`, `refactor:`, `perf:`, `test:`.
- Capitalize the first letter after the colon.
- End the subject with a period.
- Do not sign commits.
- Do not attribute commits.
