#!/usr/bin/env bash

log "Starting config.sh execution..."

source "$HOME/pers/setup/common/utils.sh"

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
  ln -sf "$i" "$HOME/$base_item_name"
done

# ---- secrets ---------------------------
log "Decrypting secret files using ansible-vault..."
find "$HOME/pers/secrets" -type f -exec ansible-vault decrypt --vault-password-file "$HOME/pers/password" -- {} \;

mv "$HOME/.ssh" "$HOME/.ssh.backup" 2>/dev/null
ln -sf "$HOME/pers/secrets/ssh" "$HOME/.ssh"

mkdir -p "$HOME/pers/dotfiles/.config/keepassxc"
ln -sf "$HOME/pers/secrets/passwords/keepassxc.ini" "$HOME/pers/dotfiles/.config/keepassxc/keepassxc.ini"

log "Symlinking custom /etc/hosts file..."
mv /etc/hosts /etc/hosts.backup
sudo ln -sf "$HOME/pers/secrets/hosts" /etc/hosts

log "======= config.sh execution finished successfully ======="
