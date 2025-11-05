#!/usr/bin/env bash
set -euo pipefail

window_info=$(swaymsg -t get_tree | jq '.. | select(.focused? == true)')

pid=$(echo "$window_info" | jq -r '.pid')
floating=$(echo "$window_info" | jq -r '.floating')
x=$(echo "$window_info" | jq -r '.rect.x')
y=$(echo "$window_info" | jq -r '.rect.y')
width=$(echo "$window_info" | jq -r '.rect.width')
height=$(echo "$window_info" | jq -r '.rect.height')

is_floating=false
[[ "$floating" == *"_on" ]] && is_floating=true

shell_pid=$(pgrep -P "$pid" | head -1)
if [[ -n "$shell_pid" ]]; then
    cwd=$(readlink /proc/"$shell_pid"/cwd 2>/dev/null || echo "$HOME")
else
    cwd="$HOME"
fi

unique_id="cloned-terminal-$$-$RANDOM"

spawn-terminal.sh \
    --working-directory="$cwd" \
    --title="$unique_id" \
    --floating

if [[ "$is_floating" == true ]]; then
    offset=30
    waybar_height=$(swaymsg -t get_tree | jq '.. | select(.type? == "workspace" and .num? > 0) | .rect.y' | head -n1)
    new_x=$((x + offset))
    new_y=$((y + offset - waybar_height))

    for i in {1..100}; do
        if swaymsg "[title=\"$unique_id\"]" nop &>/dev/null; then
            swaymsg "[title=\"$unique_id\"] floating enable, resize set ${width}px ${height}px, move position $new_x $new_y" &>/dev/null

            break
        fi
        sleep 0.0025
    done
fi
