#-------------------------------------------------------------------------------
# System theme Fish API
#-------------------------------------------------------------------------------

set -l lib_dir $XDG_OPT_HOME/theme
set -l cache_file $XDG_CACHE_HOME/theme/theme-data.fish

# API
#-------------------------------------------------------------------------------

function color_named --argument-names key
    eval echo -n \$$key
end

function color_hash --argument-names key
    eval echo -n '\#'\$$key
end

function color_zerox --argument-names key
    eval echo -n '0x'\$$key
end

function color_256 --argument-names key
    python3 $lib_dir/theme.py color_256 $key
end

function font --argument-names key
    eval echo -n \$$key
end

function cursor --argument-names key
    eval echo -n \$$key
end

# Import the system theme variables.
#-------------------------------------------------------------------------------

if test -r $cache_file
    source $cache_file
else
    echo "[theme.fish] ERROR: Theme cache file is not readable. Run \`python3 \$XDG_OPT_HOME/theme/theme.py parse\` to generate it."
end
