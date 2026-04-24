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
- Update `install()` and `uninstall()` together and verify they stay in sync
- Profile files are plain key=value text in `profiles/`; profiles compose via `profile.extends=`
- Module install order within a profile: `modules.lib` → `modules.theme` → `modules.install`
- Templates use [Mako](https://www.makotemplates.org/); template files use a `.mako` infix and rendered output is never committed
- All paths are XDG compliant.
- Deployment state is tracked in `~/.local/state/dotfiles/`

## Environment variables set by deploy.sh

| Variable | Value |
|---|---|
| `XDG_CONFIG_HOME` | Config root (defaults to `~/.config`) |
| `XDG_CACHE_HOME` | Cache root (defaults to `~/.local/cache`) |
| `XDG_DATA_HOME` | Data root (defaults to `~/.local/share`) |
| `XDG_BIN_HOME` | User bin dir (defaults to `~/.local/bin`) |
| `XDG_OPT_HOME` | User opt dir (defaults to `~/.local/opt`) |
| `XDG_SCRIPTS_HOME` | User scripts dir (defaults to `~/.local/scripts`) |
| `XDG_TEMPLATES_DIR` | User templates dir (defaults to `~/.local/share/templates`) |
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
- [docs/templates.md](docs/templates.md) — Mako template engine, context variables, patterns
