# Dotfiles

Linux dotfiles managed via a profile/module deployment system. Configs are symlinked into `$HOME`; templates are rendered at deploy time.

## Quick orientation

| Concept | Location | Purpose |
|---|---|---|
| Entry point CLI | `deploy.sh` | Install/uninstall profiles and modules |
| Profiles | `profiles/` | Declare module sets for specific hosts/roles |
| Modules | `modules/` | Per-app config + deploy script |
| Lib | `lib/` | Shared Bash utilities (fs, profile, template) |
| Theme | `modules/lib-theme/`, `modules/theme-base/`, `modules/theme-desktop/` | Color/font/cursor system |

## Common tasks

```bash
./deploy.sh install --host          # deploy profile matching hostname
./deploy.sh install <profile>       # deploy named profile (see profiles/)
./deploy.sh install <module...>     # deploy one or more modules
./deploy.sh uninstall               # uninstall using tracked state
./deploy.sh status                  # show active profile
./deploy.sh list                    # list all profiles and modules
./deploy.sh show <profile>          # show resolved module set
```

## Key conventions

- Modules live at `modules/<name>/deploy.sh`; must define `<name>::install()` and `<name>::uninstall()`
- Profile files are plain key=value text in `profiles/`; profiles compose via `profile.extends=`
- Module install order within a profile: `modules.lib` → `modules.theme` → `modules.install`
- Templates use [ESH](https://github.com/jirutka/esh) (`.esh` suffix); rendered at deploy time, never committed
- All paths are XDG-compliant; `deploy.sh` exports the full set of `XDG_*` vars
- State is tracked in `~/.local/state/dotfiles/`

## Environment variables set by deploy.sh

| Variable | Value |
|---|---|
| `DEPLOY_PROFILE` | Space-separated inheritance chain |
| `DEPLOY_DISTRO` | Linux distro ID (e.g. `arch`) |
| `DEPLOY_WM` | Active window manager |
| `DEPLOY_HOST` | Hostname |

## Documentation

**Before making any changes, read the documentation files relevant to the task.**

- [docs/design.md](docs/design.md) — Design overview
- [docs/profiles.md](docs/profiles.md) — Profile format, inheritance, examples
- [docs/modules.md](docs/modules.md) — Module structure, deploy script API, patterns
- [docs/theme.md](docs/theme.md) — Theme system: sources, cache, runtime API
- [docs/templates.md](docs/templates.md) — ESH template engine, context variables, patterns
