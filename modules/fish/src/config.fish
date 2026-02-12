#-------------------------------------------------------------------------------
# Fish configuration
#-------------------------------------------------------------------------------

set -g fish_greeting ""

source $HOME/.config/fish/env.fish

if status is-login
    source $HOME/.config/fish/login.fish

    function on_exit --on-event fish_exit
        source $HOME/.config/fish/logout.fish
    end
end

if status is-interactive
    source $HOME/.config/fish/interactive.fish
end
