#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Deploy desktop theme configuration
#-------------------------------------------------------------------------------

echo "Deploying desktop theme configuration..."

config_dir=${XDG_CONFIG_HOME:-$HOME/.config}
opt_dir=${XDG_OPT_HOME:-$HOME/.local/opt}

# Setup
#-------------------------------------------------------------------------------

source "$base_dir/.local/opt/shell-utils/fs.sh"

# Link theme cursor and font settings
#-------------------------------------------------------------------------------

echo "└ Link theme cursor settings."
force_link "$base_dir/.config/theme/cursor" "$config_dir/theme/cursor"

host=$(uname -n)
echo "└ Link theme font settings for \`$host\`."
case $host in
    qutedell)
        force_link "$base_dir/.config/theme/fonts~qutech" "$config_dir/theme/fonts"
        ;;

    cyxwel)
        ;&
    supertubes)
        force_link "$base_dir/.config/theme/fonts~home" "$config_dir/theme/fonts"
        ;;

    nlleq0413002159)
        force_link "$base_dir/.config/theme/fonts~windows" "$config_dir/theme/fonts"
        ;;

    *)
        echo "[$(basename "$0")] ERROR: \`$host\` is not accounted for."
        exit 1
        ;;
esac

# Configure GTK
#-------------------------------------------------------------------------------

echo "└ Configuring theme GTK settings."
source "$opt_dir/theme/configure-gtk.sh"
