#!/usr/bin/env bash

source "$HOME/pers/setup/utils.sh"

# ====================================

log "Relocating standard XDG user directories to a centralized persistent storage path."
mv "$HOME/Desktop" "$HOME/pers/xdg/desktop"
mv "$HOME/Documents" "$HOME/pers/xdg/documents"
mv "$HOME/Music" "$HOME/pers/xdg/music"
mv "$HOME/Pictures" "$HOME/pers/xdg/pictures"
mv "$HOME/Public" "$HOME/pers/xdg/public"
mv "$HOME/Templates" "$HOME/pers/xdg/templates"
mv "$HOME/Videos" "$HOME/pers/xdg/videos"
mv "$HOME/Downloads" "$HOME/pers/xdg/downloads"
xdg-user-dirs-update

log "Cloning personal projects"

gh_repos=(jv-fr avkfe scrape lvfe live lvbe lvops train slugtrans)
for r in "${gh_repos[@]}"; do
  git clone "git@github.com:bbchk/${r}.git" "$HOME/dev/my/$r"
done

git clone git@gitlab.com:liveworld/parent.git "$HOME/dev/lw"
