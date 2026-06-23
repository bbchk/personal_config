#!/usr/bin/env bash

set -euo pipefail

source /usr/local/share/devcontainer-helpers/utils.sh

log "Setting default shell to zsh..."
[[ "$SHELL" == */zsh ]] || usermod -s "$(which zsh)" root

log "Scanning /root/pers/dotfiles for items to symlink into $HOME..."
DOTFILES_FULL="/root/pers/dotfiles"
while IFS= read -r -d '' item; do
  base_item_name=$(basename "$item")
  target="$HOME/$base_item_name"

  # Skip dot-custom (system-level files handled separately below)
  [[ "$base_item_name" == ".custom" ]] && continue

  # Skip if already correctly linked
  [[ -L "$target" && "$(readlink "$target")" == "$item" ]] && continue

  log "Linking $item -> $target"
  [[ -e "$target" || -L "$target" ]] && mv --no-target-directory "$target" "${target}.backup" 2>/dev/null || true
  ln -sfnT "$item" "$target"
done < <(find "$DOTFILES_FULL" -maxdepth 1 -mindepth 1 -print0)

log "Installing neovim-remote"
pipx install neovim-remote
NVR_SCRIPT="/root/pers/scripts/sudoedit-nvr"
install -m 755 -o root -g root "$NVR_SCRIPT" "/usr/local/bin/sudoedit-nvr"

log "personal-config feature install complete!"

log "Importing gpg keys..."
chmod 700 /root/.gnupg

# Prevent GPG from trying to start its own agent.
# The host agent is forwarded via the mounted socket.
echo "no-autostart" >>/root/.gnupg/gpg.conf

gpg --import /root/.gnupg/devcon-public.asc
gpg --list-keys --with-colons |
  awk -F: '/^fpr/{print $10":6:"; exit}' |
  gpg --import-ownertrust

log "Decrypting secrets..."
git -C "$HOME/pers" config --global --add safe.directory /root/pers
git -C "$HOME/pers" checkout -- .

log "Fixing SSH key permissions..."
find "/root/pers/" -path '*/.ssh/*' -type f ! -name '*.pub' -exec chmod 600 {} + 2>/dev/null || true

log "Copying sudoers..."
cp "/root/pers/dotfiles/.custom/sys/sudoers" /etc/sudoers.d/sudoers
chmod 440 /etc/sudoers.d/sudoers

log "Syncing Neovim plugins..."
nvim --headless -c "Lazy! sync" -c "qa!" 2>/dev/null || true

# TODO: 
# source /opt/ros/lyrical/setup.bash
