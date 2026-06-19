#!/usr/bin/env bash

source "$HOME/pers/scripts/utils.sh"

log "Starting config.sh execution..."

# ---- submodules ---------------------------
log "Initializing and updating git submodules..."
git submodule update --init --recursive

# ---- config ---------------------------
#
log "Configuring Keyd service and loading default.conf..."
sudo systemctl enable keyd --now
sudo cp "$HOME/pers/dotfiles/.custom/keyd.conf" /etc/keyd/default.conf
sudo keyd reload
sudo usermod -aG keyd "$USER"

log "Configuring Docker daemon and user groups..."
sudo systemctl enable --now docker
sudo usermod -aG docker "$USER"
sudo mv /etc/docker/daemon.json{,.old}
sudo cp "$HOME/pers/dotfiles/.custom/deamon.json" /etc/docker/daemon.json

# ---- dotfiles ---------------------------

log "Scanning $HOME/pers/dotfiles for items to symlink..."
dotfiles_to_symlink=($(find "$HOME/pers/dotfiles" -maxdepth 1 -mindepth 1))
for i in "${dotfiles_to_symlink[@]}"; do
  base_item_name=$(basename "$i")
  target="$HOME/$base_item_name"

  # Skip if already correctly linked
  [[ -L "$target" && "$(readlink "$target")" == "$i" ]] && continue

  log "Linking $i -> $target"
  [[ -e "$target" || -L "$target" ]] && mv --no-target-directory "$target" "${target}.backup" 2>/dev/null
  ln -sfnT "$i" "$target"
done

log "Syncing Neovim plugins..."
nvim --headless -c "Lazy! sync" -c "qa!" 2>/dev/null || true

# ---- secrets ---------------------------
if [[ -z $(secret-tool lookup application keepassxc 2>/dev/null) ]]; then
  log "Storing KeePassXC database password in GNOME Keyring."
  secret-tool store --label='KeePassXC Password' application keepassxc
fi

log "Decrypting all secrets..."
git -C "$HOME/pers" checkout -- .

log "Fixing SSH key permissions (600 for private keys)..."
find "$HOME/pers/" -path '*/.ssh/*' -type f ! -name '*.pub' -exec chmod 600 {} +

log "Copying custom /etc/hosts file..."
sudo cp "$HOME/pers/dotfiles/.custom/sys/hosts" /etc/hosts

log "Copying pers/secrets/sudoers file for /etc/sudoers.d/sudoers ..."
sudo cp "$HOME/pers/dotfiles/.custom/sys/sudoers" /etc/sudoers.d/sudoers
