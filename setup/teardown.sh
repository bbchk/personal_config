#!/usr/bin/env bash

set -euo pipefail

# ====================================

git remote remove origin
git remote add origin git@github.com:bbchk/personal_config.git
git config core.hooksPath .githooks

chsh -s "$(which zsh)"
gnome-session-quit --logout
