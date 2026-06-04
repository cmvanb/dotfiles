#-------------------------------------------------------------------------------
# Deploy pi configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/lib/fs.sh"


pi::install () {
    echo "└> Installing pi configuration."

    local src="$base_dir/modules/pi/src"

    fs::force_link "$src/bash/pi.sh"   "$XDG_CONFIG_HOME/bash/conf.d/pi.sh"
    fs::force_link "$src/fish/pi.fish" "$XDG_CONFIG_HOME/fish/conf.d/pi.fish"
}

pi::uninstall () {
    echo "└> Uninstalling pi configuration."

    rm -f "$XDG_CONFIG_HOME/bash/conf.d/pi.sh"
    rm -f "$XDG_CONFIG_HOME/fish/conf.d/pi.fish"
}
