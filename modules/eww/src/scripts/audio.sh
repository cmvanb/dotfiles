#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Audio state listener for eww
#
# Prints one JSON object per change of the default sink, default source, or
# sink list:
#
#   {"volume": 80, "muted": false, "mic_volume": 100, "mic_muted": false,
#    "sinks": [{"name": "...", "description": "...", "default": true}, ...]}
#-------------------------------------------------------------------------------

set -uo pipefail

volume_of() {
    # `wpctl get-volume` prints "Volume: 0.80" with an optional " [MUTED]".
    wpctl get-volume "$1" 2>/dev/null | awk '{ printf "%d %s", $2 * 100 + 0.5, ($3 == "[MUTED]") }'
}

emit() {
    local volume muted mic_volume mic_muted default_sink
    read -r volume muted < <(volume_of @DEFAULT_AUDIO_SINK@)
    read -r mic_volume mic_muted < <(volume_of @DEFAULT_AUDIO_SOURCE@)
    default_sink=$(pactl get-default-sink 2>/dev/null)

    pactl -f json list sinks 2>/dev/null | jq -c \
        --argjson volume "${volume:-0}" \
        --argjson muted "${muted:-0}" \
        --argjson mic_volume "${mic_volume:-0}" \
        --argjson mic_muted "${mic_muted:-0}" \
        --arg default_sink "$default_sink" \
        '{
            volume: $volume,
            muted: ($muted == 1),
            mic_volume: $mic_volume,
            mic_muted: ($mic_muted == 1),
            sinks: [.[] | {name, description, default: (.name == $default_sink)}]
        }'
}

emit

# Coalesce bursts of events (a single volume step emits several) into one update.
while read -r _; do
    while read -r -t 0.05 _; do :; done
    emit
done < <(pactl subscribe 2>/dev/null | grep --line-buffered -E "on (sink|source|server)")
