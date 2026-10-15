# DEVENV.md template

Copy the skeleton below into `$MAIN/.agents/DEVENV.md`.
Replace each `<placeholder>`.
Keep only the rows that the project uses.
Keep each section heading, also for a short file.

Each step has a check and an action.
The check is a command and the output that shows the step is complete.
The action is the command that completes the step.
A step that gives the same result each time it runs is an action only.
Examples are `ln -sfn` and a file write.

## Skeleton

````markdown
# Development Environment

<Project name> is a <one-sentence description>.
This file rebuilds its local development environment on an Arch-family
machine.

Run every project command from the repository root.
Run every project command as `mise exec -- <command>` or `mise run <task>`.

## Main checkout

Each worktree shares this file, the mise config, and the secrets of the main
checkout.

```bash
MAIN=$(dirname "$(git rev-parse --path-format=absolute --git-common-dir)")
```

## System prerequisites

The user runs this block one time.
It needs root.

```bash
sudo pacman -S --needed <package> <package>
paru -S --needed <aur-package>
```

| Check | Expected output |
|---|---|
| `pacman -Q <package>` | `<package> <version>` |
| `command -v <command>` | `/usr/bin/<command>` |

## Secrets

Secret values live in `$MAIN/.secrets/`.

| File in `.secrets/` | Used at | Needed by | Source | Get command |
|---|---|---|---|---|
| `<name>.env` | `[env]` through `_.file` | <tiers> | <project secret store> | `<command> > "$MAIN/.secrets/<name>.env"` |
| `<file>` | Symlink at `<fixed path>` | <tiers> | <CLI> | `<command> > "$MAIN/.secrets/<file>"` |
| `<file>` | <use> | Optional | <source> | `<command>` |

Make each symlink:

```bash
ln -sfn "$MAIN/.secrets/<file>" "<fixed path>"
```

## Project toolchain

### Write the mise config

Write this text to `$MAIN/mise.local.toml`.

```toml
[tools]
<tool> = "<version>"
"npm:<cli>" = "<version>"

[env]
_.file = { path = ".secrets/<name>.env", redact = true }
_.path = ["{{config_root}}/<dir>"]
<NAME> = "<value>"
<CONFLICTING_HOST_VAR> = false

[tasks.run]
run = "<command>"
raw = true

[tasks."test:<tier>"]
run = "<runner> <tier>"

[tasks.test]
run = [{ task = "test:<tier>" }, { task = "test:<tier>" }]

[tasks."<service>:start"]
run = '''
mkdir -p "$XDG_STATE_HOME/<project>"
setsid -f <command> > "$XDG_STATE_HOME/<project>/<service>.log" 2>&1
until <ready check>; do sleep 1; done
'''

[tasks."<service>:stop"]
run = "<command>"
```

### Trust and install

| Check | Expected output | Action |
|---|---|---|
| `mise trust --show` | Lists `mise.local.toml` as trusted | `mise trust` |
| `mise ls --current --missing --no-header` | Empty output | `mise install` |

Trust in the main checkout also applies to each worktree.

### Project convention

| Check | Expected output | Action |
|---|---|---|
| `<command>` | `<output>` | `<command>` |

### User data

| Check | Expected output | Action |
|---|---|---|
| `ls "$XDG_DATA_HOME/<tool>"` | `<entries>` | `<install command>` |

### Dependencies

| Check | Expected output | Action |
|---|---|---|
| `<command>` | `<output>` | `mise exec -- <install command>` |

## Worktree setup

In a worktree, link the local files of the main checkout.

```bash
ln -sfn "$MAIN/mise.local.toml" mise.local.toml
ln -sfn "$MAIN/.secrets" .secrets
ln -sfn "$MAIN/.secrets/<file>" "<fixed path>"
```

Then do the steps in "Project convention" and "Dependencies" in the worktree.

## Services and devices

| Name | Ports | Start | Ready check | Stop |
|---|---|---|---|---|
| <service> | <ports> | `mise run <service>:start` | `<command>` gives `<output>` | `mise run <service>:stop` |
| <device> | <ports> | `mise run <device>:start` | `<command>` gives `<output>` | `mise run <device>:stop` |

Each service writes its log to `$XDG_STATE_HOME/<project>/<service>.log`.

## Run

| Task | Needs | Success signal |
|---|---|---|
| `mise run run` | <services, devices> | `<first ready line>` |

## Test tiers

`mise run test` runs every tier in sequence.

| Task | Covers | Needs | Success signal |
|---|---|---|---|
| `mise run test:<tier>` | <scope> | <services, devices, secrets> | `<output line>` |
````

## Notes for the writer

- The skeleton holds one example row per table.
  Add one row for each real item.
- Put a step in "Project convention" when a committed file of the project
  selects the tool, for example `fvm install` for a project with `.fvmrc`.
- Put a step in "User data" when the tool is outside the mise registry.
  Derive SDK components from the build files of the project.
- Put devices in `$XDG_DATA_HOME`, for example
  `ANDROID_AVD_HOME = "{{env.XDG_DATA_HOME}}/android-avd"` in `[env]`.
- Use `setsid -f` for a background process, so that it continues after the task exits.
- Use the success line that the tool prints, for example `All tests passed!`.
