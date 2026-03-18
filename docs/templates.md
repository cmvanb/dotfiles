# Templates

Some config files are generated at deploy time to adapt to the environment (theme colors, host-specific values, distro, window manager).

## Engine

[ESH](https://github.com/jirutka/esh) embeds Bash code blocks in any text file.

| Tag | Behavior |
|---|---|
| `<% ... %>` | Execute Bash; output discarded |
| `<%= ... %>` | Execute and inline the output |
| `<%- ... -%>` | Trim surrounding whitespace |

Template files use a `~esh` suffix (e.g. `config~esh`, `style.css~esh`). Rendered output is never committed.

## Context variables

`deploy.sh` exports these to all templates:

| Variable | Value |
|---|---|
| `$DEPLOY_PROFILE` | Space-separated inheritance chain |
| `$DEPLOY_DISTRO` | Linux distro ID (e.g. `arch`) |
| `$DEPLOY_WM` | Active window manager |
| `$DEPLOY_HOST` | Hostname |

The full `XDG_*` variable set is also available.

## Patterns

### Theme color injection

Source the theme API once, then call color functions inline:

```css
/* <% source $XDG_OPT_HOME/theme/theme.sh -%> */
window#waybar {
    background: <% color_hash $system_bg %>;
    color:      <% color_hash $system_text %>;
    border:     1px solid <% color_css_rgba $primary_10 0.45 %>;
}
```

### Variable injection (fonts, sizes)

```ini
size   = <%= $font_size_mlarge %>
family = '<%= $font_mono %>'
```

### Distro/profile conditionals

```bash
<% if [[ $DEPLOY_DISTRO == "arch" ]]; then -%>
alias uu="sudo pacman -Syu"
<% fi -%>

<% if [[ " $DEPLOY_PROFILE " == *" workstation "* ]]; then -%>
export BROWSER="qutebrowser"
<% fi -%>
```

### Host conditionals

```bash
/* <%
source $XDG_OPT_HOME/theme/theme.sh
if [[ $DEPLOY_HOST == "casino" ]]; then
    waybar_font_size=$font_size_small
else
    waybar_font_size=$font_size_medium
fi
-%> */
font-size: <%= $waybar_font_size %>px;
```

### Comment hiding

Wrap ESH control tags in native comment syntax to keep the rendered output readable and linters happy:

```css
/* <% source $XDG_OPT_HOME/theme/theme.sh -%> */
```

## Rendering

Modules render templates via the `render_esh_template` wrapper from `lib/template.sh`:

```bash
source "$base_dir/lib/template.sh"
render_esh_template "$src/config~esh" "$XDG_CONFIG_HOME/app/config"
```
