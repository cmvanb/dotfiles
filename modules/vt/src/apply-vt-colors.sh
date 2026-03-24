#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Apply the virtual terminal colors from the theme
#-------------------------------------------------------------------------------

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

echo "Applying virtual terminal colors from \`$script_dir/colors.mako\`."

python3 "$XDG_OPT_HOME/theme/template.py" "$script_dir/colors.mako" /tmp/vtcolors
setvtrgb /tmp/vtcolors
rm /tmp/vtcolors
