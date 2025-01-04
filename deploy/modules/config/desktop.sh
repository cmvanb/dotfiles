#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Deploy desktop configuration files
#-------------------------------------------------------------------------------

echo "Deploying desktop configuration files..."

# Setup
#-------------------------------------------------------------------------------

config_dir=${XDG_CONFIG_HOME:-$HOME/.config}
data_dir=${XDG_DATA_HOME:-$HOME/.local/share}
templates_dir=${XDG_TEMPLATES_DIR:-$data_dir/templates}
host=$(uname -n)

source "$base_dir/local/opt/shell-utils/debug.sh"

assert_dependency esh

# Link configuration
#-------------------------------------------------------------------------------

# XDG MIME configuration
mkdir -p "$config_dir"
force_link "$base_dir/config/mimeapps.list" "$config_dir/mimeapps.list"

# Fontconfig
mkdir -p "$config_dir/fontconfig"
esh "$base_dir/config/fontconfig/fonts.conf~esh" > "$config_dir/fontconfig/fonts.conf"

# Systemd integrations
mkdir -p "$config_dir/systemd/user"
force_link "$base_dir/config/systemd/user/bluetooth-autoconnect.service" "$config_dir/systemd/user/bluetooth-autoconnect.service"
force_link "$base_dir/config/systemd/user/udiskie.service" "$config_dir/systemd/user/udiskie.service"

# Way-displays
if [[ $host == "supertubes" ]] || [[ $host == "cyxwel" ]]; then
    force_link "$base_dir/config/way-displays/cfg.yaml~home-triple" "$config_dir/way-displays/cfg.yaml"

else
    echo "[$(basename "$0")] ERROR: \`$host\` is not accounted for."
    exit 1
fi

# Wezterm
mkdir -p "$config_dir/wezterm"
force_link "$base_dir/config/wezterm/wezterm.lua" "$config_dir/wezterm/wezterm.lua"

# Wofi
mkdir -p "$config_dir/wofi"
force_link "$base_dir/config/wofi/config" "$config_dir/wofi/config"
esh "$base_dir/config/wofi/style.css~esh" > "$config_dir/wofi/style.css"

# XDG integration
mkdir -p "$config_dir/xdg-desktop-portal"
force_link "$base_dir/config/xdg-desktop-portal/river-portals.conf" "$config_dir/xdg-desktop-portal/river-portals.conf"
force_link "$base_dir/config/xdg-desktop-portal/niri-portals.conf" "$config_dir/xdg-desktop-portal/niri-portals.conf"

# Yay
if [[ $SYSTEM_DISTRO == "arch" ]]; then
    mkdir -p "$config_dir/yay"
    force_link "$base_dir/config/yay/config.json" "$config_dir/yay/config.json"
fi

# Zathura
mkdir -p "$config_dir/zathura"
esh "$base_dir/config/zathura/zathurarc~esh" > "$config_dir/zathura/zathurarc"

# Link shared data
#-------------------------------------------------------------------------------

# Templates
mkdir -p "$templates_dir"
force_link "$base_dir/local/share/templates/bookmark.md~esh" "$templates_dir/bookmark.md~esh"

# XDG .desktop files
mkdir -p "$data_dir"
mkdir -p "$data_dir/applications"
force_link "$base_dir/local/share/applications/bitwarden.desktop" "$data_dir/applications/bitwarden.desktop"
force_link "$base_dir/local/share/applications/chromium.desktop" "$data_dir/applications/chromium.desktop"
force_link "$base_dir/local/share/applications/discord.desktop" "$data_dir/applications/discord.desktop"
force_link "$base_dir/local/share/applications/lf.desktop" "$data_dir/applications/lf.desktop"
force_link "$base_dir/local/share/applications/org.qutebrowser.qutebrowser.desktop" "$data_dir/applications/org.qutebrowser.qutebrowser.desktop"
force_link "$base_dir/local/share/applications/org.pwmt.zathura.desktop" "$data_dir/applications/org.pwmt.zathura.desktop"
force_link "$base_dir/local/share/applications/spotify.desktop" "$data_dir/applications/spotify.desktop"
force_link "$base_dir/local/share/applications/vscodium-wayland.desktop" "$data_dir/applications/vscodium-wayland.desktop"
esh "$base_dir/local/share/applications/draw.io.desktop~esh" > "$data_dir/applications/draw.io.desktop"

# Disabled XDG .desktop files
if [[ $SYSTEM_DISTRO == "arch" ]]; then
    force_link "$base_dir/local/share/applications/avahi-discover.desktop" "$data_dir/applications/avahi-discover.desktop"
    force_link "$base_dir/local/share/applications/bssh.desktop" "$data_dir/applications/bssh.desktop"
    force_link "$base_dir/local/share/applications/bvnc.desktop" "$data_dir/applications/bvnc.desktop"
    force_link "$base_dir/local/share/applications/cmake-gui.desktop" "$data_dir/applications/cmake-gui.desktop"
    force_link "$base_dir/local/share/applications/electron24.desktop" "$data_dir/applications/electron24.desktop"
    force_link "$base_dir/local/share/applications/lstopo.desktop" "$data_dir/applications/lstopo.desktop"
    force_link "$base_dir/local/share/applications/qv4l2.desktop" "$data_dir/applications/qv4l2.desktop"
    force_link "$base_dir/local/share/applications/qvidcap.desktop" "$data_dir/applications/qvidcap.desktop"
    force_link "$base_dir/local/share/applications/vscodium.desktop" "$data_dir/applications/vscodium.desktop"
fi

# Application data
mkdir -p "$data_dir/qutebrowser/userscripts"
force_link "$base_dir/local/share/qutebrowser/userscripts/format_json.sh" "$data_dir/qutebrowser/userscripts/format_json.sh"
force_link "$base_dir/local/share/qutebrowser/userscripts/readability.py" "$data_dir/qutebrowser/userscripts/readability.py"
force_link "$base_dir/local/share/pandoc" "$data_dir/pandoc"
