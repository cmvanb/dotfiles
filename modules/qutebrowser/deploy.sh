#-------------------------------------------------------------------------------
# Deploy qutebrowser configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/modules/lib-shell-utils/src/fs.sh"


qutebrowser::install () {
    echo "└> Installing qutebrowser configuration."

    local src="$base_dir/modules/qutebrowser/src"

    ensure_directory "$XDG_CONFIG_HOME/qutebrowser"
    force_link "$src/config.py" "$XDG_CONFIG_HOME/qutebrowser/config.py"
    esh "$src/stylesheet.css~esh" > "$XDG_CONFIG_HOME/qutebrowser/stylesheet.css"
    force_link "$src/stylemap.py" "$XDG_CONFIG_HOME/qutebrowser/stylemap.py"

    ensure_directory "$XDG_CONFIG_HOME/qutebrowser/styles"
    esh "$src/styles/qute.css~esh" > "$XDG_CONFIG_HOME/qutebrowser/styles/qute.css"
    force_link "$src/styles/github.css" "$XDG_CONFIG_HOME/qutebrowser/styles/github.css"
    force_link "$src/styles/hackernews.css" "$XDG_CONFIG_HOME/qutebrowser/styles/hackernews.css"
    force_link "$src/styles/wikipedia.css" "$XDG_CONFIG_HOME/qutebrowser/styles/wikipedia.css"

    ensure_directory "$XDG_DATA_HOME/applications"
    force_link "$src/org.qutebrowser.qutebrowser.desktop" "$XDG_DATA_HOME/applications/org.qutebrowser.qutebrowser.desktop"

    ensure_directory "$XDG_DATA_HOME/qutebrowser/userscripts"
    force_link "$src/userscripts/format_json.sh" "$XDG_DATA_HOME/qutebrowser/userscripts/format_json.sh"
    force_link "$src/userscripts/rebuild-grease-styles.py" "$XDG_DATA_HOME/qutebrowser/userscripts/rebuild-grease-styles.py"
    force_link "$src/userscripts/readability.py" "$XDG_DATA_HOME/qutebrowser/userscripts/readability.py"

    ensure_directory "$XDG_SCRIPTS_HOME"
    force_link "$src/add-bookmark.sh" "$XDG_SCRIPTS_HOME/add-bookmark.sh"
    force_link "$src/browse.sh" "$XDG_SCRIPTS_HOME/browse.sh"
    force_link "$src/open-qutebrowser-session.sh" "$XDG_SCRIPTS_HOME/open-qutebrowser-session.sh"
    force_link "$src/select-bookmark.sh" "$XDG_SCRIPTS_HOME/select-bookmark.sh"

    ensure_directory "$XDG_TEMPLATES_DIR"
    force_link "$src/bookmark.md~esh" "$XDG_TEMPLATES_DIR/bookmark.md~esh"

    echo "└> Installing qutebrowser shortcuts."

    ensure_directory "$XDG_BIN_HOME"
    force_link "$src/browse.sh" "$XDG_BIN_HOME/browse"

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
