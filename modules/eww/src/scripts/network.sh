#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Network state listener for eww (NetworkManager)
#
# Prints one JSON object per change, and every 10 seconds for signal updates:
#
#   {"type": "wifi", "iface": "wlan0", "name": "ssid", "signal": 72,
#    "ip": "192.168.1.2/24", "gateway": "192.168.1.1", "wifi_enabled": true}
#-------------------------------------------------------------------------------

set -uo pipefail

emit() {
    local device type state name signal="" ip="" gateway="" wifi_enabled

    wifi_enabled=$(nmcli -t radio wifi 2>/dev/null)

    # Primary device: the first connected one, as ordered by NetworkManager.
    IFS=: read -r device type state name < <(
        nmcli -t -f DEVICE,TYPE,STATE,CONNECTION device 2>/dev/null \
            | grep -E ':(ethernet|wifi):connected:' | head -1
    )

    if [[ -z ${device:-} ]]; then
        jq -cn --arg wifi "$wifi_enabled" \
            '{type: "none", iface: "", name: "", signal: 0, ip: "", gateway: "", wifi_enabled: ($wifi == "enabled")}'
        return
    fi

    if [[ $type == wifi ]]; then
        signal=$(nmcli -t -f IN-USE,SIGNAL device wifi list --rescan no 2>/dev/null | awk -F: '$1 == "*" { print $2; exit }')
    fi
    ip=$(nmcli -g IP4.ADDRESS device show "$device" 2>/dev/null | head -1)
    gateway=$(nmcli -g IP4.GATEWAY device show "$device" 2>/dev/null)

    jq -cn \
        --arg type "$type" --arg iface "$device" --arg name "$name" \
        --arg signal "${signal:-0}" --arg ip "$ip" --arg gateway "$gateway" \
        --arg wifi "$wifi_enabled" \
        '{type: $type, iface: $iface, name: $name, signal: ($signal | tonumber),
          ip: $ip, gateway: $gateway, wifi_enabled: ($wifi == "enabled")}'
}

emit

exec {monitor}< <(nmcli monitor 2>/dev/null)
while true; do
    if read -r -t 10 -u "$monitor" _; then
        while read -r -t 0.2 -u "$monitor" _; do :; done
    fi
    emit
done
