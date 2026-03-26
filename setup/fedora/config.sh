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
[[ -z $(secret-tool lookup application keepassxc) ]] \
  && secret-tool store --label='KeePassXC Password' application keepassxc

log "Setting up GPG filters and decrypting secrets..."
git config core.hooksPath .githooks
git config --local filter.gpg.clean "/home/bchk/pers/scripts/gpg-clean"
git config --local filter.gpg.smudge "/home/bchk/pers/scripts/gpg-smudge"
git config --local filter.gpg.required true
git config --local diff.gpg.textconv "/home/bchk/pers/scripts/gpg-diff"
git -C "$HOME/pers" checkout -- secrets/

ln -sfb "$HOME/pers/secrets/ssh_config" "$HOME/.ssh/config"

mkdir -p "$HOME/pers/dotfiles/.config/keepassxc"
ln -sfb "$HOME/pers/secrets/my/keepassxc/keepassxc.ini" "$HOME/pers/dotfiles/.config/keepassxc/keepassxc.ini"

log "Symlinking custom /etc/hosts file..."
sudo cp "$HOME/pers/secrets/my/sys/hosts" /etc/hosts

log "Symlinking pers/secrets/sudoers file for /etc/sudoers.d/sudoers ..."
sudo cp "$HOME/pers/secrets/my/sys/sudoers" /etc/sudoers.d/sudoers
