# Dotfiles System Design

## Features

- **Declarative configuration** with profiles and modules
- **Instant updates** with symlinks
- **Dynamically themable** with templates
- **Deployment CLI**
- **Global theme system**
- **Multiple Wayland window managers**
- **XDG Base Directory compliance**

---

## Directory Structure

```
~/Code/dotfiles/
├── profiles/          # Configuration profiles
│   ├── server
│   ├── workstation
│   ├── cyxwel
│   └── ...
├── modules/           # Configuration modules
│   ├── <name>/
│   │   ├── src/
│   │   └── deploy.sh
│   └── ...
├── extras/            # Reference modules
│   ├── <name>/
│   │   ├── src/
│   │   └── deploy.sh
│   └── ...
├── lib/               # Deployment libraries
└── deploy.sh          # Deployment CLI
```

---

## Deploy CLI

The `deploy.sh` script provides a command-line interface to install and uninstall profiles and modules, list available configurations, and show the current deployment status.

### Usage

```
Usage: ./deploy.sh <command> [options]

Commands:
  install <profile|module>    Install a profile or individual module
  uninstall [profile|module]  Uninstall (defaults to tracked state)
  list                        List available profiles and modules
  show <profile>              Show resolved modules for a profile
  status                      Show currently deployed profile

Options:
  --dry-run                   Show what would be done without doing it
  --help                      Show this help message
  --host                      Auto-detect profile from hostname

Examples:
  ./deploy.sh install cyxwel
  ./deploy.sh install server
  ./deploy.sh install --host
  ./deploy.sh install nvim
  ./deploy.sh uninstall
  ./deploy.sh show workstation
  ./deploy.sh status
```

### Examples

Install a host profile:

```bash
./deploy.sh install cyxwel
```

Install a window manager profile:

```bash
./deploy.sh install sway
```

Install a single module:

```bash
./deploy.sh install alacritty
```

---

## Profile System

Profiles define collections of modules to install together for specific use cases. Profiles can extend other profiles, enabling declarative composition.

### Profile Structure

Profiles are text files with key-value pairs.

```bash
profile.extends=<parents>   # Space-separated parent profiles (optional)
profile.wm=<wm>             # Window manager (optional)

modules.lib=<modules>       # Library modules (installed first)
modules.theme=<modules>     # Theme modules (installed second)
modules.install=<modules>   # Application modules (installed third)
modules.enable=<modules>    # Systemd user services to enable
```

### Profile Inheritance

Profiles can extend multiple parents. The inheritance graph is linearized via recursive depth-first traversal with the following rules:

- Parents before children, each profile appears once
- Don't allow circular dependencies
- Additively merge and deduplicate modules
- Most specific non-empty `profile.wm` wins

### Example Profiles

**`profiles/server`** — Base profile for servers:

```
profile.extends=

modules.lib=lib-shell-utils lib-theme
modules.theme=theme-base
modules.install=bash bat fish git less lf npm nvim python readline ripgrep scripts-shell-utils wget yazi
modules.enable=
```

**`profiles/workstation`** — Generic workstation profile:

```
profile.extends=server

modules.theme=theme-desktop
modules.install=alacritty bitwarden chromium direnv disable-xdg-desktop-files discord draw.io fontconfig ghostty gitui imv mpv pandoc pyenv qutebrowser scripts-markdown scripts-misc scripts-system-utils spotify udiskie vscodium vt wezterm xdg-mimetype-associations yay zathura
modules.enable=pipewire ssh syncthing udiskie
```

**`profiles/wayland-wm`** — Desktop shell for Wayland WMs:

```
profile.extends=

modules.lib=lib-wayland-utils
modules.install=fuzzel hyprlock mako waybar scripts-desktop
modules.enable=
```

**`profiles/sway`** — Sway profile extends `wayland-wm`, sets `profile.wm` and installs its own module.

```
profile.extends=wayland-wm
profile.wm=sway

modules.install=sway
modules.enable=
```

**`profiles/cyxwel`** — Top-level host profile extends `workstation` and includes all WMs:

```
profile.extends=workstation sway river hyprland
profile.wm=sway

modules.install=
modules.enable=
```

---

## Module System

Modules are collections of configuration files and/or scripts for an application or service. Deployment scripts encapsulate the logic for installing and uninstalling these files to the user home directory. 

