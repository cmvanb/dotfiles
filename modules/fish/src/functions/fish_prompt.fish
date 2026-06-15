#-------------------------------------------------------------------------------
# Fish prompt configuration
#-------------------------------------------------------------------------------

# Emit one prompt component. If it would overflow $cols, insert a newline first.
# --no-scope-shadowing reads $cols and mutates $line_w in the caller's scope.
# Skips silently when the display width (argv[2]) is zero.
function _prompt_emit --no-scope-shadowing
    test $argv[2] -gt 0; or return
    if test (math $line_w + $argv[2]) -gt $cols; and test $line_w -gt 0
        printf '\n'
        set line_w 0
    end
    printf '%s' $argv[1]
    set line_w (math $line_w + $argv[2])
end

# Sets $login and $login_w in the caller's scope.
# Requires $login, $login_w pre-declared and $normal, $hostname in scope.
function _prompt_login --no-scope-shadowing
    set -l user_text (whoami)
    set -l user_colored
    if test "$user_text" = "root"
        set user_colored (set_color brred)$user_text$normal
    else
        set user_colored (set_color brgreen)$user_text$normal
    end
    set -l sep "·"
    if test "$TERM" != "linux"
        set sep "⋅"
    end
    set -l host_color $normal
    if test -n "$SSH_TTY"
        set host_color (set_color bryellow)
    end
    set login "$user_colored$sep$host_color$hostname$normal "
    set login_w (math (string length $user_text) + 1 + (string length $hostname) + 1)
end

# Sets $cwd and $cwd_w in the caller's scope.
# Requires $cwd, $cwd_w pre-declared and $normal in scope.
function _prompt_cwd --no-scope-shadowing
    set -l realhome (string escape --style=regex -- ~)
    set -l cwd_text (string replace -r '^'"$realhome"'($|/)' '~$1' $PWD)
    set cwd (set_color blue)$cwd_text$normal" "
    set cwd_w (math (string length $cwd_text) + 1)
end

# Sets $vcs and $vcs_w in the caller's scope.
# Requires $vcs, $vcs_w pre-declared and $normal in scope.
function _prompt_vcs --no-scope-shadowing
    set -l git_sym ""
    set -l git_sym_w 0
    if test "$TERM" != "linux"
        set git_sym " "
        set git_sym_w 3  # icon renders as 2 cols + 1 space
    end
    set -l git_color (set_color green)
    set -l git_ahead (git status 2>/dev/null | grep "Your branch is ahead" 2>/dev/null)
    if test -n "$git_ahead"
        set git_color (set_color yellow)
    end
    set -l git_dirty (git status --porcelain 2>/dev/null)
    if test -n "$git_dirty"
        set git_color (set_color yellow)
    end
    set -l git_branch (git branch --show-current 2>/dev/null)
    if test -n "$git_branch"
        set vcs "$git_color$git_sym$git_branch$normal "
        set vcs_w (math $git_sym_w + (string length $git_branch) + 1)
    end
end

# Sets $venv and $venv_w in the caller's scope.
# Requires $venv, $venv_w pre-declared and $normal in scope.
function _prompt_venv --no-scope-shadowing
    set -l venv_sym ""
    set -l venv_sym_w 0
    if test "$TERM" != "linux"
        set venv_sym "󰌠 "
        set venv_sym_w 3  # icon renders as 2 cols + 1 space
    end
    set -l venv_name ""
    if test -n "$VIRTUAL_ENV"
        set -l venv_parts (string split / "$VIRTUAL_ENV")
        if contains -- $venv_parts[-1] virtualenv venv .venv env
            set venv_name $venv_parts[-2]
        else
            set venv_name $venv_parts[-1]
        end
    end
    if test -n "$venv_name"
        set venv (set_color magenta)$venv_sym$venv_name$normal" "
        set venv_w (math $venv_sym_w + (string length $venv_name) + 1)
    end
end

# Sets $last_status_colored and $last_status_w in the caller's scope.
# Requires $last_status_colored, $last_status_w pre-declared and $last_pipestatus in scope.
function _prompt_last_status --no-scope-shadowing
    set last_status_colored (__fish_print_pipestatus "[" "] " "|" (set_color red) (set_color brred) $last_pipestatus)
    set -l last_status_plain (__fish_print_pipestatus "[" "] " "|" "" "" $last_pipestatus)
    set last_status_w (string length "$last_status_plain")
end

# Sets $prompt_str and $prompt_w in the caller's scope.
# Requires $prompt_str, $prompt_w pre-declared and $normal in scope.
function _prompt_char --no-scope-shadowing
    set -l prompt_char ">"
    if test "$TERM" != "linux"
        set prompt_char "❱"
    end
    set prompt_str (set_color white)$prompt_char$normal" "
    set prompt_w 18  # 1 (char) + 1 (space) + 16 (typing room)
end

function fish_prompt --description 'Print the prompt'
    set -g VIRTUAL_ENV_DISABLE_PROMPT true
    set -l last_pipestatus $pipestatus
    set -lx __fish_last_status $status
    set -l normal (set_color white)
    set -l cols $COLUMNS
    test -n "$cols"; or set cols 80

    # Pre-declare output variables so builders can update them via plain set.
    set -l login "" ; set -l login_w 0
    set -l cwd "" ; set -l cwd_w 0
    set -l vcs "" ; set -l vcs_w 0
    set -l venv "" ; set -l venv_w 0
    set -l last_status_colored "" ; set -l last_status_w 0
    set -l prompt_str "" ; set -l prompt_w 0

    _prompt_login
    _prompt_cwd
    _prompt_vcs
    _prompt_venv
    _prompt_last_status
    _prompt_char

    set -l line_w 0
    _prompt_emit "$login" $login_w
    _prompt_emit "$cwd" $cwd_w
    _prompt_emit "$vcs" $vcs_w
    _prompt_emit "$venv" $venv_w
    _prompt_emit "$last_status_colored" $last_status_w
    _prompt_emit "$prompt_str" $prompt_w
end
