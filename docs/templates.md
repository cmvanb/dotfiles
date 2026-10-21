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

The `render-mako` command (invoked via `template::render_mako`) injects these into every template:

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
primary_8       →  "2a68ca"   (6-digit hex, no prefix)
font_sans       →  "Inter"
cursor_size     →  "32"
scheme_variant  →  "dark"     (or "light")
scheme_name     →  "carbon-dark"
```

Reference palette steps and semantic aliases rather than branching on
`scheme_variant`; see [theme.md](theme.md).
Branch only for true polarity flags:

```ini
gtk-application-prefer-dark-theme=${1 if scheme_variant == 'dark' else 0}
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
    whisrs_model = 'ggml-small.en.bin' if DEPLOY_HOST == 'casino' else 'ggml-large-v3.bin'
%>
model = "${whisrs_model}"
```

Font sizes per host come from the [host overlay](theme.md#host-overlay).

## Rendering

`render-mako` (from `lib-python-utils`) does the rendering: it builds the context, compiles the Mako template, and writes the output file.

Modules use the `template::render_mako` wrapper (from `lib-shell-utils`), which removes any pre-existing file or link at the destination before rendering:

```bash
template::render_mako "$src/config.mako" "$XDG_CONFIG_HOME/app/config"
```

The wrapper records each render in `$XDG_STATE_HOME/dotfiles/renders`,
so `theme switch` can re-render it against the other color scheme.
An optional third argument pins the output to one scheme instead:

```bash
template::render_mako "$src/gtk.mako.css" "$theme_dest/gtk-3.0/gtk.css" carbon-light
```
