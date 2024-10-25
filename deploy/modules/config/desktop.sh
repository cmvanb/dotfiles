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

source "$base_dir/.local/opt/shell-utils/debug.sh"

assert_dependency esh

# Link configuration
#-------------------------------------------------------------------------------

# XDG MIME configuration
mkdir -p "$config_dir"
force_link "$base_dir/.config/mimeapps.list" "$config_dir/mimeapps.list"

# Alacritty
mkdir -p "$config_dir/alacritty"
esh "$base_dir/.config/alacritty/alacritty.toml~esh" > "$config_dir/alacritty/alacritty.toml"

# Bitwarden
# NOTE: Don't symlink Bitwarden config because it will be overwritten by the app.
cp -nr "$base_dir/.config/Bitwarden" "$config_dir/Bitwarden" && true

# Btop
mkdir -p "$config_dir/btop"
force_link "$base_dir/.config/btop/btop.conf" "$config_dir/btop/btop.conf"
mkdir -p "$config_dir/btop/themes"
esh "$base_dir/.config/btop/themes/carbon.theme~esh" > "$config_dir/btop/themes/carbon.theme"

# Direnv
force_link "$base_dir/.config/direnv" "$config_dir/direnv"

# Fontconfig
mkdir -p "$config_dir/fontconfig"
esh "$base_dir/.config/fontconfig/fonts.conf~esh" > "$config_dir/fontconfig/fonts.conf"

# Hyprland
force_link "$base_dir/.config/hypr" "$config_dir/hypr"

# Imv
force_link "$base_dir/.config/imv" "$config_dir/imv"

# Mako
mkdir -p "$config_dir/mako"
esh "$base_dir/.config/mako/config~esh" > "$config_dir/mako/config"

# Mpv
force_link "$base_dir/.config/mpv" "$config_dir/mpv"

# Niri
mkdir -p "$config_dir/niri"
force_link "$base_dir/.config/niri/config.kdl" "$config_dir/niri/config.kdl"
mkdir -p "$config_dir/systemd/user/niri.service.wants"
force_link "/usr/lib/systemd/user/mako.service" "$config_dir/systemd/user/niri.service.wants/mako.service"
force_link "/usr/lib/systemd/user/waybar.service" "$config_dir/systemd/user/niri.service.wants/waybar.service"

if [[ $host == "supertubes" || $host == "cyxwel" ]]; then
    force_link "$base_dir/.config/niri/workspace.sh~home-triple" "$config_dir/niri/workspace.sh"

else
    echo "[$(basename "$0")] ERROR: \`$host\` is not accounted for."
    exit 1
fi

# Python
force_link "$base_dir/.config/python" "$config_dir/python"
force_link "$base_dir/.config/pip" "$config_dir/pip"

# Qutebrowser
mkdir -p "$config_dir/qutebrowser"
force_link "$base_dir/.config/qutebrowser/config.py" "$config_dir/qutebrowser/config.py"
force_link "$base_dir/.config/qutebrowser/stylesheet.css" "$config_dir/qutebrowser/stylesheet.css"

# River
mkdir -p "$config_dir/river"
force_link "$base_dir/.config/river/environment.sh" "$config_dir/river/environment.sh"
force_link "$base_dir/.config/river/init" "$config_dir/river/init"
force_link "$base_dir/.config/river/keymaps.sh" "$config_dir/river/keymaps.sh"
force_link "$base_dir/.config/river/send-and-focus-output.sh" "$config_dir/river/send-and-focus-output.sh"
force_link "$base_dir/.config/river/send-to-output.sh" "$config_dir/river/send-to-output.sh"
force_link "$base_dir/.config/river/send-view-to-tag.sh" "$config_dir/river/send-view-to-tag.sh"
force_link "$base_dir/.config/river/theme.sh" "$config_dir/river/theme.sh"
force_link "$base_dir/.config/river/utils.sh" "$config_dir/river/utils.sh"

if [[ $host == "supertubes" || $host == "cyxwel" ]]; then
    force_link "$base_dir/.config/river/workspace.sh~home-triple" "$config_dir/river/workspace.sh"

else
    echo "[$(basename "$0")] ERROR: \`$host\` is not accounted for."
    exit 1
fi

# Systemd integrations
mkdir -p "$config_dir/systemd/user"
force_link "$base_dir/.config/systemd/user/bluetooth-autoconnect.service" "$config_dir/systemd/user/bluetooth-autoconnect.service"
force_link "$base_dir/.config/systemd/user/udiskie.service" "$config_dir/systemd/user/udiskie.service"

# Virtual terminal
force_link "$base_dir/.config/vt" "$config_dir/vt"

# Waybar
mkdir -p "$config_dir/waybar"
force_link "$base_dir/.config/waybar/niri-config" "$config_dir/waybar/config"
esh "$base_dir/.config/waybar/niri-style.css~esh" > "$config_dir/waybar/style.css"

# Wallpaper
if [[ $host == "qutedell" ]]; then
    force_link "$base_dir/.config/wallpaper/wallpaper.sh~qutech-dual" "$config_dir/wallpaper/wallpaper.sh"

