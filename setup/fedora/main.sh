#!/usr/bin/env bash

source "$HOME/pers/setup/common/utils.sh"

log "\n\n ======= main.sh is starting ======= \n\n"

# ====================================

if [ ! -f "$HOME/pers/password" ]; then
  echo "ERROR: $HOME/pers/password missing."
  touch password
fi

# ====================================

nvim --headless "+Lazy! sync" +qa

sudo dnf update -y --skip-unavailable --exclude=openh264

"$HOME/pers/setup/fedora/install.sh"
"$HOME/pers/setup/fedora/config.sh"
"$HOME/pers/setup/common/gnome.sh"
"$HOME/pers/setup/common/filesystem.sh"
"$HOME/pers/setup/common/teardown.sh"
