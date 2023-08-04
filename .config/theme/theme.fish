#-------------------------------------------------------------------------------
# System theme Fish API
#-------------------------------------------------------------------------------

function dict_get --argument-names key
    eval echo -n \$'__var_'$key
end

function dict_set --argument-names key value
    set -g '__var_'$key $value
end

# Parsing
#-------------------------------------------------------------------------------

function parse_vars --argument-names filePath
    test -z $filePath && set filePath $XDG_CONFIG_HOME"/theme/colors"

    while read line
        set -l key ''
        set -l value ''
        set -l assignment_op 'false'
        set -l lookup 'false'

        if test -z $line
            continue
        end

        for char in (string split '' $line)
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
                    echo "Unable to continue parsing, expected character [$char] only after assignment."
                    return 2
                end

            # Dollar, indicates variable lookup, only allowed after assignment
            else if test $char = '$'
                if test $assignment_op = 'true'
                    set lookup 'true'
                    continue
                else
                    echo "Unable to continue parsing, expected character [$char] only after assignment."
                    return 3
                end

            # Alphanumeric or underscore, append to either key or value
            else if string match -qr -- '[0-9a-zA-Z_]' $char
                if test $assignment_op = 'false'
                    set key "$key$char"
                else
                    set value "$value$char"
                end

            # Assignment operator reached, keep reading for value
            else if test $char = '='
                if test $assignment_op = 'false'
                    set assignment_op 'true'
                end

            else
                echo "Unable to continue parsing, unexpected character [$char]."
                return 4
            end
        end

        # Assign value
        if test -n $key && test -n $value
            if test $lookup = 'true'
                dict_set $key $(dict_get $value)
            else
                dict_set $key $value
            end
        end

    end < $filePath

    return 0
end

# Entry point
#-------------------------------------------------------------------------------

parse_vars $XDG_CONFIG_HOME"/theme/colors"
parse_vars $XDG_CONFIG_HOME"/theme/fonts"

# Lookup
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

function font --argument-names key
    eval echo -n (dict_get $key)
end

