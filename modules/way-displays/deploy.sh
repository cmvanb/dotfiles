#-------------------------------------------------------------------------------
# Deploy way-displays configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")
host=$(uname -n)

source "$base_dir/lib/fs.sh"


way-displays::install () {
    if [[ $host == "supertubes" ]] || [[ $host == "cyxwel" ]]; then
        echo "└> Installing way-displays configuration."

        local src="$base_dir/modules/way-displays/src"

        ensure_directory "$XDG_CONFIG_HOME/way-displays"
        force_link "$src/cfg.yaml~home-triple" "$XDG_CONFIG_HOME/way-displays/cfg.yaml"

    else
        echo "└> Skipping way-displays - no configuration for \`$host\`."

    fi
}

way-displays::uninstall () {
    echo "└> Uninstalling way-displays configuration."

    rm -r "$XDG_CONFIG_HOME/way-displays"
}
