#!/usr/bin/env bash
# Dependencies: bc, jq, awk
#-------------------------------------------------------------------------------
# Move a window; if it reaches an edge, move it to the next monitor.
# Handles both tiled and floating windows.
#-------------------------------------------------------------------------------

# Function to handle moving to adjacent monitor
function move_to_adjacent_monitor() {
    local dir="$1"

    mapfile -t sorted_monitors <<< "$(hyprctl monitors -j | jq -r 'sort_by(.x) | .[] | .id')"
    current_monitor="$(hyprctl activeworkspace -j | jq ".monitorID")"
    sorted_monitors_count="${#sorted_monitors[@]}"

    # Find the index of the current monitor in the sorted monitors array
    for index in "${!sorted_monitors[@]}"; do
        if [[ "${sorted_monitors[$index]}" == "$current_monitor" ]]; then
            current_index="$index"
            break
        fi
    done

    if [[ $dir == "r" ]]; then
        ((current_index++))
    elif [[ $dir == "l" ]]; then
        ((current_index--))
    fi

    # Floating windows don't wrap
    if [[ $is_floating == "true" ]]; then
        if (( current_index == sorted_monitors_count )); then
            return
        elif (( current_index < 0 )); then
            return
        fi
    fi

    if (( current_index == sorted_monitors_count )); then
        current_index=0
    elif (( current_index < 0 )); then
        current_index=$((sorted_monitors_count - 1))
    fi

    next_monitor_id="${sorted_monitors[$current_index]}"
    hyprctl dispatch movewindow mon:"$next_monitor_id"

    if [[ $is_floating == "true" ]]; then
        # For floating windows, position appropriately on the target monitor
        window_info=$(hyprctl activewindow -j)
        win_x=$(echo "$window_info" | jq '.at[0]')
        win_y=$(echo "$window_info" | jq '.at[1]')
        win_width=$(echo "$window_info" | jq '.size[0]')
        win_height=$(echo "$window_info" | jq '.size[1]')
        mon_info=$(hyprctl monitors -j | jq ".[] | select(.id == $next_monitor_id)")
        mon_x=$(echo "$mon_info" | jq ".x")
        mon_y=$(echo "$mon_info" | jq ".y")
        mon_transform=$(echo "$mon_info" | jq ".transform")
        if (( mon_transform == "1" )) || (( mon_transform == "3")); then
            mon_width=$(echo "$mon_info" | jq ".height")
            mon_height=$(echo "$mon_info" | jq ".width")
        else
            mon_width=$(echo "$mon_info" | jq ".width")
            mon_height=$(echo "$mon_info" | jq ".height")
        fi
        mon_scale=$(echo "$mon_info" | jq ".scale")
        scaled_mon_width=$(echo "$mon_width / $mon_scale" | bc -l | awk '{printf "%.0f", $1}')
        scaled_mon_height=$(echo "$mon_height / $mon_scale" | bc -l | awk '{printf "%.0f", $1}')

        # Scale the buffer for the target monitor
        scaled_buffer=$(echo "$buffer_zone * $mon_scale" | bc -l | awk '{printf "%.0f", $1}')

        if [[ $dir == "r" ]]; then
            # Position on the left side of the next monitor with buffer
            new_x=$((mon_x + scaled_buffer))
            new_y=$((mon_y + (scaled_mon_height / 2) - (win_height / 2)))
            hyprctl dispatch movewindowpixel "exact $new_x $new_y", activewindow
        elif [[ $dir == "l" ]]; then
            # Position on the right side of the next monitor with buffer
            new_x=$((mon_x + scaled_mon_width - win_width - scaled_buffer))
            new_y=$((mon_y + (scaled_mon_height / 2) - (win_height / 2)))
            hyprctl dispatch movewindowpixel "exact $new_x $new_y", activewindow
        fi
    else
        # For tiled windows, use existing logic
        if [[ $dir == "r" ]]; then
            # Position the active window on the left side of the next monitor
            hyprctl dispatch hy3:movewindow l
            hyprctl dispatch hy3:movewindow l
        elif [[ $dir == "l" ]]; then
            # Position the active window on the right side of the next monitor
            hyprctl dispatch hy3:movewindow r
            hyprctl dispatch hy3:movewindow r
        fi
    fi
}

direction="$1"
delta_h=338
delta_v=280
buffer_zone=20  # Buffer zone to prevent windows from getting too close to edges

