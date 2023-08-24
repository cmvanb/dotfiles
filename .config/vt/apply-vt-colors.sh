#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Apply the virtual terminal colors from a configuration file
#-------------------------------------------------------------------------------

set -euo pipefail

if ! command -v esh &> /dev/null; then
    echo "ERROR: "$(basename "$0")" missing dependency: esh"
    exit
fi

bash_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source_dir=$( realpath "$bash_dir/.." )

echo "Applying virtual terminal colors from \`$source_dir/vt/colors~esh\`."

# Generate the colors template and pass it to setvtrgb.
esh "$source_dir/vt/colors~esh" > /tmp/vtcolors
setvtrgb /tmp/vtcolors
rm /tmp/vtcolors
