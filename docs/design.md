# Dotfiles System Design

## Goals

- **Declarative** — profiles compose modules; no imperative setup scripts
- **Instant updates** — configs are symlinks; editing source is immediately live
- **Dynamically themable** — Mako templates are re-rendered at deploy time
- **XDG-compliant** — paths follow the XDG Base Directory spec

## Repository layout

```
dotfiles/
├── deploy.sh          # CLI entry point
├── profiles/          # profile files (key=value)
├── modules/           # per-app config + deploy.sh
│   ├── lib-theme/     # theme runtime API
│   ├── theme-base/    # color/font/cursor YAML sources
│   ├── theme-desktop/ # GTK config
│   └── <name>/
│       ├── src/       # config files, scripts, templates
│       └── deploy.sh
├── extras/            # optional/reference modules (same structure)
└── lib/               # shared Bash utilities
    ├── fs.sh          # create links, move and copy files, etc.
    ├── profile.sh     # parse/resolve/merge profile files
    ├── linux.sh       # distro detection
    └── debug.sh
```

## Core concepts

### Profiles

Text files in `profiles/` that declare which modules to install via four module lists (`modules.lib`, `modules.theme`, `modules.install`, `modules.enable`) and optional `profile.extends` for composition.

→ [profiles.md](profiles.md)

### Modules

Self-contained units at `modules/<name>/`. A `deploy.sh` defines `<name>::install()` and `<name>::uninstall()` (and optionally `enable`/`disable`). Install functions create XDG-paths, symlink source files, and render templates.

→ [modules.md](modules.md)

### Theme system

Three cooperating modules (`lib-theme`, `theme-base`, `theme-desktop`) provide a single source of truth for colors, fonts, and cursor across all apps. YAML source files are merged into language-specific cache files at deploy time; runtime APIs (Bash, Fish, Lua, Python) load from cache.

→ [theme.md](theme.md)

### Templates

Mako templates (`.mako` infix, e.g. `config.mako`, `style.mako.css`) are rendered at deploy time. Context includes the theme color/font/cursor values, deploy vars and relevant environment vars. This enables theme injection and distro/host/profile/wm conditionals.

→ [templates.md](templates.md)

## Deployment flow

**Profile install**:

`deploy.sh install <profile>`

1. resolve inheritance chain
1. export `DEPLOY_*` vars
1. install `modules.lib` modules
1. install `modules.theme` modules
1. install `modules.install` modules
1. run `modules.enable` logic

**Module install**:

`deploy.sh install <module...>`

1. ensure directory structure with `fs::ensure_directory`
1. symlink configuration files with `fs::force_link`
1. render templates with `render-mako`

## Design decisions


| Decision | Rationale |
|---|---|
| Symlinks over copies | Edits are immediately live |
| Profiles compose modules | Flexible, composition over inheritance |
| Mako template engine | Python-native; portable to windows |
| Depth-first profile resolution | Predictable merge order; child values win over parents |
