#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Kill the hyprland window under the mouse cursor.
#-------------------------------------------------------------------------------

clients=$(hyprctl -j clients)
address=$(echo "$clients"| jq -r '.[] | select(.focusHistoryID == 0) | .address')
window=$(echo "$clients" | jq -r --arg ADDR "$address" '.[] | select(.address==$ADDR)')

window_x=$(echo "$window" | jq -r '.at.[0]')
window_y=$(echo "$window" | jq -r '.at.[1]')

window_w=$(echo "$window" | jq -r '.size.[0]')
window_h=$(echo "$window" | jq -r '.size.[1]')

cursor_position=$(hyprctl cursorpos | tr -d '[:space:]')
IFS=, read -r cursor_x cursor_y <<< "$cursor_position"

if [ "$cursor_x" -ge "$window_x" ] \
    && [ "$cursor_x" -le "$((window_x + window_w))" ] \
    && [ "$cursor_y" -ge "$window_y" ] \
    && [ "$cursor_y" -le "$((window_y + window_h))" ];
then
    hyprctl dispatch closewindow address:"$address"
fi
