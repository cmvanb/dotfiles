#-------------------------------------------------------------------------------
# Fish configuration
#-------------------------------------------------------------------------------

set -g fish_greeting ""

source $HOME/.config/shell/fish/env.fish

if status is-login
    source $HOME/.config/shell/fish/login.fish

    function on_exit --on-event fish_exit
        source $HOME/.config/shell/fish/logout.fish
    end
end

if status is-interactive
    source $HOME/.config/shell/fish/interactive.fish
end

