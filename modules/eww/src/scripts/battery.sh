#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Battery details for eww
#
# Supports both energy (µWh/µW) and charge (µAh/µA) reporting batteries.
#
#   {"present": true, "capacity": 33, "status": "Discharging", "icon": "battery-030",
#    "watts": 16.4, "remaining": "1h 37m", "health": 96, "cycles": 12}
#-------------------------------------------------------------------------------

set -uo pipefail

battery=$(find /sys/class/power_supply -maxdepth 1 -name 'BAT*' | sort | head -1)

if [[ -z $battery ]]; then
    echo '{"present":false,"capacity":0,"status":"","icon":"","watts":0,"remaining":"","health":0,"cycles":0}'
    exit 0
fi

read_value() {
    cat "$battery/$1" 2>/dev/null || echo 0
}

status=$(read_value status)
capacity=$(read_value capacity)
cycles=$(read_value cycle_count)
voltage=$(read_value voltage_now)

if [[ -e $battery/energy_now ]]; then
    now=$(read_value energy_now)
    full=$(read_value energy_full)
    design=$(read_value energy_full_design)
    rate=$(read_value power_now)
    watts=$(awk -v p="$rate" 'BEGIN { printf "%.1f", p / 1e6 }')
else
    now=$(read_value charge_now)
    full=$(read_value charge_full)
    design=$(read_value charge_full_design)
    rate=$(read_value current_now)
    watts=$(awk -v i="$rate" -v v="$voltage" 'BEGIN { printf "%.1f", i * v / 1e12 }')
fi

# Hours until empty or full, at the present rate.
remaining=$(awk -v now="$now" -v full="$full" -v rate="$rate" -v status="$status" 'BEGIN {
    if (rate <= 0) exit
    if (status == "Discharging") hours = now / rate
    else if (status == "Charging") hours = (full - now) / rate
    else exit
    printf "%dh %02dm", int(hours), int((hours - int(hours)) * 60)
}')

# Theme icons come in 10% steps: battery-000 ... battery-100[-charging].
icon=$(printf 'battery-%03d' $(( (capacity + 5) / 10 * 10 )))
[[ $status == Charging ]] && icon+=-charging

health=$(awk -v full="$full" -v design="$design" 'BEGIN { printf "%d", (design > 0 ? 100 * full / design : 0) }')

jq -cn \
    --argjson capacity "$capacity" --arg status "$status" --arg icon "$icon" --argjson watts "$watts" \
    --arg remaining "$remaining" --argjson health "$health" --argjson cycles "$cycles" \
    '{present: true, capacity: $capacity, status: $status, icon: $icon, watts: $watts,
      remaining: $remaining, health: $health, cycles: $cycles}'
