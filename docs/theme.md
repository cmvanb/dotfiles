# Theme System

Unified color, font, and cursor management across all dotfiles.
Three modules cooperate:

| Module | Role |
|---|---|
| `lib-theme` | Runtime APIs (Bash, Fish, Lua, Python), cache generator, `theme` command |
| `theme-base` | YAML source files, terminal assets, cache generation at deploy time |
| `theme-desktop` | GTK configuration, GTK and icon themes, palette generators |

## YAML source files

`modules/theme-base/src/`:

```
carbon-dark.yaml    # colors: dark scheme
carbon-light.yaml   # colors: light scheme
cursor.yaml         # cursor: shared
fonts-linux.yaml    # fonts: Linux
fonts-windows.yaml  # fonts: Windows
```

Font and cursor files have a single top-level key (`fonts:`, `cursor:`).
Color schemes have two: `scheme:` and `colors:`.

### Scheme properties

```yaml
scheme:
  name: carbon-light
  variant: light
```

`variant` is `dark` or `light`.
Consumers with a polarity flag read it, for example GTK
`prefer-dark-theme`, delta `dark`/`light`, Claude Code `base`,
qutebrowser dark mode and the mermaid theme.

### Color scheme structure

Colors are `key: "#RRGGBB"` hex strings.
YAML anchors and aliases allow internal references (`ansi_red: *red_4`).

**Canvas**: `canvas` is the background every other color sits on.

**Core palettes** (16-step gradients): `primary`, `secondary`, `text`, `gray`

**Accent palettes** (10-step gradients): `red`, `orange`, `yellow`,
`green`, `cyan`, `blue`, `purple`, `magenta`

**ANSI mapping**: 16 terminal color indices mapped to palette entries,
with aliases (`ansi_red`, `ansi_brblue`, …)

**Semantic aliases**: reference palette colors via YAML aliases
(`system_bg`, `shadow`, `web_page_bg`, `syn_function`, `gtk_window_bg`).

### Contrast-indexed steps

Every palette step is indexed by its contrast against the canvas,
not by lightness.
Step `0` sits next to the canvas and the top step has the most contrast.
In carbon-dark `text_15` is the lightest cream; in carbon-light it is the
darkest ink.

Consumers therefore reference steps by index and work unchanged in both
schemes: `text_15` on `primary_8` is readable ink on a focus color in
either scheme.
Both schemes define the same keys.

Where a role does not mirror, the scheme overrides a semantic alias
instead of the consumer branching on the variant:

- `shadow` stays dark in both schemes (`canvas` in dark, `gray_15` in light).
- `gtk_*` follow GTK elevation: raised surfaces are lighter than the
  window in both schemes.

### Carbon Light

carbon-light is generated from carbon-dark.
Each step is solved in OKLCH so its WCAG contrast against the cream canvas
matches its dark twin's contrast against the dark canvas, raised slightly
for bright rooms.
Near-canvas steps take the cream tint; text is espresso ink, grays are cool
steel, yellow is capped at gold so high steps stay mustard.
The design parameters live in the generator:

```bash
generate-contrast-mirror-palette.py modules/theme-base/src/carbon-dark.yaml
```

It prints the palette section of `carbon-light.yaml`.

## Deploy-time flow

`theme-base::install()` symlinks source files, keeps the selected scheme
(carbon-dark on first deploy), then runs the cache generator:

`$XDG_CONFIG_HOME/theme/`:

```
├── carbon-dark.yaml   -> modules/theme-base/src/carbon-dark.yaml
├── carbon-light.yaml  -> modules/theme-base/src/carbon-light.yaml
├── cursor.yaml        -> modules/theme-base/src/cursor.yaml
├── fonts.yaml         -> modules/theme-base/src/fonts-linux.yaml
└── colors.yaml        -> carbon-dark.yaml or carbon-light.yaml
```

Cache generator merges the YAML files and writes language-specific cache
files:

