#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Apply the virtual terminal colors from a configuration file
#-------------------------------------------------------------------------------

if ! command -v esh &> /dev/null; then
    echo "ERROR: $(basename "$0") missing dependency: esh"
    exit
fi

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

echo "Applying virtual terminal colors from \`$base_dir/.config/vt/colors~esh\`."

# Set ESH_SHELL to bash for Ubuntu compatibility (dash doesn't support 'source')
export ESH_SHELL=/usr/bin/bash

# Generate the colors template and pass it to setvtrgb.
esh "$base_dir/config/vt/colors~esh" > /tmp/vtcolors
setvtrgb /tmp/vtcolors
rm /tmp/vtcolors
