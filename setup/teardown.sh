#!/usr/bin/env bash

# set -euo pipefail

# ====================================

git remote add origin-ssh git@github.com:bbchk/personal_config.git

git config core.hooksPath .githooks

xdg-user-dirs-update

chsh -s "$(which zsh)"
gnome-session-quit --logout
