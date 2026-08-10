---
name: sway
description: Control the Sway (i3-compatible Wayland) window manager programmatically via swaymsg. Identify windows, target them with criteria, and float/tile/resize/position them.
---

# Sway Skill

## swaymsg

Drive Sway from the shell with `swaymsg`. See `man 5 sway` and `man 5 sway-input` for the full command and criteria reference.

Check the exit status, not just the printed body: `-q` silences the JSON but a failing command still exits nonzero, and an unreachable socket fails with a plain error line instead of JSON.

## Rules

- When testing or experimenting with workspaces, snapshot the focused workspace. Restore its focus, name, and layout when done.

## Inspect State

Everything is a node in a tree. Query it, then filter with `jq`.

```bash
swaymsg -t get_tree                  # full window tree (JSON)
swaymsg -t get_workspaces            # workspaces + which is focused
swaymsg -t get_outputs               # monitors, geometry, focus
swaymsg -t get_marks                 # all defined marks
swaymsg -t get_seats                 # input seats / focus
```

A window node exposes these key identity fields.

| Field | Notes |
|---|---|
| `id` | Container id. Remains valid until the window closes; a stale id fails with `"No matching node."` |
| `app_id` | Identifies Wayland-native apps. |
| `window_properties.class`/`.instance`/`.title` | Identifies XWayland apps. |
| `name` | Window's current title. |
| `pid` | |
| `shell` | |
| `focused` | |
| `floating` | |
| `rect` | |

## Identify a Window

Recurse through `nodes` and `floating_nodes` to reach every window.

```bash
# Currently focused window's identity
swaymsg -t get_tree | jq -r '.. | select(.focused? == true) | {id, app_id, name, pid}'

# All windows: id, app_id/class, title
swaymsg -t get_tree | jq -r '.. | objects | select(.pid? and .name?) | "\(.id)\t\(.app_id // .window_properties.class)\t\(.name)"'

# Find the container id of the first Firefox window
swaymsg -t get_tree | jq '.. | objects | select(.app_id? == "firefox") | .id' | head -1

# Is anything fullscreen on the focused workspace?
swaymsg -t get_tree | jq '.. | select(.focused? == true) | .fullscreen_mode'
```

Discover an app's `app_id` or X11 `class` interactively by focusing it and reading the focused node, or watch events live:

```bash
swaymsg -t subscribe '["window"]' -m | jq -r '.change + " " + (.container.app_id // .container.window_properties.class // "?")'
```

## Target a Window with Criteria

A command prefixed by `[criteria]` runs against every matching window instead of the focused one. Multiple criteria in one bracket are ANDed.

```bash
swaymsg '[app_id="firefox"] focus'
swaymsg '[class="Gimp"] floating enable'                # XWayland app by class
swaymsg '[title="(?i)youtube"] move to workspace 9'     # title is a regex
swaymsg '[con_id=78] kill'                              # exact container by id
swaymsg '[pid=197182] focus'
swaymsg '[app_id="mpv" floating] move position center'
```

The table below lists the useful criteria.

| Criterion | Notes |
|---|---|
| `app_id` | Wayland-native app identifier. |
| `class`, `instance` | XWayland app identifiers. |
| `title` | Current window title. |
| `con_id` | Container id from `get_tree`. |
| `con_mark` | User-assigned mark. |
| `pid` | Process id. |
| `shell` | `xdg_shell`, `xwayland`, or similar. |
| `workspace` | Name of the containing workspace. |
| `floating`, `tiling` | Match by layout state. |
| `urgent` | Matches windows with the urgency hint set. |
| `all` | Matches every window. |

Special values include `con_id=__focused__`, `app_id=__focused__`, and `urgent=latest`. Text criteria are PCRE regexes, so anchor them (`title="^Foo$"`) to avoid partial matches.

## Float vs Tile

```bash
swaymsg floating toggle                                 # focused window
swaymsg '[app_id="pavucontrol"] floating enable'
swaymsg floating disable                                # send back to tiling
```

## Resize

`resize` works on tiled and floating windows; `set` is absolute, `grow`/`shrink` are relative. Units are `px` or `ppt` (percent of parent/output).

```bash
swaymsg resize set width 800 px height 600 px
swaymsg resize set width 50 ppt height 50 ppt           # half the screen
swaymsg resize grow width 100 px
swaymsg resize shrink height 10 ppt
swaymsg '[app_id="mpv"] resize set 1280 720'            # shorthand: w h in px
```

## Position Floating Windows

A window must be floating for absolute positioning to apply.

```bash
swaymsg move position 100 200                           # x y, px relative to output
swaymsg move position center                            # center on current output
swaymsg move position cursor                            # under the pointer
swaymsg move absolute position 0 0                      # relative to whole layout
swaymsg move absolute position center                   # center across all outputs

# Resize + place in one go (top-right corner of a 2242px-wide output)
swaymsg '[app_id="mpv"] floating enable, resize set 640 360, move position 1602 0'
```

Chain commands with `,`. A `;` starts a fresh command with its own (or no) criteria.

## Move, Focus, Workspaces

```bash
swaymsg focus left                                      # left|right|up|down|parent|child
swaymsg '[con_id=78] focus'
swaymsg move left 50 px                                 # nudge in a direction
swaymsg move window to workspace 3
swaymsg move window to output DP-4                      # or left|right|up|down
swaymsg workspace 3
swaymsg move workspace to output DP-3
```

## Marks and Scratchpad

Marks are user labels for windows; the scratchpad is a hidden floating store.

```bash
swaymsg mark myterm                                     # label focused window
swaymsg '[con_mark="myterm"] focus'
swaymsg unmark myterm

swaymsg move scratchpad                                 # hide focused window
swaymsg scratchpad show                                 # cycle visible scratchpad windows
swaymsg '[app_id="telegram"] scratchpad show'           # show a specific one
```
