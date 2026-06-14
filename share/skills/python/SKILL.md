---
name: python
description: Apply Python conventions for package management and new package creation.
---

# Python Skill

- Use `uv` for all Python tasks.
- Never install to the system Python.

## Virtual Environments

Always install into a venv:

```sh
uv add <pkg>          # preferred: updates pyproject.toml and syncs venv
uv pip install <pkg>  # fallback: install directly into active venv
```

Create `.envrc` in the project root:

```
activate_venv /absolute/path/to/project/.venv
```

## New Packages

Always create: `pyproject.toml`, `README.md`, `.gitignore`, `.envrc`

`README.md` is human-facing — install, configure, test, run only.
