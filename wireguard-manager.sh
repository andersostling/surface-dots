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