### Directory Structure

```
<module name>/
├── src/
│   ├── <config files>
│   ├── <scripts>
│   ├── <service files>
│   └── ...
└── deploy.sh
```

### Deploy Script

Typical module deployment structure:

```bash
<name>::install() {
    # Create directories
    # Process templates
    # Create symlinks
    # Install packages (if needed)
}

<name>::uninstall() {
    # Remove symlinks
    # Remove files
    # Remove directories
}
```

Service modules may have enable/disable functions:

```bash
<name>::enable() {
    systemctl --user enable <service>
}

<name>::disable() {
    systemctl --user disable <service>
}
```

### Deployment Patterns

```bash
force_link "$src" "$XDG_CONFIG_HOME/git"                        # Symlink entire directory
force_link "$src/bashrc" "$XDG_CONFIG_HOME/bash/bashrc"         # Symlink individual file
esh "$src/env.sh~esh" > "$XDG_CONFIG_HOME/bash/env.sh"          # Process template
force_link "$src/config~variant" "$XDG_CONFIG_HOME/app/config"  # Variant config
force_link "$src/upload-to-0x0.sh" "$XDG_BIN_HOME/0x0"          # Script with alias
```

### Example Module

```bash
bat::install () {
    assert_dependency bat

    echo "└> Installing bat configuration."

    local src="$base_dir/modules/bat/src"

    ensure_directory "$XDG_CONFIG_HOME/bat"
    force_link "$src/config" "$XDG_CONFIG_HOME/bat/config"
    force_link "$src/syntaxes" "$XDG_CONFIG_HOME/bat/syntaxes"

    ensure_directory "$XDG_CONFIG_HOME/bat/themes"
    esh "$base_dir/modules/theme-base/src/carbon-dark.tmTheme~esh" > "$XDG_CONFIG_HOME/bat/themes/carbon-dark.tmTheme"

    bat cache --build
}

bat::uninstall () {
    echo "└> Uninstalling bat configuration."
n
    rm -r "$XDG_CONFIG_HOME/bat"
}
```

---

## Theme System

Provides unified color, font, and cursor management across all dotfiles. The theme system has three layers:

- **`lib-theme`** — Runtime APIs in Bash, Fish, Lua, and Python, plus a cache generator
- **`theme-base`** — Color scheme definitions, font definitions, cursor definitions, and terminal-level assets
- **`theme-desktop`** — GTK configuration

### Source Files

Theme data is split into composable YAML files, each containing a single concern:

```
theme-base/src/
├── carbon-dark.yaml       # Colors — dark scheme
├── carbon-light.yaml      # Colors — light scheme
├── fonts-linux.yaml       # Fonts — Linux
├── fonts-windows.yaml     # Fonts — Windows
└── cursor.yaml            # Cursor — shared
```

Each file contains a single top-level key (`colors:`, `fonts:`, or `cursor:`).

### Color Scheme Structure

Color schemes are YAML files. Colors are defined as hex strings in `key: "#RRGGBB"` format. YAML anchors and aliases enable internal references: `i0: *gray_0`.

**Core palettes** — Four 16-step gradients: `primary`, `secondary`, `text`, `gray`

**Accent palettes** — Eight 10-step gradients: `red`, `orange`, `yellow`, `green`, `cyan`, `blue`, `purple`, `magenta`

**ANSI colors** — The 16 terminal color indices (`i0`–`i15`) are mapped to palette colors, with named aliases (`ansi_red`, `ansi_brblue`, etc.)

### Deployed Layout

At deploy time, `theme-base` symlinks the source files and creates indirection symlinks to select the active configuration:

```
$XDG_CONFIG_HOME/theme/
├── carbon-dark.yaml       -> src/carbon-dark.yaml
├── carbon-light.yaml      -> src/carbon-light.yaml
├── cursor.yaml            -> src/cursor.yaml
├── colors.yaml            -> carbon-dark.yaml       # active color scheme
└── fonts.yaml             -> src/fonts-linux.yaml   # active font set
```

The deploy script then runs the cache generator:

```bash
python3 $XDG_OPT_HOME/theme/theme.py parse \
    $XDG_CONFIG_HOME/theme/colors.yaml \
    $XDG_CONFIG_HOME/theme/fonts.yaml \
    $XDG_CONFIG_HOME/theme/cursor.yaml
```

