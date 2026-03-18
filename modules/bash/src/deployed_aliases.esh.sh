#-------------------------------------------------------------------------------
# Bash per-deployment aliases
#-------------------------------------------------------------------------------

# <% if [[ $DEPLOY_DISTRO == "arch" ]]; then -%>

alias p="pacman"
alias pa="pacman"
alias pac="pacman"
alias uu="sudo pacman -Syu"
# <% fi -%>

#<% if [[ $DEPLOY_DISTRO == "ubuntu" ]]; then -%>

alias uu="sudo apt update && sudo apt upgrade -y"
# <% fi -%>

# <% if [[ " $DEPLOY_PROFILE " == *" workstation "* ]]; then -%>

alias rb="reboot"
alias sus="suspend"
alias sdn="shutdown"
# <% fi -%>
