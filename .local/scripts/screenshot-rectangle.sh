#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Select a rectangle and screenshot it. Optionally upload it to 0x0.st
#-------------------------------------------------------------------------------

if [[ "${TRACE-0}" == "1" ]]; then set -o xtrace; fi

scriptName=`basename "$0"`

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
            exit -1
            ;;
        *)
            echo "Invalid parameter \`$OPTARG\`." >&2
            echo "" >&2
            usage
            exit -1
            ;;
    esac
done

# Log a debug message.
log() {
    echo "$1" 1>&2
}

# Log a fatal error and dispatch a notification.
fatal_error() {
    log "$2"
    notify-send "$2"
    exit "$1"
}

# Where to save screenshots.
screenshotDir="${XDG_PICTURES_DIR:-$HOME/Media/Images}/screenshots"
mkdir -p $screenshotDir

# Screenshot file name.
currentDateTime=`date +"%Y-%m-%d--%H-%M-%S"`

# Screenshot file path.
filePath="$screenshotDir/$currentDateTime.jpg"

# Get the screen coordinates (or error out).
coordinates=$(slurp 2>&1)
if [[ $coordinates == "selection cancelled" ]]; then
    fatal_error 1 "Screenshot selection cancelled."
fi

# Take a screenshot (or error out).
error="$(grim -g "$coordinates" "$filePath" 2>&1)"
if [[ -n $error ]]; then
    fatal_error 2 "$error"
fi

# If `upload` flag was passed, upload screenshot to image share host and
# dispatch success notification.
if [[ "$upload" == true ]]; then
    url=$(0x0 -f $filePath 2>/dev/null)

    message="Screenshot saved to $filePath and uploaded to $url"
    log "$message"

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
    log "$message"

    # Notifcation with singular default action.
    result=$(notify-send --action="default=View image." "$message")
    if [[ $result == "default" ]]; then
        xdg-open "$filePath"
    fi
fi


