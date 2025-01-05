#-------------------------------------------------------------------------------
# Deploy pipewire configuration
#-------------------------------------------------------------------------------


pipewire::enable () {
    echo "└> Enabling pipewire user service."

    systemctl --user enable pipewire
}

pipewire::disable () {
    echo "└> Disabling pipewire user service."

    systemctl --user disable pipewire
}
