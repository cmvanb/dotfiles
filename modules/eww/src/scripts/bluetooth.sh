#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Bluetooth state listener for eww (BlueZ)
#
# Prints one JSON object per BlueZ change, and every 30 seconds:
#
#   {"powered": true, "connected": 1,
#    "devices": [{"address": "...", "name": "...", "icon": "audio-headset",
#                 "connected": true, "battery": 80, "battery_icon": "battery-level-80-symbolic"}]}
#-------------------------------------------------------------------------------

set -uo pipefail

device_json() {
    bluetoothctl info "$1" 2>/dev/null | awk -v address="$1" '
        /^\tName: /               { sub(/^\tName: /, ""); name = $0 }
        /^\tIcon: /               { icon = $2 }
        /^\tConnected: /          { connected = ($2 == "yes") }
        /^\tBattery Percentage: / { gsub(/[()]/, "", $4); battery = $4 }
        END {
            gsub(/["\\]/, "", name)
            battery_icon = battery == "" ? "" : sprintf("battery-level-%d-symbolic", int((battery + 5) / 10) * 10)
            printf "{\"address\":\"%s\",\"name\":\"%s\",\"icon\":\"%s\",\"connected\":%s,\"battery\":%s,\"battery_icon\":\"%s\"}\n",
                address, name, icon, connected ? "true" : "false", battery == "" ? "null" : battery, battery_icon
        }'
}

emit() {
    local powered address
    powered=$(bluetoothctl show 2>/dev/null | awk '/^\tPowered:/ { print ($2 == "yes"); exit }')

    {
        bluetoothctl devices Paired 2>/dev/null | while read -r _ address _; do
            device_json "$address"
        done
    } | jq -sc --arg powered "${powered:-0}" '{
        powered: ($powered == "1"),
        connected: (map(select(.connected)) | length),
        devices: sort_by((.connected | not), .name)
    }'
}

emit

exec {monitor}< <(dbus-monitor --system "type='signal',sender='org.bluez'" 2>/dev/null)
while true; do
    if read -r -t 30 -u "$monitor" _; then
        while read -r -t 0.3 -u "$monitor" _; do :; done
    fi
    emit
done
