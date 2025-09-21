#!/usr/bin/env bash

set -euo pipefail

# ====================================

mkdir -p ~/dev

mv "$HOME/Desktop" "$HOME/pers/xdg/Desktop"
mv "$HOME/Documents" "$HOME/pers/xdg/Documents"
mv "$HOME/Music" "$HOME/pers/xdg/Music"
mv "$HOME/Pictures" "$HOME/pers/xdg/Pictures"
mv "$HOME/Public" "$HOME/pers/xdg/Public"
mv "$HOME/Templates" "$HOME/pers/xdg/Templates"
mv "$HOME/Videos" "$HOME/pers/xdg/Videos"

mv "$HOME/Downloads" "$HOME/downloads"

