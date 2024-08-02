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

function parse_error --argument-names line, column, message
    echo "theme.fish -> Unable to continue parsing at line {$line}, {$column}: {$message}"
end

function parse_vars --argument-names filePath
    test -z $filePath && set filePath $XDG_CONFIG_HOME"/theme/colors"

    set -l line_count 0

    while read line
        set -l key ''
        set -l value ''
        set -l assignment_op 'false'
        set -l lookup 'false'

        if test -z $line
            continue
        end

        set line_count (math $line_count + 1)
        set -l char_count 0

        for char in (string split '' $line)
            set char_count (math $char_count + 1)

            # Space after assignment, append to value.
            # Space before assignment, keep reading.
            if test $char = ' '
                if test $assignment_op = 'true'
                    set value "$value$char"
                else
                    continue
                end

            # Hash after assignment, char is ignored, but continue parsing value.
            # Hash before assignment, line is skipped.
            else if test $char = '#'
                if test $assignment_op = 'true'
                    continue
                else
                    set key ''
                    set value ''
                    break
                end

            # Quote, char is ignored, only allowed after assignment
            else if test $char = '\''
                if test $assignment_op = 'true'
                    continue
                else
                    parse_error $line_count $char_count "Expected character [$char] only after assignment."
                    return 2
                end

            # Dollar, indicates variable lookup, only allowed after assignment
            else if test $char = '$'
                if test $assignment_op = 'true'
                    set lookup 'true'
                    continue
                else
                    parse_error $line_count $char_count "Expected character [$char] only after assignment."
                    return 3
                end

            # Alphanumeric or underscore, append to either key or value
            else if string match -qr -- '[0-9a-zA-Z_]' $char
                if test $assignment_op = 'false'
                    set key "$key$char"
                else
                    set value "$value$char"
                end

            # Decimal point, append to value, only allowed after assignment
            else if test $char = '.'
                if test $assignment_op = 'true'
                    set value "$value$char"
                    continue
                else
                    parse_error $line_count $char_count "Expected character [$char] only after assignment."
                    return 2
                end

            # Assignment operator reached, keep reading for value
            else if test $char = '='
                if test $assignment_op = 'false'
                    set assignment_op 'true'
                end

            else
                parse_error $line_count $char_count "Unknown character [$char]."
                return 4
            end
        end

        # Assign value
        if test -n $key && test -n $value
            if test $lookup = 'true'
                dict_set $key (dict_get $value)
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

parse_vars $config_dir/colors
parse_vars $config_dir/fonts
