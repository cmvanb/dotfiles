#-------------------------------------------------------------------------------
# Deploy wget configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/lib/fs.sh"
source "$base_dir/lib/template.sh"


wget::install () {
    echo "└> Installing wget configuration."

    local src="$base_dir/modules/wget/src"

    fs::ensure_directory "$XDG_CONFIG_HOME/wget"
    template::render_mako "$src/wgetrc.mako" "$XDG_CONFIG_HOME/wget/wgetrc"

    fs::force_link "$src/bash/wget.sh"   "$XDG_CONFIG_HOME/bash/conf.d/wget.sh"
    fs::force_link "$src/fish/wget.fish" "$XDG_CONFIG_HOME/fish/conf.d/wget.fish"
}

wget::uninstall () {
    echo "└> Uninstalling wget configuration."

    rm -r "$XDG_CONFIG_HOME/wget"
    rm -f "$XDG_CONFIG_HOME/bash/conf.d/wget.sh"
    rm -f "$XDG_CONFIG_HOME/fish/conf.d/wget.fish"
}
