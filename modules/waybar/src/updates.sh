#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# System update status waybar component
#
# Prints nothing while no update needs attention, which hides the module.
#-------------------------------------------------------------------------------

status=$(sysupdate status --json 2>/dev/null) || exit 0

jq -c 'select(.needs_attention) | {
    text: (
        if .state == "error" then "  update failed"
        elif .state == "reboot" then "󰜉  reboot"
        elif .state == "warning" then "  \(.pacnew_count) pacnew"
        else "󰏔  \(.aur_count) AUR" end
    ),
    tooltip: ([
        (select(.pacman_status == "failed") | "Background upgrade failed: \(.pacman_error)"),
        (select(.reboot_required) | "Reboot required: running \(.running_kernel), installed \(.installed_kernel)"),
        (select(.pacnew_count > 0) | "\(.pacnew_count) .pacnew files to merge"),
        (select(.aur_count > 0) | "\(.aur_count) AUR updates: \([.aur_packages[].name] | join(", "))")
    ] | join("\n")),
    class: .state
}' <<< "$status"
