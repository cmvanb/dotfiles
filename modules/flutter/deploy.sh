#-------------------------------------------------------------------------------
# Deploy flutter configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/lib/fs.sh"


flutter::install () {
    echo "└> Installing flutter configuration."

    local src="$base_dir/modules/flutter/src"

    fs::force_link "$src/bash/flutter.sh"   "$XDG_CONFIG_HOME/bash/conf.d/flutter.sh"
    fs::force_link "$src/fish/flutter.fish" "$XDG_CONFIG_HOME/fish/conf.d/flutter.fish"
}

flutter::uninstall () {
    echo "└> Uninstalling flutter configuration."

    rm -f "$XDG_CONFIG_HOME/bash/conf.d/flutter.sh"
    rm -f "$XDG_CONFIG_HOME/fish/conf.d/flutter.fish"
}