`$XDG_CACHE_HOME/theme/`:

```
├──  theme-data.sh    # Bash variables
├──  theme-data.fish  # Fish variables
└──  theme-data.lua   # Lua table
```

Scheme properties are cached as `scheme_name` and `scheme_variant`.

## Switching schemes

```bash
theme switch dark|light|toggle
theme status
```

`$mod+Shift+c` toggles the scheme in sway.

`template::render_mako` records every render in
`$XDG_STATE_HOME/dotfiles/renders`.
`theme switch` repoints `colors.yaml`, regenerates the cache, re-renders
every recorded template, selects the GTK and icon themes, then tells
running apps to reload.
Entries whose template or output is gone are pruned.

| App | Reload |
|---|---|
| sway, Hyprland, river | Config reload or theme script |
| waybar, eww, swaync, swayosd | Signal, reload command or service restart |
| ghostty | `SIGUSR2` |
| wezterm | Config touch |
| Neovim | `SIGUSR1`, replays every highlight against the new theme |
| qutebrowser | `:config-source` |
| bat, delta | `bat cache --build` |

Apps that read colors only at startup pick up the scheme on their next
launch.

> [!NOTE]
> Sway exports `GTK_THEME=carbon-gtk`, an alias that `theme switch`
> repoints. Running GTK apps keep their theme until restarted.

## GTK

`theme-desktop` installs `carbon-dark-gtk` and `carbon-light-gtk` from the
`carbon-gtk` submodule.
Both render the shared templates in `carbon-dark-gtk/`, each pinned to its
own scheme, and bring their own Adwaita widget base (adw-gtk3 v5.8, dark and
light).
The templates map Adwaita's absolute named palette (`blue_1` is lightest)
onto the variant's steps and take surfaces from the `gtk_*` aliases.

Icon themes `carbon-dark` and `carbon-light` share the symbolic overrides
and inherit `Win11-dark` and `Win11`.

## Runtime API

### Language APIs

| File | Language | Loads from |
|---|---|---|
| `theme.sh` | Bash | `$XDG_CACHE_HOME/theme/theme-data.sh` |
| `theme.fish` | Fish | `$XDG_CACHE_HOME/theme/theme-data.fish` |
| `theme.lua` | Lua | `$XDG_CACHE_HOME/theme/theme-data.lua` |
| `theme.py` | Python | `$XDG_CONFIG_HOME/theme/{colors,fonts,cursor}.yaml` directly |

`theme.py` reads `$THEME_COLORS` instead of `colors.yaml` when set.

### Color functions

| Function | Output | Example |
|---|---|---|
| `color_named` | `RRGGBB` | `05aaff` |
| `color_hash` | `#RRGGBB` | `#05aaff` |
| `color_zerox` | `0xRRGGBB` | `0x05aaff` |
| `color_rgb_int` | `R,G,B` | `5,170,255` |
| `color_css_rgba` | `rgba(R, G, B, A)` | `rgba(5, 170, 255, 0.8)` |
| `color_256` | 256-color index | `31` |
| `color_ansi_fg` | ANSI 24-bit fg escape | `\e[38:2:5:170:255m` |
| `color_ansi_bg` | ANSI 24-bit bg escape | `\e[48:2:5:170:255m` |
| `color_ansi_reset` | ANSI reset | `\e[0m` |

### Font / cursor / scheme functions

| Function | Output |
|---|---|
| `font <key>` | Font value (e.g. `Agave Nerd Font Mono`) |
| `cursor <key>` | Cursor value (e.g. `Simp1e`) |
| `scheme <key>` | Scheme property (e.g. `light`); Python and Lua |

## Usage in modules

Source the theme API at the top of a template or deploy script, then call
functions inline:

```bash
source $XDG_OPT_HOME/theme/theme.sh
bg=$(color_hash $primary_0)
```

Or inside a Mako template; see [templates.md](templates.md).
