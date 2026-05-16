#!/usr/bin/env bash

source "$HOME/pers/setup/utils.sh"

log "\n\n ======= index.sh is starting ======= \n\n"

# ====================================

GPG_KEY_ID="E78A0D774F0BDAC50F897DC5FF99608021A353C0"
if ! gpg --list-secret-keys "$GPG_KEY_ID" >/dev/null 2>&1; then
  echo "ERROR: GPG key not found. Import it first:"
  echo "  gpg --import ~/path/to/your/gpg/key.key"
  exit 1
fi

# ====================================

"$HOME/pers/setup/install.sh"
"$HOME/pers/setup/config.sh"
"$HOME/pers/setup/gnome.sh"
"$HOME/pers/setup/filesystem.sh"
"$HOME/pers/setup/teardown.sh"

"$HOME/pers/scripts/connect_vpn.sh"
