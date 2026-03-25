# Profiles

Profiles declare which modules to install for a specific host or role. They are plain key=value files in `profiles/`.

## Format

```
profile.extends=<parents>   # space-separated parent profile names (optional)
profile.wm=<wm>             # window manager name (optional)

modules.lib=<modules>       # library modules — installed first
modules.theme=<modules>     # theme modules — installed second
modules.install=<modules>   # application modules — installed third
modules.enable=<modules>    # systemd user services to enable
```

Comments and blank lines are ignored.

## Inheritance

`profile.extends` lists space-separated parent profiles. Resolution is recursive depth-first, parents before children, each profile appearing once (deduplication). Module lists are merged additively. The most specific non-empty `profile.wm` wins (child overrides parent).

Circular dependencies are rejected.

## Examples

**`profiles/server`** — home server CLI environment:
```
profile.extends=

modules.lib=lib-shell-utils lib-theme
modules.theme=theme-base
modules.install=bash bat fish git less npm nvim python readline ripgrep scripts-shell-utils wget yazi
modules.enable=
```

**`profiles/workstation`** — extends server, adds desktop apps and services:
```
profile.extends=server

modules.theme=theme-desktop
modules.install=alacritty bitwarden btop chromium direnv disable-xdg-desktop-files discord draw.io fontconfig ghostty gitui imv mpv opencode pandoc pyenv qutebrowser scripts-markdown scripts-misc scripts-system-utils spotify udiskie vscodium vt wezterm xdg-mimetype-associations yay zathura
modules.enable=pipewire ssh syncthing udiskie
```

**`profiles/wayland-wm`** — wayland desktop shell:
```
profile.extends=

modules.lib=lib-wayland-utils
modules.install=fuzzel hyprlock mako waybar scripts-desktop
modules.enable=
```

**`profiles/sway`** — window manager profile, extends `wayland-wm`:
```
profile.extends=wayland-wm
profile.wm=sway

modules.install=sway
modules.enable=
```

**`profiles/cyxwel`** — top-level host profile:
```
profile.extends=workstation sway river hyprland
profile.wm=sway

modules.install=
modules.enable=
```

## Implementation

Profile parsing and resolution live in `lib/profile.sh`:

| Function | Purpose |
|---|---|
| `profile::parse <file> <assoc_array>` | Parse a profile file into an associative array |
| `profile::get_inheritance_chain <name> <dir>` | Resolve linearized inheritance chain |
| `profile::merge <dir> <result> <names...>` | Merge a chain of profiles into a single result |
