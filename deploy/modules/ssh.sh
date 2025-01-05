#-------------------------------------------------------------------------------
# Deploy ssh configuration
#-------------------------------------------------------------------------------


ssh::enable () {
    echo "└> Enabling ssh-agent user service."

    systemctl --user enable ssh-agent
}

ssh::disable () {
    echo "└> Disabling ssh-agent user service."

    systemctl --user disable ssh-agent
}
