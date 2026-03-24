#-------------------------------------------------------------------------------
# Fish per-deployment aliases
#-------------------------------------------------------------------------------

function fish_deployed_aliases
% if DEPLOY_DISTRO == 'arch':

    abbr -a p pacman
    abbr -a pa pacman
    abbr -a pac pacman
    abbr -a uu sudo pacman -Syu
% endif

% if DEPLOY_DISTRO == 'ubuntu':

    abbr -a uu "sudo apt update && sudo apt upgrade -y"
% endif

% if 'workstation' in DEPLOY_PROFILE.split():

    abbr -a rb reboot
    abbr -a sus suspend
    abbr -a sdn shutdown
% endif

end
