#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Switch the system color scheme at runtime
#
# Usage:
#   theme switch dark|light|toggle
#   theme status
#-------------------------------------------------------------------------------

set -uo pipefail

config_home="${XDG_CONFIG_HOME:-$HOME/.config}"
config_dir="$config_home/theme"
cache_dir="${XDG_CACHE_HOME:-$HOME/.local/cache}/theme"
opt_dir="${XDG_OPT_HOME:-$HOME/.local/opt}"
bin_dir="${XDG_BIN_HOME:-$HOME/.local/bin}"
manifest="${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles/renders"

theme::active_variant () {
    local variant
    variant=$(sed -n "s/^scheme_variant='\(.*\)'$/\1/p" "$cache_dir/theme-data.sh" 2>/dev/null)
    echo "${variant:-dark}"
}

theme::select_scheme () {
    local scheme="$1"
    ln -sfn "$config_dir/$scheme.yaml" "$config_dir/colors.yaml"
    python3 "$opt_dir/theme/theme.py" parse \
        "$config_dir/colors.yaml" "$config_dir/fonts.yaml" "$config_dir/cursor.yaml"
}

# Re-render every recorded template that follows the active scheme. Entries
# whose template or output no longer exists belong to uninstalled modules and
# are pruned.
theme::rerender () {
    [[ -f "$manifest" ]] || return 0

    local kept failed=0
    kept=$(mktemp)

    local destination template scheme profile distro wm host
    while IFS=$'\t' read -r destination template scheme profile distro wm host; do
        if [[ ! -f "$template" ]] || [[ ! -e "$destination" ]]; then
            continue
        fi
        printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
            "$destination" "$template" "$scheme" "$profile" "$distro" "$wm" "$host" >> "$kept"
        [[ "$scheme" != - ]] && continue

        [[ "$profile" == - ]] && profile=""
        [[ "$distro" == - ]] && distro=""
        [[ "$wm" == - ]] && wm=""
        [[ "$host" == - ]] && host=""

        DEPLOY_PROFILE="$profile" DEPLOY_DISTRO="$distro" DEPLOY_WM="$wm" DEPLOY_HOST="$host" \
            "$bin_dir/render-mako" "$template" "$destination" &

        # Bound parallelism to the core count.
        while (( $(jobs -rp | wc -l) >= $(nproc) )); do
            wait -n || failed=1
        done
    done < "$manifest"

    while (( $(jobs -rp | wc -l) > 0 )); do
        wait -n || failed=1
    done

    mv "$kept" "$manifest"
    return "$failed"
}

# Running GTK apps restyle when the theme name changes. Apps started with
# GTK_THEME=carbon-gtk pick up the repointed alias on their next launch.
theme::apply_gtk () {
    local variant="$1"
    local themes_dir="${XDG_DATA_HOME:-$HOME/.local/share}/themes"
    [[ -d "$themes_dir/carbon-$variant-gtk" ]] || return 0

    ln -sfn "carbon-$variant-gtk" "$themes_dir/carbon-gtk"

    command -v gsettings &> /dev/null || return 0
    gsettings set org.gnome.desktop.interface gtk-theme "carbon-$variant-gtk"
    gsettings set org.gnome.desktop.interface color-scheme "prefer-$variant"
    gsettings set org.gnome.desktop.interface icon-theme "carbon-$variant"

    local cursor_theme cursor_size
    cursor_theme=$(sed -n "s/^cursor_theme='\(.*\)'$/\1/p" "$cache_dir/theme-data.sh" 2>/dev/null)
    cursor_size=$(sed -n "s/^cursor_size='\(.*\)'$/\1/p" "$cache_dir/theme-data.sh" 2>/dev/null)
    [[ -n "$cursor_theme" ]] && gsettings set org.gnome.desktop.interface cursor-theme "$cursor_theme"
    [[ -n "$cursor_size" ]] && gsettings set org.gnome.desktop.interface cursor-size "$cursor_size"
}

theme::is_running () {
    pgrep -u "$USER" -x "$1" &> /dev/null
}

# Apps that read their colors at startup are told to reload.
theme::reload_apps () {
    if theme::is_running sway;     then swaymsg reload &> /dev/null; fi
    if theme::is_running Hyprland; then hyprctl reload &> /dev/null; fi
    if theme::is_running river;    then "$config_home/river/theme.sh" &> /dev/null; fi

    if theme::is_running waybar;   then pkill -u "$USER" -USR2 -x waybar; fi
    if theme::is_running eww;      then eww reload &> /dev/null; fi
    if theme::is_running swaync;   then swaync-client --reload-css &> /dev/null; fi
    if systemctl --user --quiet is-active swayosd-server.service 2> /dev/null; then
        systemctl --user restart swayosd-server.service
    fi

    if theme::is_running ghostty;  then pkill -u "$USER" -USR2 -x ghostty; fi
    if theme::is_running wezterm-gui && [[ -f "$config_home/wezterm/wezterm.lua" ]]; then
        touch "$config_home/wezterm/wezterm.lua"
    fi
    if theme::is_running nvim;     then pkill -u "$USER" -USR1 -x nvim; fi
    if command -v bat &> /dev/null && [[ -f "$config_home/bat/themes/carbon.tmTheme" ]]; then
        bat cache --build &> /dev/null
    fi
    if pgrep -u "$USER" -f '/qutebrowser' &> /dev/null; then
        qutebrowser ':config-source' &> /dev/null &
    fi
}

theme::switch () {
    local variant="$1"

    case "$variant" in
        toggle)
            [[ "$(theme::active_variant)" == dark ]] && variant=light || variant=dark
            ;;
        dark|light)
            ;;
        *)
            echo "Usage: theme switch dark|light|toggle" >&2
            return 1
            ;;
    esac

    local scheme="carbon-$variant"
    if [[ ! -f "$config_dir/$scheme.yaml" ]]; then
        echo "[theme] Scheme not found: $config_dir/$scheme.yaml" >&2
        return 1
    fi

    theme::select_scheme "$scheme" || return 1
    theme::rerender || echo "[theme] Some templates failed to render." >&2
    theme::apply_gtk "$variant"
    theme::reload_apps

    echo "[theme] Switched to $scheme."
}

case "${1:-}" in
    switch)
        theme::switch "${2:-}"
        ;;
    status)
        echo "carbon-$(theme::active_variant)"
        ;;
    *)
        echo "Usage: theme switch dark|light|toggle | theme status" >&2
        exit 1
        ;;
esac
