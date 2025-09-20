#!/usr/bin/env bash

# set -euo pipefail

# ====================================
echo -e "\n\n ======= config.sh is starting ======= \n\n"

# ---- dotfiles below ---------------------------

dotfiles_to_symlink=($(find "$HOME/pers/dotfiles" -maxdepth 1 -mindepth 1))
for i in "${dotfiles_to_symlink[@]}"; do
  base_item_name=$(basename "$i")

  echo "Linking $i to $HOME/$base_item_name"
  rm -rf "$HOME/$base_item_name"
  ln -sf "$i" "$HOME/$base_item_name"
done

# ---- secrets below ---------------------------

find "$HOME/pers/secrets" -type f -exec ansible-vault decrypt --vault-password-file "$HOME/pers/password" -- {} \;

mv "$HOME/.ssh" "$HOME/.ssh.backup"
ln -sf "$HOME/pers/secrets/ssh" "$HOME/.ssh"

mv "$HOME/.zsh_history" "$HOME/.zsh_history.backup"
ln -sf "$HOME/pers/secrets/.zsh_history" "$HOME/.zsh_history"

# ---- networking below ---------------------------

read -rp "Enter pretty hostname: " pretty_hostname
sudo hostnamectl set-hostname --pretty "$pretty_hostname"

read -rp "Enter static hostname: " static_hostname
sudo hostnamectl set-hostname --static "$static_hostname"
