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
mkdir -p "$HOME/dev/my"
my_repos=(jv-fr avkfe scrape lvfe live lvbe lvops train slugtrans)
for r in "${my_repos[@]}"; do
  git clone --bare -- "git@github.com:bbchk/${r}.git" "$HOME/dev/my/$r"
done

# mkdir -p "$HOME/dev/ib"
# ib_repos=()
# for r in "${ib_repos[@]}"; do
#   git clone --bare -- "${r}.git" "$HOME/dev/my/$r"
# done
