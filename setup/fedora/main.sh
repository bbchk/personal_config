#!/usr/bin/env bash

source "$HOME/pers/setup/common/utils.sh"

log "\n\n ======= main.sh is starting ======= \n\n"

# ====================================

GPG_KEY_ID="E78A0D774F0BDAC50F897DC5FF99608021A353C0"
if ! gpg --list-secret-keys "$GPG_KEY_ID" >/dev/null 2>&1; then
  echo "ERROR: GPG key not found. Import it first:"
  echo "  gpg --import ~/path/to/your/gpg/key.key"
  exit 1
fi

# ====================================

nvim --headless "+Lazy! sync" +q

sudo dnf update -y --skip-unavailable --exclude=openh264

"$HOME/pers/setup/fedora/install.sh"
"$HOME/pers/setup/fedora/config.sh"
"$HOME/pers/setup/common/gnome.sh"
"$HOME/pers/setup/common/filesystem.sh"
"$HOME/pers/setup/common/teardown.sh"
