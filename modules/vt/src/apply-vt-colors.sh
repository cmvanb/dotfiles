#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Apply the virtual terminal colors from the theme
#-------------------------------------------------------------------------------

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

# shellcheck disable=SC1091
source "${XDG_OPT_HOME:-$HOME/.local/opt}/shell-utils/template.sh"

echo "Applying virtual terminal colors from \`$script_dir/colors.mako\`."

template::render_mako "$script_dir/colors.mako" /tmp/vtcolors
setvtrgb /tmp/vtcolors
rm /tmp/vtcolors
