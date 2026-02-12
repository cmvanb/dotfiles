#-------------------------------------------------------------------------------
# Deploy wallpaper configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")
host=$(uname -n)

source "$base_dir/modules/lib-shell-utils/src/fs.sh"


wallpaper::install () {
    if [[ $host == "cyxwel" ]] \
        || [[ $host == "supertubes" ]] \
    ;then
        echo "└> Installing wallpaper configuration."

        ensure_directory "$XDG_CONFIG_HOME/wallpaper"
        force_link "$base_dir/extras/wallpaper/src/wallpaper.sh~home-triple" "$XDG_CONFIG_HOME/wallpaper/wallpaper.sh"

    else
        echo "└> Skipping wallpaper - no configuration for \`$host\`."

    fi
}

wallpaper::uninstall () {
    echo "└> Uninstalling wallpaper configuration."

    rm -r "$XDG_CONFIG_HOME/wallpaper"
}
