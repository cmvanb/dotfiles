#-------------------------------------------------------------------------------
# Deploy android configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/lib/fs.sh"


android::install () {
    echo "└> Installing android configuration."

    local src="$base_dir/modules/android/src"

    fs::force_link "$src/bash/android.sh"   "$XDG_CONFIG_HOME/bash/conf.d/android.sh"
    fs::force_link "$src/fish/android.fish" "$XDG_CONFIG_HOME/fish/conf.d/android.fish"
}

android::uninstall () {
    echo "└> Uninstalling android configuration."

    rm -f "$XDG_CONFIG_HOME/bash/conf.d/android.sh"
    rm -f "$XDG_CONFIG_HOME/fish/conf.d/android.fish"
}
