#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Print terminal colors and indices.
#-------------------------------------------------------------------------------

set -euo pipefail

terminal_supports_256_colors=false

if [[ $TERM = "xterm-256color" ]]; then
    terminal_supports_256_colors=true
fi

# Print a string with foreground color.
#-------------------------------------------------------------------------------

function print_string_in_color() {
    local string="$1"
    local color="$2"

    local style=""
    if [[ $terminal_supports_256_colors = false ]] && (( color > 7 )); then
        style="1;"
    fi
    printf "\e[%s38;5;%sm%s\e[0m" "$style" "$color" "$string"
}

# Print a string with foreground and background color.
#-------------------------------------------------------------------------------

function print_string_in_color_fg_bg() {
    local string="$1"
    local fg="$2"
    local bg="$3"

    local fg_style=""
    if [[ $terminal_supports_256_colors = false ]] && (( fg > 7 )); then
        fg_style="1;"
    fi
    printf "\e[%s38;5;%sm\e[48;5;%sm%s\e[0m" "$fg_style" "$fg" "$bg" "$string"
}

# Print a color block to the terminal.
#-------------------------------------------------------------------------------

function print_color_block() {
    local count="$1"
    local color="$2"

    local style=""
    if [[ $terminal_supports_256_colors = false ]] && (( color > 7 )); then
        style="1;"
    fi

    local string=$(for _ in $(seq 1 $count); do printf "█"; done)

    print_string_in_color "$string" "$color"
}

# Print a band of $2 color blocks starting from index $1.
#-------------------------------------------------------------------------------

function print_band {
    local start="$1"
    local count="$2"

    local color
    for (( color = "$1"; color < "$start" + "$count"; color++ )) do
        local buffer
        if (( color > 99 )); then
            buffer=5
        elif (( color > 9 )); then
            buffer=6
        else
            buffer=7
        fi
        print_color_block "$buffer" "$color"

        # Text color is selected from the provided band range with an offset to
        # ensure contrast.
        local text_color=$(( (((color - start) + (5)) % count) + start ))
        print_string_in_color_fg_bg "$color" "$text_color" "$color"
    done
    printf "  \n"

    for (( color = "$1"; color < "$1" + "$2"; color++ )) do
        print_color_block 8 "$color"
    done
    printf "  \n"
}

# Output
#-------------------------------------------------------------------------------

# Print basic 16 colors.
print_band 0 8
print_band 8 8

if [[ $terminal_supports_256_colors = false ]]; then
    exit 0
fi

printf "\n"

# Print themed 256-index colors.
print_band 16 16
print_band 32 16
print_band 48 16
print_band 64 16

printf "\n"

print_band 80 10
print_band 90 10
print_band 100 10
print_band 110 10
print_band 120 10
print_band 130 10
print_band 140 10
print_band 150 10
