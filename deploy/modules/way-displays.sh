#-------------------------------------------------------------------------------
# Deploy way-displays configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")
host=$(uname -n)

source "$base_dir/config/lib-shell-utils/fs.sh"


way-displays::install () {
    echo "└> Installing way-displays configuration."

    ensure_directory "$XDG_CONFIG_HOME/way-displays"

    if [[ $host == "supertubes" ]] || [[ $host == "cyxwel" ]]; then
        force_link "$base_dir/config/way-displays/cfg.yaml~home-triple" "$XDG_CONFIG_HOME/way-displays/cfg.yaml"

    else
        echo "[$(basename "$0")] ERROR: \`$host\` is not accounted for."
        exit 1
    fi
}

way-displays::uninstall () {
    echo "└> Uninstalling way-displays configuration."

    rm -r "$XDG_CONFIG_HOME/way-displays"
}
