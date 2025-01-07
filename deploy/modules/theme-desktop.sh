#-------------------------------------------------------------------------------
# Deploy theme desktop configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")
host=$(uname -n)

source "$base_dir/config/lib-shell-utils/fs.sh"


theme-desktop::install () {
    echo "└> Installing theme desktop configuration."

    ensure_directory "$XDG_CONFIG_HOME/theme"
    force_link "$base_dir/config/theme/cursor" "$XDG_CONFIG_HOME/theme/cursor"

    case $host in
        cyxwel)
            ;&
        supertubes)
            force_link "$base_dir/config/theme/fonts~home" "$XDG_CONFIG_HOME/theme/fonts"
            ;;

        nlleq0413002159)
            force_link "$base_dir/config/theme/fonts~windows" "$XDG_CONFIG_HOME/theme/fonts"
            ;;

        *)
            echo "[$(basename "$0")] ERROR: \`$host\` is not accounted for."
            exit 1
            ;;
    esac

    ensure_directory "$XDG_SCRIPTS_HOME"
    force_link "$base_dir/config/theme/generate-color-gradient-palette.py" "$XDG_SCRIPTS_HOME/generate-color-gradient-palette.py"

    source "$XDG_OPT_HOME/theme/configure-gtk.sh"
}

theme-desktop::uninstall () {
    echo "└> Uninstalling theme desktop configuration."

    rm "$XDG_CONFIG_HOME/theme/cursor"
    rm "$XDG_CONFIG_HOME/theme/fonts"

    rm "$XDG_SCRIPTS_HOME/generate-color-gradient-palette.py"
}
