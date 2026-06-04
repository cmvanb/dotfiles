#-------------------------------------------------------------------------------
# Deploy gnupg configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/lib/fs.sh"


gnupg::install () {
    echo "└> Installing gnupg configuration."

    local src="$base_dir/modules/gnupg/src"

    fs::force_link "$src/bash/gnupg.sh"   "$XDG_CONFIG_HOME/bash/conf.d/gnupg.sh"
    fs::force_link "$src/fish/gnupg.fish" "$XDG_CONFIG_HOME/fish/conf.d/gnupg.fish"
}

gnupg::uninstall () {
    echo "└> Uninstalling gnupg configuration."

    rm -f "$XDG_CONFIG_HOME/bash/conf.d/gnupg.sh"
    rm -f "$XDG_CONFIG_HOME/fish/conf.d/gnupg.fish"
}
