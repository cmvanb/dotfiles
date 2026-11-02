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

    fs::ensure_directory "$XDG_CONFIG_HOME/qutebrowser"
    fs::force_link "$src/config.py" "$XDG_CONFIG_HOME/qutebrowser/config.py"
    template::render_mako "$src/stylesheet.mako.css" "$XDG_CONFIG_HOME/qutebrowser/stylesheet.css"
    fs::force_link "$src/stylemap.py" "$XDG_CONFIG_HOME/qutebrowser/stylemap.py"
    fs::force_link "$src/modern-normalize.css" "$XDG_CONFIG_HOME/qutebrowser/modern-normalize.css"

    fs::ensure_directory "$XDG_CONFIG_HOME/qutebrowser/styles"
    template::render_mako "$src/styles/qute.mako.css" "$XDG_CONFIG_HOME/qutebrowser/styles/qute.css"
    template::render_mako "$src/styles/hackernews.mako.css" "$XDG_CONFIG_HOME/qutebrowser/styles/hackernews.css"
    fs::force_link "$src/styles/ansible-docs.css" "$XDG_CONFIG_HOME/qutebrowser/styles/ansible-docs.css"
    fs::force_link "$src/styles/arch-linux-forum.css" "$XDG_CONFIG_HOME/qutebrowser/styles/arch-linux-forum.css"
    fs::force_link "$src/styles/arch-linux-wiki.css" "$XDG_CONFIG_HOME/qutebrowser/styles/arch-linux-wiki.css"
    template::render_mako "$src/styles/claude.mako.css" "$XDG_CONFIG_HOME/qutebrowser/styles/claude.css"
    fs::force_link "$src/styles/codemuch.css" "$XDG_CONFIG_HOME/qutebrowser/styles/codemuch.css"
    fs::force_link "$src/styles/github.css" "$XDG_CONFIG_HOME/qutebrowser/styles/github.css"
    fs::force_link "$src/styles/azure-devops.css" "$XDG_CONFIG_HOME/qutebrowser/styles/azure-devops.css"
    fs::force_link "$src/styles/reddit.css" "$XDG_CONFIG_HOME/qutebrowser/styles/reddit.css"
    fs::force_link "$src/styles/wikipedia.css" "$XDG_CONFIG_HOME/qutebrowser/styles/wikipedia.css"

    # Packaged rasters win icon lookups by name, so the desktop entry names a distinct icon.
    fs::ensure_directory "$XDG_DATA_HOME/icons/hicolor/scalable/apps"
    fs::force_link "$src/icons/qutebrowser-globe.svg" "$XDG_DATA_HOME/icons/hicolor/scalable/apps/qutebrowser-globe.svg"
    gtk-update-icon-cache -q -f -t "$XDG_DATA_HOME/icons/hicolor"

    fs::ensure_directory "$XDG_DATA_HOME/applications"
    fs::force_link "$src/org.qutebrowser.qutebrowser.desktop" "$XDG_DATA_HOME/applications/org.qutebrowser.qutebrowser.desktop"

    fs::ensure_directory "$XDG_DATA_HOME/qutebrowser/userscripts"
    fs::force_link "$src/userscripts/format_json.sh" "$XDG_DATA_HOME/qutebrowser/userscripts/format_json.sh"
    fs::force_link "$src/userscripts/rebuild-grease-styles.py" "$XDG_DATA_HOME/qutebrowser/userscripts/rebuild-grease-styles.py"
    fs::force_link "$src/userscripts/readability.py" "$XDG_DATA_HOME/qutebrowser/userscripts/readability.py"
    fs::force_link "$src/userscripts/qute-rbw" "$XDG_DATA_HOME/qutebrowser/userscripts/qute-rbw"

    fs::ensure_directory "$XDG_SCRIPTS_HOME"
    fs::force_link "$src/add-bookmark.sh" "$XDG_SCRIPTS_HOME/add-bookmark.sh"
    fs::force_link "$src/browse.sh" "$XDG_SCRIPTS_HOME/browse.sh"
    fs::force_link "$src/open-qutebrowser-session.sh" "$XDG_SCRIPTS_HOME/open-qutebrowser-session.sh"
    fs::force_link "$src/select-bookmark.sh" "$XDG_SCRIPTS_HOME/select-bookmark.sh"

    fs::ensure_directory "$XDG_TEMPLATES_DIR"
    fs::force_link "$src/bookmark.mako.md" "$XDG_TEMPLATES_DIR/bookmark.mako.md"

    echo "└> Installing qutebrowser shortcuts."

    fs::ensure_directory "$XDG_BIN_HOME"
    fs::force_link "$src/browse.sh" "$XDG_BIN_HOME/browse"
    fs::force_link "$src/qutebrowser-window.sh" "$XDG_BIN_HOME/qutebrowser-window"

    echo "└> Building qutebrowser custom CSS."

    python "$XDG_DATA_HOME/qutebrowser/userscripts/rebuild-grease-styles.py"
}

