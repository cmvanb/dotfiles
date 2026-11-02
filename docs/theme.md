# Theme system

One set of colors, fonts, and cursors drives every app.
`theme switch` swaps between a dark and a light scheme at runtime.

| Module | Role |
|---|---|
| `lib-theme` | `theme` command, cache generator, runtime APIs |
| `theme-base` | YAML sources, terminal assets, cache at deploy time |
| `theme-desktop` | GTK, Qt, and icon themes, palette generators |

## Colors

The schemes `carbon-dark` and `carbon-light` define the same keys.

Color keys are `#RRGGBB` strings named `<palette>_<step>`, such as
`primary_8`.
ANSI keys (`ansi_red`, `ansi_brblue`) and semantic keys (`system_bg`,
`shadow`, `syn_function`, `gtk_window_bg`) are YAML aliases of palette
steps.

### Steps follow contrast

A step index measures contrast against the canvas, not lightness.
Step `0` sits next to the canvas and the top step has the most contrast.
`text_15` is the lightest cream in carbon-dark and the darkest ink in
carbon-light.
A consumer that names steps by index works in both schemes.
For example, `text_15` on `primary_8` is readable in either.

Where a role does not mirror, the scheme overrides a semantic alias.
Consumers never branch on the variant.

- `shadow` stays dark in both schemes.
- `gtk_*` follow GTK elevation, so raised surfaces are lighter than the
  window in both schemes.

### Carbon Light is generated

`generate-contrast-mirror-palette.py` solves each light step in OKLCH.
Its WCAG contrast against the cream canvas matches the dark twin's
contrast against the dark canvas, raised slightly for bright rooms.
Near-canvas steps take the cream tint.
Text is espresso ink, grays are cool steel, and yellow stops at gold so
high steps stay mustard.

```bash
generate-contrast-mirror-palette.py modules/theme-base/src/carbon-dark.yaml
```

The script prints the palette section of `carbon-light.yaml`.

### Variant

`scheme.variant` is `dark` or `light`.
Apps with a polarity flag read it, such as GTK `prefer-dark-theme`,
delta, Claude Code `base`, qutebrowser dark mode, and the mermaid theme.

## Fonts

`fonts.yaml` holds four kinds of keys.

- Faces are `font_mono`, `font_sans`, and `font_serif`.
- Sizes run from `font_size_tiny` to `font_size_xxlarge` and set
  hierarchy within one surface.
- Roles size one surface for every app that draws it.
- `zoom_level` is the page scale of qutebrowser and draw.io.

| Role | Unit | Consumers |
|---|---|---|
| `font_size_terminal` | pt | ghostty, alacritty |
| `font_size_bar` | px | waybar, eww |
| `font_size_bar_tooltip` | px | waybar |

Sizes and roles depend on the face.
When the face changes, retune them in `fonts.yaml` and in every host file
that sets them.

## Cursor

`cursor.yaml` sets the shared size.
Each scheme picks the cursor theme that contrasts with its canvas.
carbon-dark uses the light-filled `Simp1e` and carbon-light uses
`Simp1e-Dark`.
`theme switch` applies it to gsettings and re-renders the sway and niri
configs.

## Host overlay

`hosts/<host>.yaml` overrides any key of `fonts` or `cursor`.
`theme-base::install()` selects it by `DEPLOY_HOST` and merges it last.
Hosts without a file use the defaults.
Consumers read the merged keys and never branch on the host.

## Deploy

`theme-base::install()` links the sources from `modules/theme-base/src/`
into `$XDG_CONFIG_HOME/theme/`.

```
carbon-dark.yaml
carbon-light.yaml
cursor.yaml
fonts.yaml
host.yaml    -> hosts/<host>.yaml, when present
colors.yaml  -> the selected scheme, carbon-dark on first deploy
```

`theme.py parse` then merges them into `$XDG_CACHE_HOME/theme/`.
It writes `theme-data.sh`, `theme-data.fish`, and `theme-data.lua`.
The cache stores the scheme properties as `scheme_name` and
`scheme_variant`.

## Switching schemes

```bash
theme switch dark|light|toggle
theme status
```

In sway, `$mod+Shift+c` toggles the scheme.

`template::render_mako` records every render in
`$XDG_STATE_HOME/dotfiles/renders`.
`theme switch` runs these steps:

1. Repoints `colors.yaml` and regenerates the cache.
2. Re-renders every recorded template that follows the active scheme and
   prunes entries whose template or output is gone.
3. Selects the GTK and icon themes.
4. Tells running apps to reload.

