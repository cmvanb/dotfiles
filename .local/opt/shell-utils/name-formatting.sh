#!/usr/bin/env bash
# ------------------------------------------------------------------------------
# Name formatting functions
# ------------------------------------------------------------------------------

# API
# ------------------------------------------------------------------------------

# camelCaseListOfWords
convert_to_camel_case() {
    echo $@ | nf_normalize | nf_capitalize_words | nf_remove_spaces | nf_lowercase_first
}

# kebab-case-list-of-words
convert_to_kebab_case() {
    echo $@ | nf_normalize | nf_dash_spaces
}

# snake_case_list_of_words
convert_to_snake_case() {
    echo $@ | nf_normalize | nf_under_spaces
}

# PascalCaseListOfWords
convert_to_pascal_case() {
    echo $@ | nf_normalize | nf_capitalize_words | nf_remove_spaces
}

# Internal
# ------------------------------------------------------------------------------
nf_normalize() {
    while read in; do
        echo $in | nf_lowercase | nf_alphanumeric_sanitize | nf_dedup_spaces
    done
}

nf_lowercase() {
    while read in; do
        echo $in | sed 's/\(.*\)/\L\1/'
    done
}

nf_lowercase_first() {
    while read in; do
        echo ${in,}
    done
}

nf_capitalize_words() {
    while IFS=' ' read -a in; do
        output=''

        for word in "${in[@]}"; do
            output="$output ${word^}"
        done

        echo $output
    done
}

nf_alphanumeric_sanitize() {
    while read in; do
        echo $in | sed 's/[^A-Za-z0-9]/ /g'
    done
}

nf_dash_spaces() {
    while read in; do
        echo $in | sed 's/[ ]/-/g'
    done
}

nf_under_spaces() {
    while read in; do
        echo $in | sed 's/[ ]/_/g'
    done
}

nf_remove_spaces() {
    while read in; do
        echo $in | sed 's/[ ]//g'
    done
}

nf_dedup_spaces() {
    while read in; do
        echo $in | tr -s ' '
    done
}

nf_not_implemented() {
    error 1 "Not implemented."
}

nf_error() {
    echo "Error: $2"
    exit $1
}

