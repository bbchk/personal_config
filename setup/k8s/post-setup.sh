#!/bin/bash

# /usr/bin/apt-get update
# /usr/bin/apt-get install -y my-custom-package

# exit 0

su

apt update
apt install sudo vim

update-alternatives --config editor

systemctl mask  "dev-*.swap"

# TODO: make laptops do not turn off when lid's closed or is idle, act as server
# HandlePowerKey=poweroff        # Can be poweroff, reboot, halt, ignore
# HandleLidSwitch=suspend        # Can be suspend, ignore, lock, etc.
# HandleLidSwitchDocked=ignore   # Controls lid action when docked
# IdleAction=ignore              # Can be suspend, poweroff, etc.
# IdleActionSec=30min            # Time before IdleAction triggers

systemctl restart systemd-logind

# /etc/network/interfaces
# auto enp3s0
# iface enp3s0 inet static
#     address 192.168.1.10
#     netmask 255.255.255.0
#     gateway 192.168.1.1
#     metric 100
#

# d-i preseed/late_command string \
#     cp /cdrom/scripts/network-config/interfaces /target/etc/network/interfaces; \
#     cp /cdrom/scripts/network-config/resolv.conf /target/etc/resolv.conf

TODO change password,
TODO change hostname

we need tailscale

/etc/systemd/system/firstrun.service


### Preseeding other packages
d-i preseed/late_command string \
    in-target apt-get update; \
    in-target apt-get install -y sudo; \
    in-target usermod -aG sudo bchk; \
    in-target sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config
/cdrom/setup

    in-target /cdrom/setup.sh