| App | Reload |
|---|---|
| sway | Config reload |
| niri | Watches its included theme file |
| waybar, eww, swaync, swayosd | Signal, reload command, or service restart |
| ghostty | `SIGUSR2` |
| wezterm | Config touch |
| Neovim | `SIGUSR1`, replays every highlight |
| qutebrowser | `:restart`, required by `preferred_color_scheme` |
| bat, delta | `bat cache --build` |

Other apps pick up the scheme on their next launch.

> [!NOTE]
> Running GTK apps keep their theme until restarted.
> Sway and niri export `GTK_THEME=carbon-gtk`, an alias that
> `theme switch` repoints.

## GTK

`theme-desktop` installs `carbon-dark-gtk` and `carbon-light-gtk` from the
`carbon-gtk` submodule.
Both render the shared templates in `carbon-dark-gtk/`, each pinned to its
own scheme, on its own adw-gtk3 v5.8 widget base.
The templates map Adwaita's named palette onto the variant's steps and
take surfaces from the `gtk_*` aliases.
Adwaita's palette is absolute, so `blue_1` is its lightest blue.

The icon themes `carbon-dark` and `carbon-light` share symbolic overrides
and inherit `Win11-dark` and `Win11`.
Win11 ships its symbolic status icons as fixed 22 and 24px panel art,
which GTK picks at 17 to 24px on a scale 1 output.
Both themes link every Win11 symbolic status icon into `scalable/status`,
so every size resolves to the symbolic glyph.

## Qt

`theme-desktop` installs the carbon Qt theme for qt6ct from the
`carbon-qt` submodule.
Sway and niri export `QT_QPA_PLATFORMTHEME=qt6ct`.

| File | Role |
|---|---|
| `colors/carbon.mako.conf` | QPalette, one `gtk_*` alias or step per role |
| `qss/carbon.mako.qss` | Menus, tooltips, scrollbars, buttons, item hover |
| `icons/icons.tsv` | Icon overrides as name, context, and source |
| `icons/src/` | Icons Win11 lacks, drawn in its 16px style |
| `generate-icons.py` | Writes the `carbon-dark-qt` and `carbon-light-qt` icon themes |

The palette and stylesheet render for both variants under
`$XDG_DATA_HOME/qt6ct/`.
`qt6ct.conf` follows the active scheme, so `theme switch` re-renders it
and qt6ct restyles running Qt apps.

`carbon-dark-qt` inherits `Win11-dark,Win11` and `carbon-light-qt`
inherits `Win11`.
`Win11-dark` only overlays `Win11`, and Win11's `status/` directories
ship white tray art under action names, so lookups need both fixes.
Each override is its source recolored to Win11's ink, `#dedede` on dark
and `#363636` on light.

qutebrowser leaves `colors.contextmenu.*` unset, so its context menus take
the Qt theme and match GTK popovers.

## Runtime API

Source the API in a deploy script, then call its functions.
Mako templates get every theme value as a plain variable, described in
[templates.md](templates.md).

```bash
source $XDG_OPT_HOME/theme/theme.sh
bg=$(color_hash $primary_0)
```

| File | Language | Loads |
|---|---|---|
| `theme.sh` | Bash | `$XDG_CACHE_HOME/theme/theme-data.sh` |
| `theme.fish` | Fish | `$XDG_CACHE_HOME/theme/theme-data.fish` |
| `theme.lua` | Lua | `$XDG_CACHE_HOME/theme/theme-data.lua` |
| `theme.py` | Python | `$XDG_CONFIG_HOME/theme/{colors,fonts,cursor,host}.yaml` |

`theme.py` reads `$THEME_COLORS` instead of `colors.yaml` when set.

| Function | Output | Example |
|---|---|---|
| `color_named` | `RRGGBB` | `05aaff` |
| `color_hash` | `#RRGGBB` | `#05aaff` |
| `color_zerox` | `0xRRGGBB` | `0x05aaff` |
| `color_rgb_int` | `R,G,B` | `5,170,255` |
| `color_css_rgba` | `rgba(R, G, B, A)` | `rgba(5, 170, 255, 0.8)` |
| `color_256` | 256-color index | `31` |
| `color_ansi_fg` | 24-bit foreground escape | `\e[38:2:5:170:255m` |
| `color_ansi_bg` | 24-bit background escape | `\e[48:2:5:170:255m` |
| `color_ansi_reset` | Reset escape | `\e[0m` |
| `font <key>` | Font value | `Nordwand Mono` |
| `cursor <key>` | Cursor value | `Simp1e`, `32` |
| `scheme <key>` | Scheme property, Python and Lua only | `light` |
