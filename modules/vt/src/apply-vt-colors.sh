#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Apply the virtual terminal colors from a configuration file
#-------------------------------------------------------------------------------

if ! command -v esh &> /dev/null; then
    echo "ERROR: $(basename "$0") missing dependency: esh"
    exit
fi

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

echo "Applying virtual terminal colors from \`$script_dir/colors~esh\`."

# Generate the colors template and pass it to setvtrgb.
esh "$script_dir/colors~esh" > /tmp/vtcolors
setvtrgb /tmp/vtcolors
rm /tmp/vtcolors
