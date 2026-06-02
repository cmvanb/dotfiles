---
name: linux-context
description: Use terminal commands to gather context for the current linux system environment. Instill some basic preferences regarding linux tool choices.
---

# Linux Context Skill

## Gather Context

Run these commands:

```bash
hostnamectl
inxi
```

## Preferences

- Use vim, not nano

## Making Changes

All changes to the system must be versioned and deployed through the appropriate repository.

**System-level changes** (packages, services, system config) are versioned and deployed with Ansible from `~/Code/manifesto`.

**User-level changes** (dotfiles, user config, shell environment) are versioned and deployed with Bash from `~/Code/dotfiles`.