This merges the YAML files and writes three cache files to `$XDG_CACHE_HOME/theme/`:

- **`theme-data.lua`** — Lua table (consumed by `theme.lua`)
- **`theme-data.sh`** — Bash variables as `key='RRGGBB'` (consumed by `theme.sh`)
- **`theme-data.fish`** — Fish variables as `set -g key 'RRGGBB'` (consumed by `theme.fish`)

### Theme API

The `lib-theme` module provides runtime lookup functions in four languages. All APIs are symlinked into `$XDG_OPT_HOME/theme/`.

**Library files:**

| File | Language | Loads from |
|---|---|---|
| `theme.sh` | Bash | `$XDG_CACHE_HOME/theme/theme-data.sh` |
| `theme.fish` | Fish | `$XDG_CACHE_HOME/theme/theme-data.fish` |
| `theme.lua` | Lua | `$XDG_CACHE_HOME/theme/theme-data.lua` |
| `theme.py` | Python | `$XDG_CONFIG_HOME/theme/{colors,fonts,cursor}.yaml` |

**Color functions:**

| Function | Output format | Example |
|---|---|---|
| `color_named` | `RRGGBB` | `05aaff` |
| `color_hash` | `#RRGGBB` | `#05aaff` |
| `color_zerox` | `0xRRGGBB` | `0x05aaff` |
| `color_rgb_int` | `R,G,B` | `5,170,255` |
| `color_css_rgba` | `rgba(R, G, B, A)` | `rgba(5, 170, 255, 0.8)` |
| `color_256` | 256-color index | `31` |
| `color_ansi_fg` | ANSI 24-bit fg escape | `\e[38:2:5:170:255m` |
| `color_ansi_bg` | ANSI 24-bit bg escape | `\e[48:2:5:170:255m` |
| `color_ansi_reset` | ANSI reset escape | `\e[0m` |

**Font and cursor functions:**

| Function | Output format | Example |
|---|---|---|
| `font` | font value by key | `Agave Nerd Font Mono` |
| `cursor` | cursor value by key | `Simp1e` |

---

## Templates

Some configuration files are generated via templates at deploy time. This enables dotfiles to adapt to the environment.

### Backend

[ESH](https://github.com/jirutka/esh) processes bash code blocks in config files. Template files are indicated with a variant suffix, typically `~esh`.

### Example Template

`modules/waybar/src/river-style.css~esh`

```css
/* <% source $XDG_OPT_HOME/theme/theme.sh -%> */
window#waybar {
    background: <% color_hash $primary_0 %>;
    color: <% color_hash $system_text %>;
}
```

### Context Variables

`deploy.sh` exports context variables available to all templates:


| Variable | Contents |
|---|---|
| `$DEPLOY_PROFILE` | Profile inheritance chain |
| `$DEPLOY_DISTRO` | Linux distro ID |
| `$DEPLOY_WM` | Window manager |
| `$DEPLOY_HOST` | Hostname |


Templates use these for conditional content:

```bash
<% if [[ $DEPLOY_DISTRO == "arch" ]]; then -%>
alias uu="sudo pacman -Syu"
<% fi -%>

<% if [[ " $DEPLOY_PROFILE " == *" workstation "* ]]; then -%>
export BROWSER="qutebrowser"
<% fi -%>
```

### Common Patterns

**Theme color injection** — Most templates source the theme API then call color functions inline:

```
background: <% color_hash $primary_0 %>;
border-color: <% color_css_rgba $secondary_5 0.45 %>;
```

**Variable injection** — Used for font names and sizes:

```
size = <%= $font_size_mlarge %>
family = '<%= $font_mono %>'
```

**Comment hiding** — ESH tags are wrapped in comment syntax to preserve output readability:

```
/* <% source $XDG_OPT_HOME/theme/theme.sh -%> */
```

**Host-specific tuning** — Adjust values per machine:

```
/* <%
source $XDG_OPT_HOME/theme/theme.sh
host=$(uname -n)
if [[ $host == "casino" ]]; then
    waybar_font_size=$font_size_small
else
    waybar_font_size=$font_size_medium
fi
-%> */
```
