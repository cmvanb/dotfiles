#-------------------------------------------------------------------------------
# Deploy wireplumber configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/lib/fs.sh"


wireplumber::install () {
    echo "└> Installing wireplumber configuration."

    local src="$base_dir/modules/wireplumber/src"

    fs::ensure_directory "$XDG_CONFIG_HOME/wireplumber/wireplumber.conf.d"

    fs::force_link "$src/wireplumber.conf.d/50-audio-priority.conf" \
        "$XDG_CONFIG_HOME/wireplumber/wireplumber.conf.d/50-audio-priority.conf"
}

wireplumber::uninstall () {
    echo "└> Uninstalling wireplumber configuration."

    rm -f "$XDG_CONFIG_HOME/wireplumber/wireplumber.conf.d/50-audio-priority.conf"
}

wireplumber::enable () {
    echo "└> Enabling wireplumber user service."

    systemctl --user enable wireplumber
}

wireplumber::disable () {
    echo "└> Disabling wireplumber user service."

    systemctl --user disable wireplumber
}
