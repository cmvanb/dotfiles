#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Estimate disk space usage
#-------------------------------------------------------------------------------

set -euo pipefail

directory=${1:-$(pwd)}

du -h -d 1 "$directory" | sort -hr
