#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Change output volume with audible feedback
#
# Usage: volume.sh raise|lower               # volume keys: step with swayosd
#        volume.sh set <wpctl target> <pct>  # sliders: set an absolute volume
#
# Output changes play the volume-change sound. Held keys and dragged sliders
# fire many changes, so the sound plays at most once per interval.
#-------------------------------------------------------------------------------

set -uo pipefail

sound=/usr/share/sounds/freedesktop/stereo/audio-volume-change.oga
stamp="${XDG_RUNTIME_DIR:-/tmp}/sway/volume-sound"
interval_ms=100

play_feedback() {
    local now last
    now=$(date +%s%3N)
    last=$(cat "$stamp" 2>/dev/null || echo 0)
    (( now - last >= interval_ms )) || return 0

    mkdir -p "$(dirname "$stamp")"
    echo "$now" > "$stamp"
    # Detached, so callers with a command timeout (eww) do not cut it short.
    setsid -f paplay "$sound" &> /dev/null
}

case ${1:-} in
    raise|lower)
        swayosd-client --output-volume "$1" && play_feedback
        ;;

    set)
        target=$2
        wpctl set-volume "$target" "${3%.*}%"
        [[ $target == @DEFAULT_AUDIO_SINK@ ]] && play_feedback
        ;;

    *)
        echo "Usage: $(basename "$0") raise | lower | set <target> <percent>" >&2
        exit 1
        ;;
esac
