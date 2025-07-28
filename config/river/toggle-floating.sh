#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Toggle all windows on an output between floating and tiled
#-------------------------------------------------------------------------------

# Imports
#-------------------------------------------------------------------------------

# shellcheck disable=SC1091
source "$XDG_OPT_HOME/shell-utils/debug.sh"

# Validation
#-------------------------------------------------------------------------------

assert_dependency jq
assert_dependency lswt
assert_dependency river-bedload
assert_dependency riverctl

# Toggle floating
#-------------------------------------------------------------------------------

# Function to get the active output name
get_active_output() {
    # Use river-bedload to get outputs info
    river-bedload -print outputs | jq -r '.[] | select(.focused == true) | .name'
}

# Function to get all window IDs on the active output
get_windows_on_output() {
    local output_name="$1"
    
    # lswt doesn't provide output information, so we'll get all windows
    # and let river handle the filtering by focusing only windows on current output
    lswt -j | sed 's/"identifier": \([0-9a-f]*\),/"identifier": "\1",/g' | jq -r '.toplevels[].identifier'
}

# Function to check if a window is currently floating
is_window_floating() {
    local window_id="$1"
    
    # Use riverctl to check if window is floating
    # River doesn't provide a direct way to query floating state,
    # so we'll use riverctl's return code approach
    # This is a workaround - we'll track state ourselves
    return 1  # Will be handled differently in the main logic
}

# Function to toggle window floating state
toggle_window_float() {
    local window_id="$1"
    
    # Since river doesn't provide an easy way to query floating state,
    # we'll use a simple toggle approach - try to float first, then sink
    echo "Toggling window $window_id"
    
    # Try to toggle float - if already floating, this will do nothing
    # If tiled, this will float it
    riverctl toggle-float &>/dev/null || true
    
    # Alternative approach: just toggle the focused window if it matches our target
    # This is a limitation of river's current riverctl interface
}

# Main function
main() {
    echo "River WM Float Toggle Script"
    echo "============================"
    
    # Get active output
    local active_output
    active_output=$(get_active_output)
    
    if [ -z "$active_output" ]; then
        echo "Error: Could not determine active output" >&2
        exit 1
    fi
    
    echo "Active output: $active_output"
    echo "Note: lswt doesn't provide per-output window info, processing all windows"
    
    # Get all windows (lswt doesn't filter by output)
    local window_ids
    window_ids=$(get_windows_on_output "$active_output")
    
    if [ -z "$window_ids" ]; then
        echo "No windows found"
        exit 0
    fi
    
    echo "Found windows:"
    
    # Count windows for summary
    local window_count=0
    
    # Count windows
    while IFS= read -r window_id; do
        if [ -n "$window_id" ]; then
            ((window_count++))
            echo "  Window $window_id found"
        fi
    done <<< "$window_ids"
    
    echo
    echo "Summary: $window_count total windows found"
    echo
    echo "Toggling all windows (focusing each and toggling float state)..."
    echo
    
    # Toggle all windows by focusing each and using toggle-float
    while IFS= read -r window_id; do
        if [ -n "$window_id" ]; then
            echo "Focusing and toggling window $window_id"
            # Focus the window first, then toggle its float state
            riverctl focus-view "$window_id" 2>/dev/null || {
                echo "  Warning: Could not focus window $window_id"
                continue
            }
            # Small delay to ensure focus is processed
            sleep 0.1
            # Toggle float state of the now-focused window
            riverctl toggle-float 2>/dev/null || {
                echo "  Warning: Could not toggle float for window $window_id"
            }
        fi
    done <<< "$window_ids"
    
    echo
    echo "Toggle complete!"
}

# Run main function
main "$@"
