#!/usr/bin/env bash

su

apt update
apt install sudo vim
sudo update-alternatives --config editor

# visudo thing

sudo systemctl mask  "dev-*.swap"



# HandlePowerKey=poweroff        # Can be poweroff, reboot, halt, ignore
# HandleLidSwitch=suspend        # Can be suspend, ignore, lock, etc.
# HandleLidSwitchDocked=ignore   # Controls lid action when docked
# IdleAction=ignore              # Can be suspend, poweroff, etc.
# IdleActionSec=30min            # Time before IdleAction triggers

sudo systemctl restart systemd-logind