# Check if window is floating
is_floating=$(hyprctl activewindow -j | jq '.floating')

# Handle floating windows
if [[ "$is_floating" == "true" ]]; then
    # Get current window position and size
    window_info=$(hyprctl activewindow -j)
    win_x=$(echo "$window_info" | jq '.at[0]')
    win_y=$(echo "$window_info" | jq '.at[1]')
    win_width=$(echo "$window_info" | jq '.size[0]')
    win_height=$(echo "$window_info" | jq '.size[1]')

    # Get current monitor dimensions and scale
    current_monitor="$(hyprctl activeworkspace -j | jq ".monitorID")"
    mon_info=$(hyprctl monitors -j | jq ".[] | select(.id == $current_monitor)")
    mon_x=$(echo "$mon_info" | jq ".x")
    mon_y=$(echo "$mon_info" | jq ".y")
    mon_transform=$(echo "$mon_info" | jq ".transform")
    if (( mon_transform == "1" )) || (( mon_transform == "3")); then
        mon_width=$(echo "$mon_info" | jq ".height")
        mon_height=$(echo "$mon_info" | jq ".width")
    else
        mon_width=$(echo "$mon_info" | jq ".width")
        mon_height=$(echo "$mon_info" | jq ".height")
    fi
    mon_scale=$(echo "$mon_info" | jq ".scale")
    scaled_mon_width=$(echo "$mon_width / $mon_scale" | bc -l | awk '{printf "%.0f", $1}')
    scaled_mon_height=$(echo "$mon_height / $mon_scale" | bc -l | awk '{printf "%.0f", $1}')

    # Adjust deltas and buffer based on monitor scale
    scaled_delta_h=$(echo "$delta_h / $mon_scale" | bc -l | awk '{printf "%.0f", $1}')
    scaled_delta_v=$(echo "$delta_v / $mon_scale" | bc -l | awk '{printf "%.0f", $1}')
    scaled_buffer=$(echo "$buffer_zone / $mon_scale" | bc -l | awk '{printf "%.0f", $1}')

    # Calculate new position
    case "$direction" in
        "l")
            new_x=$((win_x - scaled_delta_h))
            new_y=$win_y
            # Check if window would go out of bounds or too close to edge
            if [[ $new_x -lt $((mon_x + scaled_buffer)) ]]; then
                # Will exceed monitor bounds or buffer zone, handle monitor switching
                new_x=$((mon_x + scaled_buffer))
                move_to_adjacent_monitor "l"
            fi
            ;;
        "r")
            new_x=$((win_x + scaled_delta_h))
            new_y=$win_y
            # Check if window would go out of bounds or too close to edge
            if [[ $((new_x + win_width)) -gt $((mon_x + scaled_mon_width - scaled_buffer)) ]]; then
                # Will exceed monitor bounds or buffer zone, handle monitor switching
                new_x=$((mon_x + scaled_mon_width - win_width - scaled_buffer))
                move_to_adjacent_monitor "r"
            fi
            ;;
        "u")
            new_x=$win_x
            new_y=$((win_y - scaled_delta_v))
            # Check if window would go out of bounds or too close to edge
            if [[ $new_y -lt $((mon_y + scaled_buffer)) ]]; then
                # Set to top of current monitor with buffer
                new_y=$((mon_y + scaled_buffer))
            fi
            ;;
        "d")
            new_x=$win_x
            new_y=$((win_y + scaled_delta_v))
            # Check if window would go out of bounds or too close to edge
            if [[ $((new_y + win_height)) -gt $((mon_y + scaled_mon_height - scaled_buffer)) ]]; then
                # Set to bottom of current monitor with buffer
                new_y=$((mon_y + scaled_mon_height - win_height - scaled_buffer))
            fi
            ;;
    esac

    # Move the window
    hyprctl dispatch movewindowpixel "exact $new_x $new_y", activewindow

# Handle tiled windows (using the existing logic)
else
    # Try moving in direction, keep track of the position variable.
    current_position=$(hyprctl activewindow -j | jq ".at")
    hyprctl dispatch hy3:movewindow "$direction"
    sleep 0.05
    next_position=$(hyprctl activewindow -j | jq ".at")

    # If the position variable changed, early exit.
    if [[ ! "$current_position" == "$next_position" ]]; then
        exit
    fi

    # Else, we are at the monitor edge, move to next.
    move_to_adjacent_monitor "$direction"
fi
