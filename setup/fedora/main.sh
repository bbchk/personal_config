#!/usr/bin/env bash

source "$HOME/pers/setup/common/utils.sh"

# ====================================
echo -e "\n\n ======= main.sh is starting ======= \n\n"

confirm "Do you want to pre sync all neovim plugins?" do_nvim_pre
if "$do_nvim_pre"; then
  nvim --headless "+Lazy! sync" +qa
fi

confirm "Do you want to run dnf update?" do_dnf_update
if "$do_dnf_update"; then
  sudo dnf update -y --skip-unavailable --exclude=openh264
fi

"$HOME/pers/setup/fedora/install.sh" && "$HOME/pers/setup/fedora/config.sh"
