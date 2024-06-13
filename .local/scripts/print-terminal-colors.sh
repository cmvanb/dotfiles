#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Print terminal colors and indices.
#-------------------------------------------------------------------------------

set -euo pipefail

declare terminal_supports_256_colors

case "$TERM" in
    alacritty)
        ;&
    foot)
        ;&
    xterm-kitty)
        ;&
    xterm-256color)
        terminal_supports_256_colors=true
        ;;
    *)
        terminal_supports_256_colors=false
        ;;
esac

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
    local width="$1"
    local color="$2"

    local style=""
    if [[ $terminal_supports_256_colors = false ]] && (( color > 7 )); then
        style="1;"
    fi

    local string
    string=$(for _ in $(seq 1 "$width"); do printf "█"; done)

    print_string_in_color "$string" "$color"
}

# Print a band of $2 color blocks starting from index $1.
#-------------------------------------------------------------------------------

function print_band() {
    local start="$1"
    local count="$2"
    local width="${3:-4}"
    local height="${4:-1}"

    if (( width < 3 )); then
        echo "[$(basename "$0")] ERROR: Block width must be 3 or greater."
    fi

    if (( height < 1 )); then
        echo "[$(basename "$0")] ERROR: Block height must be 1 or greater."
    fi

    local color
    for (( color = "$1"; color < "$start" + "$count"; color++ )) do
        local buffer
        if (( color > 99 )); then
            buffer=$(( width - 3 ))
        elif (( color > 9 )); then
            buffer=$(( width - 2 ))
        else
            buffer=$(( width - 1 ))
        fi

        print_color_block "$buffer" "$color"

        # Text color is shifted along the band range with an offset for constrast.
        local offset
        if (( color < 16 )); then # ANSI 16
            offset=3
        elif (( color >= 16 && color < 80 )); then # Theme palettes
            offset=8
        elif (( color >= 80 )); then # Color palettes
            offset=5
        fi
        local text_color=$(( (((color - start) + (offset)) % count) + start ))
        print_string_in_color_fg_bg "$color" "$text_color" "$color"
    done
    printf "  \n"

    for (( i = 0; i < "$height" - 1; i++ )) do
        for (( color = "$1"; color < "$start" + "$count"; color++ )) do
            print_color_block "$width" "$color"
        done
        printf "  \n"
    done
}

# Output
#-------------------------------------------------------------------------------

declare width=6
declare height=2

# Print basic 16 colors.
print_band 0 8 "$width" "$height"
print_band 8 8 "$width" "$height"

if [[ $terminal_supports_256_colors = false ]]; then
    exit 0
fi

printf "\n"

# Print themed 256-index colors.
print_band 16 16 "$width" "$height"
print_band 32 16 "$width" "$height"
print_band 48 16 "$width" "$height"
print_band 64 16 "$width" "$height"

printf "\n"

print_band 80 10 "$width" "$height"
print_band 90 10 "$width" "$height"
print_band 100 10 "$width" "$height"
print_band 110 10 "$width" "$height"
print_band 120 10 "$width" "$height"
print_band 130 10 "$width" "$height"
print_band 140 10 "$width" "$height"
print_band 150 10 "$width" "$height"
