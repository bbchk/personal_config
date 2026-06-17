#!/usr/bin/env bash

source "$HOME/pers/scripts/utils.sh"

# ====================================

log "Relocating standard XDG user directories to a centralized persistent storage path."

mv "$HOME/Desktop" "$HOME/pers/xdg/Desktop"
mv "$HOME/Documents" "$HOME/pers/xdg/Documents"
mv "$HOME/Music" "$HOME/pers/xdg/Music"
mv "$HOME/Pictures" "$HOME/pers/xdg/Pictures"
mv "$HOME/Public" "$HOME/pers/xdg/Public"
mv "$HOME/Templates" "$HOME/pers/xdg/Templates"
mv "$HOME/Videos" "$HOME/pers/xdg/Videos"
mv "$HOME/Downloads" "$HOME/pers/xdg/Downloads"
xdg-user-dirs-update

# ====================================

mkdir -p "$HOME/dev/my" "$HOME/dev/lw" "$HOME/dev/ib"

log "Cloning all the git repositories"
for repo in $(curl -s "https://api.github.com/users/bbchk/repos?per_page=100&page=1" | jq -r '.[].ssh_url'); do
  git clone "$repo" "$HOME/dev/my/$(basename "${repo%.git}")"
done

for repo in $(curl -s "https://gitlab.com/api/v4/users/bchk/projects?per_page=100" | jq -r '.[].ssh_url_to_repo'); do
  git clone "$repo" "$HOME/dev/my/$(basename "${repo%.git}")"
done

for repo in $(curl -s "https://gitlab.com/api/v4/groups/liveworld/projects?per_page=100" | jq -r '.[].ssh_url_to_repo'); do
  git clone "$repo" "$HOME/dev/lw/$(basename "${repo%.git}")"
done

log "Pulling latest changes from all git repositories in batches"
repos=($(find "$HOME/dev/my" "$HOME/dev/lw" "$HOME/dev/ib" -maxdepth 1 -mindepth 1 -type d))
for repo in "${repos[@]}"; do
  git -C "$repo" pull &
  # allow only 8 jobs at a time
  while (( $(jobs -r | wc -l) >= 10 )); do sleep 0.5; done
done
wait
