#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Niri workspace
#
# Welcome to the land of sleep statements and magic numbers. 🪄
# Am I proud of it? No. Does it work? Yes.
#-------------------------------------------------------------------------------

# Workspace
#-------------------------------------------------------------------------------

# Right
niri msg action spawn -- "pavucontrol"
sleep 0.15
niri msg action spawn -- "spotify" "--enable-features=UseOzonePlatform" "--ozone-platform=wayland"
sleep 0.65

id=$(niri msg -j windows | jq '.[] | select(.app_id == "spotify").id')
niri msg action focus-window --id "$id"
niri msg action consume-or-expel-window-left
niri msg action set-window-height "66.6667%"
niri msg action move-window-up

# Left
niri msg action spawn -- "bitwarden-desktop" "--enable-features=UseOzonePlatform" "--ozone-platform=wayland"

niri msg action spawn -- "sh" "-c" "alacritty --working-directory ~/Wiki/todo --command edit"
sleep 0.65

id=$(niri msg -j windows | jq '.[] | select(.app_id == "Alacritty") | select(.title | test("~\/Wiki\/todo")).id')
niri msg action focus-window --id "$id"
niri msg action move-window-to-workspace "todo"
niri msg action maximize-column

# Center
niri msg action spawn -- "qutebrowser" "-r" "home"
sleep 1.75
niri msg action spawn -- "thunderbird"

id=$(niri msg -j windows | jq '.[] | select(.app_id == "org.qutebrowser.qutebrowser").id')
niri msg action move-window-to-workspace --window-id "$id" "home"
id=$(niri msg -j windows | jq '.[] | select(.app_id == "thunderbird").id')
niri msg action move-window-to-workspace --window-id "$id" "home"
