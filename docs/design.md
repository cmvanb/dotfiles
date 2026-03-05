# Dotfiles System Design

## Goals

- **Declarative** — profiles compose modules; no imperative setup scripts
- **Instant updates** — configs are symlinks; editing source is immediately live
- **Dynamically themable** — ESH templates are re-rendered at deploy time
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
    ├── fs.sh          # force_link, ensure_directory, …
    ├── profile.sh     # parse/resolve/merge profile files
    ├── template.sh    # render_esh_template wrapper
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

ESH (embedded shell) templates (`~esh` suffix) are rendered at deploy time. Context includes `DEPLOY_*` vars and the full XDG set, enabling theme injection, distro conditionals, and host-specific tuning.

→ [templates.md](templates.md)

## Deployment flow

```
deploy.sh install <profile>
  │
  ├─ resolve profile inheritance chain (lib/profile.sh)
  ├─ export DEPLOY_PROFILE, DEPLOY_WM, DEPLOY_DISTRO, DEPLOY_HOST
  │
  ├─ install modules.lib   (lib-shell-utils, lib-theme, …)
  ├─ install modules.theme (theme-base, theme-desktop, …)
  ├─ install modules.install (nvim, fish, waybar, …)
  └─ enable  modules.enable  (pipewire, syncthing, …)

Each module::install():
  ├─ ensure_directory  → mkdir -p (removing conflicting file/link)
  ├─ force_link        → ln -sfT  (atomic symlink)
  └─ esh <tpl~esh>     → rendered config file
```

State is written to `~/.local/state/dotfiles/{profile,modules,wm}` for `uninstall` and `status`.

## Key design decisions

| Decision | Rationale |
|---|---|
| Symlinks over copies | Edits to source are immediately live; no re-deploy needed for config tweaks |
| Profiles as plain text | Trivially parseable by Bash without a parser library |
| ESH over other template engines | Shell-native; zero additional dependencies |
| Depth-first profile resolution | Predictable merge order; child values win over parents |
| Uninstall in reverse order | Avoids dependency issues when removing modules |
