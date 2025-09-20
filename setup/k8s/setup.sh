#!/usr/bin/env bash

su

apt update
apt install sudo vim

update-alternatives --config editor

# visudo thing

systemctl mask  "dev-*.swap"



# HandlePowerKey=poweroff        # Can be poweroff, reboot, halt, ignore
# HandleLidSwitch=suspend        # Can be suspend, ignore, lock, etc.
# HandleLidSwitchDocked=ignore   # Controls lid action when docked
# IdleAction=ignore              # Can be suspend, poweroff, etc.
# IdleActionSec=30min            # Time before IdleAction triggers

systemctl restart systemd-logind

wifi_device=$(basename $(echo /sys/class/net/wlp*))
ip link set "${wifi_device}" down


# /etc/network/interfaces
# auto enp3s0
# iface enp3s0 inet static
#     address 192.168.1.10
#     netmask 255.255.255.0
#     gateway 192.168.1.1
#     metric 100
