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
    xterm-256color)
        ;&
    xterm-ghostty)
        ;&
    xterm-kitty)
        terminal_supports_256_colors=true
        ;;
    *)
        terminal_supports_256_colors=false
        ;;
esac

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

    # Pre-build the full-width block string (used by extra height rows).
    local full_block=""
    local i
    for (( i = 0; i < width; i++ )); do
        full_block+="█"
    done

    local style=""
    local row=""
    local color
    for (( color = start; color < start + count; color++ )) do
        local buffer
        if (( color > 99 )); then
            buffer=$(( width - 3 ))
        elif (( color > 9 )); then
            buffer=$(( width - 2 ))
        else
            buffer=$(( width - 1 ))
        fi

        # Build block string inline (avoids subshell).
        local block=""
        for (( i = 0; i < buffer; i++ )); do
            block+="█"
        done

        if [[ $terminal_supports_256_colors = false ]] && (( color > 7 )); then
            style="1;"
        else
            style=""
        fi
        row+="\e[${style}38;5;${color}m${block}\e[0m"

        # Text color is shifted along the band range with an offset for contrast.
        local offset
        if (( color < 16 )); then # ANSI 16
            offset=3
        elif (( color < 80 )); then # Theme palettes
            offset=8
        else # Color palettes
            offset=5
        fi
        local text_color=$(( (((color - start) + offset) % count) + start ))

        local fg_style=""
        if [[ $terminal_supports_256_colors = false ]] && (( text_color > 7 )); then
            fg_style="1;"
        fi
        row+="\e[${fg_style}38;5;${text_color}m\e[48;5;${color}m${color}\e[0m"
    done
    printf "%b  \n" "$row"

    for (( i = 0; i < height - 1; i++ )) do
        row=""
        for (( color = start; color < start + count; color++ )) do
            if [[ $terminal_supports_256_colors = false ]] && (( color > 7 )); then
                style="1;"
            else
                style=""
            fi
            row+="\e[${style}38;5;${color}m${full_block}\e[0m"
        done
        printf "%b  \n" "$row"
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
