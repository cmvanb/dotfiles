#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Outputs workspace mapper daemon
#
# Subscribes to sway output events and writes a state file consumed by sws.sh
# for display-aware workspace switching.
#
# Output priority is read from output-order (one output name per line).
# Outputs not listed in the file rank above all listed outputs (unknown monitors
# are treated as higher priority, e.g. an external display on a laptop).
#
# State file: $XDG_STATE_HOME/sway/outputs-workspace-map
#   Format: one line per active output — "name:offset"
#   where offset = slot * 10 (slot 0 = primary, slot 1 = secondary, ...)
#-------------------------------------------------------------------------------

set -euo pipefail

# Kill any previous instance before taking over.
pkill -f "outputs-workspace-mapper.sh" --ignore-ancestors || true

order_file="${XDG_CONFIG_HOME:-$HOME/.config}/sway/output-order"
state_file="${XDG_STATE_HOME:-$HOME/.local/state}/sway/outputs-workspace-map"

read_order() {
    if [[ -f "$order_file" ]]; then
        grep -v '^\s*#' "$order_file" | grep -v '^\s*$'
    fi
}

get_active_outputs() {
    swaymsg -t get_outputs | jq -r '.[] | select(.active) | .name'
}

update_state() {
    local -a orders=() active=() unknown=() ordered=()
    local active_output known_output

    mapfile -t orders < <(read_order)
    mapfile -t active < <(get_active_outputs)

    # Collect unknown outputs (active but not in orders file) — highest priority
    for active_output in "${active[@]}"; do
        local known=0
        for known_output in "${orders[@]}"; do
            [[ "$active_output" == "$known_output" ]] && known=1 && break
        done
        [[ $known -eq 0 ]] && unknown+=("$active_output")
    done

    # Build ordered slot list: unknowns first, then known outputs that are active
    [[ ${#unknown[@]} -gt 0 ]] && ordered=("${unknown[@]}")
    for known_output in "${orders[@]}"; do
        for active_output in "${active[@]}"; do
            [[ "$active_output" == "$known_output" ]] && ordered+=("$active_output") && break
        done
    done

    mkdir -p "$(dirname "$state_file")"
    : > "$state_file"

    local slot
    for slot in "${!ordered[@]}"; do
        printf '%s:%d\n' "${ordered[$slot]}" $(( slot * 10 )) >> "$state_file"
    done
}

update_state

while read -r _event; do
    update_state
done < <(swaymsg -t subscribe '["output"]' --raw)
