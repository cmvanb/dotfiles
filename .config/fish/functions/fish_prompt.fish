#-------------------------------------------------------------------------------
# Fish prompt configuration
#-------------------------------------------------------------------------------

# TODO: Use theme colors.

function fish_prompt --description 'Write out the prompt'
    # Preserve pipestatus
    set -l last_pipestatus $pipestatus

    # Export for __fish_print_pipestatus.
    set -lx __fish_last_status $status

    # Colors
    set -l normal (set_color normal)

    # Login
    set -l user (whoami)
    if [ "$user" = "root" ]
        set user (set_color brred)$user$normal
    else
        set user (set_color brgreen)$user$normal
    end

    set -l separator "@"
    if [ "$TERM" != "linux" ]
        set separator "⋅"
    end

    set -l login "$user$separator$hostname "

    # CWD
    set -l realhome (string escape --style=regex -- ~)
    set -l cwd (string replace -r '^'"$realhome"'($|/)' '~$1' $PWD)
    set cwd (set_color blue)"$cwd$normal "

    # Git status
    set -l vcs ""

    set -l git_symbol ""
    if [ "$TERM" != "linux" ]
        set git_symbol " "
    end

    set -l git_color (set_color green)

    set -l git_status $(git status 2>/dev/null | grep "Your branch is ahead" 2>/dev/null)
    if [ "$git_status" != "" ]
        set git_color (set_color yellow)
    end

    set -l git_status $(git status --porcelain 2>/dev/null)
    if [ "$git_status" != "" ]
        set git_color (set_color yellow)
    end

    set -l git_branch $(git branch --show-current 2>/dev/null)
    if [ "$git_branch" != "" ]
        set vcs "$git_color$git_symbol$git_branch$normal "
    end

    # Last command status
    set -l brace_sep_color (set_color red)
    set -l status_color (set_color brred)
    set -l last_command_status (__fish_print_pipestatus "[" "] " "|" $brace_sep_color $status_color $last_pipestatus)

    # Prompt
    set -l prompt ">"
    if [ "$TERM" != "linux" ]
        set prompt "❱"
    end
    set prompt (set_color white)"$prompt$normal "

    echo -n -s "$login$cwd$vcs$last_command_status$prompt"
end
