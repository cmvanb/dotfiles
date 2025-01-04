#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Clean up packer artifacts (packer_compiled.lua and packer data directory)
#-------------------------------------------------------------------------------

packer_compiled=$XDG_DATA_HOME/nvim/plugin/packer_compiled.lua
packer_data_dir=$XDG_DATA_HOME/nvim/site/pack/packer

if [[ -f "$packer_compiled" ]]; then
    rm "$packer_compiled"
    echo "Removed $packer_compiled."
else
    echo "$packer_compiled doesn't exist."
fi

if [[ -d "$packer_data_dir" ]]; then
    rm -r "$packer_data_dir"
    echo "Removed $packer_data_dir."
else
    echo "$packer_data_dir doesn't exist."
fi

echo 'clean.sh complete.'
