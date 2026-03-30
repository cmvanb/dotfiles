#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Select a rectangle and screenshot it. Optionally upload it to 0x0.st
#-------------------------------------------------------------------------------

if [[ "${TRACE-0}" == "1" ]]; then set -o xtrace; fi

# shellcheck disable=SC1091
source "$XDG_OPT_HOME/shell-utils/debug.sh"

scriptName=$(basename "$0")

# Print the usage instructions.
usage() {
    echo "$scriptName [--upload]" >&2
    echo "" >&2
    echo "Takes a screenshot of a user selected rectangular region." >&2
    echo "" >&2
    echo "Options:" >&2
    echo "--upload: Optionally upload the screenshot to \`0x0.st\`." >&2
    echo "" >&2
    echo "Dependencies:" >&2
    echo "grim, slurp, xdg-open, 0x0" >&2
}

# Parse command line options.
while getopts ":-:" option; do
    [[ "${option}" == "-" ]] || continue
    case "${OPTARG}" in
        upload)
            upload=true
            ;;
        help)
            usage
            exit 1
            ;;
        *)
            echo "Invalid parameter \`$OPTARG\`." >&2
            echo "" >&2
            usage
            exit 1
            ;;
    esac
done

# Where to save screenshots.
screenshotDir="${XDG_PICTURES_DIR:-"$HOME/Media/Images"}/screenshots"
mkdir -p "$screenshotDir"

# Screenshot file name.
currentDateTime=$(date +"%Y-%m-%d--%H-%M-%S")

# Screenshot file path.
filePath="$screenshotDir/$currentDateTime.jpg"

# Get the screen coordinates (or error out).
coordinates=$(slurp 2>&1)
if [[ $coordinates == "selection cancelled" ]]; then
    debug::error_notify "Screenshot selection cancelled."
    exit 1
fi

# Take a screenshot (or error out).
error="$(grim -g "$coordinates" "$filePath" 2>&1)"
if [[ -n $error ]]; then
    debug::error_notify "$error"
    exit 2
fi

# If `upload` flag was passed, upload screenshot to image share host and
# dispatch success notification.
if [[ "$upload" == true ]]; then
    url=$(0x0 -f "$filePath" 2>/dev/null)

    message="Screenshot saved to $filePath and uploaded to $url"
    >&2 echo "$message"

    # Notifcation with multiple actions.
    result=$(notify-send --action="default=View URL." --action="image=View image." "$message")
    if [[ $result == "default" ]]; then
        xdg-open "$url"
    elif [[ $result == "image" ]]; then
        xdg-open "$filePath"
    fi
# Dispatch succcess notifcation.
else
    message="Screenshot saved to $filePath"
    >&2 echo "$message"

    # Notifcation with singular default action.
    result=$(notify-send --action="default=View image." "$message")
    if [[ $result == "default" ]]; then
        xdg-open "$filePath"
    fi
fi
