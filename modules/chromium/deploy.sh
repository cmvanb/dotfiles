#-------------------------------------------------------------------------------
# Deploy chromium configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/lib/fs.sh"


chromium::install () {
    echo "└> Installing chromium configuration."

    local src="$base_dir/modules/chromium/src"

    fs::ensure_directory "$XDG_DATA_HOME/applications"
    fs::force_link "$src/chromium.desktop" "$XDG_DATA_HOME/applications/chromium.desktop"
    fs::force_link "$src/netflix.desktop" "$XDG_DATA_HOME/applications/netflix.desktop"

    fs::ensure_directory "$XDG_DATA_HOME/icons/hicolor/64x64/apps"
    fs::force_link "$src/netflix.png" "$XDG_DATA_HOME/icons/hicolor/64x64/apps/netflix.png"

    fs::ensure_directory "$XDG_CONFIG_HOME/chromium"
    fs::force_link "$src/extensions" "$XDG_CONFIG_HOME/chromium/External Extensions"

    "$src/vimium-c/seed-key-mappings.py" "$XDG_CONFIG_HOME/chromium/Default" \
        --mappings "$src/vimium-c/key-mappings" || true
}

chromium::uninstall () {
    echo "└> Uninstalling chromium configuration."

    rm "$XDG_DATA_HOME/applications/chromium.desktop"
    rm "$XDG_DATA_HOME/applications/netflix.desktop"
    rm "$XDG_DATA_HOME/icons/hicolor/64x64/apps/netflix.png"
    rm "$XDG_CONFIG_HOME/chromium/External Extensions"

    "$base_dir/modules/chromium/src/vimium-c/seed-key-mappings.py" "$XDG_CONFIG_HOME/chromium/Default" \
        --clear || true
}
