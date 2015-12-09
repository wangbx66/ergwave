#!/bin/bash
# ifconfig in net-tools
# iwconfig in wireless_tools

export wlan=wlp0s29u1u7
export eth=eno1

if [ $1 = 'c' ]; then
    sudo rfkill unblock wifi
    echo Done rf-kill unblock
    source ~/tools/ergwave/rcergwave
    gsettings set org.gnome.system.proxy mode 'none'
    echo Done proxy setting
    sudo systemctl stop NetworkManager
    sudo systemctl daemon-reload
    echo Done stopping NetworkManager
    sudo pkill dhcpcd
    sudo ifconfig $eth down
    sudo ifconfig $wlan up
    sudo iwconfig $wlan essid ERGWAVE
    echo Done $wlan config
    sudo dhcpcd -4q $wlan
    echo Done dhcp $wlan
    python ~/tools/ergwave/ergwave.py
fi

if [ $1 = 'dc' ]; then
    sudo pkill dhcpcd
    echo Done closing dhcp
    sudo ifconfig $wlan down
    sudo ifconfig $eth up
    sudo systemctl start NetworkManager
    echo Done wifi config
    source ~/.bashrc
    gsettings set org.gnome.system.proxy mode 'manual'
    echo Done proxy setting
    echo wifi disconnection succeed
fi