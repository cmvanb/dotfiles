#-------------------------------------------------------------------------------
# Deploy qutebrowser configuration
#-------------------------------------------------------------------------------


script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
base_dir=$(realpath "$script_dir/../..")

source "$base_dir/lib/fs.sh"
source "$base_dir/lib/template.sh"


qutebrowser::install () {
    echo "└> Installing qutebrowser configuration."

    local src="$base_dir/modules/qutebrowser/src"

    ensure_directory "$XDG_CONFIG_HOME/qutebrowser"
    force_link "$src/config.py" "$XDG_CONFIG_HOME/qutebrowser/config.py"
    render_esh_template "$src/stylesheet.esh.css" "$XDG_CONFIG_HOME/qutebrowser/stylesheet.css"
    force_link "$src/stylemap.py" "$XDG_CONFIG_HOME/qutebrowser/stylemap.py"

    ensure_directory "$XDG_CONFIG_HOME/qutebrowser/styles"
    render_esh_template "$src/styles/qute.esh.css" "$XDG_CONFIG_HOME/qutebrowser/styles/qute.css"
    render_esh_template "$src/styles/hackernews.esh.css" "$XDG_CONFIG_HOME/qutebrowser/styles/hackernews.css"
    force_link "$src/styles/ansible-docs.css" "$XDG_CONFIG_HOME/qutebrowser/styles/ansible-docs.css"
    force_link "$src/styles/arch-linux-forum.css" "$XDG_CONFIG_HOME/qutebrowser/styles/arch-linux-forum.css"
    force_link "$src/styles/arch-linux-wiki.css" "$XDG_CONFIG_HOME/qutebrowser/styles/arch-linux-wiki.css"
    force_link "$src/styles/github.css" "$XDG_CONFIG_HOME/qutebrowser/styles/github.css"
    force_link "$src/styles/wikipedia.css" "$XDG_CONFIG_HOME/qutebrowser/styles/wikipedia.css"

    ensure_directory "$XDG_DATA_HOME/applications"
    force_link "$src/org.qutebrowser.qutebrowser.desktop" "$XDG_DATA_HOME/applications/org.qutebrowser.qutebrowser.desktop"

    ensure_directory "$XDG_DATA_HOME/qutebrowser/userscripts"
    force_link "$src/userscripts/format_json.sh" "$XDG_DATA_HOME/qutebrowser/userscripts/format_json.sh"
    force_link "$src/userscripts/rebuild-grease-styles.py" "$XDG_DATA_HOME/qutebrowser/userscripts/rebuild-grease-styles.py"
    force_link "$src/userscripts/readability.py" "$XDG_DATA_HOME/qutebrowser/userscripts/readability.py"
    force_link "$src/userscripts/qute-rbw" "$XDG_DATA_HOME/qutebrowser/userscripts/qute-rbw"

    ensure_directory "$XDG_SCRIPTS_HOME"
    force_link "$src/add-bookmark.sh" "$XDG_SCRIPTS_HOME/add-bookmark.sh"
    force_link "$src/browse.sh" "$XDG_SCRIPTS_HOME/browse.sh"
    force_link "$src/open-qutebrowser-session.sh" "$XDG_SCRIPTS_HOME/open-qutebrowser-session.sh"
    force_link "$src/select-bookmark.sh" "$XDG_SCRIPTS_HOME/select-bookmark.sh"

    ensure_directory "$XDG_TEMPLATES_DIR"
    force_link "$src/bookmark.esh.md" "$XDG_TEMPLATES_DIR/bookmark.esh.md"

    echo "└> Installing qutebrowser shortcuts."

    ensure_directory "$XDG_BIN_HOME"
    force_link "$src/browse.sh" "$XDG_BIN_HOME/browse"

    echo "└> Building qutebrowser custom CSS."

    python "$XDG_DATA_HOME/qutebrowser/userscripts/rebuild-grease-styles.py"
}

qutebrowser::uninstall () {
    echo "└> Uninstalling qutebrowser configuration."

    rm "$XDG_CONFIG_HOME/qutebrowser/config.py"
    rm "$XDG_CONFIG_HOME/qutebrowser/stylesheet.css"
    rm "$XDG_CONFIG_HOME/qutebrowser/stylemap.py"
    rm "$XDG_CONFIG_HOME/qutebrowser/styles/qute.css"
    rm "$XDG_CONFIG_HOME/qutebrowser/styles/ansible-docs.css"
    rm "$XDG_CONFIG_HOME/qutebrowser/styles/github.css"
    rm "$XDG_CONFIG_HOME/qutebrowser/styles/hackernews.css"
    rm "$XDG_CONFIG_HOME/qutebrowser/styles/wikipedia.css"
    rmdir "$XDG_CONFIG_HOME/qutebrowser/styles" 2>/dev/null || true
    rmdir "$XDG_CONFIG_HOME/qutebrowser" 2>/dev/null || true

    rm "$XDG_DATA_HOME/applications/org.qutebrowser.qutebrowser.desktop"

    rm "$XDG_DATA_HOME/qutebrowser/userscripts/format_json.sh"
    rm "$XDG_DATA_HOME/qutebrowser/userscripts/rebuild-grease-styles.py"
    rm "$XDG_DATA_HOME/qutebrowser/userscripts/readability.py"
    rm "$XDG_DATA_HOME/qutebrowser/userscripts/qute-rbw"
    rmdir "$XDG_DATA_HOME/qutebrowser/userscripts" 2>/dev/null || true

    rm "$XDG_SCRIPTS_HOME/add-bookmark.sh"
    rm "$XDG_SCRIPTS_HOME/browse.sh"
    rm "$XDG_SCRIPTS_HOME/open-qutebrowser-session.sh"
    rm "$XDG_SCRIPTS_HOME/select-bookmark.sh"

    rm "$XDG_TEMPLATES_DIR/bookmark.esh.md"

    echo "└> Uninstalling qutebrowser shortcuts."

    rm "$XDG_BIN_HOME/browse"
}
