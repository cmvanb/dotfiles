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
    class = pct >= 90 ? "critical" : pct >= 70 ? "heavy" : pct >= 50 ? "medium" : ""
    printf "{\"text\":\"mem %d%%\",\"tooltip\":\"%.1f / %.1f GiB\",\"percentage\":%d,\"class\":\"%s\"}\n",
        pct, used/1048576, total/1048576, pct, class
}
' /proc/meminfo
