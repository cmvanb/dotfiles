#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Memory usage waybar component.
# Reports MemTotal - MemAvailable.
#-------------------------------------------------------------------------------

awk '
/^MemTotal:/    { total=$2 }
/^MemAvailable:/{ avail=$2 }
END {
    used = total - avail
    pct  = int(100 * used / total)
    printf "{\"text\":\"mem %d%%\",\"tooltip\":\"%.1f / %.1f GiB\",\"percentage\":%d}\n",
        pct, used/1048576, total/1048576, pct
}
' /proc/meminfo
