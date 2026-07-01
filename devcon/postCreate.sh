#!/usr/bin/env bash

set -euo pipefail

source /usr/local/share/devcontainer-helpers/utils.sh

log "Scanning $HOME/pers/dotfiles for items to symlink into $HOME..."
DOTFILES_FULL="$HOME/pers/dotfiles"
while IFS= read -r -d '' item; do
  base_item_name=$(basename "$item")
  target="$HOME/$base_item_name"

  [[ "$base_item_name" == ".custom" ]] && continue

  [[ -L "$target" && "$(readlink "$target")" == "$item" ]] && continue

  log "Linking $item -> $target"
  [[ -e "$target" || -L "$target" ]] && mv --no-target-directory "$target" "${target}.backup" 2>/dev/null || true
  ln -sfnT "$item" "$target"
done < <(find "$DOTFILES_FULL" -maxdepth 1 -mindepth 1 -print0)


log "Doing Gpg keys magic..."
# Fixing bind root mount
sudo install -d -o "$(id -u)" -g "$(id -g)" -m 700 "$HOME/.gnupg"
# The agent is forwarded from host machine via the mounted socket instead
echo "no-autostart" >>"$HOME/.gnupg/gpg.conf"

gpg --import "$HOME/.gnupg/devcon-public.asc"
gpg --list-keys --with-colons |
  awk -F: '/^fpr/{print $10":6:"; exit}' |
  gpg --import-ownertrust

log "Decrypting secrets..."
git -C "$HOME/pers" checkout -- .
find "$HOME/pers/" -path '*/.ssh/*' -type f ! -name '*.pub' -exec chmod 600 {} + 2>/dev/null || true

log "Customizing sudoers..."
sudo install -m 440 -o root -g root "$HOME/pers/dotfiles/.custom/sys/sudoers" /etc/sudoers.d/sudoers

log "Dancing around Nvim plugins..."
# Fixing bind root mount
sudo chown "$(id -u):$(id -g)" "$HOME/.local/share/nvim"
nvim --headless -c "Lazy! restore" -c "qa!" 2>/dev/null || true

log "postCreate complete"
