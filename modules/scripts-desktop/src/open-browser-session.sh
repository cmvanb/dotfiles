#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Choose a qutebrowser session and open it in the default browser
#-------------------------------------------------------------------------------

# Imports
#-------------------------------------------------------------------------------

# shellcheck disable=SC1091
source "$XDG_OPT_HOME/shell-utils/debug.sh"

# Validation
#-------------------------------------------------------------------------------

assert_dependency spawn-launcher.sh
assert_dependency python

# Get browser from environment
#-------------------------------------------------------------------------------

browser="${BROWSER:-qutebrowser}"

case "$browser" in
    *qutebrowser*|*chromium*|*firefox*)
        ;;
    *)
        echo "Error: Unsupported browser '$browser'"
        echo "Supported browsers: qutebrowser, chromium, firefox"
        exit 1
        ;;
esac

# Choose session
#-------------------------------------------------------------------------------

data_dir="${XDG_DATA_HOME:-$HOME/.local/share}"
session_dir="$data_dir/qutebrowser/sessions"
session_files=$(fd ".yml" "$session_dir" -E 'before-qt-515' -x basename | sed -e 's/\.yml//' | sort)
session=$(echo "$session_files" | spawn-launcher.sh --menu --prompt="Open browser session..." 2> /dev/null)

if [[ -z $session ]]; then
    exit 1
fi

session_file="$session_dir/$session.yml"

# Open session based on browser type
#-------------------------------------------------------------------------------

case "$browser" in
    qutebrowser)
        if pgrep qutebrowser; then
            qutebrowser --target window ":session-load $session"

        else
            qutebrowser --target window --restore "$session"
        fi
        ;;

    chromium|firefox)
        # Extract URLs from qutebrowser session YAML
        urls=$(python3 - "$session_file" <<'EOF'
import sys
import yaml

session_file = sys.argv[1]

try:
    with open(session_file, 'r') as f:
        session = yaml.safe_load(f)

    urls = []
    if 'windows' in session:
        for window in session['windows']:
            if 'tabs' in window:
                for tab in window['tabs']:
                    if 'history' in tab:
                        for entry in tab['history']:
                            if 'url' in entry:
                                urls.append(entry['url'])

    # Print unique URLs preserving order
    seen = set()
    for url in urls:
        if url not in seen:
            print(url)
            seen.add(url)

except Exception as e:
    print(f"Error parsing session file: {e}", file=sys.stderr)
    sys.exit(1)
EOF
)

        if [[ -z "$urls" ]]; then
            echo "Error: No URLs found in session '$session'"
            exit 1
        fi

        readarray -t url_array <<< "$urls"

        if [[ "$browser" == "chromium" ]]; then
            "$browser" --new-window "${url_array[@]}"

        else
            "$browser" --new-window "${url_array[@]}"
        fi
        ;;
esac
