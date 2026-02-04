#!/usr/bin/env bash

source "$HOME/pers/setup/utils.sh"

# ====================================

git remote add origin-ssh git@github.com:bbchk/personal_config.git
git config core.hooksPath .githooks

xdg-user-dirs-update

confirm "Do you want to change the default shell to Zsh?" do_chsh
if $do_chsh; then
  chsh -s "$(which zsh)"
  echo "Shell changed to Zsh. Please log out and back in for the change to take effect."
fi

confirm "Do you want to log out now to apply changes?" do_logout
if $do_logout; then
  gnome-session-quit --logout
fi
