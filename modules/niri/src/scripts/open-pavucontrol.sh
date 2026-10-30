#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Open pavucontrol on the audio workspace and focus it.
#-------------------------------------------------------------------------------

set -euo pipefail

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

"$script_dir/ws.sh" focus audio

id=$(niri msg -j windows | jq -r 'first(.[] | select(.app_id == "org.pulseaudio.pavucontrol") | .id) // empty')

if [[ -n $id ]]; then
    niri msg action move-window-to-workspace --window-id "$id" --focus false audio
    niri msg action focus-window --id "$id"
else
    niri msg action spawn -- pavucontrol
fi
