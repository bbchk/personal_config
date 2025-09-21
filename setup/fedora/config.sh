#!/usr/bin/env bash

# set -euo pipefail

# ====================================
echo -e "\n\n ======= config.sh is starting ======= \n\n"

# ---- dotfiles below ---------------------------

read -rp "Do you want to link dotfiles? (y/n): " dotfiles_res
if [[ "$dotfiles_res" =~ ^[Yy]$ ]]; then
  dotfiles_to_symlink=($(find "$HOME/pers/dotfiles" -maxdepth 1 -mindepth 1))
  for i in "${dotfiles_to_symlink[@]}"; do
    base_item_name=$(basename "$i")

    echo "Linking $i to $HOME/$base_item_name"
    rm -rf "$HOME/$base_item_name"
    ln -sf "$i" "$HOME/$base_item_name"
  done

  # omz config below


  git submodule add https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
  cd "$HOME/pers/dotfiles/.oh-my-zsh"
  git submodule update --init --recursive
  cd -
fi

# ---- secrets below ---------------------------

read -rp "Do you want to link secrets? (y/n): " secrets_res
if [[ "$secrets_res" =~ ^[Yy]$ ]]; then
  find "$HOME/pers/secrets" -type f -exec ansible-vault decrypt --vault-password-file "$HOME/pers/password" -- {} \;

  mv "$HOME/.ssh" "$HOME/.ssh.backup"
  ln -sf "$HOME/pers/secrets/ssh" "$HOME/.ssh"

  mv "$HOME/.zsh_history" "$HOME/.zsh_history.backup"
  ln -sf "$HOME/pers/secrets/.zsh_history" "$HOME/.zsh_history"
fi

# ---- networking below ---------------------------

read -rp "Do you want to tweak networking settings? (y/n): " networking_res
if [[ "$networking_res" =~ ^[Yy]$ ]]; then
  read -rp "Enter pretty hostname: " pretty_hostname
  sudo hostnamectl set-hostname --pretty "$pretty_hostname"

  read -rp "Enter static hostname: " static_hostname
  sudo hostnamectl set-hostname --static "$static_hostname"
fi

# ---- personalization below ---------------------------

read -rp "Do you set default user image? (y/n): " user_image_y_n
case "$user_image_y_n" in
[Yy]*)
  default_user_image_path="$HOME/pers/xdg/Pictures/default/sun-with-face.png"
  magick "$default_user_image_path" -resize 512x512 -gravity center -extent 512x512 "$default_user_image_path"
  sudo busctl call org.freedesktop.Accounts /org/freedesktop/Accounts/User$(id -u) org.freedesktop.Accounts.User SetIconFile s "$default_user_image_path"
  ;;
esac
