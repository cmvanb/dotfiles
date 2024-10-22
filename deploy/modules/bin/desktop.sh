#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Deploy desktop binary shortcuts
#-------------------------------------------------------------------------------

echo "Deploying desktop binary shortcuts..."

# Setup
#-------------------------------------------------------------------------------

bin_dir=${XDG_BIN_HOME:-$HOME/.local/bin}
host=$(uname -n)

# Link shortcuts
#-------------------------------------------------------------------------------

# Link binary shortcuts
mkdir -p "$bin_dir"
force_link "$base_dir/.local/bin/0x0" "$bin_dir/0x0"
force_link "$base_dir/.local/bin/browse" "$bin_dir/browse"
force_link "$base_dir/.local/bin/fetchpw" "$bin_dir/fetchpw"
force_link "$base_dir/.local/bin/logout" "$bin_dir/logout"
force_link "$base_dir/.local/bin/reboot" "$bin_dir/reboot"
force_link "$base_dir/.local/bin/river-run" "$bin_dir/river-run"
force_link "$base_dir/.local/bin/shutdown" "$bin_dir/shutdown"
force_link "$base_dir/.local/bin/suspend" "$bin_dir/suspend"

# Link host-specific init script
if [[ $host == "qutedell" ]] || [[ $host == "supertubes" ]] || [[ $host == "cyxwel" ]]; then
    force_link "$base_dir/.local/bin/init~niri" "$bin_dir/init"

else
    echo "[$(basename "$0")] ERROR: \`$host\` is not accounted for."
    exit 1
fi
