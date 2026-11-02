# Profiles

Profiles declare which modules to install for a specific host or role. They are plain key=value files in `profiles/`.

## Format

| Key | Value |
|---|---|
| `profile.extends` | Parent profiles |
| `profile.wm` | Window manager |
| `modules.lib` | Library modules, installed first |
| `modules.theme` | Theme modules, installed second |
| `modules.install` | Application modules, installed last |
| `modules.enable` | Modules whose services are enabled |

Lists are space-separated.
Every key is optional.
Lines starting with `#` are comments.

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
modules.install=alacritty bitwarden btop chromium direnv disable-xdg-desktop-files discord draw.io fontconfig ghostty gitui imv mpv opencode pandoc qutebrowser scripts-markdown scripts-misc scripts-system-utils spotify udiskie vscodium vt wezterm xdg-mimetype-associations yay zathura
modules.enable=pipewire ssh syncthing udiskie
```

**`profiles/wayland-wm`** — wayland desktop shell:
```
profile.extends=

modules.lib=lib-wayland-utils
modules.install=wm-shared fuzzel hyprlock swaync waybar scripts-desktop wayrcursor whisrs xkb
modules.enable=swaync wayrcursor whisrs
```

**`profiles/sway`** — window manager profile, extends `wayland-wm`:
```
profile.extends=wayland-wm
profile.wm=sway

modules.install=eww sway swayosd
modules.enable=swayosd
```

**`profiles/cyxwel`** — top-level host profile:
```
profile.extends=workstation sway niri
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
