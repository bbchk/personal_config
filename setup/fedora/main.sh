#!/usr/bin/env bash

# set -euo pipefail

# ====================================
echo -e "\n\n ======= main.sh is starting ======= \n\n"

# create password file and ask for password, write it to the file
# install ansible first
# install nvim extensions before opening the nvim

sudo dnf update -y --skip-unavailable --exclude=openh264

"$HOME/pers/setup/fedora/install.sh" && "$HOME/pers/setup/fedora/config.sh"

# TODO: can import vimium setting automatically?
