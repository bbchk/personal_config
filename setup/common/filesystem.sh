#!/usr/bin/env bash

set -euo pipefail

# ====================================

# Create new xdg directories

mv "$HOME/Desktop" "$HOME/pers/xdg/Desktop"
mv "$HOME/Documents" "$HOME/pers/xdg/Documents"
mv "$HOME/Music" "$HOME/pers/xdg/Music"
mv "$HOME/Pictures" "$HOME/pers/xdg/Pictures"
mv "$HOME/Public" "$HOME/pers/xdg/Public"
mv "$HOME/Templates" "$HOME/pers/xdg/Templates"
mv "$HOME/Videos" "$HOME/pers/xdg/Videos"
mv "$HOME/Downloads" "$HOME/downloads"

# Clone frequently worked on projects
mkdir -p "$HOME/dev/my" "$HOME/dev/ib"
git clone git@github.com:bbchk/jv-fr.git     "$HOME/dev/my/jv-fr"
git clone git@github.com:bbchk/avkfe.git     "$HOME/dev/my/avkfe"
git clone git@github.com:bbchk/scrape.git    "$HOME/dev/my/scrape"
git clone git@github.com:bbchk/lvfe.git      "$HOME/dev/my/lvfe"
git clone git@github.com:bbchk/live.git      "$HOME/dev/my/live"
git clone git@github.com:bbchk/lvbe.git      "$HOME/dev/my/lvbe"
git clone git@github.com:bbchk/lvops.git     "$HOME/dev/my/lvops"
git clone git@github.com:bbchk/train.git     "$HOME/dev/my/train"
git clone git@github.com:bbchk/slugtrans.git "$HOME/dev/my/slugtrans"