qutebrowser::uninstall () {
    echo "└> Uninstalling qutebrowser configuration."

    fs::remove "$XDG_CONFIG_HOME/qutebrowser/config.py"
    fs::remove "$XDG_CONFIG_HOME/qutebrowser/stylesheet.css"
    fs::remove "$XDG_CONFIG_HOME/qutebrowser/stylemap.py"
    fs::remove "$XDG_CONFIG_HOME/qutebrowser/modern-normalize.css"
    fs::remove "$XDG_CONFIG_HOME/qutebrowser/styles/qute.css"
    fs::remove "$XDG_CONFIG_HOME/qutebrowser/styles/ansible-docs.css"
    fs::remove "$XDG_CONFIG_HOME/qutebrowser/styles/arch-linux-forum.css"
    fs::remove "$XDG_CONFIG_HOME/qutebrowser/styles/arch-linux-wiki.css"
    fs::remove "$XDG_CONFIG_HOME/qutebrowser/styles/claude.css"
    fs::remove "$XDG_CONFIG_HOME/qutebrowser/styles/codemuch.css"
    fs::remove "$XDG_CONFIG_HOME/qutebrowser/styles/github.css"
    fs::remove "$XDG_CONFIG_HOME/qutebrowser/styles/azure-devops.css"
    fs::remove "$XDG_CONFIG_HOME/qutebrowser/styles/hackernews.css"
    fs::remove "$XDG_CONFIG_HOME/qutebrowser/styles/reddit.css"
    fs::remove "$XDG_CONFIG_HOME/qutebrowser/styles/wikipedia.css"

    fs::remove "$XDG_DATA_HOME/applications/org.qutebrowser.qutebrowser.desktop"
    fs::remove "$XDG_DATA_HOME/icons/hicolor/scalable/apps/qutebrowser-globe.svg"
    gtk-update-icon-cache -q -f -t "$XDG_DATA_HOME/icons/hicolor"

    fs::remove "$XDG_DATA_HOME/qutebrowser/userscripts/format_json.sh"
    fs::remove "$XDG_DATA_HOME/qutebrowser/userscripts/rebuild-grease-styles.py"
    fs::remove "$XDG_DATA_HOME/qutebrowser/userscripts/readability.py"
    fs::remove "$XDG_DATA_HOME/qutebrowser/userscripts/qute-rbw"

    fs::remove "$XDG_SCRIPTS_HOME/add-bookmark.sh"
    fs::remove "$XDG_SCRIPTS_HOME/browse.sh"
    fs::remove "$XDG_SCRIPTS_HOME/open-qutebrowser-session.sh"
    fs::remove "$XDG_SCRIPTS_HOME/select-bookmark.sh"

    fs::remove "$XDG_TEMPLATES_DIR/bookmark.mako.md"

    echo "└> Uninstalling qutebrowser shortcuts."

    fs::remove "$XDG_BIN_HOME/browse"
    fs::remove "$XDG_BIN_HOME/qutebrowser-window"
}
