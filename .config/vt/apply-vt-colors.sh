#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Apply the virtual terminal colors from a configuration file
#-------------------------------------------------------------------------------

set -euo pipefail

if ! command -v esh &> /dev/null; then
    echo "ERROR: $(basename "$0") missing dependency: esh"
    exit
fi

base_dir=$(realpath "$(dirname "$(realpath "$0")")/../..")

echo "Applying virtual terminal colors from \`$base_dir/.config/vt/colors~esh\`."

# Generate the colors template and pass it to setvtrgb.
esh "$base_dir/.config/vt/colors~esh" > /tmp/vtcolors
setvtrgb /tmp/vtcolors
rm /tmp/vtcolors
