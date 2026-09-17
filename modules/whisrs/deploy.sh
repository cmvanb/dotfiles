#-------------------------------------------------------------------------------
# Deploy whisrs configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/lib/fs.sh"
source "$base_dir/lib/template.sh"


whisrs_model="ggml-small.en.bin"
whisrs_model_url="https://huggingface.co/ggerganov/whisper.cpp/resolve/main/$whisrs_model"


whisrs::install () {
    echo "└> Installing whisrs configuration."

    local src="$base_dir/modules/whisrs/src"

    fs::ensure_directory "$XDG_CONFIG_HOME/whisrs"
    template::render_mako "$src/config.mako.toml" "$XDG_CONFIG_HOME/whisrs/config.toml"
    chmod 600 "$XDG_CONFIG_HOME/whisrs/config.toml"

    whisrs::install_model
}

whisrs::install_model () {
    local model_dir="$XDG_DATA_HOME/whisrs/models"

    if [[ -f "$model_dir/$whisrs_model" ]]; then
        return 0
    fi

    echo "└> Downloading whisper model: $whisrs_model"

    fs::ensure_directory "$model_dir"
    curl --fail --location --progress-bar --output "$model_dir/$whisrs_model" "$whisrs_model_url"
}

whisrs::uninstall () {
    echo "└> Uninstalling whisrs configuration."

    rm "$XDG_CONFIG_HOME/whisrs/config.toml"
    rmdir --ignore-fail-on-non-empty "$XDG_CONFIG_HOME/whisrs"

    echo "└> Uninstalling whisper model: $whisrs_model"

    rm -f "$XDG_DATA_HOME/whisrs/models/$whisrs_model"
    rmdir --ignore-fail-on-non-empty "$XDG_DATA_HOME/whisrs/models" "$XDG_DATA_HOME/whisrs"
}

whisrs::enable () {
    echo "└> Enabling whisrs user service."

    systemctl --user enable whisrs
}

whisrs::disable () {
    echo "└> Disabling whisrs user service."

    systemctl --user disable whisrs
}
