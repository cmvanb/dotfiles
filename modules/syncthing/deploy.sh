#-------------------------------------------------------------------------------
# Deploy syncthing configuration
#-------------------------------------------------------------------------------


syncthing::enable () {
    echo "└> Enabling syncthing user service."

    systemctl --user enable syncthing
}

syncthing::disable () {
    echo "└> Disabling syncthing user service."

    systemctl --user disable syncthing
}
