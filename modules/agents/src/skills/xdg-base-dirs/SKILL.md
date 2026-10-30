---
name: xdg-base-dirs
description: XDG Base Directory Specification — which env vars to use for user-level paths, their defaults, and when to apply them.
---

# XDG Base Dirs Skill

Spec: <https://specifications.freedesktop.org/basedir-spec/latest/>

The XDG Base Directory Specification defines standard environment variables that point to user-specific directories. Use these variables — never hardcoded paths — whenever placing files under the user's home directory.

## Standard Directories

| Variable | Default | Purpose |
|---|---|---|
| `XDG_CONFIG_HOME` | `~/.config` | Configuration: settings files, preferences, ini/toml/yaml |
| `XDG_DATA_HOME` | `~/.local/share` | Data: databases, assets, application data |
| `XDG_CACHE_HOME` | `~/.cache` | Non-essential cache: downloads, build artifacts, thumbnails |
| `XDG_STATE_HOME` | `~/.local/state` | Persistent state: logs, history, lock files |
| `XDG_RUNTIME_DIR` | `/run/user/<uid>` | Ephemeral runtime files: sockets, pipes |


## General Rules

Never hardcode paths under `$HOME`. Always use the appropriate XDG variable.

```bash
# Wrong
"$HOME/.config/foo/config"
"$HOME/.local/share/foo"

# Correct
"$XDG_CONFIG_HOME/foo/config"
"$XDG_DATA_HOME/foo"
```

Always namespace files by application — never place files directly at the root of an XDG directory.

```bash
# Wrong
"$XDG_CONFIG_HOME/myapp-config"

# Correct
"$XDG_CONFIG_HOME/myapp/config"
```

Guard against unset variables with `${VAR:-default}`:

```bash
"${XDG_CONFIG_HOME:-$HOME/.config}/foo/config"
"${XDG_STATE_HOME:-$HOME/.local/state}/foo/state.json"
```

## Relocation

Use application's environment variable overrides to relocate config files.
Never use symlinks to relocate files.

```bash
# Wrong
ln -s "$XDG_CONFIG_HOME/NuGet" "$DOTNET_CLI_HOME/.nuget/NuGet"

# Correct
export DOTNET_CLI_HOME="$XDG_DATA_HOME/dotnet"
```
