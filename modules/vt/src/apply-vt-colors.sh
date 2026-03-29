#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Apply the virtual terminal colors from the theme
#-------------------------------------------------------------------------------

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

echo "Applying virtual terminal colors from \`$script_dir/colors.mako\`."

"${XDG_BIN_HOME:-$HOME/.local/bin}/render-mako" "$script_dir/colors.mako" /tmp/vtcolors
setvtrgb /tmp/vtcolors
rm /tmp/vtcolors
