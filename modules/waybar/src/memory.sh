#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Memory usage waybar component
#
# Reports actual RAM consumption: AnonPages + Unevictable + KernelStack + PageTables
# This excludes reclaimable caches and buffers, giving a true picture of memory
# that cannot be freed without killing processes or swapping.
#-------------------------------------------------------------------------------

declare -A meminfo

while IFS=': ' read -r key value _; do
    meminfo[$key]=${value// /}
done < /proc/meminfo

anon=${meminfo[AnonPages]:-0}
unevictable=${meminfo[Unevictable]:-0}
kernel_stack=${meminfo[KernelStack]:-0}
page_tables=${meminfo[PageTables]:-0}
mem_total=${meminfo[MemTotal]:-1}

used_kb=$(( anon + unevictable + kernel_stack + page_tables ))
percentage=$(( 100 * used_kb / mem_total ))

used_gib=$(awk "BEGIN { printf \"%.1f\", $used_kb / 1048576 }")
total_gib=$(awk "BEGIN { printf \"%.1f\", $mem_total / 1048576 }")

tooltip="AnonPages:   $(( anon / 1024 )) MiB\nUnevictable: $(( unevictable / 1024 )) MiB\nKernelStack: $(( kernel_stack / 1024 )) MiB\nPageTables:  $(( page_tables / 1024 )) MiB\nTotal:       ${used_gib} / ${total_gib} GiB"

printf '{"text":"mem %d%%","tooltip":"<tt>%s</tt>","percentage":%d}\n' \
    "$percentage" "$tooltip" "$percentage"
