#-------------------------------------------------------------------------------
# Deploy fuzzel configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/config/lib-shell-utils/fs.sh"


fuzzel::install () {
    echo "└> Installing fuzzel configuration."

    ensure_directory "$XDG_CONFIG_HOME/fuzzel"
    esh "$base_dir/config/fuzzel/fuzzel.ini~esh" > "$XDG_CONFIG_HOME/fuzzel/fuzzel.ini"
}

fuzzel::uninstall () {
    echo "└> Uninstalling fuzzel configuration."

    rm -r "$XDG_CONFIG_HOME/fuzzel"
}
