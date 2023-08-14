#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Generate configuration files from templates
#-------------------------------------------------------------------------------

if ! command -v esh &> /dev/null
then
    echo "ERROR: "$(basename "$0")" missing dependency: esh"
    exit
fi

esh .config/mako/config~esh > $HOME/.config/mako/config
esh .config/wofi/style.css~esh > $HOME/.config/wofi/style.css
esh .config/yambar/config.yml~desktop > $HOME/.config/yambar/config.yml

