#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Move a window; if it reaches an edge, move it to the next monitor.
#-------------------------------------------------------------------------------

direction="$1"
current_position=$(hyprctl activewindow -j | jq ".at")
hyprctl dispatch hy3:movewindow "$direction"
sleep 0.05
next_position=$(hyprctl activewindow -j | jq ".at")

if [[ ! "$current_position" == "$next_position" ]]
then
    exit
fi

mapfile -t sorted_monitors <<< "$(hyprctl monitors -j | jq -r 'sort_by(.x) | .[] | .id')"
current_monitor="$(hyprctl activeworkspace -j | jq ".monitorID")"
sorted_monitors_count="${#sorted_monitors[@]}"

declare current_index

# Find the index of the current monitor in the sorted monitors array.
for index in "${!sorted_monitors[@]}"; do
    if [[ "${sorted_monitors[$index]}" == "$current_monitor" ]]; then
        current_index="$index"
        break
    fi
done

if [[ $direction == "r" ]]; then
    ((current_index++))

elif [[ $direction == "l" ]]; then
    ((current_index--))
fi

if (( current_index == sorted_monitors_count )); then
    current_index=0

elif (( current_index < 0 )); then
    current_index=$((sorted_monitors_count - 1))
fi

next_monitor_id="${sorted_monitors[$current_index]}"

hyprctl dispatch movewindow mon:"$next_monitor_id"

if [[ $direction == "r" ]]; then
    # TODO: Position the active window on the left side of the next monitor.
    hyprctl dispatch hy3:movewindow l
    hyprctl dispatch hy3:movewindow l

elif [[ $direction == "l" ]]; then
    # TODO: Position the active window on the right side of the next monitor.
    hyprctl dispatch hy3:movewindow r
    hyprctl dispatch hy3:movewindow r
fi
