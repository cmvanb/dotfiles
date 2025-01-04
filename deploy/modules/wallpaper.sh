#-------------------------------------------------------------------------------
# Deploy wallpaper configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")
config_dir=${XDG_CONFIG_HOME:-$HOME/.config}
host=$(uname -n)

source "$base_dir/local/opt/shell-utils/fs.sh"


wallpaper::install () {
    echo "└> Installing wallpaper configuration."

    mkdir -p "$config_dir/wallpaper"

    if [[ $host == "supertubes" ]] || [[ $host == "cyxwel" ]]; then
        force_link "$base_dir/config/wallpaper/wallpaper.sh~home-triple" "$config_dir/wallpaper/wallpaper.sh"

    else
        echo "[$(basename "$0")] ERROR: \`$host\` is not accounted for."
        exit 1
    fi
}

wallpaper::uninstall () {
    echo "└> Uninstalling wallpaper configuration."

    rm -r "$config_dir/wallpaper"
}
