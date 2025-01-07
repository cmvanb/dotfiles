#-------------------------------------------------------------------------------
# Deploy qutebrowser configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/local/opt/shell-utils/fs.sh"


qutebrowser::install () {
    echo "└> Installing qutebrowser configuration."

    mkdir -p "$XDG_CONFIG_HOME/qutebrowser"
    force_link "$base_dir/config/qutebrowser/config.py" "$XDG_CONFIG_HOME/qutebrowser/config.py"
    force_link "$base_dir/config/qutebrowser/stylesheet.css" "$XDG_CONFIG_HOME/qutebrowser/stylesheet.css"

    mkdir -p "$XDG_DATA_HOME/applications"
    force_link "$base_dir/local/share/applications/org.qutebrowser.qutebrowser.desktop" "$XDG_DATA_HOME/applications/org.qutebrowser.qutebrowser.desktop"

    mkdir -p "$XDG_DATA_HOME/qutebrowser/userscripts"
    force_link "$base_dir/local/share/qutebrowser/userscripts/format_json.sh" "$XDG_DATA_HOME/qutebrowser/userscripts/format_json.sh"
    force_link "$base_dir/local/share/qutebrowser/userscripts/readability.py" "$XDG_DATA_HOME/qutebrowser/userscripts/readability.py"

    mkdir -p "$XDG_SCRIPTS_HOME"
    force_link "$base_dir/local/scripts/add-bookmark.sh" "$XDG_SCRIPTS_HOME/add-bookmark.sh"
    force_link "$base_dir/local/scripts/select-bookmark.sh" "$XDG_SCRIPTS_HOME/select-bookmark.sh"
    force_link "$base_dir/local/scripts/open-qutebrowser-session.sh" "$XDG_SCRIPTS_HOME/open-qutebrowser-session.sh"

    mkdir -p "$XDG_TEMPLATES_DIR"
    force_link "$base_dir/local/share/templates/bookmark.md~esh" "$XDG_TEMPLATES_DIR/bookmark.md~esh"

    echo "└> Installing qutebrowser shortcuts."

    mkdir -p "$XDG_BIN_HOME"
    force_link "$base_dir/local/bin/browse" "$XDG_BIN_HOME/browse"
}

qutebrowser::uninstall () {
    echo "└> Uninstalling qutebrowser configuration."

    rm -r "$XDG_CONFIG_HOME/qutebrowser"

    rm "$XDG_DATA_HOME/applications/org.qutebrowser.qutebrowser.desktop"

    rm "$XDG_SCRIPTS_HOME/add-bookmark.sh"
    rm "$XDG_SCRIPTS_HOME/select-bookmark.sh"
    rm "$XDG_SCRIPTS_HOME/open-qutebrowser-session.sh"

    rm "$XDG_TEMPLATES_DIR/bookmark.md~esh"

    echo "└> Uninstalling qutebrowser shortcuts."

    rm "$XDG_BIN_HOME/browse"
}
