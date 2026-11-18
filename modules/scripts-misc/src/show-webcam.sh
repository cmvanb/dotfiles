#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Show webcam video using ffplay
#-------------------------------------------------------------------------------

device=/dev/video0
attempts=3
first_frame_timeout=50 # tenths of a second

# A stalled ffplay holds the device without ever showing a window.
pkill -KILL -f "^ffplay .*$device" && sleep 0.5

log=$(mktemp)
trap 'rm -f "$log"' EXIT

for ((attempt = 1; attempt <= attempts; attempt++)); do
    ffplay -nostats -loglevel verbose -fflags nobuffer \
        -input_format mjpeg -video_size 1600x1200 "$device" \
        > /dev/null 2> "$log" &
    pid=$!

    for ((tick = 0; tick < first_frame_timeout; tick++)); do
        # ffplay creates its texture on the first decoded frame.
        grep -q 'texture' "$log" && exit 0
        kill -0 "$pid" 2> /dev/null || break
        sleep 0.1
    done

    kill -KILL "$pid" 2> /dev/null
    wait "$pid" 2> /dev/null
done

notify-send -u critical "show-webcam" "No video from $device: $(tail -n 1 "$log")"
exit 1
