#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Find wrapped lines in an issue, PR, or comment body.
#
# Ticketing and VCS systems can render each newline as a line break, so a
# paragraph, list item, or quote must sit on one line. Reports each line that
# continues the line before it, outside code blocks. Exits 1 on a finding.
#
# Usage: check-body.sh <file>   (or the body on stdin)
#-------------------------------------------------------------------------------

set -euo pipefail

awk '
    function block_start(s) {
        return s ~ /^[[:space:]]*([-*+]|[0-9]+[.)])[[:space:]]/ ||
               s ~ /^#/ || s ~ /^\|/ || s ~ /^[[:space:]]*```/
    }
    /^[[:space:]]*```/ { fence = !fence; prev = ""; next }
    fence { next }
    /^[[:space:]]*$/ { prev = ""; next }
    {
        line = $0
        quote_continues = line ~ /^>/ && prev ~ /^>/ && prev !~ /^>[[:space:]]*\[!/
        if (prev != "" && prev !~ /^\|/ && prev !~ /^#/ &&
            (quote_continues || (line !~ /^>/ && !block_start(line)))) {
            printf "%d: %s\n", NR, line
            found = 1
        }
        prev = line
    }
    END { exit found }
' "${1:-/dev/stdin}"
