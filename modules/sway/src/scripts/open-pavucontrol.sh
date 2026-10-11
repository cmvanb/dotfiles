#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Open pavucontrol on the audio workspace and focus it.
#-------------------------------------------------------------------------------

set -euo pipefail

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

"$script_dir/sws.sh" focus audio

if pgrep -x pavucontrol > /dev/null; then
    swaymsg '[app_id="org.pulseaudio.pavucontrol"] move workspace current, focus'
else
    swaymsg exec pavucontrol
fi
