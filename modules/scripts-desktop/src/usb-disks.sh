#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Mount or unmount ejectable USB disks via udisks2, with a launcher menu to
# choose the target disk.
#
# Usage:
#   usb-disks.sh mount    — list unmounted removable block devices, mount chosen
#   usb-disks.sh unmount  — list mounted removable block devices, unmount chosen
#
# Device discovery uses "udisksctl dump" and filters on HintSystem=false, which
# is the same signal udisks2 itself uses to distinguish user-removable media
# from internal system disks.  lsblk's RM flag is unreliable (it reflects the
# kernel's idea of "removable", which is often 0 for USB hard drives).
#-------------------------------------------------------------------------------

set -euo pipefail

if [[ "${TRACE-0}" == "1" ]]; then set -o xtrace; fi

# Dependencies
#-------------------------------------------------------------------------------

# shellcheck disable=SC1091
source "$XDG_OPT_HOME/shell-utils/debug.sh"

debug::assert_dependency udisksctl
debug::assert_dependency spawn-launcher.sh

# Parse subcommand
#-------------------------------------------------------------------------------

usage() {
    echo "Usage: $(basename "$0") <subcommand>"
    echo "Subcommands:"
    echo "    mount     Show unmounted removable disks and mount the chosen one."
    echo "    unmount   Show mounted removable disks and unmount the chosen one."
    exit 1
}

if [[ $# -ne 1 ]]; then
    usage
fi

mode="$1"

if [[ "$mode" != "mount" && "$mode" != "unmount" ]]; then
    debug::error "unknown subcommand: $mode"
    usage
fi

# Device discovery via udisksctl dump
#-------------------------------------------------------------------------------
# Parse the structured dump output from udisksctl.  For each block device
# object, collect the fields we need, then emit a record if the device:
#   - has HintSystem=false  (udisks2's marker for non-system / user media)
#   - has HintIgnore=false  (not explicitly hidden)
#   - has a non-empty filesystem type (IdType)
#
# Output format (tab-separated): <device> <label> <fstype> <mountpoint>
#
# Value extraction: each dump field looks like "FieldName:          value".
# Strip the key+colon, then strip leading whitespace with a second expansion:
#   val="${line#Key:}"; val="${val#"${val%%[^ ]*}"}"

list_removable_parts() {
    local in_block=false
    local hint_system="" hint_ignore="" dev_path="" label="" fstype="" mountpoint=""

    _emit() {
        [[ "$in_block"    == true  ]] || return 0
        [[ "$hint_system" == false ]] || return 0
        [[ "$hint_ignore" == false ]] || return 0
        [[ -n "$fstype"            ]] || return 0
        printf '%s\t%s\t%s\t%s\n' "$dev_path" "$label" "$fstype" "$mountpoint"
    }

    while IFS= read -r line; do
        # Object header lines start at column 0; all fields are indented.
        # Use the first character to cheaply decide which branch to take.
        if [[ "$line" == /org/freedesktop/UDisks2/* ]]; then
            _emit
            in_block=false
            hint_system="" hint_ignore="" dev_path="" label="" fstype="" mountpoint=""
            [[ "$line" == /org/freedesktop/UDisks2/block_devices/* ]] && in_block=true
            continue
        fi

        [[ "$in_block" == true ]] || continue

        # Strip the fixed leading indent (4 spaces) then dispatch on field name.
        local line="${line#    }"
        case "$line" in
            HintSystem:*)  hint_system="${line#HintSystem:}";   hint_system="${hint_system#"${hint_system%%[^ ]*}"}" ;;
            HintIgnore:*)  hint_ignore="${line#HintIgnore:}";   hint_ignore="${hint_ignore#"${hint_ignore%%[^ ]*}"}" ;;
            Device:*)      dev_path="${line#Device:}";          dev_path="${dev_path#"${dev_path%%[^ ]*}"}" ;;
            IdLabel:*)     label="${line#IdLabel:}";            label="${label#"${label%%[^ ]*}"}" ;;
            IdType:*)      local t="${line#IdType:}";           t="${t#"${t%%[^ ]*}"}"; [[ -n "$t" ]] && fstype="$t" ;;
            MountPoints:*) mountpoint="${line#MountPoints:}";   mountpoint="${mountpoint#"${mountpoint%%[^ ]*}"}" ;;
        esac
    done < <(udisksctl dump 2>/dev/null)

    _emit   # flush the final object
}

# Build menu entries
#-------------------------------------------------------------------------------
# Each entry: "<display label>\t<device path>"

build_menu() {
    local target_mode="$1"

    while IFS=$'\t' read -r dev_path label fstype mountpoint; do
        local display_label="${label:-<no label>}"

        if [[ "$target_mode" == "mount" && -z "$mountpoint" ]]; then
            printf '%s  %s  %s\t%s\n' "$dev_path" "$display_label" "$fstype" "$dev_path"

        elif [[ "$target_mode" == "unmount" && -n "$mountpoint" ]]; then
            printf '%s  %s  %s  →  %s\t%s\n' \
                "$dev_path" "$display_label" "$fstype" "$mountpoint" "$dev_path"
        fi
    done < <(list_removable_parts)
}

# Main
#-------------------------------------------------------------------------------

declare menu_entries
menu_entries=$(build_menu "$mode")

if [[ -z "$menu_entries" ]]; then
    case "$mode" in
        mount)   debug::error_notify "No unmounted removable disks found." ;;
        unmount) debug::error_notify "No mounted removable disks found." ;;
    esac
    exit 0
fi

# Show only the display column (before the tab) in the launcher, then map the
# chosen label back to the device path via the tab-separated second column.
declare chosen_line
chosen_line=$(
    printf '%s\n' "$menu_entries" \
        | cut -f1 \
        | spawn-launcher.sh --menu --prompt "$mode disk..."
) || exit 0   # user cancelled (launcher exited non-zero)

declare device
device=$(
    printf '%s\n' "$menu_entries" \
        | awk -F'\t' -v label="$chosen_line" '$1 == label { print $2; exit }'
)

if [[ -z "$device" ]]; then
    debug::error_notify "Could not resolve device for: $chosen_line"
    exit 1
fi

# Perform the operation
#-------------------------------------------------------------------------------

case "$mode" in
    mount)
        if udisksctl mount --block-device "$device" --no-user-interaction; then
            notify-send "$(basename "$0")" "Mounted $device."
        else
            debug::error_notify "Failed to mount $device."
            exit 1
        fi
        ;;
    unmount)
        if udisksctl unmount --block-device "$device" --no-user-interaction; then
            notify-send "$(basename "$0")" "Unmounted $device."
        else
            debug::error_notify "Failed to unmount $device."
            exit 1
        fi
        ;;
esac
