#!/usr/bin/env bash

# set -euo pipefail

# ====================================
echo -e "\n\n ======= main.sh is starting ======= \n\n"

sudo dnf update -y --skip-unavailable --exclude=openh264

"$HOME/pers/setup/fedora/install.sh" && "$HOME/pers/setup/fedora/config.sh"
