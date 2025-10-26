surface-dots
There are the files to setup Wireguard (Network Manager managed) in Waybar


**Start by adding these lines to .config/waybar/style.css**

#custom-vpn {
    background-color: @background;
    font-size: 16px;
    color: @on_surface;
    border-radius: 8px;
    padding: 3px 10px 3px 10px;
    margin: 3px 10px 3px 0px;
    border: 2px solid @border_color;
    transition: all 0.3s ease-out;
}

**Update your .config/waybar/config as below**

    "modules-right": [
        ...
        "custom/vpn",

**Now add these lines to .config/waybar/modules.json**

  "custom/vpn": {
    "exec": "exec ~/.config/waybar/wireguard-manager/wireguard-manager.sh -s",
    "format": "{icon}",   
    "format-icons": {
        "connected": "<span color=\"#50fa7b\">VPN: 🔒</span>",
        "disconnected": "<span color=\"#ff5555\">VPN: 🔓</span>",
    },
    "interval": "once",
    "on-click": "~/.config/waybar/wireguard-manager/wireguard-manager.sh -t && pk>
    "return-type": "json",
    "signal": 1,
    "tooltip-format": "Click to toggle VPN"
  },

**  and finally, add this script to your path**

#!/usr/bin/env bash

SERVICE_NAME="GCC-VPS-WG"
STATUS_CONNECTED_STR='{"text":"Connected","class":"connected","alt":"connected"}'
STATUS_DISCONNECTED_STR='{"text":"Disconnected","class":"disconnected","alt":"disconnected"}'

function askpass() {
  rofi -dmenu -password -no-fixed-num-lines -p "Sudo password : " -theme ~/.config/waybar/wireguard-manager/rofi.rasi 
}

function status_wireguard() {
  ip link show $SERVICE_NAME >/dev/null 2>&1
  return $?
}

function toggle_wireguard() {
  status_wireguard && \
     SUDO_ASKPASS=~/.config/waybar/wireguard-manager/wireguard-manager.sh sudo -A nmcli conn down $SERVICE_NAME || \
     SUDO_ASKPASS=~/.config/waybar/wireguard-manager/wireguard-manager.sh sudo -A nmcli conn up $SERVICE_NAME
}

case $1 in
  -s | --status)
    STATUS=`nmcli conn show|grep $SERVICE_NAME | awk {'print $4'}`
    if [[ $STATUS == $SERVICE_NAME ]]; then
        echo $STATUS_CONNECTED_STR
    else
        echo $STATUS_DISCONNECTED_STR
    fi
    ;;
  -t | --toggle)
    toggle_wireguard
    ;;
  *)
    askpass
    ;;
esac
