# Agent Instructions

## Never Assume, Always Verify

Verify before concluding. Every claim about system state must be backed by direct observation this session.

## Execution

- Act immediately if safe, in-scope, and permitted
- Correct wrong statements or inaccurate documentation
- Immediately update changed or removed references
- Never write "I should" or end with deferred offers
- Stop only when done or genuinely blocked

## Startup

Before the first response, list every instruction file path that was loaded in session context. Then state the working directory and active git branch.

## Skills

Evaluate every trigger below against the full task before starting. Load all skills whose conditions match — not just the first one.

- **Markdown formatting**: When writing or editing any `.md` file, load and follow the `markdown` skill.
- **Linux context**: When making system level changes, modifying system or user configuration, debugging or troubleshooting in a live linux environment — invoke the `linux-context` skill.
- **Software Developer**: When writing, modifying or refactoring code, designing or developing software, load the `software-developer` skill.
- **Diagnose**: When the user says "diagnose this" / "debug this", reports a bug, says something is broken/throwing/failing, or describes a performance regression — invoke the `diagnose` skill.
- **Grill with docs**: When the user is brainstorming, planning or otherwise developing documentation — invoke the `grill-with-docs` skill.
- **TDD**: When the user wants to build features or fix bugs using TDD, mentions "red-green-refactor", wants integration tests, or asks for test-first development — invoke the `tdd` skill.
- **Zoom out**: When the user is unfamiliar with a section of code or needing to understand how it fits into the bigger picture — invoke the `zoom-out` skill.
- **Python**: When working with Python code, packages, or dependencies — invoke the `python` skill.
- **Git**: When the users explicitly asks you to commit changes — invoke the `git` skill.
