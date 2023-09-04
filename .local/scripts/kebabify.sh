#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Apply kebabcase format to all files in CWD.
#-------------------------------------------------------------------------------

set -euo pipefail

for file in *; do
    $XDG_SCRIPTS_HOME/rename-kebabcase.sh "$file"
done

