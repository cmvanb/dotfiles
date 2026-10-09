#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Show a notification when a Bluetooth device connects or disconnects.
#-------------------------------------------------------------------------------

set -euo pipefail

match="type='signal',path_namespace='/org/bluez',interface='org.freedesktop.DBus.Properties',member='PropertiesChanged'"

path=""
iface=""
key=""

device_name() {
    bluetoothctl info "$1" 2>/dev/null | sed -n 's/^\s*Alias: //p'
}

while IFS= read -r line; do
    case "$line" in
        signal*)
            path=${line#*path=}
            path=${path%%;*}
            iface=""
            key=""
            ;;
        *'string "org.bluez.Device1"'*)
            iface="device"
            ;;
        *'string "Connected"'*)
            [ "$iface" = "device" ] && key="Connected"
            ;;
        *'variant'*'boolean'*)
            [ "$key" = "Connected" ] || continue
            mac=${path##*/dev_}
            mac=${mac//_/:}
            name=$(device_name "$mac")
            name=${name:-$mac}
            if [[ "$line" == *true ]]; then
                notify-send -a Bluetooth -i bluetooth-active "Bluetooth connected" "$name"
            else
                notify-send -a Bluetooth -i bluetooth-disabled "Bluetooth disconnected" "$name"
            fi
            key=""
            ;;
    esac
done < <(dbus-monitor --system "$match" 2>/dev/null)