elif [[ $host == "supertubes" ]] || [[ $host == "cyxwel" ]]; then
    force_link "$base_dir/.config/wallpaper/wallpaper.sh~home-triple" "$config_dir/wallpaper/wallpaper.sh"

else
    echo "[$(basename "$0")] ERROR: \`$host\` is not accounted for."
    exit 1
fi

# Way-displays
if [[ $host == "qutedell" ]]; then
    force_link "$base_dir/.config/way-displays/cfg.yaml~qutech-dual" "$config_dir/way-displays/cfg.yaml"

elif [[ $host == "supertubes" ]] || [[ $host == "cyxwel" ]]; then
    force_link "$base_dir/.config/way-displays/cfg.yaml~home-triple" "$config_dir/way-displays/cfg.yaml"

else
    echo "[$(basename "$0")] ERROR: \`$host\` is not accounted for."
    exit 1
fi

# Wezterm
mkdir -p "$config_dir/wezterm"
force_link "$base_dir/.config/wezterm/wezterm.lua" "$config_dir/wezterm/wezterm.lua"

# Wofi
mkdir -p "$config_dir/wofi"
force_link "$base_dir/.config/wofi/config" "$config_dir/wofi/config"
esh "$base_dir/.config/wofi/style.css~esh" > "$config_dir/wofi/style.css"

# River XDG integration
mkdir -p "$config_dir/xdg-desktop-portal"
force_link "$base_dir/.config/xdg-desktop-portal/river-portals.conf" "$config_dir/xdg-desktop-portal/river-portals.conf"

# Yay
if [[ $SYSTEM_DISTRO == "arch" ]]; then
    mkdir -p "$config_dir/yay"
    force_link "$base_dir/.config/yay/config.json" "$config_dir/yay/config.json"
fi

# Zathura
mkdir -p "$config_dir/zathura"
esh "$base_dir/.config/zathura/zathurarc~esh" > "$config_dir/zathura/zathurarc"

# Link shared data
#-------------------------------------------------------------------------------

# Templates
mkdir -p "$templates_dir"
force_link "$base_dir/.local/share/templates/bookmark.md~esh" "$templates_dir/bookmark.md~esh"

# XDG .desktop files
mkdir -p "$data_dir"
mkdir -p "$data_dir/applications"
force_link "$base_dir/.local/share/applications/bitwarden.desktop" "$data_dir/applications/bitwarden.desktop"
force_link "$base_dir/.local/share/applications/chromium.desktop" "$data_dir/applications/chromium.desktop"
force_link "$base_dir/.local/share/applications/lf.desktop" "$data_dir/applications/lf.desktop"
force_link "$base_dir/.local/share/applications/org.qutebrowser.qutebrowser.desktop" "$data_dir/applications/org.qutebrowser.qutebrowser.desktop"
force_link "$base_dir/.local/share/applications/org.pwmt.zathura.desktop" "$data_dir/applications/org.pwmt.zathura.desktop"
force_link "$base_dir/.local/share/applications/spotify.desktop" "$data_dir/applications/spotify.desktop"
force_link "$base_dir/.local/share/applications/vscodium-wayland.desktop" "$data_dir/applications/vscodium-wayland.desktop"
esh "$base_dir/.local/share/applications/draw.io.desktop~esh" > "$data_dir/applications/draw.io.desktop"

# Disabled XDG .desktop files
if [[ $SYSTEM_DISTRO == "arch" ]]; then
    force_link "$base_dir/.local/share/applications/avahi-discover.desktop" "$data_dir/applications/avahi-discover.desktop"
    force_link "$base_dir/.local/share/applications/bssh.desktop" "$data_dir/applications/bssh.desktop"
    force_link "$base_dir/.local/share/applications/bvnc.desktop" "$data_dir/applications/bvnc.desktop"
    force_link "$base_dir/.local/share/applications/cmake-gui.desktop" "$data_dir/applications/cmake-gui.desktop"
    force_link "$base_dir/.local/share/applications/electron24.desktop" "$data_dir/applications/electron24.desktop"
    force_link "$base_dir/.local/share/applications/lstopo.desktop" "$data_dir/applications/lstopo.desktop"
    force_link "$base_dir/.local/share/applications/qv4l2.desktop" "$data_dir/applications/qv4l2.desktop"
    force_link "$base_dir/.local/share/applications/qvidcap.desktop" "$data_dir/applications/qvidcap.desktop"
    force_link "$base_dir/.local/share/applications/vscodium.desktop" "$data_dir/applications/vscodium.desktop"
fi

# Application data
mkdir -p "$data_dir/qutebrowser/userscripts"
force_link "$base_dir/.local/share/qutebrowser/userscripts/format_json.sh" "$data_dir/qutebrowser/userscripts/format_json.sh"
force_link "$base_dir/.local/share/qutebrowser/userscripts/readability.py" "$data_dir/qutebrowser/userscripts/readability.py"
force_link "$base_dir/.local/share/pandoc" "$data_dir/pandoc"
