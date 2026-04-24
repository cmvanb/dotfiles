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
    fs::force_link "$src/styles/wikipedia.css" "$XDG_CONFIG_HOME/qutebrowser/styles/wikipedia.css"

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
    rm "$XDG_CONFIG_HOME/qutebrowser/styles/claude.css"
    rm "$XDG_CONFIG_HOME/qutebrowser/styles/codemuch.css"
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

    rm "$XDG_TEMPLATES_DIR/bookmark.mako.md"

    echo "└> Uninstalling qutebrowser shortcuts."

    rm "$XDG_BIN_HOME/browse"
}
