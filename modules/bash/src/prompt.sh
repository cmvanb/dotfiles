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

# Append one prompt component to $PS1.
# Reads $cols and mutates $PS1 and $line_w from the calling scope (dynamic scoping).
# Args: $1=content, $2=display width. Skips when width is zero.
_prompt_emit() {
    local w="$2"
    (( w > 0 )) || return
    if (( line_w + w > cols )) && (( line_w > 0 )); then
        PS1+=$'\n'
        line_w=0
    fi
    PS1+="$1"
    (( line_w += w ))
}

# Sets $login and $login_w in the calling scope.
_prompt_login() {
    local user_text
    user_text=$(whoami)
    local user_colored
    if [[ "$user_text" == "root" ]]; then
        user_colored="\[$(color_ansi_fg "${ansi_brred:?}")\]${user_text}\[$(color_ansi_reset)\]"
    else
        user_colored="\[$(color_ansi_fg "${ansi_brgreen:?}")\]${user_text}\[$(color_ansi_reset)\]"
    fi
    local sep="·" && [[ "$TERM" != "linux" ]] && sep="⋅"
    local host_text="${HOSTNAME%%.*}"
    login="${user_colored}${sep}${host_text} "
    login_w=$(( ${#user_text} + 1 + ${#host_text} + 1 ))
}

# Sets $cwd and $cwd_w in the calling scope.
_prompt_cwd() {
    local cwd_text
    if [[ "$PWD" == "$HOME" ]]; then
        cwd_text="~"
    elif [[ "$PWD" == "$HOME/"* ]]; then
        cwd_text="~${PWD#"$HOME"}"
    else
        cwd_text="$PWD"
    fi
    cwd="\[$(color_ansi_fg "${ansi_blue:?}")\]${cwd_text}\[$(color_ansi_reset)\] "
    cwd_w=$(( ${#cwd_text} + 1 ))
}

# Sets $vcs and $vcs_w in the calling scope.
_prompt_vcs() {
    local git_sym="" git_sym_w=0
    [[ "$TERM" != "linux" ]] && git_sym=" " && git_sym_w=3
    local git_color="\[$(color_ansi_fg "${ansi_green:?}")\]"
    local git_status
    git_status=$(git status 2>/dev/null | grep "Your branch is ahead" 2>/dev/null)
    [[ -n "$git_status" ]] && git_color="\[$(color_ansi_fg "${ansi_yellow:?}")\]"
    git_status=$(git status --porcelain 2>/dev/null)
    [[ -n "$git_status" ]] && git_color="\[$(color_ansi_fg "${ansi_yellow:?}")\]"
    local git_branch
    git_branch=$(git branch --show-current 2>/dev/null)
    if [[ -n "$git_branch" ]]; then
        vcs="${git_color}${git_sym}${git_branch}\[$(color_ansi_reset)\] "
        vcs_w=$(( git_sym_w + ${#git_branch} + 1 ))
    fi
}

# Sets $venv and $venv_w in the calling scope.
_prompt_venv() {
    local venv_sym="" venv_sym_w=0
    [[ "$TERM" != "linux" ]] && venv_sym="󰌠 " && venv_sym_w=3
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
        venv="\[$(color_ansi_fg "${ansi_magenta:?}")\]${venv_sym}${venv_name}\[$(color_ansi_reset)\] "
        venv_w=$(( venv_sym_w + ${#venv_name} + 1 ))
    fi
}

# Sets $prompt_str and $prompt_w in the calling scope.
_prompt_char() {
    local char='$' && [[ "$(id -u)" -eq 0 ]] && char='#'
    prompt_str="\[$(color_ansi_fg "${ansi_brwhite:?}")\]${char}\[$(color_ansi_reset)\] "
    prompt_w=$(( 1 + 1 + 16 ))
}

construct_prompt() {
    local cols="${COLUMNS:-80}"

    local login="" login_w=0
    local cwd="" cwd_w=0
    local vcs="" vcs_w=0
    local venv="" venv_w=0
    local prompt_str="" prompt_w=0

    _prompt_login
    _prompt_cwd
    _prompt_vcs
    _prompt_venv
    _prompt_char

    PS1=""
    local line_w=0
    _prompt_emit "$login" $login_w
    _prompt_emit "$cwd" $cwd_w
    _prompt_emit "$vcs" $vcs_w
    _prompt_emit "$venv" $venv_w
    _prompt_emit "$prompt_str" $prompt_w
}

PROMPT_COMMAND='construct_prompt'
