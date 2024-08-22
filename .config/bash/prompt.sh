#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Bash prompt configuration
#
# NOTE: The ${var:?} syntax fails if var is unassigned. Use this to appease shellcheck SC2154.
#-------------------------------------------------------------------------------

# shellcheck disable=SC1091
source "$XDG_OPT_HOME/shell-utils/string.sh"

# Parse system theme and provide API.
# shellcheck disable=SC1091
source "$XDG_OPT_HOME/theme/theme.sh"

construct_prompt() {
    # Login
    #---------------------------------------------------------------------------
    local user
    user=$(whoami)
    if [[ "$user" == "root" ]]; then
        user="\[$(color_ansi_fg "${ansi_brred:?}")\]\u\[$(color_ansi_reset)\]"
    else
        user="\[$(color_ansi_fg "${ansi_brgreen:?}")\]\u\[$(color_ansi_reset)\]"
    fi

    local separator="·" && [[ "$TERM" != "linux" ]] && separator="⋅"

    local hostname="\h"

    local login="$user$separator$hostname "

    # CWD
    #---------------------------------------------------------------------------
    local cwd
    cwd="\[$(color_ansi_fg "${ansi_blue:?}")\]\w\[$(color_ansi_reset)\] "

    # Git status
    #---------------------------------------------------------------------------
    local vcs=""

    local git_symbol="" && [[ "$TERM" != "linux" ]] && git_symbol=" "

    local git_color
    git_color="\[$(color_ansi_fg "${ansi_green:?}")\]"

    local git_status
    git_status=$(git status 2>/dev/null | grep "Your branch is ahead" 2>/dev/null)
    if [[ -n "$git_status" ]]; then
        git_color="\[$(color_ansi_fg "${ansi_yellow:?}")\]"
    fi

    git_status=$(git status --porcelain 2>/dev/null)
    if [[ -n "$git_status" ]]; then
        git_color="\[$(color_ansi_fg "${ansi_yellow:?}")\]"
    fi

    local git_branch
    git_branch=$(git branch --show-current 2>/dev/null)
    if [[ -n "$git_branch" ]]; then
        vcs="$git_color$git_symbol$git_branch\[$(color_ansi_reset)\] "
    fi

    # Python virtual environment
    #---------------------------------------------------------------------------
    local venv=""

    local venv_symbol="" && [[ "$TERM" != "linux" ]] && venv_symbol="󰌠 "

    local venv_name=""
    if [[ -n "$VIRTUAL_ENV" ]]; then
        IFS='/' read -r -a split_virtual_env <<< "$VIRTUAL_ENV"
        if string_contains "${split_virtual_env[-1]}" virtualenv venv .venv env; then
            venv_name="${split_virtual_env[-2]}"
        else
            venv_name="${split_virtual_env[-1]}"
        fi
    fi

    if [[ -n "$venv_name" ]]; then
        venv="\[$(color_ansi_fg "${ansi_magenta:?}")\]$venv_symbol$venv_name\[$(color_ansi_reset)\] "
    fi

    # Prompt
    #---------------------------------------------------------------------------
    PS1="$login$cwd$vcs$venv\[$(color_ansi_fg "${ansi_brwhite:?}")\]\$\[$(color_ansi_reset)\] "
}

PROMPT_COMMAND='construct_prompt'
