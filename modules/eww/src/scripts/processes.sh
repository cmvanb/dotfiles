#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Top processes for eww
#
# Usage: processes.sh <cpu|mem>
#
#   [{"pid": 1234, "name": "chromium", "cpu": 12.3, "mem": 4.5}, ...]
#-------------------------------------------------------------------------------

set -uo pipefail

sort_key="-%${1:-cpu}"

ps -eo pid=,comm=,%cpu=,%mem= --sort="$sort_key" | head -5 \
    | jq -Rsc '[split("\n")[] | select(length > 0) | [splits(" +")] | map(select(length > 0))
        | {pid: (.[0] | tonumber), name: .[1], cpu: (.[2] | tonumber), mem: (.[3] | tonumber)}]'
