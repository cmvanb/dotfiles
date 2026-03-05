# Theme System

Unified color, font, and cursor management across all dotfiles. Three modules cooperate:

| Module | Role |
|---|---|
| `lib-theme` | Runtime APIs (Bash, Fish, Lua, Python) + cache generator |
| `theme-base` | YAML source files, terminal assets, cache generation at deploy time |
| `theme-desktop` | GTK configuration |

## YAML source files

`modules/theme-base/src/`:
```
carbon-dark.yaml    # colors — dark scheme
carbon-light.yaml   # colors — light scheme
cursor.yaml         # cursor — shared
fonts-linux.yaml    # fonts — Linux
fonts-windows.yaml  # fonts — Windows
```

Each file has a single top-level key (`colors:`, `fonts:`, `cursor:`).

### Color scheme structure

Colors are `key: "#RRGGBB"` hex strings. YAML anchors/aliases allow internal references (`i0: *gray_0`).

**Core palettes** (16-step gradients): `primary`, `secondary`, `text`, `gray`

**Accent palettes** (10-step gradients): `red`, `orange`, `yellow`, `green`, `cyan`, `blue`, `purple`, `magenta`

**ANSI mapping**: 16 terminal color indices mapped to palette entries, with aliases (`ansi_red`, `ansi_brblue`, …)

## Deploy-time flow

`theme-base::install()` symlinks source files, selects active scheme/fonts, then runs the cache generator:

`$XDG_CONFIG_HOME/theme/`:
```
├── carbon-dark.yaml   -> modules/theme-base/src/carbon-dark.yaml
├── carbon-light.yaml  -> modules/theme-base/src/carbon-light.yaml
├── cursor.yaml        -> modules/theme-base/src/cursor.yaml
├── fonts.yaml         -> modules/theme-base/src/fonts-linux.yaml
└── colors.yaml        -> carbon-dark.yaml
```

Cache generator merges the YAML files and writes language-specific cache files:

`$XDG_CACHE_HOME/theme/`:
```
├──  theme-data.sh    # Bash variables
├──  theme-data.fish  # Fish variables
└──  theme-data.lua   # Lua table
```

## Runtime API

### Language APIs

| File | Language | Loads from |
|---|---|---|
| `theme.sh` | Bash | `$XDG_CACHE_HOME/theme/theme-data.sh` |
| `theme.fish` | Fish | `$XDG_CACHE_HOME/theme/theme-data.fish` |
| `theme.lua` | Lua | `$XDG_CACHE_HOME/theme/theme-data.lua` |
| `theme.py` | Python | `$XDG_CONFIG_HOME/theme/{colors,fonts,cursor}.yaml` directly |

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

### Font / cursor functions

| Function | Output |
|---|---|
| `font <key>` | Font value (e.g. `Agave Nerd Font Mono`) |
| `cursor <key>` | Cursor value (e.g. `Simp1e`) |

## Usage in modules

Source the theme API at the top of a template or deploy script, then call functions inline:

```bash
source $XDG_OPT_HOME/theme/theme.sh
bg=$(color_hash $primary_0)
```

Or inside an ESH template — see [templates.md](templates.md).
