#!/usr/bin/env bash

source "$HOME/pers/setup/common/utils.sh"

log "Starting config.sh execution..."

# ---- submodules ---------------------------
log "Initializing and updating git submodules..."
git submodule update --init --recursive

# ---- dotfiles ---------------------------
log "Scanning $HOME/pers/dotfiles for items to symlink..."
dotfiles_to_symlink=($(find "$HOME/pers/dotfiles" -maxdepth 1 -mindepth 1))
for i in "${dotfiles_to_symlink[@]}"; do
  base_item_name=$(basename "$i")
  log "Linking $i -> $HOME/$base_item_name"
  mv "$HOME/$base_item_name" "$HOME/${base_item_name}.backup" 2>/dev/null
  ln -sfnT "$i" "$HOME/$base_item_name"

done

# ---- secrets ---------------------------
[[ -z $(secret-tool lookup application keepassxc) ]] && secret-tool store --label='KeePassXC Password' application keepassxc

log "Decrypting secret files using ansible-vault..."
find "$HOME/pers/secrets" -type f -exec ansible-vault decrypt --vault-password-file "$HOME/pers/password" -- {} \;

mv "$HOME/.ssh" "$HOME/.ssh.backup" 2>/dev/null
ln -sfnT "$HOME/pers/secrets/ssh" "$HOME/.ssh"

mkdir -p "$HOME/pers/dotfiles/.config/keepassxc"
ln -sfnT "$HOME/pers/secrets/passwords/keepassxc.ini" "$HOME/pers/dotfiles/.config/keepassxc/keepassxc.ini"

log "Symlinking custom /etc/hosts file..."
sudo mv /etc/hosts /etc/hosts.backup
sudo ln -sfnT "$HOME/pers/secrets/hosts" /etc/hosts

log "======= config.sh execution finished successfully ======="
