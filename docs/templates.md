# Templates

Some config files are generated at deploy time to adapt to the environment (theme colors/fonts/cursor, host/distro/profile/wm specific values).

## Engine

[Mako](https://www.makotemplates.org/) is a Python templating engine. It compiles templates to Python and renders them with a context dict.

| Tag | Behavior |
|---|---|
| `<% ... %>` | Execute Python |
| `${expr}` | Inline Python expression |
| `% if ...:` / `% endif` | Conditional block |
| `% for x in ...:` / `% endfor` | Loop block |
| `## ...` | Comment |

Template files use a `.mako` infix (e.g. `config.mako`, `style.mako.css`). Rendered output is never committed.

## Context variables

The `render-mako` command injects these into every template:

| Variable | Value |
|---|---|
| `DEPLOY_PROFILE` | Space-separated inheritance chain |
| `DEPLOY_DISTRO` | Linux distro identifier |
| `DEPLOY_WM` | Active window manager |
| `DEPLOY_HOST` | Hostname |
| `USER` | Current user name |
| `XDG_CONFIG_HOME` | `~/.config` |
| `XDG_CACHE_HOME` | `~/.cache` |
| `XDG_DATA_HOME` | `~/.local/share` |
| `XDG_STATE_HOME` | `~/.local/state` |
| `XDG_BIN_HOME` | `~/.local/bin` |
| `XDG_OPT_HOME` | `~/.local/opt` |
| `XDG_SCRIPTS_HOME` | `~/.local/scripts` |
| `XDG_TEMPLATES_DIR` | `~/.local/templates` |


## Theme context

All theme color, font, and cursor values are pre-loaded and available as plain variables:

```
primary_8    →  "2a68ca"   (6-digit hex, no prefix)
font_sans    →  "Inter"
cursor_size  →  "24"
```

Color formatting functions are also available:

| Function | Output |
|---|---|
| `color_hash('name')` | `#RRGGBB` |
| `color_hash('name', alpha)` | `#RRGGBBAA` |
| `color_named('name')` | `RRGGBB` (no prefix) |
| `color_named('name', alpha)` | `RRGGBBAA` |
| `color_zerox('name')` | `0xRRGGBB` |
| `color_rgb_int('name')` | `R,G,B` (decimal integers) |
| `color_css_rgba('name', alpha)` | `rgba(R, G, B, alpha)` |
| `color_256('name')` | 256-color palette index |

## Patterns

### Theme color injection

```css
window#waybar {
    background: ${color_css_rgba('system_bg', 0.85)};
    color:      ${color_hash('system_text')};
    border:     1px solid ${color_css_rgba('primary_10', 0.45)};
}
```

### Variable injection (fonts, sizes)

```ini
size   = ${font_size_mlarge}
family = '${font_mono}'
```

### Distro/profile conditionals

```bash
% if DEPLOY_DISTRO == 'arch':
alias uu="sudo pacman -Syu"
% endif

% if 'workstation' in DEPLOY_PROFILE.split():
export BROWSER="qutebrowser"
% endif
```

### Host conditionals

```toml
<%
    if DEPLOY_HOST == 'casino':
        terminal_font_size = font_size_medium
    else:
        terminal_font_size = font_size_msmall
%>
[font]
size = ${terminal_font_size}
```

## Rendering

`render-mako` (the `template` pip package installed by `lib-python-utils`) does the rendering: it builds the context, compiles the Mako template, and writes the output file.

Modules call it directly:

```bash
render-mako "$src/config.mako" "$XDG_CONFIG_HOME/app/config"
```
