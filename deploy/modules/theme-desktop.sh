#-------------------------------------------------------------------------------
# Deploy theme desktop configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")
config_dir=${XDG_CONFIG_HOME:-$HOME/.config}
scripts_dir=${XDG_SCRIPTS_HOME:-$HOME/.local/scripts}
opt_dir=${XDG_OPT_HOME:-$HOME/.local/opt}
host=$(uname -n)

source "$base_dir/local/opt/shell-utils/fs.sh"


theme-desktop::install () {
    echo "└> Installing theme desktop configuration."

    mkdir -p "$config_dir/theme"
    force_link "$base_dir/config/theme/cursor" "$config_dir/theme/cursor"

    case $host in
        cyxwel)
            ;&
        supertubes)
            force_link "$base_dir/config/theme/fonts~home" "$config_dir/theme/fonts"
            ;;

        nlleq0413002159)
            force_link "$base_dir/config/theme/fonts~windows" "$config_dir/theme/fonts"
            ;;

        *)
            echo "[$(basename "$0")] ERROR: \`$host\` is not accounted for."
            exit 1
            ;;
    esac

    mkdir -p "$scripts_dir"
    force_link "$base_dir/local/scripts/generate-color-gradient-palette.py" "$scripts_dir/generate-color-gradient-palette.py"

    source "$opt_dir/theme/configure-gtk.sh"
}

theme-desktop::uninstall () {
    echo "└> Uninstalling theme desktop configuration."

    rm "$config_dir/theme/cursor"
    rm "$config_dir/theme/fonts"

    rm "$scripts_dir/generate-color-gradient-palette.py"
}
