#!/usr/bin/env bash

# set -euo pipefail

git submodule update --init --recursive

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
fi

# ---- secrets below ---------------------------

read -rp "Do you want to link secrets? (y/n): " secrets_res
if [[ "$secrets_res" =~ ^[Yy]$ ]]; then
  find "$HOME/pers/secrets" -type f -exec ansible-vault decrypt --vault-password-file "$HOME/pers/password" -- {} \;

  mv "$HOME/.ssh" "$HOME/.ssh.backup"
  ln -sf "$HOME/pers/secrets/ssh" "$HOME/.ssh"
fi

# ---- networking below ---------------------------

read -rp "Do you want to tweak networking settings? (y/n): " networking_res
if [[ "$networking_res" =~ ^[Yy]$ ]]; then
  read -rp "Enter pretty hostname: " pretty_hostname
  sudo hostnamectl set-hostname --pretty "$pretty_hostname"

  read -rp "Enter static hostname: " static_hostname
  sudo hostnamectl set-hostname --static "$static_hostname"

  ln -sf "$HOME/pers/config/hosts" /etc/hosts
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

read -rp "Do you create desktop entry for sessionizer? (y/n): " sessionizer_y_n
case "$sessionizer_y_n" in
  [Yy]*)
    APP_NAME=sessionizer
    APP_CMD="kitty -e $HOME/pers/scripts/sessionizer"
    APP_ICON="utilities-terminal"
    APP_COMMENT="Open Neovim session with directory picker"

    DESKTOP_FILE="$HOME/.local/share/applications/${APP_NAME// /_}.desktop"

    mkdir -p "$HOME/.local/share/applications"

 # Write the .desktop file
    cat > "$DESKTOP_FILE" <<EOL
[Desktop Entry]
Type=Application
Name=$APP_NAME
Exec=$APP_CMD
Icon=$APP_ICON
Comment=$APP_COMMENT
Terminal=true
Categories=Utility;
EOL

    chmod +x "$DESKTOP_FILE"


    gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings \
      "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/sessionizer/']"

    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/sessionizer/ name 'Sessionizer'
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/sessionizer/ command "kitty -e $HOME/pers/scripts/sessionizer"
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/sessionizer/ binding '<Super>f'
;;

esac

# ---- teardown below ---------------------------
