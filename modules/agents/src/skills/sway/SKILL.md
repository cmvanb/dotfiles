---
name: sway
description: Control the Sway (i3-compatible Wayland) window manager programmatically via swaymsg. Identify windows, target them with criteria, and float/tile/resize/position them. Run a headless Sway instance to launch and drive GUI apps in a feedback loop without touching the user's session.
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

## Headless Sway

Run GUI apps in a headless Sway instance whenever a feedback loop needs to launch, drive, or restart them. This keeps windows, focus, and input out of the user's session.

### Start

```bash
dir=/tmp/opencode/headless; mkdir -p "$dir"
printf 'output HEADLESS-1 resolution 1280x800\n' > "$dir/sway.conf"
before=$(ls "$XDG_RUNTIME_DIR" | grep -x 'wayland-[0-9]*')

env -u SWAYSOCK -u WAYLAND_DISPLAY -u DISPLAY \
    WLR_BACKENDS=headless WLR_LIBINPUT_NO_DEVICES=1 WLR_RENDERER=pixman \
    setsid sway -c "$dir/sway.conf" > "$dir/sway.log" 2>&1 < /dev/null &
pid=$!; sleep 2

sock=$XDG_RUNTIME_DIR/sway-ipc.$UID.$pid.sock
display=$(comm -13 <(echo "$before") <(ls "$XDG_RUNTIME_DIR" | grep -x 'wayland-[0-9]*'))
```

Shell variables are lost between tool calls. Record `pid`, `sock` and `display` in the output.

### Use

```bash
env -u DISPLAY WAYLAND_DISPLAY=$display <app> ...       # launch an app inside it
swaymsg -s "$sock" -t get_tree                          # query or drive it
WAYLAND_DISPLAY=$display grim "$dir/shot.png"           # screenshot
```

- Unset `DISPLAY`: the headless instance has no Xwayland, so apps must use Wayland.
- Give the app its own config and state directory, such as `qutebrowser --basedir` or a separate `XDG_CONFIG_HOME`. Single-instance apps otherwise forward commands to the user's running instance.
- Report results with a probe that is independent of the display, such as a local HTTP beacon, a log file, or `grim`.

### Stop

```bash
kill <app-pid> "$pid"
rm -rf "$dir"
```

- Kill by PID. `pkill -f <pattern>` also matches the shell running the command and kills it.
- Confirm the `wayland-N` and `sway-ipc` sockets are gone.
