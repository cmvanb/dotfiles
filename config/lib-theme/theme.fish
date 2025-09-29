#-------------------------------------------------------------------------------
# System theme Fish API
#-------------------------------------------------------------------------------

set -l config_dir $XDG_CONFIG_HOME/theme
set -l lib_dir $XDG_OPT_HOME/theme

# Parsing and lookup functions
#-------------------------------------------------------------------------------

function dict_get --argument-names key
    eval echo -n \$'__theme_var_'$key
end

function dict_set --argument-names key value
    set -g '__theme_var_'$key $value
end

function raise_error --argument-names message
    echo "[theme.fish] ERROR: $message"
end

function parse_error --argument-names line column message
    raise_error "Unable to continue parsing at line {$line}, {$column}: {$message}"
end

function parse_vars --argument-names filePath
    while read -l line
        # Skip empty lines, comments, and shebang
        if test -z "$line" || string match -q '#*' "$line" || string match -q '!*' "$line"
            continue
        end

        # Check for variable assignment pattern with optional leading spaces and quotes
        # Supports: key=value, key='value', key=$reference, " key=value"
        if string match -qr '^\s*([0-9a-zA-Z_]+)=(.+)$' "$line"
            set -l key (string replace -r '^\s*([0-9a-zA-Z_]+)=(.+)$' '$1' "$line")
            set -l value (string replace -r '^\s*([0-9a-zA-Z_]+)=(.+)$' '$2' "$line")

            # Remove surrounding quotes if present
            set value (string replace -r "^'(.+)'\$" '$1' "$value")

            # Remove leading # from color values
            set value (string replace -r "^#(.+)" '$1' "$value")

            # Handle variable references (starts with $)
            if string match -q '$*' "$value"
                set -l ref_var (string sub -s 2 "$value")
                dict_set $key (dict_get $ref_var)
            else
                dict_set $key $value
            end
        end
    end < $filePath

    return 0
end

# API
#-------------------------------------------------------------------------------

function color_named --argument-names key
    eval echo -n (dict_get $key)
end

function color_hash --argument-names key
    eval echo -n '\#'(dict_get $key)
end

function color_zerox --argument-names key
    eval echo -n '0x'(dict_get $key)
end

function color_256 --argument-names key
    $lib_dir/color-lookup-256-index.sh $key
end

function font --argument-names key
    eval echo -n (dict_get $key)
end

# Parse the system theme variables.
#-------------------------------------------------------------------------------

if test -r $config_dir/colors
    parse_vars $config_dir/colors
else
    raise_error "Theme color file is not readable."
end

if test -r $config_dir/fonts
    parse_vars $config_dir/fonts
end

if test -r $config_dir/cursor
    parse_vars $config_dir/cursor
end
