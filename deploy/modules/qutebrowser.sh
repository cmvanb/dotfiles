#-------------------------------------------------------------------------------
# Deploy qutebrowser configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/config/lib-shell-utils/fs.sh"


qutebrowser::install () {
    echo "└> Installing qutebrowser configuration."

    ensure_directory "$XDG_CONFIG_HOME/qutebrowser"
    force_link "$base_dir/config/qutebrowser/config.py" "$XDG_CONFIG_HOME/qutebrowser/config.py"
    force_link "$base_dir/config/qutebrowser/stylesheet.css" "$XDG_CONFIG_HOME/qutebrowser/stylesheet.css"
    force_link "$base_dir/config/qutebrowser/stylemap.py" "$XDG_CONFIG_HOME/qutebrowser/stylemap.py"
    force_link "$base_dir/config/qutebrowser/styles" "$XDG_CONFIG_HOME/qutebrowser/styles"

    ensure_directory "$XDG_DATA_HOME/applications"
    force_link "$base_dir/config/qutebrowser/org.qutebrowser.qutebrowser.desktop" "$XDG_DATA_HOME/applications/org.qutebrowser.qutebrowser.desktop"

    ensure_directory "$XDG_DATA_HOME/qutebrowser/userscripts"
    force_link "$base_dir/config/qutebrowser/userscripts/format_json.sh" "$XDG_DATA_HOME/qutebrowser/userscripts/format_json.sh"
    force_link "$base_dir/config/qutebrowser/userscripts/rebuild-grease-styles.py" "$XDG_DATA_HOME/qutebrowser/userscripts/rebuild-grease-styles.py"
    force_link "$base_dir/config/qutebrowser/userscripts/readability.py" "$XDG_DATA_HOME/qutebrowser/userscripts/readability.py"

    ensure_directory "$XDG_SCRIPTS_HOME"
    force_link "$base_dir/config/qutebrowser/add-bookmark.sh" "$XDG_SCRIPTS_HOME/add-bookmark.sh"
    force_link "$base_dir/config/qutebrowser/browse.sh" "$XDG_SCRIPTS_HOME/browse.sh"
    force_link "$base_dir/config/qutebrowser/open-qutebrowser-session.sh" "$XDG_SCRIPTS_HOME/open-qutebrowser-session.sh"
    force_link "$base_dir/config/qutebrowser/select-bookmark.sh" "$XDG_SCRIPTS_HOME/select-bookmark.sh"

    ensure_directory "$XDG_TEMPLATES_DIR"
    force_link "$base_dir/config/qutebrowser/bookmark.md~esh" "$XDG_TEMPLATES_DIR/bookmark.md~esh"

    echo "└> Installing qutebrowser shortcuts."

    ensure_directory "$XDG_BIN_HOME"
    force_link "$base_dir/config/qutebrowser/browse.sh" "$XDG_BIN_HOME/browse"

    echo "└> Building qutebrowser custom CSS."

    python "$XDG_DATA_HOME/qutebrowser/userscripts/rebuild-grease-styles.py"
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
