#-------------------------------------------------------------------------------
# Bash per-deployment aliases
#-------------------------------------------------------------------------------

% if DEPLOY_DISTRO == 'arch':

alias p="pacman"
alias pa="pacman"
alias pac="pacman"
alias uu="sudo pacman -Syu"
% endif

% if DEPLOY_DISTRO == 'ubuntu':

alias uu="sudo apt update && sudo apt upgrade -y"
% endif

% if 'workstation' in DEPLOY_PROFILE.split():

alias rb="reboot"
alias sus="suspend"
alias sdn="shutdown"
% endif
